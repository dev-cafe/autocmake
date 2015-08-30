#include <stdio.h>
#include <stdlib.h>
/* cblas */
#if defined HAVE_MKL_BLAS
#include "mkl_cblas.h"
#pragma message "Using Intel MKL <mkl_cblas.h> interface"
#else
#include "cblas.h"
#pragma message "Using GNU <cblas.h> interface"
#endif

void main(void)
{
  int i,j,n=10;
  double *a,*b,*c;
  unsigned char test_ok=1;

  a = (double*)malloc(n * n * sizeof(a[0]));
  b = (double*)malloc(n * n * sizeof(b[0]));
  c = (double*)malloc(n * n * sizeof(c[0]));

  for (i = 0; i < n*n; i++) { a[i] = 1.0;  b[i] = 2.0;  c[i] = 0.0; }

  cblas_dgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, n, n, n, 1.00, a, n, b, n, 0.00, c, n);

  for (i = 0; i < n*n; i++) {
    if (abs(c[i]) - 20.00 > 0.0) { printf ("\n ERROR: element %i is %lf",i,c[i]); test_ok = 0;}
  }
  if ( test_ok == 1 ) {printf("PASSED");}
  free(a);free(b);free(c);
}
