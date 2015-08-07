program example

   implicit none

   integer, parameter :: n = 3
   real(8), parameter :: small = 1.0d-12
   integer :: ierr
   real(8) :: a(n, n)
   real(8) :: b(n)
   integer :: ipiv(n)
   logical :: roots_ok

   a(1, 1) =  2.0d0
   a(2, 1) =  1.0d0
   a(3, 1) =  3.0d0
   a(1, 2) =  2.0d0
   a(2, 2) =  6.0d0
   a(3, 2) =  8.0d0
   a(1, 3) =  6.0d0
   a(2, 3) =  8.0d0
   a(3, 3) = 18.0d0

   b(1) = 1.0d0
   b(2) = 3.0d0
   b(3) = 5.0d0

   call dgesv(n, 1, a, n, ipiv, b, n, ierr)
   if (ierr /= 0) stop "error in dgesv routine!"

   roots_ok = dabs(b(1) + 0.50d0) <= small .and. &
              dabs(b(2) - 0.25d0) <= small .and. &
              dabs(b(3) - 0.25d0) <= small

   if (roots_ok) then
      print *, 'PASSED'
   else
      stop 'ERROR: dgesv test failed!'
   endif

end program
