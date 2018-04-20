#' @name Allocation Methods
#' @aliases neyman
#' @importFrom Rmpfr mpfr
#' @export
neyman <- function(n, N.str, S.str)
{
	stopifnot(length(N.str) == length(S.str))

	prec.bits <- getOption("allocation.prec.bits")
	S.str <- mpfr(S.str, prec.bits)
	n.str <- n * normalize(N.str * S.str)
	v <- sum(N.str * (N.str - n.str) * S.str^2 / n.str)

	structure(
		list(N.str = N.str, S.str = S.str, n.str = n.str, v = v),
		class = "neyman"
	)
}

#' @export
print.neyman <- function(x, ...)
{
	print(data.frame(
		N = x$N.str,
		S = my.format(x$S.str),
		allocation = my.format(x$n.str)))
	printf("----\n")
	printf("v: %s\n", my.format(x$v))
}

#' @export
alloc.neyman <- function(object) {
	asNumeric(object$n.str)
}
