# Algorithms III and IV from:
# Tommy Wright (2017), Exact optimal sample allocation: More efficient than Neyman,
# Statistics & Probability Letters, 129:50-57.
# http://www.sciencedirect.com/science/article/pii/S0167715217301657.

algIII <- function(n, N.str, S.str,
	lo.str = rep(1L, length(N.str)),
	hi.str = rep(Inf, length(N.str)),
	verbose = FALSE, precBits = 256,
	print.decimal.places = 4)
{
	S.str <- mpfr(S.str, precBits)

	n.str <- lo.str
	a.str <- lo.str
	b.str <- pmin(hi.str, N.str)

	if (any(n.str > b.str)) {
		stop("There are no feasible solutions")
	}

	# Here we're only calculating v to determine how much precision to print
	v <- sum(N.str * (N.str - n.str) * S.str^2 / n.str)
	my.format <- function(x) {
		print.digits <- max(asNumeric(ceiling(log10(x)))) + print.decimal.places
		formatMpfr(x, digits = print.digits, big.mark = ",")
	}

	r <- 0L
	while (sum(n.str) < n) {
		r <- r + 1L
		n.str.mpfr <- mpfr(n.str, precBits)
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
		cat("v =", my.format(v), "\n")
	}

	list(n.str = n.str, reps = r, v = v)
}


algIV <- function(v0, N.str, S.str,
	lo.str = rep(1L, length(N.str)),
	hi.str = rep(Inf, length(N.str)),
	verbose = FALSE, precBits = 256,
	print.decimal.places = 4)
{
	v0 <- mpfr(v0, precBits)
	S.str <- mpfr(S.str, precBits)

	n.str <- lo.str
	a.str <- lo.str
	b.str <- pmin(hi.str, N.str)
	tol <- 1e-10

	if (any(n.str > b.str)) {
		stop("There are no feasible solutions")
	}

	r <- 0L
	v <- sum(N.str * (N.str - n.str) * S.str^2 / n.str)

	my.format <- function(x) {
		print.digits <- max(asNumeric(ceiling(log10(x)))) + print.decimal.places
		formatMpfr(x, digits = print.digits, big.mark = ",")
	}

	while (v > v0 && sum(n.str) < sum(N.str)) {
		r <- r + 1L
		n.str.mpfr <- mpfr(n.str, precBits)
		V.str <- N.str * S.str / sqrt(n.str.mpfr * (n.str.mpfr+1)) * (n.str+1 <= b.str)
		h <- which.max(asNumeric(V.str))

		if (verbose) {
			cat("----- About to make selection", r, "-----\n")
			print(data.frame(n.str,
				V.str = my.format(V.str),
				a.str, b.str))
			cat("Currently v =", my.format(v), "\n")
			cat("Target v0 =", my.format(v0), "\n")
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

	if (verbose) {
		cat("----- After", r, "selections -----\n")
		print(data.frame(n.str, a.str, b.str))
		cat("Final v =", my.format(v), "\n")
		cat("Target v0 =", my.format(v0), "\n")
	}

	list(n.str = n.str, v = v, reps = r)
}

algAdhoc <- function(n, N.str, S.str,
	lo.str = rep(1, length(N.str)),
	hi.str = rep(Inf, length(N.str)),
	verbose = TRUE, precBits = 256,
	print.decimal.places = 4)
{
	S.str <- mpfr(S.str, precBits)

	a.str <- lo.str
	b.str <- pmin(hi.str, N.str)

	if (any(a.str > b.str)) {
		stop("There are no feasible solutions")
	}

	n.str.ney <- n * normalize(N.str * S.str)
	n.str.ney.ru <- asNumeric(ceiling(n.str.ney))
	n.str <- pmin(pmax(n.str.ney.ru, a.str), b.str)
	v <- sum(N.str * (N.str - n.str) * S.str^2 / n.str)

	my.format <- function(x) {
		print.digits <- max(asNumeric(ceiling(log10(x)))) + print.decimal.places
		formatMpfr(x, digits = print.digits, big.mark = ",")
	}

	if (verbose) {
		cat("----- Selection -----\n")
		print(data.frame(S.str = my.format(S.str),
			n.str.ney = my.format(n.str.ney),
			n.str.ney.ru, a.str, b.str, n.str))
		cat("v =", my.format(v), "\n")
	}

	list(n.str = n.str, v = v, n.str.ney = n.str.ney, n.str.ney.ru = n.str.ney.ru)
}
