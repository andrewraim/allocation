    suppressMessages(library(Rmpfr))
    suppressMessages(library(allocation))

Algorithm III: Sampling with Target Sample Size
===============================================

Test Algorithm III using the example in the Wright (2017).

    N.str <- c(47, 61, 41)
    S.str <- sqrt(c(100, 36, 16))
    lo.str <- c(1,2,3)
    hi.str <- c(5,6,4)
    n <- 10

    out1 <- algIII(n, N.str, S.str, lo.str, hi.str, verbose = TRUE)

    ## ----- About to make selection 1 -----
    ##      value lower_bound upper_bound allocation
    ## 1 332.3402           1           5          1
    ## 2 149.4189           2           6          2
    ## 3  47.3427           3           4          3
    ## Selecting a unit from strata 1 
    ## ----- About to make selection 2 -----
    ##      value lower_bound upper_bound allocation
    ## 1 191.8767           1           5          2
    ## 2 149.4189           2           6          2
    ## 3  47.3427           3           4          3
    ## Selecting a unit from strata 1 
    ## ----- About to make selection 3 -----
    ##      value lower_bound upper_bound allocation
    ## 1 135.6773           1           5          3
    ## 2 149.4189           2           6          2
    ## 3  47.3427           3           4          3
    ## Selecting a unit from strata 2 
    ## ----- About to make selection 4 -----
    ##      value lower_bound upper_bound allocation
    ## 1 135.6773           1           5          3
    ## 2 105.6551           2           6          3
    ## 3  47.3427           3           4          3
    ## Selecting a unit from strata 1 
    ## ----- After 4 selections -----
    ##   lower_bound upper_bound allocation
    ## 1           1           5          4
    ## 2           2           6          3
    ## 3           3           4          3
    ## v = 101,290.3333

    print(out1)

    ##   lower_bound upper_bound allocation
    ## 1           1           5          4
    ## 2           2           6          3
    ## 3           3           4          3
    ## ----
    ## Made 4 selections
    ## Target n: 10.000
    ## Achieved v: 101,290.3333

Compare the above results to Neyman allocation

    out2 <- neyman(n, N.str, S.str, verbose = TRUE)
    print(out2)

    ##    N      S allocation
    ## 1 47 10.000     4.7000
    ## 2 61 6.0000     3.6600
    ## 3 41 4.0000     1.6400
    ## ----
    ## v: 92,448.0000

Internally, we work with high precision numbers via the `Rmpfr` package.
We provided an `alloc` accessor function to extract the allocation as a
numeric vector.

    alloc(out1)

    ## [1] 4 3 3

    alloc(out2)

    ## [1] 4.70 3.66 1.64

The numerical precision and number of decimal points printed, can be
changed by setting a global option for the `allocation` package.

    options(allocation.prec.bits = 256)
    options(allocation.print.decimals = 4)

Algorithm IV: Sampling with Target Variance
===========================================

