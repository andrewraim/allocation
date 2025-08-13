#' @name Allocation-Methods
#' @export
algIII = function(n0, N, S, lo = NULL, hi = NULL, verbose = FALSE)
{
	H = length(N)
	if (is.null(lo)) { lo = rep(1, H) }
	if (is.null(hi)) { hi = rep(Inf, H) }
	stopifnot(H == length(S))
	stopifnot(H == length(lo))
	stopifnot(H == length(hi))

	prec_bits = getOption("allocation.prec.bits")
	S = mpfr(S, prec_bits)
	hi = pmin(hi, N)
	n = mpfr(lo, prec_bits)

	if (any(n > hi)) {
		stop("There are no feasible solutions")
	}

	r = 0L
	while (sum(n) < n0) {
		r = r + 1L
		V = N * S / sqrt(n * (n+1)) * (n+1 <= hi)
		h = which.max(asNumeric(V))

		if (verbose) {
			printf("----- About to make selection %d -----\n", r)
			df = data.frame(
				value = my_format(V),
				lower_bound = lo,
				upper_bound = hi,
				allocation = my_format(n, 0))
			print(df)
			printf("Selecting a unit from strata %d\n", h)
		}

		n[h] = n[h] + 1L
	}

	v = sum(N * (N - n) * S^2 / n)

	if (verbose) {
		printf("----- After %d selections -----\n", r)
		df = data.frame(lower_bound = lo, upper_bound = hi,
			allocation = my_format(n, 0))
		print(df)
		printf("v = %s\n", my_format(v))
	}

	structure(
		list(n = n, lo = lo, hi = hi, iter = r, v = v,
			N = N, S = S),
		class = "algIII"
	)
}

#' @export
print.algIII = function(x, ...)
{
	df = data.frame(
		lower_bound = x$lo,
		upper_bound = x$hi,
		allocation = my_format(x$n, 0))
	print(df)
	printf("----\n")
	printf("Made %d selections\n", x$iter)
	printf("Target n: %s\n", my_format(sum(x$n)))
	printf("Achieved v: %s\n", my_format(x$v))
}

#' @export
alloc.algIII = function(object) {
	asNumeric(object$n)
}
