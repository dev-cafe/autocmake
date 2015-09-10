

Testing Autocmake
=================

You will need to install `pytest <http://pytest.org/>`__.

Check also the `Travis  <https://github.com/scisoft/autocmake/blob/master/.travis.yml>`__
and the `Appveyor <https://github.com/scisoft/autocmake/blob/master/appveyor.yml>`__ 
build and test recipes for other requirements.

Your contributions and changes should preserve the test set. You can run locally all tests with::

  $ py.test test/test.py
  
You can also select individual tests, for example those with *fc_blas* string in the name

  $ py.test -k fc_blas test/test.py
  
For more options, see the *py.test* flags.

This test set is run upon each push to the central repository.
See also the `Travis <https://travis-ci.org/scisoft/autocmake/builds>`__ and the
`Appveyour <https://ci.appveyor.com/project/bast/autocmake/history>`__  build and test history.
