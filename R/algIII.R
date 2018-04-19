#' Exact Optimization Allocation, Algorithms III and IV
#'
#' @param n 
#' @param N.str 
#' @param S.str 
#' @param lo.str 
#' @param hi.str 
#' @param verbose 
#'
#' @return
#'
#' @examples
#' @references
#' Tommy Wright (2017), Exact optimal sample allocation: More efficient than Neyman,
#' Statistics & Probability Letters, 129:50-57.

#' @export
algIII <- function(n, N.str, S.str,
	lo.str = rep(1L, length(N.str)),
	hi.str = rep(Inf, length(N.str)),
	verbose = FALSE)
{
	prec.bits <- getOption("TommySampling.prec.bits")
	S.str <- mpfr(S.str, prec.bits)

	n.str <- lo.str
	a.str <- lo.str
	b.str <- pmin(hi.str, N.str)

	if (any(n.str > b.str)) {
		stop("There are no feasible solutions")
	}

	r <- 0L
	while (sum(n.str) < n) {
		r <- r + 1L
		n.str.mpfr <- mpfr(n.str, prec.bits)
		V.str <- N.str * S.str / sqrt(n.str.mpfr * (n.str.mpfr+1)) * (n.str+1 <= b.str)
		h <- which.max(asNumeric(V.str))

		if (verbose) {
			cat("----- About to make selection", r, "-----\n")
			print(data.frame(n.str,
				V.str = my.format(V.str),
				a.str, b.str))
			cat("Selecting a unit from strata", h, "\n")
		}

		n.str[h] <- n.str[h] + 1L
	}

	v <- sum(N.str * (N.str - n.str) * S.str^2 / n.str)

	if (verbose) {
		cat("----- After", r, "selections -----\n")
		print(data.frame(n.str, a.str, b.str))
		printf("v = %s\n", my.format(v))
	}

	list(n.str = n.str, reps = r, v = v)
}

