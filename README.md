# Overview

This package implements several methods of allocation into strata for
stratified sampling. In particular, they provide an alternative to Neyman's
classical method to minimize variance which avoid rounding.

# Installation

To install from Github, first obtain the `devtools` and `Rmpfr` packages. The
latter is used for high precision arithmetic. Then run the following.

```r
devtools::install_github("andrewraim/allocation")
```

# Usage

```r
library(Rmpfr)
library(allocation)
```





# Algorithm III: Sampling with Target Sample Size

Run Algorithm III using an example in Wright (2017).

```r
N_str = c(47, 61, 41)
S_str = sqrt(c(100, 36, 16))
lo_str = c(1,2,3)
hi_str = c(5,6,4)
n = 10

out1 = algIII(n, N_str, S_str, lo_str, hi_str)
print(out1)

##   lower_bound upper_bound allocation
## 1           1           5          4
## 2           2           6          3
## 3           3           4          3
## ----
## Made 4 selections
## Target n: 10.000
## Achieved v: 101,290.3333
```

To see details justifying each selection, run `algIII` with the option
`verbose = TRUE`.

Compare the above results to Neyman allocation

```r
out2 = neyman(n, N_str, S_str)
print(out2)

##    N      S allocation
## 1 47 10.000     4.7000
## 2 61 6.0000     3.6600
## 3 41 4.0000     1.6400
## ----
## v: 92,448.0000
```

Internally, we work with high precision numbers via the `Rmpfr` package.
We provided an `alloc` accessor function to extract the allocation as a
numeric vector.

```r
alloc(out1)

## [1] 4 3 3

alloc(out2)

## [1] 4.70 3.66 1.64
```

The numerical precision and number of decimal points printed, can be
changed by setting a global option for the `allocation` package.

```r
options(allocation.prec.bits = 256)
options(allocation.print.decimals = 4)
```

# Algorithm IV: Sampling with Target Variance

Run Algorithm IV using an example in Wright (2017). Since our target
variance `v0` is a very large number, we pass it as an `mpfr` object to
avoid loss of precision.

```r
H = 10
v0 = mpfr(388910760, 256)^2
N_str = c(819, 672, 358, 196, 135, 83, 53, 40, 35, 13)
lo_str = c(3,3,3,3,3,3,3,3,3,13)
S_str = c(330000, 518000, 488000, 634000, 1126000, 2244000, 2468000, 5869000, 29334000, 1233311000)

out1 = algIV(v0, N_str, S_str, lo_str)
print(out1)

##    lower_bound upper_bound allocation
## 1            3         819          4
## 2            3         672          5
## 3            3         358          3
## 4            3         196          3
## 5            3         135          3
## 6            3          83          3
## 7            3          53          3
## 8            3          40          3
## 9            3          35         13
## 10          13          13         13
## ----
## Made 13 selections
## Target v0: 151,251,579,243,777,600.0000
## Achieved v: 149,400,057,961,841,025.6410
```

To see details justifying each selection, run `algIV` with the option
`verbose = TRUE`.

Compare the above results to Neyman allocation. Here, we first need to
compute a target sample size. This is done with a given cv and revenue
data. See Wright (2017) for details. We also exclude the 10th stratum
from the allocation procedure, as it is a certainty stratum; its
allocation is considered fixed at 13.

```r
cv = 0.042
rev = mpfr(9259780000, 256)
n = sum(N_str[-10] * S_str[-10])^2 / ((cv * rev)^2 + sum(N_str[-10] * S_str[-10]^2))
out2 = neyman(n, N_str[-10], S_str[-10])
print(out2)

##     N               S allocation
## 1 819    330,000.0000     3.8874
## 2 672    518,000.0000     5.0068
## 3 358    488,000.0000     2.5128
## 4 196    634,000.0000     1.7873
## 5 135  1,126,000.0000     2.1864
## 6  83  2,244,000.0000     2.6789
## 7  53  2,468,000.0000     1.8814
## 8  40  5,869,000.0000     3.3766
## 9  35 29,334,000.0000    14.7672
## ----
## v: 151,251,579,243,777,625.5132
```

Extract the final allocations.

```r
alloc(out1)

##  [1]  4  5  3  3  3  3  3  3 13 13

alloc(out2)

## [1]  3.887378  5.006774  2.512822  1.787328  2.186408  2.678921  1.881395
## [8]  3.376627 14.767205
```

