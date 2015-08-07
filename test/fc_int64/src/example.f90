program example
   implicit none
   ! max i*4 is 2,147,483,647, add 1 for i*8
   integer*8, parameter :: i8ref = 2147483648
   integer :: i
   logical :: test_ok
   i=i8ref
   test_ok = (sizeof(i) == 8 .and. i == 2147483648)
   if (test_ok) then
      print *, "PASSED"
   else
      stop "FAILED"
   endif
end program
