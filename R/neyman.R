#' @name Allocation Methods
#' @importFrom Rmpfr mpfr
#' @export
neyman <- function(n, N.str, S.str,
	lo.str = rep(1, length(N.str)),
	hi.str = rep(Inf, length(N.str)),
	verbose = TRUE)
{
	prec.bits <- getOption("allocation.prec.bits")
	S.str <- mpfr(S.str, prec.bits)

	a.str <- mpfr(lo.str, prec.bits)
	b.str <- mpfr(pmin(hi.str, N.str), prec.bits)

	if (any(a.str > b.str)) {
		stop("There are no feasible solutions")
	}

	n.str.ney <- n * normalize(N.str * S.str)
	n.str.ney.ru <- ceiling(n.str.ney)
	n.str <- pmin(pmax(n.str.ney.ru, a.str), b.str)
	v <- sum(N.str * (N.str - n.str) * S.str^2 / n.str)

	structure(
		list(S.str = S.str, n.str.ney = n.str.ney,
			n.str.ney.ru = n.str.ney.ru, a.str = a.str,
			b.str = b.str, n.str = n.str, v = v),
		class = "neyman"
	)
}

#' @export
print.neyman <- function(x, ...)
{
	print(data.frame(S.str = my.format(x$S.str),
		n.str.ney = my.format(x$n.str.ney),
		n.str.ney.ru = my.format(x$n.str.ney.ru, 0),
		a.str = my.format(x$a.str),
		b.str = my.format(x$b.str),
		n.str = my.format(x$n.str, 0)))
	printf("v = %s\n", my.format(x$v))
}
