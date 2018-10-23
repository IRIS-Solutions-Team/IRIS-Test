# X12-ARIMA spec file default template.

# -The IRIS Toolbox.
# -Copyright (c) 2007-2013 IRIS Solutions Team.

series {
    data = (
        -1.16389431
    -1.95913721
    -1.36688609
    -0.38553866
    0.29704271
    1.67173587
    1.59332035
    0.77992534
    0.72283519
    0.06669303
    -0.38180259
    -0.09125393
    -0.25670734
    1.50992404
    0.75703203
    1.29733516
    0.97071895
    0.50072540
    0.30258362
    0.79322812
    -0.81836659
    -0.60294457
    -1.14810910
    -1.56105587
    -0.48840471
    1.28204543
    -0.32744585
    -0.84859228
    -0.61448497
    -0.48172354
    0.18889814
    0.32242302
    -0.56500307
    -0.28077122
    -1.56619292
    -2.06738476
    -1.02839316
    -1.54203288
    -0.58760829
    0.07124520
    0.23359795
    0.90580125
    1.02290260
    1.64757431
    2.24477095
    0.89979619
    1.43851652
    0.20202452
    0.82368076
    1.87160906
    1.80569416
    0.76635751
    -0.68449493
    0.14596783
    -1.50045725
    -1.15167052
    -1.59785496
    -1.68414757
    -2.01594638
    -2.20028839
    -0.49886203
    0.44047548
    1.52049899
    2.37047626

    )
    period = 4
    start = 2000.1
    precision = 5
    decimals = 5
    
}

transform {
    function = none
}

automdl {
    maxorder = (2 1)
}

forecast {
    maxlead = 0
    maxback = 0
    save = (forecasts backcasts)
}

estimate {
    tol = 1.000000e-05
    maxiter = 1500
    save = (model)
}

#regression regression {
#regression #tdays     variables = ($tdays$)
#regression #dummy     start = $dummy_startyear$.$dummy_startper$
#regression #dummy     user = ($dummy_name$)
#regression #dummy     usertype = $dummy_type$
#regression #dummy     data = (
#regression #dummy     $dummy_data$
#regression #dummy     )    
#regression }

x11 {
    mode = add
    save = (d11 )
    appendbcst = no
    appendfcst = no
}
