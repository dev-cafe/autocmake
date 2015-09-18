#include <stdio.h>
#include <stdlib.h>

#include "Accelerate/Accelerate.h"

bool test_lapack()
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

    ierr = LAPACKE_dgesv(CblasColMajor, n, 1, a,  n, ipiv, b, n);
    if (ierr != 0)
    {
        fprintf(stderr, "\ndgesv failure with error %i\n", ierr);
    }

    const double small = 1.0e-12;

    if (abs(b[0] + 0.50) <= small &&
        abs(b[1] - 0.25) <= small &&
        abs(b[2] - 0.25) <= small)
    {
        return true;
    }

    return false;
}

bool test_blas()
{
    const int n = 10;

    double a[n*n];
    double b[n*n];
    double c[n*n];

    for (int i = 0; i < n*n; i++)
    {
        a[i] = 1.0;
        b[i] = 2.0;
        c[i] = 0.0;
    }

    cblas_dgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, n, n, n, 1.0, a, n, b, n, 0.0, c, n);

    bool passed = true;
    for (int i = 0; i < n*n; i++)
    {
        if (abs(c[i]) - 20.00 > 0.0) passed = false;
    }

    return passed;
}

int main()
{
    if (test_lapack() and test_blas()) printf("PASSED");
}
