import os
import subprocess
import shutil
import sys

HERE = os.path.abspath(os.path.dirname(__file__))

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
    stdout, stderr = subprocess.Popen(command.split(),
                                      stdout=subprocess.PIPE,
                                      stderr=subprocess.PIPE).communicate()
    return stdout, stderr

# ------------------------------------------------------------------------------


def test_cxx():
    os.chdir(os.path.join(HERE, 'cxx', 'cmake'))
    shutil.copy(os.path.join('..', '..', '..', 'update.py'), 'update.py')
    if not os.path.exists('lib'):
        os.makedirs('lib')
    shutil.copy(os.path.join('..', '..', '..', 'lib', 'config.py'), 'lib')
    fetch_url(src='https://github.com/docopt/docopt/raw/master/docopt.py',
              dst='lib/docopt.py')
    stdout, stderr = exe('python update.py ..')
    os.chdir(os.path.join(HERE, 'cxx'))
    stdout, stderr = exe('python setup.py --cxx=g++')
    os.chdir(os.path.join(HERE, 'cxx', 'build'))
    stdout, stderr = exe('make')
    stdout, stderr = exe('./bin/example')
    assert 'Hello World!' in stdout

# ------------------------------------------------------------------------------


def test_fc():
    os.chdir(os.path.join(HERE, 'fc', 'cmake'))
    shutil.copy(os.path.join('..', '..', '..', 'update.py'), 'update.py')
    if not os.path.exists('lib'):
        os.makedirs('lib')
    shutil.copy(os.path.join('..', '..', '..', 'lib', 'config.py'), 'lib')
    fetch_url(src='https://github.com/docopt/docopt/raw/master/docopt.py',
              dst='lib/docopt.py')
    stdout, stderr = exe('python update.py ..')
    os.chdir(os.path.join(HERE, 'fc'))
    stdout, stderr = exe('python setup.py --fc=gfortran')
    os.chdir(os.path.join(HERE, 'fc', 'build'))
    stdout, stderr = exe('make')
    stdout, stderr = exe('./bin/example')
    assert 'Hello World!' in stdout
