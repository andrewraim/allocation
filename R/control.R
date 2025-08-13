#' Control Object for Allocation Methods
#' 
#' Additional arguments (controls) for [Allocation-Methods].
#' 
#' @param bits Number of bits of precision to use with `mpfr` objects in
#' internal calculations.
#' @param digits Number of decimals to display in output.
#' @param tol A small positive number for use in `algIV`; if all strata have
#' `V <= tol`, regard the situation as one where no more allocation is
#' possible, even if target value `v0` has not yet been attained.
#'
#' @return An list of class `allocation_control`.
#' 
#' @examples
#' out1 = allocation_control()
#' out2 = allocation_control(verbose = TRUE, bits = 128, tol = 1e-8, digits = 2)
#'
#' @export
allocation_control = function(verbose = FALSE, bits = 256, tol = 1e-10,
	digits = 4)
{
	out = list(
		verbose = verbose,
		bits = bits,
		tol = tol,
		digits = digits
	)
	structure(out, class = "allocation_control")
}
