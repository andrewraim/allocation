#' Accessor for to Extract Allocation
#' 
#' @description 
#' Extract the allocation from the result of one of the [Allocation-Methods].
#' 
#' @param object Result from an allocation method
#'
#' @return A numeric vector whose elements contain an allocation for the
#' corresponding stratum.
#' 
#' @name alloc
#' @export
alloc = function(object)
{
	UseMethod("alloc")
}
