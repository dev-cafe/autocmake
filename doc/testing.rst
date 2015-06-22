

Testing Autocmake
=================

You will need to install `pytest <http://pytest.org/>`__.
Check also the `Travis build and test recipe <https://github.com/scisoft/autocmake/blob/master/.travis.yml>`__
for other requirements.

Your contributions and changes should preserve the test set. You can run it locally with::

  $ py.test test/test.py

This test set is run upon each push to the central repository.
See also the `Travis build and test history <https://travis-ci.org/scisoft/autocmake/builds>`__.
