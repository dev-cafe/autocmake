#!/usr/bin/env python

import os
import sys


AUTOCMAKE_GITHUB_URL = 'https://github.com/coderefinery/autocmake/raw/yaml/'


def print_progress_bar(text, done, total, width):
    """
    Print progress bar.
    """
    n = int(float(width) * float(done) / float(total))
    sys.stdout.write("\r{0} [{1}{2}] ({3}/{4})".format(text, '#' * n, ' ' * (width - n), done, total))
    sys.stdout.flush()


def prepend_or_set(config, section, option, value, defaults):
    """
    If option is already set, then value is prepended.
    If option is not set, then it is created and set to value.
    This is used to prepend options with values which come from the module documentation.
    """
    if value:
        if config.has_option(section, option):
            value += '\n{0}'.format(config.get(section, option, 0, defaults))
        config.set(section, option, value)
    return config


def fetch_modules(config, relative_path):
    """
    Assemble modules which will
    be included in CMakeLists.txt.
    """
    from collections import Iterable, namedtuple
    from autocmake.extract import extract_list

    download_directory = 'downloaded'
    if not os.path.exists(download_directory):
        os.makedirs(download_directory)

    # here we get the list of sources to fetch
    sources = extract_list(config, 'source')

    modules = []
    Module = namedtuple('Module', 'path name')

    warnings = []

    if len(sources) > 0:  # otherwise division by zero in print_progress_bar
        print_progress_bar(text='- assembling modules:', done=0, total=len(sources), width=30)
        for i, src in enumerate(sources):
            module_name = os.path.basename(src)
            if 'http' in src:
                path = download_directory
                name = 'autocmake_{0}'.format(module_name)
                dst = os.path.join(download_directory, 'autocmake_{0}'.format(module_name))
                fetch_url(src, dst)
                file_name = dst
                fetch_dst_directory = download_directory
            else:
                if os.path.exists(src):
                    path = os.path.dirname(src)
                    name = module_name
                    file_name = src
                    fetch_dst_directory = path
                else:
                    sys.stderr.write("ERROR: {0} does not exist\n".format(src))
                    sys.exit(-1)

# FIXME
#           if config.has_option(section, 'override'):
#               defaults = ast.literal_eval(config.get(section, 'override'))
#           else:
#               defaults = {}

# FIXME
#           # we infer config from the module documentation
#           with open(file_name, 'r') as f:
#               parsed_config = parse_cmake_module(f.read(), defaults)
#               if parsed_config['warning']:
#                   warnings.append('WARNING from {0}: {1}'.format(module_name, parsed_config['warning']))
#               config = prepend_or_set(config, section, 'docopt', parsed_config['docopt'], defaults)
#               config = prepend_or_set(config, section, 'define', parsed_config['define'], defaults)
#               config = prepend_or_set(config, section, 'export', parsed_config['export'], defaults)
#               if parsed_config['fetch']:
#                   for src in parsed_config['fetch'].split('\n'):
#                       dst = os.path.join(fetch_dst_directory, os.path.basename(src))
#                       fetch_url(src, dst)

            modules.append(Module(path=path, name=name))
            print_progress_bar(
                text='- assembling modules:',
                done=(i + 1),
                total=len(sources),
                width=30
            )
# FIXME
#           if config.has_option(section, 'fetch'):
#               # when we fetch directly from autocmake.yml
#               # we download into downloaded/
#               for src in config.get(section, 'fetch').split('\n'):
#                   dst = os.path.join(download_directory, os.path.basename(src))
#                   fetch_url(src, dst)
        print('')

    if warnings != []:
        print('- {0}'.format('\n- '.join(warnings)))

    return modules


