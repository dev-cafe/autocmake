program example

   implicit none

   integer, parameter :: n = 10

   integer :: i, j

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

   do i = 1, n
      do j = 1, n
         if ((c(i, j) - 20.0d0) > tiny(0.0d0)) return
      end do
   end do

   deallocate(a)
   deallocate(b)
   deallocate(c)

   print *, 'dgemm test ok'

end program
