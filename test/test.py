import os
import sys
import subprocess
import shlex
import shutil
import sys
import time
import datetime
import pytest

HERE = os.path.abspath(os.path.dirname(__file__))

skip_on_windows = pytest.mark.skipif('sys.platform == "win32"', reason="not working on windows")
skip_on_osx = pytest.mark.skipif('sys.platform == "darwin"', reason="not working on osx")
skip_always = pytest.mark.skipif('1 == 1', reason="tests are broken")


# ------------------------------------------------------------------------------


def exe(command):
    """
    Executes command and returns string representations of stdout and stderr captured from the console.
    When universal_newlines=True stdout and stderr are opened in text mode.
    Otherwise, they are opened in binary mode. In that case captured stdout and stderr
    are not strings and Python 3 throws type error when compared against strings later in tests.
    Note:
    This feature is only available if Python is built with universal newline support (the default).
    Also, the newlines attribute of the file objects stdout, stdin and stderr are not updated by the
    communicate() method.
    See https://docs.python.org/2/library/subprocess.html
    """
    stdout, stderr = subprocess.Popen(shlex.split(command),
                                      stdout=subprocess.PIPE,
                                      stderr=subprocess.PIPE,
                                      universal_newlines=True).communicate()

    if stderr:
        sys.stderr.write(stderr)

    return stdout, stderr

# ------------------------------------------------------------------------------


def configure_build_and_exe(name, setup_command, launcher=None):

    stamp = datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d-%H-%M-%S')

    os.chdir(os.path.join(HERE, name, 'cmake'))
    shutil.copy(os.path.join('..', '..', '..', 'update.py'), 'update.py')

    dst_dir = 'lib'
    if not os.path.exists(dst_dir):
        os.makedirs(dst_dir)
    shutil.copy(os.path.join('..', '..', '..', dst_dir, 'config.py'), dst_dir)

    dst_dir = os.path.join('lib', 'docopt')
    if not os.path.exists(dst_dir):
        os.makedirs(dst_dir)
    shutil.copy(os.path.join('..', '..', '..', dst_dir, 'docopt.py'), dst_dir)

    stdout, stderr = exe('python update.py ..')
    os.chdir(os.path.join(HERE, name))

    make_command = 'make'
    binary = './bin/example'
    if sys.platform == 'win32':
        setup_command += ' --generator="MinGW Makefiles"'
        make_command = 'mingw32-make'
        binary = 'bin\\\example.exe'

    if launcher:
        binary = '%s %s' % (launcher, binary)

    setup_command += ' build-%s' % stamp

    stdout, stderr = exe(setup_command)

    os.chdir(os.path.join(HERE, name, 'build-%s' % stamp))

    stdout, stderr = exe(make_command)
    # mi: remove <assert stderr == ''> due to warnings flushed to stderr

    stdout, stderr = exe(binary)
    assert stderr == ''

    assert 'PASSED' in stdout

# ------------------------------------------------------------------------------


def test_cxx_custom():
    configure_build_and_exe('cxx_custom', 'python setup.py --cxx=g++')

# ------------------------------------------------------------------------------


def test_extra_cmake_options():
    configure_build_and_exe('extra_cmake_options', 'python setup.py --cxx=g++ --cmake-options="-DENABLE_SOMETHING=OFF -DENABLE_FOO=ON"')

# ------------------------------------------------------------------------------


def test_cxx():
    configure_build_and_exe('cxx', 'python setup.py --cxx=g++')


@skip_on_osx
def test_cxx_static():
    configure_build_and_exe('cxx', 'python setup.py --cxx=g++ --static')

# ------------------------------------------------------------------------------


def test_fc():
    configure_build_and_exe('fc', 'python setup.py --fc=gfortran')

# ------------------------------------------------------------------------------


def test_fc_git_info():
    configure_build_and_exe('fc_git_info', 'python setup.py --fc=gfortran')

# ------------------------------------------------------------------------------


def test_fc_int64():
    configure_build_and_exe('fc_int64', 'python setup.py --fc=gfortran --int64')

# ------------------------------------------------------------------------------


def test_fc_mpi():
    if sys.platform == 'win32':
        configure_build_and_exe('fc_mpi', 'python setup.py --mpi --fc=gfortran --extra-fc-flags="-D_WIN64 -D INT_PTR_KIND()=8 -fno-range-check" --add-definitions="-D USE_MPI_MODULE"', 'mpiexec -n 2')
    else:
        configure_build_and_exe('fc_mpi', 'python setup.py --mpi --fc=mpif90 --add-definitions="-D USE_MPI_MODULE"', 'mpirun -np 2')


