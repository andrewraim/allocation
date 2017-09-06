# Algorithms III and IV from:
# Tommy Wright (2017), Exact optimal sample allocation: More efficient than Neyman,
# Statistics & Probability Letters, 129:50-57.
# http://www.sciencedirect.com/science/article/pii/S0167715217301657.

algIII <- function(n, N.str, S.str, lo.str, hi.str, verbose = FALSE)
{
	n.str <- lo.str
	b.str <- pmin(hi.str, N.str)

	if (any(n.str > b.str)) {
		stop("There are no feasible solutions")
	}

	r <- 0
	while (sum(n.str) < n) {
		r <- r + 1
		V.str <- N.str * S.str / sqrt(n.str * (n.str+1)) * (n.str+1 <= b.str)
		h <- which.max(V.str)

		if (verbose) {
			cat("----- About to make selection", r, "-----\n")
			print(data.frame(n.str, V.str, lo.str, b.str))
			cat("Selecting a unit from strata", h, "\n")
		}

		n.str[h] <- n.str[h] + 1
	}

	v <- sum(N.str * (N.str - n.str) * S.str^2 / n.str)

	if (verbose) {
		cat("----- After", r, "selections -----\n")
		print(data.frame(n.str, lo.str, b.str))
		cat("v =", v, "\n")
	}
 
	list(n.str = n.str, reps = r, v = v)
}


algIV <- function(v0, N.str, S.str,
	lo.str = rep(1, length(N.str)),
	hi.str = rep(Inf, length(N.str)),
	verbose = FALSE)
{
	n.str <- lo.str
	b.str <- pmin(hi.str, N.str)
	tol <- 1e-10

	if (any(n.str > b.str)) {
		stop("There are no feasible solutions")
	}

	r <- 0
	v <- sum(N.str * (N.str - n.str) * S.str^2 / n.str)

	while (v > v0 && sum(n.str) < sum(N.str)) {
		r <- r + 1
		V.str <- N.str * S.str / sqrt(n.str * (n.str+1)) * (n.str+1 <= b.str)
		h <- which.max(V.str)

		if (verbose) {
			cat("----- About to make selection", r, "-----\n")
			print(data.frame(n.str, V.str, lo.str, b.str))
			cat("Currently v =", v, " and v0 =", v0, "\n")
		}
		
		if (all(V.str <= tol)) {
			warning("All units from all strata have been selected, but v0 was not attained")
			break
		}

		if (verbose) {
			cat("Selecting a unit from strata", h, "\n")
		}

		n.str[h] <- n.str[h] + 1
		v <- sum(N.str * (N.str - n.str) * S.str^2 / n.str)
	}

	if (verbose) {
		cat("----- After", r, "selections -----\n")
		print(data.frame(n.str, lo.str, b.str))
		cat("v =", v, " and v0 =", v0, "\n")
	}

	list(n.str = n.str, v = v, reps = r)
}
