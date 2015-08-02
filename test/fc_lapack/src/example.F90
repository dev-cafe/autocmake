program example
   implicit none
   integer, parameter :: n = 3
   integer :: info
   real(8) :: a(n, n)
   real(8) :: b(n)
   integer :: ipiv(n)
   logical :: roots_ok=.false.
  
   data a /2,1,3,2,6,8,6,8,18/
   data b /1,3,5/

   call dgesv( n, 1, a, n, ipiv, b, n , info )
   if (info.gt.0) stop "error in dgesv routine !"

!    roots are -0.5, 0.25, 0.25
   roots_ok=dabs(b(1)+0.5).le.1d-12.and.dabs(b(2)-0.25).le.1d-12.and.dabs(b(3)-0.25).le.1d-12

   if (roots_ok) then
    print *, 'dgesv test ok'
   else
    stop 'dgesv test failed!'
   endif
end program
