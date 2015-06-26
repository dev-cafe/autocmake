import os
import subprocess
import update

HERE = os.path.abspath(os.path.dirname(__file__))


def exe(command):
    stdout, stderr = subprocess.Popen(command.split(),
                                      stdout=subprocess.PIPE,
                                      stderr=subprocess.PIPE).communicate()
    return stdout, stderr


def test_cxx():
    os.chdir(os.path.join(HERE, 'cxx', 'cmake'))
    update.fetch_url('https://github.com/scisoft/autocmake/raw/master/update.py', 'update.py')
    stdout, stderr = exe('python update.py --self')
    stdout, stderr = exe('python update.py ..')
    os.chdir(os.path.join(HERE, 'cxx'))
    stdout, stderr = exe('python setup.py --cxx=g++')
    os.chdir(os.path.join(HERE, 'cxx', 'build'))
    stdout, stderr = exe('make')
    stdout, stderr = exe('./bin/example')
    assert 'Hello World!' in stdout


def test_fc():
    os.chdir(os.path.join(HERE, 'fc', 'cmake'))
    update.fetch_url('https://github.com/scisoft/autocmake/raw/master/update.py', 'update.py')
    stdout, stderr = exe('python update.py --self')
    stdout, stderr = exe('python update.py ..')
    os.chdir(os.path.join(HERE, 'fc'))
    stdout, stderr = exe('python setup.py --fc=gfortran')
    os.chdir(os.path.join(HERE, 'fc', 'build'))
    stdout, stderr = exe('make')
    stdout, stderr = exe('./bin/example')
    assert 'Hello World!' in stdout
