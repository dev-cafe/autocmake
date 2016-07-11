from .test import configure_build_and_exe, skip_on_osx


@skip_on_osx
def test_fc_openblas():
    configure_build_and_exe('fc_openblas', 'python setup --fc=gfortran --openblas')
