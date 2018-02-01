.onLoad <- function(libname, pkgname){
	options(TommySampling.prec.bits = 256)
	options(TommySampling.print.decimals = 4)
}

normalize <- function(x)
{
	x / sum(x)
}

printf <- function(msg, ...)
{
	cat(sprintf(msg, ...))
}

my.format <- function(x, decimal.digits = getOption("TommySampling.print.decimals"))
{
	L <- length(x)

	idx.notna <- which(!is.na(x) & abs(x) > 1)
	whole.digits <- rep(1,L)
	whole.digits[idx.notna] <- asNumeric(ceiling(log10(abs(x[idx.notna]))))
	print.digits <- whole.digits + decimal.digits

	out <- numeric(L)
	for (l in 1:L) {
		out[l] <- formatMpfr(x[l], digits = print.digits[l], big.mark = ",")
	}
	return(out)
}
