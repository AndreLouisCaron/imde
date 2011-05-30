/* 'NEWUOA Scilab Interface' (interface with scilab of the NEWUOA Library) The
   'NEWUOA Library' is an unconstrainted optimization algorithm without
   derivtatives What is Licensed is the Scilab Interface and not the NEWUOA
   Library written by MJD Powell
   Copyright (C) 2005 GUILBERT */

/* This code includes minor modifications by André Caron
   <andre.louis.caron@usherbrooke.ca> for compilation as a MATLAB extension. */

#ifndef CPOWELL_H
#define CPOWELL_H

/****************************************************************/
/*Function written by M.J.D. Powell and translated into C by f2c*/
/****************************************************************/

typedef void (*pobj)(long int *, double *, double *, void *);

extern int newuoa(double *, double *, long int *, long int *, double *, 
	    double *, double *, long int *, long int *, 
		  pobj obj, void * );

int newuob_(double *, long int *, long int *, double *, 
	    double *, double *, long int *, long int *, pobj obj, void *,
		double *, double *, double *, double *, double *, 
	    double *, double *, double *, double *, 
	    double *, long int *, double *, double *, double *);

int biglag_(long int *, long int *, double *, 
	    double *, double *, double *, long int *, long int *, 
	    long int *, double *, double *, double *, double *,
	     double *, double *, double *, double *);
	
int bigden_(long int *, long int *, double *, double *, double *, 
	    double *, long int *, long int *, long int *, long int *, 
	    double *, double *, double *, double *, 
	    double *, double *, double *);

int update_(long int *, long int *, 
	    double *, double *, long int *, long int *, double *, 
	    double *, long int *, double *);

int trsapp_(long int *, long int *, double *, 
	    double *, double *, double *, double *, 
	    double *, double *, double *, double *, 
	    double *, double *, double *);

#define min(a,b) ((a) <= (b) ? (a) : (b))
#define max(a,b) ((a) >= (b) ? (a) : (b))

#endif
