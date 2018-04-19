.onLoad <- function(libname, pkgname){
	options(allocation.prec.bits = 256)
	options(allocation.print.decimals = 4)
}

normalize <- function(x)
{
	x / sum(x)
}

printf <- function(msg, ...)
{
	cat(sprintf(msg, ...))
}

#' @importFrom Rmpfr asNumeric formatMpfr
my.format <- function(x, decimal.digits = getOption("allocation.print.decimals"))
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

#' @export
alloc <- function(object)
{
	UseMethod("alloc")
}
