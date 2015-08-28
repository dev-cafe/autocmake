#include <iostream>
#include <Python.h>

int main(int argc, char *argv[])
{
    Py_SetProgramName(argv[0]);  /* optional but recommended */
    Py_Initialize();
    PyRun_SimpleString("print('PASSED')\n");
    Py_Finalize();
    return 0;
}
