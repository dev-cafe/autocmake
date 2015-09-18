#include <stdio.h>
#include <stdlib.h>

#include "Accelerate/Accelerate.h"

int main()
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

    if (passed) printf("PASSED");

    return 0;
}
