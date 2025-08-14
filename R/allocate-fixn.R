#' @name Allocation-Methods
#' @export
allocate_fixn = function(n0, N, S, lo = NULL, hi = NULL, control = allocation_control())
{
	H = length(N)
	if (is.null(lo)) { lo = rep(1, H) }
	if (is.null(hi)) { hi = rep(Inf, H) }
	stopifnot(H == length(S))
	stopifnot(H == length(lo))
	stopifnot(H == length(hi))

	verbose = control$verbose
	prec_bits = control$bits
	S = mpfr(S, prec_bits)
	hi = pmin(hi, N)
	n = mpfr(lo, prec_bits)

	if (any(n > hi)) {
		stop("There are no feasible solutions")
	}

	r = 0L
	while (sum(n) < n0) {
		r = r + 1L
		P = N * S / sqrt(n * (n+1)) * (n+1 <= hi)
		h = which.max(asNumeric(P))

		if (verbose) {
			printf("----- About to make selection %d -----\n", r)
			df = data.frame(
				value = my_format(P),
				lo = lo,
				hi = hi,
				n = my_format(n, 0L))
			print(df)
			printf("Selecting a unit from strata %d\n", h)
		}

		n[h] = n[h] + 1L
	}

	v = sum(N * (N - n) * S^2 / n)

	if (verbose) {
		printf("----- After %d selections -----\n", r)
		df = data.frame(
			lo = lo,
			hi = hi,
			n = my_format(n, 0L)
		)
		print(df)
		printf("v = %s\n", my_format(v))
	}

	out = list(n = n, lo = lo, hi = hi, iter = r, v = v, N = N, S = S)
	structure(out, class = "allocation_fixn")
}

#' @export
print.allocation_fixn = function(x, control = allocation_control(), ...)
{
	digits = control$digits
	df = data.frame(
		lo = x$lo,
		hi = x$hi,
		n = my_format(x$n, 0L)
	)
	print(df)
	printf("----\n")
	printf("Made %d selections\n", x$iter)
	printf("Target n: %s\n", my_format(sum(x$n), 0L))
	printf("Achieved v: %s\n", my_format(x$v, digits))
}

#' @export
allocation.allocation_fixn = function(object)
{
	asNumeric(object$n)
}