Test Algorithm IV using the example in the Wright (2017). Since our
target variance `v0` is a very large number, we pass it as an `mpfr`
object to avoid loss of precision.

    H <- 10
    v0 <- mpfr(388910760, 256)^2
    N.str <- c(819, 672, 358, 196, 135, 83, 53, 40, 35, 13)
    lo.str <- c(3,3,3,3,3,3,3,3,3,13)
    S.str <- c(330000, 518000, 488000, 634000, 1126000, 2244000, 2468000, 5869000, 29334000, 1233311000)

    out1 <- algIV(v0, N.str, S.str, lo.str, verbose = TRUE)

    ## ----- About to make selection 1 -----
    ## Target v0: 151,251,579,243,777,600.0000
    ## So far achieved v: 441,923,415,373,333,333.3333
    ##               value lower_bound upper_bound allocation
    ## 1   78,020,228.6269           3         819          3
    ## 2  100,486,659.6519           3         672          3
    ## 3   50,432,700.7143           3         358          3
    ## 4   35,871,926.9253           3         196          3
    ## 5   43,881,507.2098           3         135          3
    ## 6   53,766,321.1686           3          83          3
    ## 7   37,759,862.3055           3          53          3
    ## 8   67,769,374.5975           3          40          3
    ## 9  296,379,873.9371           3          35          3
    ## 10           0.0000          13          13         13
    ## Now selecting a unit from strata 9 
    ## ----- About to make selection 2 -----
    ## Target v0: 151,251,579,243,777,600.0000
    ## So far achieved v: 354,082,385,698,333,333.3333
    ##               value lower_bound upper_bound allocation
    ## 1   78,020,228.6269           3         819          3
    ## 2  100,486,659.6519           3         672          3
    ## 3   50,432,700.7143           3         358          3
    ## 4   35,871,926.9253           3         196          3
    ## 5   43,881,507.2098           3         135          3
    ## 6   53,766,321.1686           3          83          3
    ## 7   37,759,862.3055           3          53          3
    ## 8   67,769,374.5975           3          40          3
    ## 9  229,574,863.1819           3          35          4
    ## 10           0.0000          13          13         13
    ## Now selecting a unit from strata 9 
    ## ----- About to make selection 3 -----
    ## Target v0: 151,251,579,243,777,600.0000
    ## So far achieved v: 301,377,767,893,333,333.3333
    ##               value lower_bound upper_bound allocation
    ## 1   78,020,228.6269           3         819          3
    ## 2  100,486,659.6519           3         672          3
    ## 3   50,432,700.7143           3         358          3
    ## 4   35,871,926.9253           3         196          3
    ## 5   43,881,507.2098           3         135          3
    ## 6   53,766,321.1686           3          83          3
    ## 7   37,759,862.3055           3          53          3
    ## 8   67,769,374.5975           3          40          3
    ## 9  187,447,090.8550           3          35          5
    ## 10           0.0000          13          13         13
    ## Now selecting a unit from strata 9 
    ## ----- About to make selection 4 -----
    ## Target v0: 151,251,579,243,777,600.0000
    ## So far achieved v: 266,241,356,023,333,333.3333
    ##               value lower_bound upper_bound allocation
    ## 1   78,020,228.6269           3         819          3
    ## 2  100,486,659.6519           3         672          3
    ## 3   50,432,700.7143           3         358          3
    ## 4   35,871,926.9253           3         196          3
    ## 5   43,881,507.2098           3         135          3
    ## 6   53,766,321.1686           3          83          3
    ## 7   37,759,862.3055           3          53          3
    ## 8   67,769,374.5975           3          40          3
    ## 9  158,421,706.3726           3          35          6
    ## 10           0.0000          13          13         13
    ## Now selecting a unit from strata 9 
    ## ----- About to make selection 5 -----
    ## Target v0: 151,251,579,243,777,600.0000
    ## So far achieved v: 241,143,918,973,333,333.3333
    ##               value lower_bound upper_bound allocation
    ## 1   78,020,228.6269           3         819          3
    ## 2  100,486,659.6519           3         672          3
    ## 3   50,432,700.7143           3         358          3
    ## 4   35,871,926.9253           3         196          3
    ## 5   43,881,507.2098           3         135          3
    ## 6   53,766,321.1686           3          83          3
    ## 7   37,759,862.3055           3          53          3
    ## 8   67,769,374.5975           3          40          3
    ## 9  137,197,222.2295           3          35          7
    ## 10           0.0000          13          13         13
    ## Now selecting a unit from strata 9 
    ## ----- About to make selection 6 -----
    ## Target v0: 151,251,579,243,777,600.0000
    ## So far achieved v: 222,320,841,185,833,333.3333
    ##               value lower_bound upper_bound allocation
    ## 1   78,020,228.6269           3         819          3
    ## 2  100,486,659.6519           3         672          3
    ## 3   50,432,700.7143           3         358          3
    ## 4   35,871,926.9253           3         196          3
    ## 5   43,881,507.2098           3         135          3
    ## 6   53,766,321.1686           3          83          3
    ## 7   37,759,862.3055           3          53          3
    ## 8   67,769,374.5975           3          40          3
    ## 9  120,996,576.8627           3          35          8
    ## 10           0.0000          13          13         13
    ## Now selecting a unit from strata 9 
    ## ----- About to make selection 7 -----
    ## Target v0: 151,251,579,243,777,600.0000
    ## So far achieved v: 207,680,669,573,333,333.3333
    ##               value lower_bound upper_bound allocation
    ## 1   78,020,228.6269           3         819          3
    ## 2  100,486,659.6519           3         672          3
    ## 3   50,432,700.7143           3         358          3
    ## 4   35,871,926.9253           3         196          3
    ## 5   43,881,507.2098           3         135          3
    ## 6   53,766,321.1686           3          83          3
    ## 7   37,759,862.3055           3          53          3
    ## 8   67,769,374.5975           3          40          3
    ## 9  108,222,628.3639           3          35          9
    ## 10           0.0000          13          13         13
    ## Now selecting a unit from strata 9 
    ## ----- About to make selection 8 -----
    ## Target v0: 151,251,579,243,777,600.0000
    ## So far achieved v: 195,968,532,283,333,333.3333
    ##               value lower_bound upper_bound allocation
    ## 1   78,020,228.6269           3         819          3
    ## 2  100,486,659.6519           3         672          3
    ## 3   50,432,700.7143           3         358          3
    ## 4   35,871,926.9253           3         196          3
    ## 5   43,881,507.2098           3         135          3
    ## 6   53,766,321.1686           3          83          3
    ## 7   37,759,862.3055           3          53          3
    ## 8   67,769,374.5975           3          40          3
    ## 9   97,891,050.5753           3          35         10
    ## 10           0.0000          13          13         13
    ## Now selecting a unit from strata 2 
    ## ----- About to make selection 9 -----
    ## Target v0: 151,251,579,243,777,600.0000
    ## So far achieved v: 185,870,963,515,333,333.3333
    ##              value lower_bound upper_bound allocation
    ## 1  78,020,228.6269           3         819          3
    ## 2  77,836,631.8696           3         672          4
    ## 3  50,432,700.7143           3         358          3
    ## 4  35,871,926.9253           3         196          3
    ## 5  43,881,507.2098           3         135          3
    ## 6  53,766,321.1686           3          83          3
    ## 7  37,759,862.3055           3          53          3
    ## 8  67,769,374.5975           3          40          3
    ## 9  97,891,050.5753           3          35         10
    ## 10          0.0000          13          13         13
    ## Now selecting a unit from strata 9 
    ## ----- About to make selection 10 -----
    ## Target v0: 151,251,579,243,777,600.0000
    ## So far achieved v: 176,288,305,732,606,060.6061
    ##              value lower_bound upper_bound allocation
    ## 1  78,020,228.6269           3         819          3
    ## 2  77,836,631.8696           3         672          4
    ## 3  50,432,700.7143           3         358          3
    ## 4  35,871,926.9253           3         196          3
    ## 5  43,881,507.2098           3         135          3
    ## 6  53,766,321.1686           3          83          3
    ## 7  37,759,862.3055           3          53          3
    ## 8  67,769,374.5975           3          40          3
    ## 9  89,361,894.2966           3          35         11
    ## 10          0.0000          13          13         13
    ## Now selecting a unit from strata 9 
    ## ----- About to make selection 11 -----
    ## Target v0: 151,251,579,243,777,600.0000
    ## So far achieved v: 168,302,757,580,333,333.3333
    ##              value lower_bound upper_bound allocation
    ## 1  78,020,228.6269           3         819          3
    ## 2  77,836,631.8696           3         672          4
    ## 3  50,432,700.7143           3         358          3
    ## 4  35,871,926.9253           3         196          3
    ## 5  43,881,507.2098           3         135          3
    ## 6  53,766,321.1686           3          83          3
    ## 7  37,759,862.3055           3          53          3
    ## 8  67,769,374.5975           3          40          3
    ## 9  82,200,987.1151           3          35         12
    ## 10          0.0000          13          13         13
    ## Now selecting a unit from strata 9 
    ## ----- About to make selection 12 -----
    ## Target v0: 151,251,579,243,777,600.0000
    ## So far achieved v: 161,545,755,297,641,025.6410
    ##              value lower_bound upper_bound allocation
    ## 1  78,020,228.6269           3         819          3
    ## 2  77,836,631.8696           3         672          4
    ## 3  50,432,700.7143           3         358          3
    ## 4  35,871,926.9253           3         196          3
    ## 5  43,881,507.2098           3         135          3
    ## 6  53,766,321.1686           3          83          3
    ## 7  37,759,862.3055           3          53          3
    ## 8  67,769,374.5975           3          40          3
    ## 9  76,103,326.0923           3          35         13
    ## 10          0.0000          13          13         13
    ## Now selecting a unit from strata 1 
    ## ----- About to make selection 13 -----
    ## Target v0: 151,251,579,243,777,600.0000
    ## So far achieved v: 155,458,599,222,641,025.6410
    ##              value lower_bound upper_bound allocation
    ## 1  60,434,209.2279           3         819          4
    ## 2  77,836,631.8696           3         672          4
    ## 3  50,432,700.7143           3         358          3
    ## 4  35,871,926.9253           3         196          3
    ## 5  43,881,507.2098           3         135          3
    ## 6  53,766,321.1686           3          83          3
    ## 7  37,759,862.3055           3          53          3
    ## 8  67,769,374.5975           3          40          3
    ## 9  76,103,326.0923           3          35         13
    ## 10          0.0000          13          13         13
    ## Now selecting a unit from strata 2

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

Compare the above results to Neyman allocation. Here, we first need to
compute a target sample size. This is done with a given cv and revenue
data. See Wright (2017) for details. We also exclude the 10th stratum
from the allocation procedure, as it is a certainty stratum; its
allocation is considered fixed at 13.

    cv <- 0.042
    rev <- mpfr(9259780000, 256)
    n <- sum(N.str[-10] * S.str[-10])^2 / ((cv * rev)^2 + sum(N.str[-10] * S.str[-10]^2))
    out2 <- neyman(n, N.str[-10], S.str[-10], verbose = TRUE)
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

Extract the final allocations.

    alloc(out1)

    ##  [1]  4  5  3  3  3  3  3  3 13 13

    alloc(out2)

    ## [1]  3.887378  5.006774  2.512822  1.787328  2.186408  2.678921  1.881395
    ## [8]  3.376627 14.767205

\`\`\`
