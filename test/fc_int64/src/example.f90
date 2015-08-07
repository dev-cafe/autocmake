program example

   implicit none

   ! max integer(4) is 2147483647
   integer(8), parameter :: i8ref = 2147483648

   integer :: i

   logical :: test_ok

   i = i8ref

   test_ok = (sizeof(i) == 8 .and. i == 2147483648)

   if (test_ok) then
      print *, "PASSED"
   else
      stop "FAILED"
   endif

end program
