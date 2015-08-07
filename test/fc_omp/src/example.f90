program example
   implicit none
   integer ::  nthreads, tid 
   integer, external :: omp_get_num_threads, omp_get_thread_num
   logical :: test_ok, tid_ok
!$OMP PARALLEL SHARED (nthreads, tid_ok), PRIVATE(tid)
   tid = omp_get_thread_num()
   if (tid .eq. 0) then
      nthreads = omp_get_num_threads() 
   endif
   tid_ok=(tid == 0 .or. tid == 1)
!$OMP END PARALLEL
   test_ok=(nthreads==2 .and. tid_ok)
   if (test_ok) then
      print *, "PASSED"
   else
      stop "test fc_omp failed!"
   endif
end program
