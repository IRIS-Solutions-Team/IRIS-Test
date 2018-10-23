# X12-ARIMA spec file default template.

# -The IRIS Toolbox.
# -Copyright (c) 2007-2013 IRIS Solutions Team.

series {
    data = (
        0.81472369
    0.90579194
    0.12698682
    0.91337586
    1.44708293
    1.00333234
    0.40548504
    1.46025738
    2.40458977
    1.96822088
    0.56309812
    2.43085016
    3.36175672
    2.45359653
    1.36337859
    2.57273650
    3.78351800
    3.36933205
    2.15558592
    3.53222892
    4.43925870
    3.40504373
    3.00471522
    4.46622217
    5.11799385
    4.16278386
    3.74784769
    4.85844919
    5.77347174
    4.33397055
    4.45389378
    4.89028204
    6.05039473
    4.38014194
    4.55102556
    5.71373986
    6.74522335
    4.69724142
    5.50124761
    5.74818594

    )
    period = 4
    start = 2000.1
    precision = 5
    decimals = 5
    
}

transform {
    function = log
}

automdl {
    maxorder = (2 1)
}

forecast {
    maxlead = 8
    maxback = 8
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
    mode = mult
    save = (d11 )
    appendbcst = no
    appendfcst = no
}
