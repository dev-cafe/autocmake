#include <iostream>

#include <boost/mpi/environment.hpp>
#include <boost/mpi/communicator.hpp>
#include <boost/python.hpp>
#include <boost/version.hpp>

int main()
{
    using namespace boost::python;
    namespace mpi = boost::mpi;

    std::cout << "Boost version: "
              << BOOST_VERSION / 100000
              << "."
              << BOOST_VERSION / 100 % 1000
              << "."
              << BOOST_VERSION % 100
              << std::endl;

    try {
        Py_Initialize();

        object main_module((
                    handle<>(borrowed(PyImport_AddModule("__main__")))));

        object main_namespace = main_module.attr("__dict__");

        handle<> ignored(( PyRun_String( "print \"Hello, World\"",
                        Py_file_input,
                        main_namespace.ptr(),
                        main_namespace.ptr() ) ));
    } catch( error_already_set ) {
        PyErr_Print();
    }

    mpi::environment env;
    mpi::communicator world;
    std::cout << "I am process " << world.rank() << " of " << world.size()
        << "." << std::endl;

    std::cout << "PASSED" << std::endl;

    return 0;
}
