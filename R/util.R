normalize = function(x)
{
	x / sum(x)
}

printf = function(msg, ...)
{
	cat(sprintf(msg, ...))
}

my_format = function(x, digits = 4L)
{
	L = length(x)

	decimal_digits = digits
	
	idx_notna = which(!is.na(x) & abs(x) > 1)
	whole_digits = rep(1, L)
	whole_digits[idx_notna] = asNumeric(ceiling(log10(abs(x[idx_notna]))))
	print_digits = whole_digits + decimal_digits

	out = numeric(L)
	for (l in 1:L) {
		out[l] = formatMpfr(x[l], digits = print_digits[l], big.mark = ",")
	}
	return(out)
}
