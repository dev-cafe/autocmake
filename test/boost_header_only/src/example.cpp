#include <iostream>
#include <boost/version.hpp>

int main()
{
    std::cout << "Boost version: "
              << BOOST_VERSION / 100000
              << "."
              << BOOST_VERSION / 100 % 1000
              << "."
              << BOOST_VERSION % 100
              << std::endl;

    std::cout << "PASSED" << std::endl;

    return 0;
}