def process_yaml(argv):
    from autocmake.parse_yaml import parse_yaml
    from autocmake.generate import gen_cmakelists, gen_setup

    project_root = argv[1]
    if not os.path.isdir(project_root):
        sys.stderr.write("ERROR: {0} is not a directory\n".format(project_root))
        sys.exit(-1)

    # read config file
    print('- parsing autocmake.yml')
    with open('autocmake.yml', 'r') as stream:
        config = parse_yaml(stream)

    if 'name' in config:
        project_name = config['name']
    else:
        sys.stderr.write("ERROR: you have to specify the project name in autocmake.yml\n")
        sys.exit(-1)
    if ' ' in project_name.rstrip():
        sys.stderr.write("ERROR: project name contains a space\n")
        sys.exit(-1)

    if 'min_cmake_version' in config:
        min_cmake_version = config['min_cmake_version']
    else:
        sys.stderr.write("ERROR: you have to specify min_cmake_version in autocmake.yml\n")
        sys.exit(-1)

    if 'setup_script' in config:
        setup_script_name = config['setup_script']
    else:
        setup_script_name = 'setup'

    # get relative path from setup script to this directory
    relative_path = os.path.relpath(os.path.abspath('.'), project_root)

    # fetch modules from the web or from relative paths
    modules = fetch_modules(config, relative_path)

    # create CMakeLists.txt
    print('- generating CMakeLists.txt')
    s = gen_cmakelists(project_name, min_cmake_version, relative_path, modules)
    with open(os.path.join(project_root, 'CMakeLists.txt'), 'w') as f:
        f.write('{0}\n'.format('\n'.join(s)))

    # create setup script
    print('- generating setup script')
    s = gen_setup(config, relative_path, setup_script_name)
    file_path = os.path.join(project_root, setup_script_name)
    with open(file_path, 'w') as f:
        f.write('{0}\n'.format('\n'.join(s)))
    if sys.platform != 'win32':
        make_executable(file_path)


def main(argv):
    """
    Main function.
    """

    if len(argv) != 2:
        sys.stderr.write("\nYou can update a project in two steps.\n\n")
        sys.stderr.write("Step 1: Update or create infrastructure files\n")
        sys.stderr.write("        which will be needed to configure and build the project:\n")
        sys.stderr.write("        $ {0} --self\n\n".format(argv[0]))
        sys.stderr.write("Step 2: Create CMakeLists.txt and setup script in PROJECT_ROOT:\n")
        sys.stderr.write("        $ {0} <PROJECT_ROOT>\n".format(argv[0]))
        sys.stderr.write("        example:\n")
        sys.stderr.write("        $ {0} ..\n".format(argv[0]))
        sys.exit(-1)

    if argv[1] in ['-h', '--help']:
        print('Usage:')
        for t, h in [('python update.py --self',
                      'Update this script and fetch or update infrastructure files under autocmake/.'),
                     ('python update.py <builddir>',
                      '(Re)generate CMakeLists.txt and setup script and fetch or update CMake modules.'),
                     ('python update.py (-h | --help)',
                      'Show this help text.')]:
            print('  {0:30} {1}'.format(t, h))
        sys.exit(0)

    if argv[1] == '--self':
        # update self
        if not os.path.isfile('autocmake.yml'):
            print('- fetching example autocmake.yml')
            fetch_url(
                src='{0}example/autocmake.yml'.format(AUTOCMAKE_GITHUB_URL),
                dst='autocmake.yml'
            )
        if not os.path.isfile('.gitignore'):
            print('- creating .gitignore')
            with open('.gitignore', 'w') as f:
                f.write('*.pyc\n')
        for f in ['autocmake/configure.py',
                  'autocmake/__init__.py',
                  'autocmake/external/docopt.py',
                  'autocmake/generate.py',
                  'autocmake/extract.py',
                  'autocmake/interpolate.py',
                  'autocmake/parse_rst.py',
                  'autocmake/parse_yaml.py',
                  'update.py']:
            print('- fetching {0}'.format(f))
            fetch_url(
                src='{0}{1}'.format(AUTOCMAKE_GITHUB_URL, f),
                dst='{0}'.format(f)
            )
        sys.exit(0)

    process_yaml(argv)


def make_executable(path):
    # http://stackoverflow.com/a/30463972
    mode = os.stat(path).st_mode
    mode |= (mode & 0o444) >> 2    # copy R bits to X
    os.chmod(path, mode)


def fetch_url(src, dst):
    """
    Fetch file from URL src and save it to dst.
    """
    # we do not use the nicer sys.version_info.major
    # for compatibility with Python < 2.7
    if sys.version_info[0] > 2:
        import urllib.request

        class URLopener(urllib.request.FancyURLopener):
            def http_error_default(self, url, fp, errcode, errmsg, headers):
                sys.stderr.write("ERROR: could not fetch {0}\n".format(url))
                sys.exit(-1)
    else:
        import urllib

        class URLopener(urllib.FancyURLopener):
            def http_error_default(self, url, fp, errcode, errmsg, headers):
                sys.stderr.write("ERROR: could not fetch {0}\n".format(url))
                sys.exit(-1)

    dirname = os.path.dirname(dst)
    if dirname != '':
        if not os.path.isdir(dirname):
            os.makedirs(dirname)

    opener = URLopener()
    opener.retrieve(src, dst)


if __name__ == '__main__':
    main(sys.argv)
