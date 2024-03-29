import os
import sys


def module_exists(module_name):
    try:
        __import__(module_name)
    except ImportError:
        return False
    else:
        return True


def check_cmake_exists(cmake_command):
    """
    Check whether CMake is installed. If not, print
    informative error message and quits.
    """
    from subprocess import Popen, PIPE

    p = Popen(
        "{0} --version".format(cmake_command), shell=True, stdin=PIPE, stdout=PIPE
    )
    if not ("cmake version" in p.communicate()[0].decode("UTF-8")):
        sys.stderr.write("   This code is built using CMake\n\n")
        sys.stderr.write("   CMake is not found\n")
        sys.stderr.write("   get CMake at http://www.cmake.org/\n")
        sys.stderr.write("   on many clusters CMake is installed\n")
        sys.stderr.write("   but you have to load it first:\n")
        sys.stderr.write("   $ module load cmake\n")
        sys.exit(1)


def setup_build_path(build_path):
    """
    Create build directory. If this already exists, print informative
    error message and quit.
    """
    if os.path.isdir(build_path):
        fname = os.path.join(build_path, "CMakeCache.txt")
        if os.path.exists(fname):
            sys.stderr.write("aborting setup\n")
            sys.stderr.write(
                "build directory {0} which contains CMakeCache.txt already exists\n".format(
                    build_path
                )
            )
            sys.stderr.write("remove the build directory and then rerun setup\n")
            sys.exit(1)
    else:
        os.makedirs(build_path, 0o755)


def add_quotes_to_argv(argv, arguments):
    """
    This function tries to solve this problem:
    https://stackoverflow.com/questions/19120247/python-sys-argv-to-preserve-or

    The problem is that sys.argv has been stripped of quotes by the shell but
    docopt's arguments contains quotes.

    So what we do is cycle through all docopt arguments: if they are also
    present in sys.argv and contain spaces, we add quotes.
    """
    setup_command = " ".join(argv[:])

    for k, v in arguments.items():
        if isinstance(v, str):
            if " " in v:
                if v in setup_command:
                    setup_command = setup_command.replace(v, '"{}"'.format(v))

    return setup_command


def run_cmake(command, build_path, default_build_path, arguments):
    """
    Execute CMake command.
    """
    from subprocess import Popen, PIPE

    topdir = os.getcwd()
    p = Popen(command, shell=True, stdin=PIPE, stdout=PIPE, stderr=PIPE)
    stdout_coded, stderr_coded = p.communicate()
    stdout = stdout_coded.decode("UTF-8")
    stderr = stderr_coded.decode("UTF-8")

    # print cmake output to screen
    print(stdout)

    if stderr:
        # we write out stderr but we do not stop yet
        # this is because CMake warnings are sent to stderr
        # and they might be benign
        sys.stderr.write(stderr)

    # write cmake output to file
    with open(os.path.join(build_path, "cmake_output"), "w") as f:
        f.write(stdout)

    # change directory and return
    os.chdir(topdir)

    # to figure out whether configuration was a success
    # we check for 3 sentences that should be part of stdout
    configuring_done = "-- Configuring done" in stdout
    generating_done = "-- Generating done" in stdout
    build_files_written = "-- Build files have been written to" in stdout
    configuration_successful = (
        configuring_done and generating_done and build_files_written
    )

    if configuration_successful:
        setup_command = add_quotes_to_argv(sys.argv, arguments)
        save_setup_command(setup_command, build_path)
        print_build_help(build_path, default_build_path)


def print_build_help(build_path, default_build_path):
    """
    Print help text after configuration step is done.
    """
    print("   configure step is done")
    print("   now you need to compile the sources:")
    if build_path == default_build_path:
        print("   $ cd build")
    else:
        print("   $ cd " + build_path)
    print("   $ make")


def save_setup_command(setup_command, build_path):
    """
    Save setup command to a file.
    """
    file_name = os.path.join(build_path, "setup_command")
    with open(file_name, "w") as f:
        f.write(setup_command + "\n")


def configure(root_directory, build_path, cmake_command, arguments):
    """
    Main configure function.
    """
    default_build_path = os.path.join(root_directory, "build")

    # check that CMake is available, if not stop
    check_cmake_exists("cmake")

    # deal with build path
    if build_path is None:
        build_path = default_build_path
    if not arguments["--show"]:
        setup_build_path(build_path)

    cmake_command += " -B" + build_path
    print("{0}\n".format(cmake_command))
    if arguments["--show"]:
        sys.exit(0)

    run_cmake(cmake_command, build_path, default_build_path, arguments)
