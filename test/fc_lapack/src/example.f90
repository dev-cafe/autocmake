program example

   implicit none
   integer, parameter :: n = 20
   integer :: i, j, info
   real(8), allocatable :: a(:, :),as(:,:)
   real(8), allocatable :: b(:),bs(:)
   integer, allocatable :: ipiv(:)
   real(8), external :: dnrm2
#if defined VAR_PGI
   real(8), external :: rand
#endif
   real(8) :: zeronorm

   allocate(a(n, n),as(n,n))
   allocate(b(n),bs(n))
   allocate(ipiv(n))

  ! fill with random numbers
   do i=1,n
   do j=1,n
    a(i,j)=rand(0);as(i,j)=a(i,j)
   enddo
    b(i)=rand(0);bs(i)=b(i)
   enddo

   call dgesv( n, 1, a, n, ipiv, b, n , info )
   if (info.gt.0) stop "error in dgesv routine !"
   print *,'A:', as
   print *,'b:',bs
   print *,'roots Ax=b, x:',b

! get Ax-b into bs
   call dgemv('n', n, n, 1.0D0, as, n, b, 1, -1.0D0, bs, 1)
   ! the bs should be zero vector, check it
   ! get euklid.norm |A.x-b| - must be zero
   zeronorm=dnrm2(n,bs,1)
   print *,'zero vector, Ax-b=0',bs
   print *,'zero vector norm=',zeronorm

   if (zeronorm.le.1.0d-14) then
    print *, 'dgesv-dgemv-dnrm2 test ok'
   else
    stop 'dgesv-dgemv-dnrm2 test failed!'
   endif
end program
