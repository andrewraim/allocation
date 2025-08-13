#' @title
#' Algorithms for Exact Optimization Allocation
#' 
#' @description 
#' Algorithms III and IV from Wright (2017), and classical (unconstrained)
#' Neyman allocation.
#' 
#' @param n Target sample size for Algorithm III (integer)
#' @param v0 Target variance for Algorithm IV (numeric)
#' @param N_str Population size for each stratum (integer vector)
#' @param S_str Standard deviation for each stratum (numeric vector)
#' @param lo_str Sample size lower bounds for each stratum (numeric vector)
#' @param hi_str Sample size upper bounds for each stratum (numeric vector)
#' @param verbose Print detailed information for each selection (boolean)
#'
#' @return An object which contains the results; the structure depends on 
#' allocation method.
#' 
#' @details
#' Algorithm III finds the optimial allocation for a given total sample size
#' `n`. Algorithm IV allocates units until the overall variance is smaller than
#' a given `v0`.
#' 
#' Global options for the package (with defaults) are:
#' 
#' - `options(allocation.prec.bits = 256)` Number of bits of
#'   precision to use with `mpfr` objects in internal calculations.
#' - `options(allocation.print.decimals = 4)` Number of decimals
#'   to display in output.
#' - `options(allocation.algIV.tol = 1e-10)` A small positive
#'   number for use in Algorithm IV; if all strata have `V_str <= tol`,
#'   no more allocation is possible, even if target value `v0` has
#'   not yet been attained.
#'
#' @references
#' Tommy Wright (2012). The Equivalence of Neyman Optimum Allocation for
#' Sampling and Equal Proportions for Apportioning the U.S. House of
#' Representatives. The American Statistician, 66, pp.217-224.
#' 
#' Tommy Wright (2017), Exact optimal sample allocation: More efficient than
#' Neyman, Statistics & Probability Letters, 129, pp.50-57.
#' @name Allocation Methods
NULL
