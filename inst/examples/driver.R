library(TommySampling)

# ----- Test Algorithm III using the example in the paper -----
N.str <- c(47, 61, 41)
S.str <- sqrt(c(100, 36, 16))
lo.str <- c(1,2,3)
hi.str <- c(5,6,4)
n <- 10

out3 <- algIII(n, N.str, S.str, lo.str, hi.str, verbose = TRUE)
print(out3)

# ----- Test Algorithm IV using the example in the paper -----
H <- 10
v0 <- 388910760^2
N.str <- c(819, 672, 358, 196, 135, 83, 53, 40, 35, 13)
lo.str <- c(3,3,3,3,3,3,3,3,3,13)
S.str <- c(330000, 518000, 488000, 634000, 1126000, 2244000, 2468000, 5869000, 29334000, 1233311000)

out4 <- algIV(v0, N.str, S.str, lo.str, verbose = TRUE)
print(out4)
