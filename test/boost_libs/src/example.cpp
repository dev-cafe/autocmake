#include <cmath>
#include <iostream>
#include <iomanip>

#include <boost/timer/timer.hpp>
#include <boost/version.hpp>

int main()
{
    boost::timer::auto_cpu_timer t;

    std::cout << "Boost version: "
              << BOOST_VERSION / 100000
              << "."
              << BOOST_VERSION / 100 % 1000
              << "."
              << BOOST_VERSION % 100
              << std::endl;


    std::cout << "Measuring some timings..." << std::endl;
    for (long i = 0; i < 100000000; ++i)
        std::sqrt(123.456L); // burn some time

    std::cout << "PASSED" << std::endl;

    return 0;
}
