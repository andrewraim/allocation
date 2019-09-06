library(Rmpfr)
library(allocation)

# ----- Test Algorithm III using the example in the paper -----
N_str = c(47, 61, 41)
S_str = sqrt(c(100, 36, 16))
lo_str = c(1,2,3)
hi_str = c(5,6,4)
n = 10

out3 = algIII(n, N_str, S_str, lo_str, hi_str, verbose = TRUE)
print(out3)

# ----- Test ad hoc allocation method with above example -----
# This part needs maintenance
# outAdhoc3 = algAdhoc(n, N_str, S_str, lo_str, hi_str, verbose = TRUE)
# print(outAdhoc3)


# ----- Test Algorithm IV using the example in the paper -----
H = 10
v0 = mpfr(388910760, 256)^2
N_str = c(819, 672, 358, 196, 135, 83, 53, 40, 35, 13)
lo_str = c(3,3,3,3,3,3,3,3,3,13)
S_str = c(330000, 518000, 488000, 634000, 1126000, 2244000, 2468000, 5869000, 29334000, 1233311000)

out4 = algIV(v0, N_str, S_str, lo_str, verbose = TRUE)
print(out4)

# ----- Test ad hoc allocation method using the example in the paper -----
# This part needs maintenance
# The code currently doesn't show strata 10 in the results, but it's fixed at 13.
# n = sum(N_str[-10] * S_str[-10])^2 / (mpfr(0.042 * 9259780000, 256)^2 + sum(N_str[-10] * S_str[-10]^2))
# outAdhoc4 = algAdhoc(n, N_str[-10], S_str[-10], lo_str[-10], verbose = TRUE)
# print(outAdhoc4)


