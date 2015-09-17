#include <stdio.h>
#include <stdlib.h>

#if defined HAVE_MKL_LAPACK
#include <mkl_lapacke.h>
#include <mkl_cblas.h>
#pragma message "Using Intel MKL c-lapack interface, <mkl_lapacke.h>."
#elif defined HAVE_OPENBLAS_LAPACK
#include <lapacke.h>
#include <cblas.h>
#pragma message "Using OpenBLAS C-lapack interface, <lapacke.h>."
#else
#include <clapack.h>
#include <cblas.h>
#pragma message "Using ATLAS/SYSTEM_NATIVE C lapack interface, <clapack.h>."
#endif

int main()
{
    const int n = 3;

    double a[n*n];
    double b[n];

    a[0] =  2.00;
    a[1] =  1.00;
    a[2] =  3.00;
    a[3] =  2.00;
    a[4] =  6.00;
    a[5] =  8.00;
    a[6] =  6.00;
    a[7] =  8.00;
    a[8] = 18.00;

    b[0] = 1.00;
    b[1] = 3.00;
    b[2] = 5.00;

    int ierr;
    int ipiv[n];

/* MKL, OpenBLAS   */
#if defined HAVE_MKL_LAPACK  || defined HAVE_OPENBLAS_LAPACK
    ierr = LAPACKE_dgesv(CblasColMajor, n, 1, a,  n, ipiv, b, n);
#else /* ATLAS, SYSTEM_NATIVE */
    ierr = clapack_dgesv(CblasColMajor, n, 1, a,  n, ipiv, b, n);
#endif
    if (ierr != 0)
    {
        fprintf(stderr, "\ndgesv failure with error %i\n", ierr);
    }

    const double small = 1.0e-12;

    if (abs(b[0] + 0.50) <= small &&
        abs(b[1] - 0.25) <= small &&
        abs(b[2] - 0.25) <= small)
    {
        printf("PASSED");
    }

    return 0;
}
