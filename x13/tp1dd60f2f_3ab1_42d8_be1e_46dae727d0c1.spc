# X12-ARIMA spec file default template.

# -The IRIS Toolbox.
# -Copyright (c) 2007-2013 IRIS Solutions Team.

series {
    data = (
        6.09850000
    0.57650000
    -1.96090000
    1.57280000
    5.41190000
    1.58890000
    -2.55130000
    2.29600000
    5.51910000
    3.52340000
    -1.96080000
    0.43130000
    4.70910000
    4.67970000
    -0.48030000
    0.06520000
    4.63260000
    5.93740000
    1.12030000
    2.69710000

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
