program example
   implicit none
   call dgemm_test
   print *,'dgemm_test done'
end program

subroutine dgemm_test
   implicit none
   integer :: i,j,k,AllocateStatus
   integer :: n=10
   real*8, allocatable :: A(:,:),B(:,:),C(:,:)
   real*8 :: diag, offdiag, asde,asode

   allocate (A(n,n),B(n,n),C(n,n),STAT=AllocateStatus)
   if (AllocateStatus.ne.0) then
      stop "error in main matrix allocations !"
   endif

   ! fill matrixes A,B,C
   do i=1,n
   do j=1,n
      if (i.eq.j) then ! A is unit matrix
          A(i,j)=1.0d0
      else
          A(i,j)=0.0d0
      endif
      B(i,j)=dfloat(i+j) ! B is symmetric matrix
      C(i,j)=0.0d0
   enddo
   enddo
   call dgemm('n','n',n,n,n,1.0d0,A,n,B,n,-2.0d0,C,n)
   ! check the resulting C matrix
   diag=0.0d0;offdiag=0.0d0
   do i=1,n
   do j=1,n
      if (i.eq.j) then
         diag = diag + C(i,j)
      else
         offdiag = offdiag + C(i,j)
      endif
   enddo
   enddo
  
   asde=diag/dfloat(n); asode=offdiag/(dfloat(n*n)-dfloat(n))
   
end subroutine dgemm_test

