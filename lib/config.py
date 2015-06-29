
# Copyright (c) 2015 by Radovan Bast and Jonas Juselius
# See https://github.com/scisoft/autocmake/blob/master/LICENSE


import subprocess
import os
import sys
import shutil


def check_cmake_exists(cmake_command):
    """
    Check whether CMake is installed. If not, print
    informative error message and quits.
    """
    p = subprocess.Popen('%s --version' % cmake_command,
                         shell=True,
                         stdin=subprocess.PIPE,
                         stdout=subprocess.PIPE)
    if not ('cmake version' in p.communicate()[0].decode('UTF-8')):
        sys.stderr.write('   This code is built using CMake\n\n')
        sys.stderr.write('   CMake is not found\n')
        sys.stderr.write('   get CMake at http://www.cmake.org/\n')
        sys.stderr.write('   on many clusters CMake is installed\n')
        sys.stderr.write('   but you have to load it first:\n')
        sys.stderr.write('   $ module load cmake\n')
        sys.exit(1)


def setup_build_path(build_path):
    """
    Create build directory. If this already exists, print informative
    error message and quit.
    """
    if os.path.isdir(build_path):
        fname = os.path.join(build_path, 'CMakeCache.txt')
        if os.path.exists(fname):
            sys.stderr.write('aborting setup\n')
            sys.stderr.write('build directory %s which contains CMakeCache.txt already exists\n' % build_path)
            sys.stderr.write('remove the build directory and then rerun setup\n')
            sys.exit(1)
    else:
        os.makedirs(build_path, 0o755)


def test_adapt_cmake_command_to_platform():

    cmake_command = "FC=foo CC=bar CXX=RABOOF cmake -DTHIS -DTHAT='this and that cmake' .."
    res = adapt_cmake_command_to_platform(cmake_command, 'linux')
    assert res == cmake_command
    res = adapt_cmake_command_to_platform(cmake_command, 'win32')
    assert res == "set FC=foo && set CC=bar && set CXX=RABOOF && cmake -DTHIS -DTHAT='this and that cmake' .."

    cmake_command = "cmake -DTHIS -DTHAT='this and that cmake' .."
    res = adapt_cmake_command_to_platform(cmake_command, 'linux')
    assert res == cmake_command
    res = adapt_cmake_command_to_platform(cmake_command, 'win32')
    assert res == cmake_command


def adapt_cmake_command_to_platform(cmake_command, platform):
    """
    Adapts CMake command to MS Windows platform.
    """

    if platform == 'win32':
        cmake_pos = cmake_command.find('cmake')
        cmake_export_vars = cmake_command[:cmake_pos]
        cmake_strings = cmake_command[cmake_pos:]
        all_modified_exported_vars = ""
        for exported_var in cmake_export_vars.split():
            modified_exported_var = "set " + exported_var + " && "
            all_modified_exported_vars = all_modified_exported_vars + modified_exported_var
        cmake_command_platform = all_modified_exported_vars + cmake_strings
    else:
        cmake_command_platform = cmake_command

    return cmake_command_platform


def run_cmake(command, build_path, default_build_path):
    """
    Execute CMake command.
    """
    topdir = os.getcwd()
    os.chdir(build_path)
    p = subprocess.Popen(command,
                         shell=True,
                         stdin=subprocess.PIPE,
                         stdout=subprocess.PIPE)
    s = p.communicate()[0].decode('UTF-8')
    # print cmake output to screen
    print(s)
    # write cmake output to file
    f = open('cmake_output', 'w')
    f.write(s)
    f.close()
    # change directory and return
    os.chdir(topdir)
    if 'Configuring incomplete' in s:
        # configuration was not successful
        if (build_path == default_build_path):
            # remove build_path iff not set by the user
            # otherwise removal can be dangerous
            shutil.rmtree(default_build_path)
    else:
        # configuration was successful
        save_configure_command(sys.argv, build_path)
        print_build_help(build_path, default_build_path)


def print_build_help(build_path, default_build_path):
    """
    Print help text after configuration step is done.
    """
    print('   configure step is done')
    print('   now you need to compile the sources:')
    if (build_path == default_build_path):
        print('   $ cd build')
    else:
        print('   $ cd ' + build_path)
    print('   $ make')


def save_configure_command(argv, build_path):
    """
    Save configure command to a file.
    """
    file_name = os.path.join(build_path, 'configure_command')
    f = open(file_name, 'w')
    f.write(' '.join(argv[:]) + '\n')
    f.close()


def configure(root_directory, build_path, cmake_command, only_show):
    """
    Main configure function.
    """
    default_build_path = os.path.join(root_directory, 'build')

    # check that CMake is available, if not stop
    check_cmake_exists('cmake')

    # deal with build path
    if build_path is None:
        build_path = default_build_path
    if not only_show:
        setup_build_path(build_path)

    cmake_command = adapt_cmake_command_to_platform(cmake_command, sys.platform)

    print('%s\n' % cmake_command)
    if only_show:
        sys.exit(0)

    run_cmake(cmake_command, build_path, default_build_path)
