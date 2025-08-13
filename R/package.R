#' allocation
#'
#' Package documentation
#'
#' @name allocation-package
#' 
#' @importFrom Rmpfr mpfr asNumeric formatMpfr
"_PACKAGE"

#' Algorithms for Exact Optimization Allocation
#' 
#' @description 
#' Algorithms III and IV from Wright (2017), and classical unconstrained
#' Neyman allocation (Neyman, 1934).
#' 
#' @param n0 Target sample size for Algorithm III; integer.
#' @param v0 Target variance for Algorithm IV; numeric.
#' @param N Population size for each stratum; integer vector of length `H`.
#' @param S Standard deviation for each stratum; numeric vector of length `H`.
#' @param lo Sample size lower bounds for each stratum; numeric vector of
#' length `H`. Default argument `NULL` is transformed to a vector of ones.
#' @param hi Sample size upper bounds for each stratum; numeric vector of
#' length `H`. Default argument `NULL` is transformed to a vector of `Inf`.
#' @param control Control object from [allocation_control].
#'
#' @return A list whose structure depends on the allocation method.
#' 
#' `allocate_neyman`
#' 
#' - `n`: Integer vector with allocation \eqn{n_1, \ldots, n_H}.
#' - `v`: Value of variance achieved at selected allocation.
#' - `N`: The argument `N` passed to the function.
#' - `S`: The argument `S` passed to the function.
#' 
#' `allocate_fixn`
#' 
#' - `n`: Integer vector with allocation \eqn{n_1, \ldots, n_H}.
#' - `iter`: Number of steps taken in the algorithm.
#' - `v`: Value of variance achieved at selected allocation.
#' - `N`: The argument `N` passed to the function.
#' - `S`: The argument `S` passed to the function.
#' - `lo`: The argument `lo` passed to the function.
#' - `hi`: The argument `hi` passed to the function.
#' 
#' `allocate_prec`
#' 
#' - `n`: Integer vector with allocation \eqn{n_1, \ldots, n_H}.
#' - `iter`: Number of steps taken in the algorithm.
#' - `v`: Value of variance achieved at selected allocation.
#' - `v0`: The argument `v0` passed to the function.
#' - `N`: The argument `N` passed to the function.
#' - `S`: The argument `S` passed to the function.
#' - `lo`: The argument `lo` passed to the function.
#' - `hi`: The argument `hi` passed to the function.
#' 
#' @details
#' The function `allocate_fixn` implements Algorithm III of Wright (2017) and
#' finds the optimal allocation for a given total sample size `n0`. The function
#' `allocate_prec` implements Algorithm IV of Wright (2017) and optimally
#' allocates units until the overall variance is smaller than a given `v0`.
#' Classical Neyman  allocation is implemented by the function
#' `allocate_neyman`.
#' 
#' @references
#' Neyman, Jerzy (1934). On the Two Different Aspects of the Representative
#' Method: The Method of Stratified Sampling and the Method of Purposive
#' Selection. Journal of the Royal Statistical Society, 97 (4): 558-625.
#' 
#' Tommy Wright (2012). The Equivalence of Neyman Optimum Allocation for
#' Sampling and Equal Proportions for Apportioning the U.S. House of
#' Representatives. The American Statistician, 66, pp.217-224.
#' 
#' Tommy Wright (2017), Exact optimal sample allocation: More efficient than
#' Neyman, Statistics & Probability Letters, 129, pp.50-57.
#' 
#' @name Allocation Methods
NULL
