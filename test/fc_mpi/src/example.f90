program example

   use mpi

   implicit none

   integer :: ierr, rank, num_ranks
   logical :: test_ok

   call MPI_INIT(ierr)
   call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
   call MPI_COMM_SIZE(MPI_COMM_WORLD, num_ranks, ierr)
   call MPI_FINALIZE(ierr)

   test_ok = (num_ranks == 2 .and. (rank == 0 .or. rank == 1))

   if (test_ok) then
      if (rank == 0) print *, 'PASSED'
   else
      stop "FAILED"
   endif

end program
