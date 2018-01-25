normalize <- function(x)
{
	x / sum(x)
}

printf <- function(msg, ...)
{
	cat(sprintf(msg, ...))
}
