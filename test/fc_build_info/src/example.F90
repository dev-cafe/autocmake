program example

   implicit none
   logical :: test_ok

! file generated at build time
#include "build_info.h"

   test_ok = len(FORTRAN_COMPILER)   > 0 .and. &
             len(SYSTEM_NAME)        > 0 .and. &
             len(CMAKE_GENERATOR)    > 0 .and. &
             len(CMAKE_VERSION)      > 0

   if (test_ok) print *, 'PASSED'

end program
