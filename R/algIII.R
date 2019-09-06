#' @name Allocation Methods
#' @aliases algIII
#' @importFrom Rmpfr mpfr asNumeric
#' @export
algIII = function(n, N_str, S_str,
	lo_str = rep(1, length(N_str)),
	hi_str = rep(Inf, length(N_str)),
	verbose = FALSE)
{
	stopifnot(length(N_str) == length(S_str))
	stopifnot(length(N_str) == length(lo_str))
	stopifnot(length(N_str) == length(hi_str))

	prec_bits = getOption("allocation.prec.bits")
	S_str = mpfr(S_str, prec_bits)
	hi_str = pmin(hi_str, N_str)
	n_str = mpfr(lo_str, prec_bits)

	if (any(n_str > hi_str)) {
		stop("There are no feasible solutions")
	}

	r = 0L
	while (sum(n_str) < n) {
		r = r + 1L
		V_str = N_str * S_str / sqrt(n_str * (n_str+1)) * (n_str+1 <= hi_str)
		h = which.max(asNumeric(V_str))

		if (verbose) {
			cat("----- About to make selection", r, "-----\n")
			print(data.frame(
				value = my_format(V_str),
				lower_bound = lo_str,
				upper_bound = hi_str,
				allocation = my_format(n_str, 0)))
			cat("Selecting a unit from strata", h, "\n")
		}

		n_str[h] = n_str[h] + 1L
	}

	v = sum(N_str * (N_str - n_str) * S_str^2 / n_str)

	if (verbose) {
		printf("----- After %d selections -----\n", r)
		print(data.frame(
			lower_bound = lo_str,
			upper_bound = hi_str,
			allocation = my_format(n_str, 0)))
		printf("v = %s\n", my_format(v))
	}

	structure(
		list(n_str = n_str, lo_str = lo_str, hi_str = hi_str, reps = r, v = v,
			N_str = N_str, S_str = S_str),
		class = "algIII"
	)
}

#' @export
print.algIII = function(x, ...)
{
	print(data.frame(
		lower_bound = x$lo_str,
		upper_bound = x$hi_str,
		allocation = my_format(x$n_str, 0)))
	printf("----\n")
	printf("Made %d selections\n", x$reps)
	printf("Target n: %s\n", my_format(sum(x$n_str)))
	printf("Achieved v: %s\n", my_format(x$v))
}

#' @export
alloc.algIII = function(object) {
	asNumeric(object$n_str)
}
