#' @title
#' Algorithms for Exact Optimization Allocation
#' 
#' @description 
#' Algorithms III and IV from Wright (2017), and classical (unconstrained)
#' Neyman allocation. Algorithm III finds the optimial allocation for a
#' given total sample size \code{n}. Algorithm IV samples until the overall
#' variance is smaller than a given \code{v0}.
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
#' Global options for the package (with defaults) are:
#' \itemize{
#' \item \code{options(allocation.prec.bits = 256)} Number of bits of
#'     precision to use with \code{mpfr} objects in internal calculations.
#' \item \code{options(allocation.print.decimals = 4)} Number of decimals
#'     to display in output.
#' \item \code{options(allocation.algIV.tol = 1e-10)} A small positive
#'     number for use in algIV; if all strata have \code{V_str <= tol},
#'     no more allocation is possible, even if target value \code{v0} has
#'     not yet been attained.
#' }
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
