#' @name Allocation Methods
#' @aliases algIII
#' @importFrom Rmpfr mpfr asNumeric
#' @export
algIII <- function(n, N.str, S.str,
	lo.str = rep(1, length(N.str)),
	hi.str = rep(Inf, length(N.str)),
	verbose = FALSE)
{
	stopifnot(length(N.str) == length(S.str))
	stopifnot(length(N.str) == length(lo.str))
	stopifnot(length(N.str) == length(hi.str))

	prec.bits <- getOption("allocation.prec.bits")
	S.str <- mpfr(S.str, prec.bits)
	hi.str <- pmin(hi.str, N.str)
	n.str <- mpfr(lo.str, prec.bits)

	if (any(n.str > hi.str)) {
		stop("There are no feasible solutions")
	}

	r <- 0L
	while (sum(n.str) < n) {
		r <- r + 1L
		V.str <- N.str * S.str / sqrt(n.str * (n.str+1)) * (n.str+1 <= hi.str)
		h <- which.max(asNumeric(V.str))

		if (verbose) {
			cat("----- About to make selection", r, "-----\n")
			print(data.frame(
				value = my.format(V.str),
				lower_bound = lo.str,
				upper_bound = hi.str,
				allocation = my.format(n.str, 0)))
			cat("Selecting a unit from strata", h, "\n")
		}

		n.str[h] <- n.str[h] + 1L
	}

	v <- sum(N.str * (N.str - n.str) * S.str^2 / n.str)

	if (verbose) {
		printf("----- After %d selections -----\n", r)
		print(data.frame(
			lower_bound = lo.str,
			upper_bound = hi.str,
			allocation = my.format(n.str, 0)))
		printf("v = %s\n", my.format(v))
	}

	structure(
		list(n.str = n.str, lo.str = lo.str, hi.str = hi.str, reps = r, v = v,
			N.str = N.str, S.str = S.str),
		class = "algIII"
	)
}

#' @export
print.algIII <- function(x, ...)
{
	print(data.frame(
		lower_bound = x$lo.str,
		upper_bound = x$hi.str,
		allocation = my.format(x$n.str, 0)))
	printf("----\n")
	printf("Made %d selections\n", x$reps)
	printf("Target n: %s\n", my.format(sum(x$n.str)))
	printf("Achieved v: %s\n", my.format(x$v))
}

#' @export
alloc.algIII <- function(object) {
	asNumeric(object$n.str)
}
