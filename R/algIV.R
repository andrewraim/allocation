#' @name Allocation Methods
#' @aliases algIV
#' @importFrom Rmpfr mpfr
#' @export
algIV <- function(v0, N.str, S.str,
	lo.str = rep(1, length(N.str)),
	hi.str = rep(Inf, length(N.str)),
	verbose = FALSE, tol = 1e-10)
{
	stopifnot(length(N.str) == length(S.str))
	stopifnot(length(N.str) == length(lo.str))
	stopifnot(length(N.str) == length(hi.str))

	prec.bits <- getOption("allocation.prec.bits")

	if (class(v0) == "numeric") {
		v0 <- mpfr(v0, prec.bits)
	} else if (class(v0) != "mpfr") {
		stop("v0 must be provided as a single number or mpfr")
	}

	S.str <- mpfr(S.str, prec.bits)
	hi.str <- pmin(hi.str, N.str)
	n.str <- mpfr(lo.str, prec.bits)

	if (any(n.str > hi.str)) {
		stop("There are no feasible solutions")
	}

	r <- 0L
	v <- sum(N.str * (N.str - n.str) * S.str^2 / n.str)

	while (v > v0 && sum(n.str) < sum(N.str)) {
		r <- r + 1L
		V.str <- N.str * S.str / sqrt(n.str * (n.str+1)) * (n.str+1 <= hi.str)
		h <- which.max(asNumeric(V.str))

		if (verbose) {
			printf("----- About to make selection %d -----\n", r)
			printf("Target v0: %s\n", my.format(v0))
			printf("So far achieved v: %s\n", my.format(v))
			print(data.frame(
				value = my.format(V.str),
				lower_bound = lo.str,
				upper_bound = hi.str),
				allocation = my.format(n.str,0))
		}
		
		if (all(V.str <= tol)) {
			warning("All units from all strata have been selected, but v0 was not attained")
			break
		}

		if (verbose) {
			cat("Now selecting a unit from strata", h, "\n")
		}

		n.str[h] <- n.str[h] + 1L
		v <- sum(N.str * (N.str - n.str) * S.str^2 / n.str)
	}

	structure(
		list(n.str = n.str, lo.str = lo.str, hi.str = hi.str, reps = r, v = v,
			v0 = v0, N.str = N.str, S.str = S.str),
		class = "algIV"
	)
}

#' @export
print.algIV <- function(x, ...)
{
	print(data.frame(
		lower_bound = x$lo.str,
		upper_bound = x$hi.str,
		allocation = my.format(x$n.str, 0)))
	printf("----\n")
	printf("Made %d selections\n", x$reps)
	printf("Target v0: %s\n", my.format(x$v0))
	printf("Achieved v: %s\n", my.format(x$v))
	
}

#' @export
alloc.algIV <- function(object) {
	asNumeric(object$n.str)
}
