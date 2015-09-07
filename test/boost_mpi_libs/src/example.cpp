#include <iostream>

#include <boost/mpi/environment.hpp>
#include <boost/mpi/communicator.hpp>
#include <boost/version.hpp>

int main()
{
    namespace mpi = boost::mpi;
    std::cout << "Boost version: "
        << BOOST_VERSION / 100000
        << "."
        << BOOST_VERSION / 100 % 1000
        << "."
        << BOOST_VERSION % 100
        << std::endl;

    mpi::environment env;
    mpi::communicator world;
    std::cout << "I am process " << world.rank() << " of " << world.size()
        << "." << std::endl;

    std::cout << "PASSED" << std::endl;

    return 0;
}
