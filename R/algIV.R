#' @name Allocation Methods
#' @aliases algIV
#' @importFrom Rmpfr mpfr
#' @export
algIV = function(v0, N_str, S_str,
	lo_str = rep(1, length(N_str)),
	hi_str = rep(Inf, length(N_str)),
	verbose = FALSE)
{
	stopifnot(length(N_str) == length(S_str))
	stopifnot(length(N_str) == length(lo_str))
	stopifnot(length(N_str) == length(hi_str))

	prec_bits = getOption("allocation.prec.bits")
	tol = getOption("allocation.algIV.tol")

	if (class(v0) == "numeric") {
		v0 = mpfr(v0, prec_bits)
	} else if (class(v0) != "mpfr") {
		stop("v0 must be provided as a single number or mpfr")
	}

	S_str = mpfr(S_str, prec_bits)
	hi_str = pmin(hi_str, N_str)
	n_str = mpfr(lo_str, prec_bits)

	if (any(n_str > hi_str)) {
		stop("There are no feasible solutions")
	}

	r = 0L
	v = sum(N_str * (N_str - n_str) * S_str^2 / n_str)

	while (v > v0 && sum(n_str) < sum(N_str)) {
		r = r + 1L
		V_str = N_str * S_str / sqrt(n_str * (n_str+1)) * (n_str+1 <= hi_str)
		h = which.max(asNumeric(V_str))

		if (verbose) {
			printf("----- About to make selection %d -----\n", r)
			printf("Target v0: %s\n", my_format(v0))
			printf("So far achieved v: %s\n", my_format(v))
			print(data.frame(
				value = my_format(V_str),
				lower_bound = lo_str,
				upper_bound = hi_str,
				allocation = my_format(n_str,0)))
		}
		
		if (all(V_str <= tol)) {
			warning("All units from all strata have been selected, but v0 was not attained")
			break
		}

		if (verbose) {
			cat("Now selecting a unit from strata", h, "\n")
		}

		n_str[h] = n_str[h] + 1L
		v = sum(N_str * (N_str - n_str) * S_str^2 / n_str)
	}

	structure(
		list(n_str = n_str, lo_str = lo_str, hi_str = hi_str, reps = r, v = v,
			v0 = v0, N_str = N_str, S_str = S_str),
		class = "algIV"
	)
}

#' @export
print.algIV = function(x, ...)
{
	print(data.frame(
		lower_bound = x$lo_str,
		upper_bound = x$hi_str,
		allocation = my_format(x$n_str, 0)))
	printf("----\n")
	printf("Made %d selections\n", x$reps)
	printf("Target v0: %s\n", my_format(x$v0))
	printf("Achieved v: %s\n", my_format(x$v))
	
}

#' @export
alloc.algIV = function(object) {
	asNumeric(object$n_str)
}
