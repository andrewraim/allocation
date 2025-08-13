#' @name Allocation-Methods
#' @export
neyman = function(n0, N, S)
{
	stopifnot(length(N) == length(S))

	prec_bits = getOption("allocation.prec.bits")
	S = mpfr(S, prec_bits)
	n = n0 * normalize(N * S)
	v = sum(N * (N - n) * S^2 / n)

	structure(
		list(N = N, S = S, n = n, v = v),
		class = "neyman"
	)
}

#' @export
print.neyman = function(x, ...)
{
	df = data.frame(
		N = x$N,
		S = my_format(x$S),
		allocation = my_format(x$n))
	print(df)
	printf("----\n")
	printf("v: %s\n", my_format(x$v))
}

#' @export
alloc.neyman = function(object) {
	asNumeric(object$n)
}
