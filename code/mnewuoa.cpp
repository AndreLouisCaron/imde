// Copyright(c) Andre Caron, 2009-2010
//
// This document is covered by the Artistic License 2.0 (Open Source Initiative
// approved license). A copy of the license should have been provided alongside
// this software package (see "license.rtf"). If not, the license is available
// online at "http://www.opensource.org/licenses/artistic-license-2.0.php".

#include "mex/mex.hpp"

#include <cmath>
#include <vector>
#include <iostream>

    /*!
     * @brief Callback to a function to optimize.
     *
     * @param n Number of variables (dimension of variable vector @a x).
     * @param x Variable vector.
     * @param f Result of objectvie function (cost of solution @a x).
     * @param p Extra parameters to pass to function.
     */
typedef void ( * ObjectiveFunction )
    ( long int * n, double * x, double * f, void * p );

    /*!
     * @brief NewUOA optimization algorithm.
     *
     * @param w Working space array.
     * @param fun Buffer for current point.
     * @param n Number of variables (dimension of variable vector @a x).
     * @param npt Number of interpolation conditions.
     * @param x Initial position.
     * @param rhobeg Initial trust radius.
     * @param rhoend Final trust radius.
     * @param iprint Verbosity level. This is ignored.
     * @param maxfun Upper-bound on the number of calls to @a obj.
     * @param obj Function to optimize.
     * @param cxt Extra context to pass to callback function @obj.
     *
     * @pre @c length(w) >= (@a npt+13)*(@a npt+ @a n)+3*@a n*(@a n+3)/2.
     * @pre @a n >= 2.
     * @pre @a npt is in the interval [@a n+2,(@a n+1)(@a n+2)/2].
     * @pre @c length(@a x) == @a n.
     * @pre @a rhobeg > 0, @a rhoend > 0, @a rhoend <= @a rhobeg
     * @pre @a maxfun > 1
     */
extern "C" int newuoa (
    double * w, double * fun, long int * n, long int * npt, double * x,
    double * rhobeg, double * rhoend, long int * iprint, long int * maxfun,
    ObjectiveFunction obj, void * cxt
    );

namespace {

        // Implementation of objective function.
    void objective ( long int * n, double * x, double * f, void * p )
    {
            // Get the function name or handle.
        ::mxArray * function = reinterpret_cast<::mxArray*>(p);
        
            // Require MATLAB-compatible buffers.
        mex::array<double> X(1, *n);
        std::copy(x, x+(*n), X.begin());
        
            // Evaluate cost function.
        ::mxArray* prhs[] = {
            function, X.backend()
        }; const int nrhs = 2;
        ::mxArray* plhs[] = {
            0
        }; const int nlhs = 1;
        mex::call(nlhs, plhs, nrhs, prhs, "feval");
        
            // Return results.
        mex::array<double> F(plhs[0], mex::claim);
        std::copy(F.begin(), F.end(), f);
    }

    const char usage[] =
      "usage: mnewuoa(function,x[,trust[,limit]]);\n"
      "  Runs the NewUOA optimization algorithm, minimizing 'function'.\n"
      "  The initial position for the algorithm is at 'x'.\n"
      "  The optional region of trust (2 doubles) defaults to [1.0, 0.01].\n"
      "  NewUOA documentation explains the first value as one tenth of the\n"
      "  greatest expected change in an iteration and the second value as the\n"
      "  maximum radius at convergeance. The maximum number of calls to\n"
      "  'function' may be defined in 'limit'. This value defaults to 50.\n"
      ;

        /*!
         * @brief Matlab extension entry point.
         *
         * @param nlhs Number of output (left hand-side) variables.
         * @param plhs Output variables.
         * @param nrhs Number of input (right hand-side) variables.
         * @param prhs Input variables.
         */
    extern "C" void mexFunction
        ( int nlhs, ::mxArray * plhs[], int nrhs, const ::mxArray * prhs [] )
    try
    {
            // Display usage if requested.
        if ( nrhs == 0 )
        {
                // Sanity check for argument count.
            if ( nlhs > 0 ) {
              throw (std::exception("Wrong number of inputs."));
            }
            
                // Display precious help.
	    mex::print(usage); return;
        }
        
            // Sanity check for argument count.
        if ((nrhs < 2) || (nrhs > 4)) {
            throw (std::exception("Wrong number of inputs."));
        }
        if ((nlhs < 1) || (nlhs > 1)) {
            throw (std::exception("Wrong number of outputs."));
        }
        
            // Sanity check for input arguments.
        mex::array<double> x0(prhs[1], mex::clone);
        if ((x0.M() != 1) || (x0.N() <= 1)) {
            throw (std::exception("Expecting vector of doubles."));
        }
        
            // Optional algorithm arguments.
        double rho[] = { 1.0, 0.01 };
        long maxfun = 50;
        if ( nrhs > 2 )
        {
            mex::array<double> r(prhs[2], mex::clone);
            if ( r.numel() != 2 ) {
                throw (std::exception(
                    "Region-of-trust shoud be a pair of doubles."));
            }
            rho[0] = r(0); rho[1] = r(1);
        }
        if ( nrhs > 3 )
        {
            mex::array<double> m(prhs[3], mex::clone);
            if ( m.numel() != 1 ) {
                throw (std::exception(
                    "Maximum evaluation count should be a positive integer."));
            }
            maxfun = static_cast<long>(floor(m(0)));
        }
        
            // Set invocation parameters (pass-by-reference required).
        long n = x0.N();
        long npt = n + 2;
        long iprint = 0;
        
            // Allocate algorithm working space (see procedure documentation for
            // array size computation details).
        mex::array<double> w(1, (npt+13)*(npt+n)+3*n*(n+3)/2);
        
            // Invoke the NewUOA algorithm.
        mex::array<double> fun(x0);
        newuoa(w.data(), fun.data(), &n, &npt, x0.data(), &rho[0], &rho[1],
            &iprint, &maxfun, objective, const_cast<::mxArray*>(prhs[0]));
        
            // Return results. This should be the last line of the program,
            // because it releases resources which won't be cleaned up if
            // something fails.
        plhs[0] = x0.release();
    }
    catch ( const std::exception& error ) {
        mex::error(error.what());
    }
    catch ( ... ) {
        mex::error("An unknown error occured, aborting!");
    }

}
