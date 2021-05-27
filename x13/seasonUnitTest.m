% saveAs=x13/seasonUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


% Set up Once

d = struct( );
d.x = Series(qq(2002,1), [447.924; 488.926; 503.106; 504.475; 476.584; 506.641; 522.494; 534.332; 525.144; 570.763; 584.736; 591.95; 568.276; 605.741; 616.934; 630.013; 612.312; 652.196; 663.098; 653.885; 630.297; 666.682; 678.601; 670.391; 630.586; 660.254; 667.159; 629.053; 532.98; 542.934; 579.899; 592.762; 572.684; 636.328; 672.832; 661.919; 633.079; 675.741; 694.481; 683.819; 659.703; 700.919; 708.03; 691.199; 654.445; 709.837; 722.323; 715.841; 684.272; 744.107; 751.67; 762.45; 730.599; 781.817; 793.546; 788.83; 747.013; 788.477; 803.988; 806.402; 776.546; 829.074; 834.472; 852.272; 811.231; 857.899; 876.732; 881.349; 826.41; 882.253; 892.011; 863.515; 789.285; 678.542]);
d.y = d.x{-Inf:qq(2018,4)};
d.z = d.x{qq(2005,3):Inf};


%% Test Plain Vanilla

if ~verLessThan('matlab', '9.9')
    sa = x13.season(d.x);
    assertClass(testCase, sa, "Series");
    assertEqual(testCase, sa.StartAsNumeric, d.x.StartAsNumeric, "AbsTol", 1e-10);
    assertEqual(testCase, sa.EndAsNumeric, d.x.EndAsNumeric, "AbsTol", 1e-10);
end


%% Test Multiple Outputs

if ~verLessThan('matlab', '9.9')
    [sa, sf, tc, ir, info] = x13.season( ...
        d.x ...
        , "Output", ["d11", "d10", "d12", "d13", "fct"] ...
        , "X11_Mode", "add" ...
    );
    assertEqual(testCase, getData(d.x, Inf), getData(sf+tc+ir, Inf), "AbsTol", 1e-10);
end


%% Test Multiple Inputs

if ~verLessThan('matlab', '9.9')
    [sa, sf, info] = x13.season( ...
        [d.x, d.y, d.z] ...
        , "Output", ["d11", "d10"] ...
        , "X11_Mode", "add" ...
    );

    assertSize(testCase, sa{:, 1}, size(d.x));
    assertSize(testCase, sa{:, 2}, size(d.y));
    assertSize(testCase, sa{:, 3}, size(d.z));

    assertSize(testCase, sf{:, 1}, size(d.x));
    assertSize(testCase, sf{:, 2}, size(d.y));
    assertSize(testCase, sf{:, 3}, size(d.z));
end


%% Test Model

if ~verLessThan('matlab', '9.9')
    [sa, info] = x13.season( ...
        d.x ...
        , "X11_Mode", "add" ...
        , "Estimate_Save", "mdl" ...
    );

    assertEqual(testCase, info.OutputSpecs.Arima_Model, "(0,0,0)");
    assertSize(testCase, info.OutputSpecs.Arima_AR, [1, 0]);
    assertSize(testCase, info.OutputSpecs.Arima_MA, [1, 0]);

    [sa, info] = x13.season( ...
        d.y ...
        , "X11_Mode", "add" ...
        , "Automdl", true ...k
        , "Estimate_Save", "mdl" ...
    );

    assertEqual(testCase, info.OutputSpecs.Arima_Model, "(0,1,1)(0,1,1)");
    assertEqual(testCase, info.OutputSpecs.Arima_AR, double.empty(1, 0));
    assertSize(testCase, info.OutputSpecs.Arima_MA, [1, 2]);
end


%% Test Forecast

if ~verLessThan('matlab', '9.9')
    [fct, info] = x13.season( ...
        d.x ...
        , "Output", "fct" ...
        , "Automdl", true ...
        , "Forecast_MaxLead", 24 ...
    );
    %
    assertSize(testCase, fct, [24, 1]);
    %
    [fct, bct, info] = x13.season( ...
        [d.x, d.y, d.z] ...
        , "Output", ["fct", "bct"] ...
        , "Automdl", true ...
        , "Forecast_MaxLead", 24 ...
    );
    %
    assertSize(testCase, fct, [30, 3]);
    assertSize(testCase, bct, [0, 3]);
end


%% Test Backcast

if ~verLessThan('matlab', '9.9')
    [bct, info] = x13.season( ...
        d.x ...
        , "Output", "bct" ...
        , "Automdl", true ...
        , "Forecast_MaxBack", 24 ...
        , "Forecast_MaxLead", 0 ...
    );

    assertSize(testCase, bct, [24, 1]);

    [fct, bct, info] = x13.season( ...
        [d.x, d.y, d.z] ...
        , "Output", ["fct", "bct"] ...
        , "Automdl", true ...
        , "Forecast_MaxBack", 24 ...
        , "Forecast_MaxLead", 0 ...
    );

    assertSize(testCase, bct, [38, 3]);
    assertSize(testCase, fct, [0, 3]);
end


%% Test Arima 

if ~verLessThan('matlab', '9.9')
    [sa, info] = x13.season( ...
        d.x ...
        , "Arima_Model", "(0 1 1)(0 1 1)" ...
        , "Estimate_Save", "mdl" ...
    );

    assertEqual(testCase, info.OutputSpecs.Arima_Model, "(0,1,1)(0,1,1)");

    [sa2, info2] = x13.season( ...
        d.x ...
        , "Arima_Model", "(0 1 1)(0 1 1)" ...
        , "Arima_MA", round(info.OutputSpecs.Arima_MA, 1)*1i ...
        , "Estimate_Save", "mdl" ...
    );

    assertEqual(testCase, info2.OutputSpecs.Arima_MA, round(info.OutputSpecs.Arima_MA, 1), "AbsTol", 1e-10);
end


%% Test Dummies 

if ~verLessThan('matlab', '9.9')
    [sa, info] = x13.season( ...
        [d.x, d.y] ...
        , "X11_Mode", "add" ...
        , "Automdl", true ...
        , "Regression_Variables", ["aos2013.1-2013.4"] ...
        , "Forecast_MaxLead", 0 ...
    );

    dummy = Series(d.x.Range, [0, 0, 0, 0]);
    for k = 1 : 4
        dummy(qq(2013,k), k) = 1;
    end

    [sa2, info2] = x13.season( ...
        [d.x, d.y] ...
        , "X11_Mode", "add" ...
        , "Automdl", true ...
        , "Regression_Data", dummy ...
        , "Regression_User", ["a","b","c","d"] ...
        , "Forecast_MaxLead", 0 ...
    );

    assertEqual(testCase, sa.Data, sa2.Data, "AbsTol", 1e-10);
end