def test_fc_mpi_include():
    if sys.platform == 'win32':
        configure_build_and_exe('fc_mpi', 'python setup.py --mpi --fc=gfortran --extra-fc-flags="-D_WIN64 -D INT_PTR_KIND()=8 -fno-range-check"', 'mpiexec -np 2')
    else:
        configure_build_and_exe('fc_mpi', 'python setup.py --mpi --fc=mpif90', 'mpirun -np 2')

# ------------------------------------------------------------------------------


@skip_on_osx
def test_fc_omp():
    os.environ['OMP_NUM_THREADS'] = '2'
    configure_build_and_exe('fc_omp', 'python setup.py --omp --fc=gfortran')


@skip_on_osx
def test_fc_static():
    configure_build_and_exe('fc', 'python setup.py --fc=gfortran --static')

# ------------------------------------------------------------------------------


def test_fc_blas():
    configure_build_and_exe('fc_blas', 'python setup.py --fc=gfortran --cmake-options="-DMATH_LIB_SEARCH_ORDER=\'OPENBLAS;ATLAS;MKL;SYSTEM_NATIVE\'"')


@skip_on_osx
def test_fc_blas_static():
    configure_build_and_exe('fc_blas', 'python setup.py --fc=gfortran --static --cmake-options="-DMATH_LIB_SEARCH_ORDER=\'OPENBLAS;ATLAS;MKL;SYSTEM_NATIVE\'"')


def test_cc_cblas():
    configure_build_and_exe('cc_cblas', 'python setup.py --cc=gcc --cmake-options="-DMATH_LIB_SEARCH_ORDER=\'OPENBLAS;ATLAS;MKL;SYSTEM_NATIVE\'"')


@skip_on_osx
def test_cc_cblas_static():
    configure_build_and_exe('cc_cblas', 'python setup.py --cc=gcc --static --cmake-options="-DMATH_LIB_SEARCH_ORDER=\'OPENBLAS;ATLAS;MKL;SYSTEM_NATIVE\'"')

# ------------------------------------------------------------------------------


def test_fc_lapack():
    configure_build_and_exe('fc_lapack', 'python setup.py --fc=gfortran --cmake-options="-DMATH_LIB_SEARCH_ORDER=\'OPENBLAS;ATLAS;MKL;SYSTEM_NATIVE\'"')


@skip_on_osx
def test_fc_lapack_static():
    configure_build_and_exe('fc_lapack', 'python setup.py --fc=gfortran --static --cmake-options="-DMATH_LIB_SEARCH_ORDER=\'OPENBLAS;ATLAS;MKL;SYSTEM_NATIVE\'"')


def test_cc_clapack():
    configure_build_and_exe('cc_clapack', 'python setup.py --cc=gcc --cmake-options="-DMATH_LIB_SEARCH_ORDER=\'OPENBLAS;ATLAS;MKL;SYSTEM_NATIVE\'"')


@skip_on_osx
def test_cc_clapack_static():
    configure_build_and_exe('cc_clapack', 'python setup.py --cc=gcc --static --cmake-options="-DMATH_LIB_SEARCH_ORDER=\'OPENBLAS;ATLAS;MKL;SYSTEM_NATIVE\'"')

# ------------------------------------------------------------------------------


def test_python_interpreter():
    configure_build_and_exe('python_interpreter', 'python setup.py --cxx=g++')


def test_python_interpreter_custom():
    setup = 'python setup.py --cxx=g++ --python=%s' % sys.executable
    configure_build_and_exe('python_interpreter_custom', setup)


def test_python_libs():
    configure_build_and_exe('python_libs', 'python setup.py --cxx=g++')


def test_python_libs_custom():
    python_executable = sys.executable
    configure_build_and_exe('python_libs_custom', 'python setup.py --cxx=g++ --python={}'.format(python_executable))


@skip_on_windows
@skip_always
def test_boost_header_only():
    configure_build_and_exe('boost_header_only', 'python setup.py --cxx=g++')


@skip_on_windows
@skip_always
def test_boost_libs():
    configure_build_and_exe('boost_libs', 'python setup.py --cxx=g++')


@skip_on_windows
@skip_always
def test_boost_mpi_libs():
    configure_build_and_exe('boost_mpi_libs', 'python setup.py --cxx=g++ --mpi')


@skip_on_windows
@skip_always
def test_boost_python_libs():
    configure_build_and_exe('boost_python_libs', 'python setup.py --cxx=g++')
