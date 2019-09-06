#' @name Allocation Methods
#' @aliases neyman
#' @importFrom Rmpfr mpfr
#' @export
neyman = function(n, N_str, S_str)
{
	stopifnot(length(N_str) == length(S_str))

	prec_bits = getOption("allocation.prec.bits")
	S_str = mpfr(S_str, prec_bits)
	n_str = n * normalize(N_str * S_str)
	v = sum(N_str * (N_str - n_str) * S_str^2 / n_str)

	structure(
		list(N_str = N_str, S_str = S_str, n_str = n_str, v = v),
		class = "neyman"
	)
}

#' @export
print.neyman = function(x, ...)
{
	print(data.frame(
		N = x$N_str,
		S = my_format(x$S_str),
		allocation = my_format(x$n_str)))
	printf("----\n")
	printf("v: %s\n", my_format(x$v))
}

#' @export
alloc.neyman = function(object) {
	asNumeric(object$n_str)
}
