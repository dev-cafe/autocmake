#include <iostream>
#include <Python.h>

int main(int argc, char *argv[])
{
    Py_Initialize();
    PyRun_SimpleString("print('PASSED')\n");
    Py_Finalize();
    return 0;
}
