

Testing Autocmake
=================

You will need to install `pytest <http://pytest.org/>`__.

Check also the `Travis  <https://github.com/coderefinery/autocmake/blob/master/.travis.yml>`__
build and test recipe for other requirements.

Your contributions and changes should preserve the test set and be PEP8 conform.
You can run locally all tests with::

  $ pep8 --ignore E501 update.py
  $ pep8 --ignore E501,E265 autocmake
  $ py.test -vv autocmake/*
  $ py.test -vv test/test.py

You can also select individual tests, for example those with ``fc_blas`` string in the name::

  $ py.test -k fc_blas test/test.py

For more options, see the ``py.test`` flags.

This test set is run upon each push to the central repository.
See also the `Travis <https://travis-ci.org/coderefinery/autocmake/builds>`__
build and test history.
