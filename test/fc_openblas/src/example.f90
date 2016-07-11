program example

   implicit none

   integer, parameter :: n = 10

   integer :: i, j
   logical :: test_ok

   real(8), allocatable :: a(:, :)
   real(8), allocatable :: b(:, :)
   real(8), allocatable :: c(:, :)

   allocate(a(n, n))
   allocate(b(n, n))
   allocate(c(n, n))

   a = 1.0d0
   b = 2.0d0
   c = 0.0d0

   call dgemm('n', 'n', n, n, n, 1.0d0, a, n, b, n, 0.0d0, c, n)

   test_ok = .true.

   do i = 1, n
      do j = 1, n
         if (dabs(c(i, j) - 20.0d0) > tiny(0.0d0)) then
            print *, 'ERROR: element', i, j, 'is', c(i, j)
            test_ok = .false.
         end if
      end do
   end do

   deallocate(a)
   deallocate(b)
   deallocate(c)

   if (test_ok) then
      print *, 'PASSED'
   else
      print *, 'FAILED'
   end if

end program
