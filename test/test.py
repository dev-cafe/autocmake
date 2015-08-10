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

skip_on_windows = pytest.mark.skipif(sys.platform == 'win32',
                                     reason="windows not supported")

# ------------------------------------------------------------------------------


# we do not use the nicer sys.version_info.major
# for compatibility with Python < 2.7
if sys.version_info[0] > 2:
    import urllib.request

    class URLopener(urllib.request.FancyURLopener):
        def http_error_default(self, url, fp, errcode, errmsg, headers):
            sys.stderr.write("ERROR: could not fetch %s\n" % url)
            sys.exit(-1)
else:
    import urllib

    class URLopener(urllib.FancyURLopener):
        def http_error_default(self, url, fp, errcode, errmsg, headers):
            sys.stderr.write("ERROR: could not fetch %s\n" % url)
            sys.exit(-1)

# ------------------------------------------------------------------------------


def fetch_url(src, dst):
    """
    Fetch file from URL src and save it to dst.
    """
    dirname = os.path.dirname(dst)
    if dirname != '':
        if not os.path.isdir(dirname):
            os.makedirs(dirname)

    opener = URLopener()
    opener.retrieve(src, dst)

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
    if not os.path.exists('lib'):
        os.makedirs('lib')
    shutil.copy(os.path.join('..', '..', '..', 'lib', 'config.py'), 'lib')
    fetch_url(src='https://github.com/docopt/docopt/raw/master/docopt.py',
              dst='lib/docopt.py')
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


@skip_on_windows
def test_fc_mpi():
    configure_build_and_exe('fc_mpi', 'python setup.py --mpi --fc=mpif90', 'mpirun -np 2')

# ------------------------------------------------------------------------------


@skip_on_windows
def test_fc_omp():
    os.environ['OMP_NUM_THREADS'] = '2'
    configure_build_and_exe('fc_omp', 'python setup.py --omp --fc=gfortran')


def test_fc_static():
    configure_build_and_exe('fc', 'python setup.py --fc=gfortran --static')

# ------------------------------------------------------------------------------


@skip_on_windows
def test_fc_blas():
    configure_build_and_exe('fc_blas', 'python setup.py --fc=gfortran')


@skip_on_windows
def test_fc_blas_static():
    configure_build_and_exe('fc_blas', 'python setup.py --fc=gfortran --static')

# ------------------------------------------------------------------------------


@skip_on_windows
def test_fc_lapack():
    configure_build_and_exe('fc_lapack', 'python setup.py --fc=gfortran')


@skip_on_windows
def test_fc_lapack_static():
    configure_build_and_exe('fc_lapack', 'python setup.py --fc=gfortran --static --cmake-options="-DMATH_LIB_SEARCH_ORDER=\'ATLAS;MKL\'"')
