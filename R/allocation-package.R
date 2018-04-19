#' @title
#' Algorithms for Exact Optimization Allocation
#' 
#' @description 
#' Algorithms III and IV from Wright (2017), and classical unconstrained
#' Neyman allocation.
#' 
#' @param n Target sample size for Algorithm III (integer)
#' @param v0 Target variance for Algorithm IV (numeric)
#' @param N.str Population size for each stratum (integer vector)
#' @param S.str Standard deviation for each stratum (numeric vector)
#' @param lo.str Sample size lower bounds for each stratum (numeric vector)
#' @param hi.str Sample size upper bounds for each stratum (numeric vector)
#' @param verbose Print detailed information for each selection (boolean)
#'
#' @return
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