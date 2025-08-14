#' @name Allocation-Methods
#' @export
allocate_neyman = function(n0, N, S, control = allocation_control())
{
	stopifnot(length(N) == length(S))

	prec_bits = control$bits
	S = mpfr(S, prec_bits)
	n = n0 * normalize(N * S)
	v = sum(N * (N - n) * S^2 / n)

	out = list(N = N, S = S, n = n, v = v)
	structure(out, class = "allocation_neyman")
}

#' @export
print.allocation_neyman = function(x, control = allocation_control(), ...)
{
	digits = control$digits
	df = data.frame(
		N = x$N,
		S = my_format(x$S, digits),
		n = my_format(x$n, digits))
	print(df)
	printf("--\n")
	printf("v: %s\n", my_format(x$v, digits))
}

#' @export
allocation.allocation_neyman = function(object)
{
	asNumeric(object$n)
}
