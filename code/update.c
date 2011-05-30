/* 'NEWUOA Scilab Interface' (interface with scilab of the NEWUOA Library) The
   'NEWUOA Library' is an unconstrainted optimization algorithm without
   derivtatives What is Licensed is the Scilab Interface and not the NEWUOA
   Library written by MJD Powell
   Copyright (C) 2005 GUILBERT */

/* This code includes minor modifications by André Caron
   <andre.louis.caron@usherbrooke.ca> for compilation as a MATLAB extension. */

#include "newuoa.h"

int update_(long int *n, long int *npt, double *bmat, double *zmat,
	    long int *idz, long int *ndim, double *vlag, double *beta,
	    long int *knew, double *w)
{
    /* System generated locals */
    long int bmat_dim1, bmat_offset, zmat_dim1, zmat_offset, i__1, i__2;
    double d__1, d__2;

    /* Builtin functions */
    double sqrt(double);

    /* Local variables */
    static long int i__, j, ja, jb, jl, jp;
    static double one, tau, temp;
    static long int nptm;
    static double zero;
    static long int iflag;
    static double scala, scalb, alpha, denom, tempa, tempb, tausq;


/* The arrays BMAT and ZMAT with IDZ are updated, in order to shift the */
/* interpolation point that has index KNEW. On entry, VLAG contains the */
/* components of the vector Theta*Wcheck+e_b of the updating formula */
/* (6.11), and BETA holds the value of the parameter that has this name. */
/* The vector W is used for working space. */

    /* Parameter adjustments */
    zmat_dim1 = *npt;
    zmat_offset = 1 + zmat_dim1;
    zmat -= zmat_offset;
    bmat_dim1 = *ndim;
    bmat_offset = 1 + bmat_dim1;
    bmat -= bmat_offset;
    --vlag;
    --w;

    /* Function Body */
    one = 1.;
    zero = 0.;
    nptm = *npt - *n - 1;

/*     Apply the rotations that put zeros in the KNEW-th row of ZMAT. */

    jl = 1;
    i__1 = nptm;
    for (j = 2; j <= i__1; ++j) {
	if (j == *idz) {
	    jl = *idz;
	} else if (zmat[*knew + j * zmat_dim1] != zero) {
/* Computing 2nd power */
	    d__1 = zmat[*knew + jl * zmat_dim1];
/* Computing 2nd power */
	    d__2 = zmat[*knew + j * zmat_dim1];
	    temp = sqrt(d__1 * d__1 + d__2 * d__2);
	    tempa = zmat[*knew + jl * zmat_dim1] / temp;
	    tempb = zmat[*knew + j * zmat_dim1] / temp;
	    i__2 = *npt;
	    for (i__ = 1; i__ <= i__2; ++i__) {
		temp = tempa * zmat[i__ + jl * zmat_dim1] + tempb * zmat[i__ 
			+ j * zmat_dim1];
		zmat[i__ + j * zmat_dim1] = tempa * zmat[i__ + j * zmat_dim1] 
			- tempb * zmat[i__ + jl * zmat_dim1];
/* L10: */
		zmat[i__ + jl * zmat_dim1] = temp;
	    }
	    zmat[*knew + j * zmat_dim1] = zero;
	}
/* L20: */
    }

/* Put the first NPT components of the KNEW-th column of HLAG into W, */
/* and calculate the parameters of the updating formula. */

    tempa = zmat[*knew + zmat_dim1];
    if (*idz >= 2) {
	tempa = -tempa;
    }
    if (jl > 1) {
	tempb = zmat[*knew + jl * zmat_dim1];
    }
    i__1 = *npt;
    for (i__ = 1; i__ <= i__1; ++i__) {
	w[i__] = tempa * zmat[i__ + zmat_dim1];
	if (jl > 1) {
	    w[i__] += tempb * zmat[i__ + jl * zmat_dim1];
	}
/* L30: */
    }
    alpha = w[*knew];
    tau = vlag[*knew];
    tausq = tau * tau;
    denom = alpha * *beta + tausq;
    vlag[*knew] -= one;

/* Complete the updating of ZMAT when there is only one nonzero element */
/* in the KNEW-th row of the new matrix ZMAT, but, if IFLAG is set to one, */
/* then the first column of ZMAT will be exchanged with another one later. */

    iflag = 0;
    if (jl == 1) {
	temp = sqrt((abs(denom)));
	tempb = tempa / temp;
	tempa = tau / temp;
	i__1 = *npt;
	for (i__ = 1; i__ <= i__1; ++i__) {
/* L40: */
	    zmat[i__ + zmat_dim1] = tempa * zmat[i__ + zmat_dim1] - tempb * 
		    vlag[i__];
	}
	if (*idz == 1 && temp < zero) {
	    *idz = 2;
	}
	if (*idz >= 2 && temp >= zero) {
	    iflag = 1;
	}
    } else {

/* Complete the updating of ZMAT in the alternative case. */

	ja = 1;
	if (*beta >= zero) {
	    ja = jl;
	}
	jb = jl + 1 - ja;
	temp = zmat[*knew + jb * zmat_dim1] / denom;
	tempa = temp * *beta;
	tempb = temp * tau;
	temp = zmat[*knew + ja * zmat_dim1];
	scala = one / sqrt(abs(*beta) * temp * temp + tausq);
	scalb = scala * sqrt((abs(denom)));
	i__1 = *npt;
	for (i__ = 1; i__ <= i__1; ++i__) {
	    zmat[i__ + ja * zmat_dim1] = scala * (tau * zmat[i__ + ja * 
		    zmat_dim1] - temp * vlag[i__]);
/* L50: */
	    zmat[i__ + jb * zmat_dim1] = scalb * (zmat[i__ + jb * zmat_dim1] 
		    - tempa * w[i__] - tempb * vlag[i__]);
	}
	if (denom <= zero) {
	    if (*beta < zero) {
		++(*idz);
	    }
	    if (*beta >= zero) {
		iflag = 1;
	    }
	}
    }

/* IDZ is reduced in the following case, and usually the first column */
/* of ZMAT is exchanged with a later one. */

    if (iflag == 1) {
	--(*idz);
	i__1 = *npt;
	for (i__ = 1; i__ <= i__1; ++i__) {
	    temp = zmat[i__ + zmat_dim1];
	    zmat[i__ + zmat_dim1] = zmat[i__ + *idz * zmat_dim1];
/* L60: */
	    zmat[i__ + *idz * zmat_dim1] = temp;
	}
    }

/* Finally, update the matrix BMAT. */

    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	jp = *npt + j;
	w[jp] = bmat[*knew + j * bmat_dim1];
	tempa = (alpha * vlag[jp] - tau * w[jp]) / denom;
	tempb = (-(*beta) * w[jp] - tau * vlag[jp]) / denom;
	i__2 = jp;
	for (i__ = 1; i__ <= i__2; ++i__) {
	    bmat[i__ + j * bmat_dim1] = bmat[i__ + j * bmat_dim1] + tempa * 
		    vlag[i__] + tempb * w[i__];
	    if (i__ > *npt) {
		bmat[jp + (i__ - *npt) * bmat_dim1] = bmat[i__ + j * 
			bmat_dim1];
	    }
/* L70: */
	}
    }
    return 0;
} /* update_ */
