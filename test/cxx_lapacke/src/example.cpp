#include <stdio.h>
#include <stdlib.h>

#include "lapacke.h"

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
        printf("PASSED");
    }

    return 0;
}
