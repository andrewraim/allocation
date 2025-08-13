#' @name Allocation-Methods
#' @export
algIV = function(v0, N, S, lo = NULL, hi = NULL, verbose = FALSE)
{
	H = length(N)
	if (is.null(lo)) { lo = rep(1, H) }
	if (is.null(hi)) { hi = rep(Inf, H) }
	stopifnot(H == length(S))
	stopifnot(H == length(lo))
	stopifnot(H == length(hi))

	prec_bits = getOption("allocation.prec.bits")
	tol = getOption("allocation.algIV.tol")

	if (class(v0) == "numeric") {
		v0 = mpfr(v0, prec_bits)
	} else if (class(v0) != "mpfr") {
		stop("v0 must be provided as a single number or mpfr")
	}

	S = mpfr(S, prec_bits)
	hi = pmin(hi, N)
	n = mpfr(lo, prec_bits)

	if (any(n > hi)) {
		stop("There are no feasible solutions")
	}

	r = 0L
	v = sum(N * (N - n) * S^2 / n)

	while (v > v0 && sum(n) < sum(N)) {
		r = r + 1L
		V = N * S / sqrt(n * (n+1)) * (n+1 <= hi)
		h = which.max(asNumeric(V))

		if (verbose) {
			printf("----- About to make selection %d -----\n", r)
			printf("Target v0: %s\n", my_format(v0))
			printf("So far achieved v: %s\n", my_format(v))
			df = data.frame(
				value = my_format(V),
				lower_bound = lo,
				upper_bound = hi,
				allocation = my_format(n,0))
			print(df)
		}
		
		if (all(V <= tol)) {
			warning("All units from all strata have been selected, but v0 was not attained")
			break
		}

		if (verbose) {
			printf("Now selecting a unit from strata %d\n", h)
		}

		n[h] = n[h] + 1L
		v = sum(N * (N - n) * S^2 / n)
	}

	structure(
		list(n = n, lo = lo, hi = hi, iter = r, v = v,
			v0 = v0, N = N, S = S),
		class = "algIV"
	)
}

#' @export
print.algIV = function(x, ...)
{
	df = data.frame(
		lower_bound = x$lo,
		upper_bound = x$hi,
		allocation = my_format(x$n, 0))
	print(df)
	printf("----\n")
	printf("Made %d selections\n", x$reps)
	printf("Target v0: %s\n", my_format(x$v0))
	printf("Achieved v: %s\n", my_format(x$v))
	
}

#' @export
alloc.algIV = function(object) {
	asNumeric(object$n)
}
