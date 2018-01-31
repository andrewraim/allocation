# Algorithms III and IV from:
# Tommy Wright (2017), Exact optimal sample allocation: More efficient than Neyman,
# Statistics & Probability Letters, 129:50-57.
# http://www.sciencedirect.com/science/article/pii/S0167715217301657.

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

algIV <- function(v0, N.str, S.str,
	lo.str = rep(1L, length(N.str)),
	hi.str = rep(Inf, length(N.str)),
	verbose = FALSE, tol = 1e-10)
{
	prec.bits <- getOption("TommySampling.prec.bits")
	v0 <- mpfr(v0, prec.bits)
	S.str <- mpfr(S.str, prec.bits)

	lo.str <- mpfr(lo.str, prec.bits)
	hi.str <- mpfr(hi.str, prec.bits)

	n.str <- lo.str
	a.str <- lo.str
	b.str <- pmin(hi.str, N.str)

	if (any(n.str > b.str)) {
		stop("There are no feasible solutions")
	}

	r <- 0L
	v <- sum(N.str * (N.str - n.str) * S.str^2 / n.str)

	while (v > v0 && sum(n.str) < sum(N.str)) {
		r <- r + 1L
		n.str.mpfr <- mpfr(n.str, prec.bits)
		V.str <- N.str * S.str / sqrt(n.str.mpfr * (n.str.mpfr+1)) * (n.str+1 <= b.str)
		h <- which.max(asNumeric(V.str))

		if (verbose) {
			cat("----- About to make selection", r, "-----\n")
			printf("Currently v = %s\n", my.format(v))
			printf("Target v0 = %s\n", my.format(v0))
			print(data.frame(n.str,
				V.str = my.format(V.str),
				a.str, b.str))
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
		list(n.str = n.str, a.str = a.str, b.str = b.str, reps = r, v = v,
			v0 = v0, S.str = S.str),
		class = "alg.Iv"
	)
}

print.alg.Iv <- function(object)
{
	cat("----- After", object$reps, "selections -----\n")
	print(data.frame(S.str = my.format(object$S.str),
		a.str = my.format(object$a.str),
		b.str = my.format(object$b.str),
		n.str = my.format(object$n.str)))
	printf("Final v = %s\n", my.format(object$v))
	printf("Target v0 = %s\n", my.format(object$v0))
}

algAdhoc <- function(n, N.str, S.str,
	lo.str = rep(1, length(N.str)),
	hi.str = rep(Inf, length(N.str)),
	verbose = TRUE)
{
	prec.bits <- getOption("TommySampling.prec.bits")
	S.str <- mpfr(S.str, prec.bits)

	a.str <- mpfr(lo.str, prec.bits)
	b.str <- mpfr(pmin(hi.str, N.str), prec.bits)

	if (any(a.str > b.str)) {
		stop("There are no feasible solutions")
	}

	n.str.ney <- n * normalize(N.str * S.str)
	n.str.ney.ru <- ceiling(n.str.ney)
	n.str <- pmin(pmax(n.str.ney.ru, a.str), b.str)
	v <- sum(N.str * (N.str - n.str) * S.str^2 / n.str)

	structure(
		list(S.str = S.str, n.str.ney = n.str.ney,
			n.str.ney.ru = n.str.ney.ru, a.str = a.str,
			b.str = b.str, n.str = n.str, v = v),
		class = "alg.adhoc"
	)
}

print.alg.adhoc <- function(object)
{
	print(data.frame(S.str = my.format(object$S.str),
		n.str.ney = asNumeric(object$n.str.ney),
		n.str.ney.ru = asNumeric(object$n.str.ney.ru),
		a.str = asNumeric(object$a.str),
		b.str = asNumeric(object$b.str),
		n.str = asNumeric(object$n.str)))
	printf("v = %s\n", my.format(object$v))
}
