%% Kalman Filtering and Historical Simulations
%
% Run the Kalman filter on the historical data to back out unobservable
% variables (such as the productivity process) and shocks, and perform a
% number of analytical exercises that help understand the inner workings of
% the model.


%% Clear Workspace

close all
clear
%#ok<*CLARRSTR> 
%#ok<*EV2IN> 

load mat/estimateParams.mat mest
load mat/prepareDataFromFred.mat c

startHist = qq(1990,1);
% endHist = qq(2019,3);
endHist = qq(2022,1);
d = databank.clip(c, -Inf, endHist);

databank.list(c)
databank.list(d)


%% Run Kalman Filter
%(
% The output data struct returned from the Kalman filter, `f`, consist by
% default of three sub-databases:
%
% * `.mean` with point estimates of all model variables as Series objects,
% * `.std` with std dev of those estimates as Series objects,
% * `.mse` with the MSE matrix for backward-looking transition variables.
%
% Use the options `Output=`, `MeanOnly=`, `ReturnStd=` and
% `ReturnMse=` to control what is reported in the output data struct.

f = kalmanFilter(mest, d, startHist:endHist);


[f1, ~, info] = kalmanFilter( ...
    mest, d, startHist:endHist ...
    , "outputData", ["smooth", "predict", "update"] ...
);



%% Plot Estimated Shocks
%
% The measurement shocks are kept turned off in our exercises (i.e. their
% standard errors are zero), and hence their estimates are zero throughout
% the historical sample.
%

ch = databank.Chartpack();
ch.Range = startHist:endHist;
ch.Transform = @(x) 100*x;
ch.AxesExtras = {@(h) visual.vline(h)};

ch < access(mest, "transition-shocks");
draw(ch, f.Mean);

visual.heading("Estimates of transition shocks");


ch = databank.Chartpack();
ch.Transform = @(x) 100*x;
ch.PlotFunc = @histogram;
ch.Range = cell.empty(1, 0);

ch < access(mest, "transition-shocks");

draw(ch, f.Mean);

visual.heading("Histograms of estimated transition shocks");



%% K-Step-Ahead Kalman Predictions
%
% Re-run the Kalman filter requesting now also prediction step data (see
% the option `Output=`) extended to 5 quarters ahead (see the option
% `Ahead=`). Each row of the time series returned in the `.pred`
% sub-database contains t/t-1, t/t-2, ..., t/t-k predictions.
%
% Because of the option `MeanOnly=true`, the filter output
% struct, `g`, only containes mean databases directly under `.pred` and
% `.smooth`, and no subdatabases `.mean` are created.
%
% Use the function `plotpred( )` to organize and plot the data in
% a convenient way.

g = kalmanFilter( ...
    mest, d, startHist:endHist ...
    , "outputData", ["predict", "smooth"] ...
    , "meanOnly", true ...
    , "ahead", 8 ...
);

g %#ok<NOPTS>
g.Predict
g.Smooth

figure( );
[h1, h2] = plotpred(startHist:endHist, d.Short, g.Predict.Short);
set(h1, "Marker", ".");
set(h2, "LineStyle", ":", "LineWidth", 1.5);
grid on
title("Short Rates: 1- to 5-Qtr-Ahead Kalman Predictions");


%% Resimulate filtered data
%
% This is to illustrate that running a simulation with the initial
% conditions and shocks estimated by the Kalman filter exactly reproduces
% the historical paths of the observables.

s = simulate(mest, f.Median, startHist:endHist, "anticipate", false);

tempDb = databank.merge("horzcat", f.Median, s);

databank.apply(tempDb, @(x) max(abs(x(:,1)-x(:,2))))


%% Run counterfactual
%
% Remove the cost-push shocks from the filtered database, and re-simulate
% the historical data. This experiment shows what the data would have
% looked like if inflation had been determeined exactly by the Phillips
% curve without any cost-push shocks.

f1 = f.Median;
f1.Ep(:) = 0;

s1 = simulate(mest, f1, startHist:endHist, "anticipate", false);

figure( );
plot([s.Infl, s1.Infl]);
grid on;
title("Inflation, Q/Q PA");
legend("Actual Data", "Counterfactual without Cost Push Shocks");


%% Simulate contributions of shocks
%
% Re-simulate the filtered data with the `Contributions=` option set to
% true. This returns each variable as a multivariate time series with $n+1$
% columns, where $n$ is the number of model shocks. The first $n$ columns
% are contributions of individual shocks (in order of their appearance in
% the `!transition_shocks` declaration block in the model file), the last,
% $n+1$-th column is the contribution of the initial condition and/or the
% deterministic drift.

c = simulate( ...
    mest, s, startHist:endHist+8 ...
    , "anticipate", false ...
    , "contributions", true ...
    , "prependInput", true ...
);

c %#ok<NOPTS>
c.Infl


%%%
%
% To plot the shock contributions, use the function `barcon( )`. Plot first
% the actual data and the effect of the initial condition and deterministic
% constant (i.e. the last, $n+1$-th column in the database `c`) in the
% upper panel, and then the contributions of individual shocks, i.e. the
% first $n$ columns.
%

figure( );

subplot(2, 1, 1);
plot(startHist:endHist, [s.Infl, c.Infl{:, end-1}]);
grid on
title("Inflation, Q/Q PA");
legend("Actual data", "Steady State + Init Cond", "location", "northWest");

subplot(2, 1, 2);
bar(startHist:endHist, c.Infl{:, 1:end-2}, "stacked");
grid on
title("Contributions of shocks");

descriptions = access(mest, "shocks-descriptions");
legend(descriptions, "location", "northWest");


%% Plot grouped contributions
%
% Use a `grouping` object to define groups of shocks whose contributions
% will be added together and plotted as one category. Run `eval( )` to
% create a new database with the contributions grouped accordingly.
% Otherwise, the information content of this figure window is the same as
% the previous one.

g = grouping(mest, "shock", "includeExtras", true);
g = addgroup(g, "Measurement", ["Mp", "Mw"]);
g = addgroup(g, "Demand", ["Ey", "Er"]); %#ok<*CLARRSTR> 
g = addgroup(g, "Supply", ["Ep", "Ea", "Ew"]);

detail(g);

[cg, lg] = eval(g, c); 

figure( );

subplot(2, 1, 1);
plot(startHist:endHist, [s.Infl, c.Infl{:, end-1}]);
grid on;
title("Inflation, Q/Q PA");
legend("Actual Data", "Steady state + Init Cond", "location", "northWest");

subplot(2, 1, 2);
barcon(cg.Infl{:, 1:end-1});
grid on;
title("Contributions of Shocks");
legend(lg(:, 1:end-1), "location", "northWest");


%% Save Output Data for Further Use

save mat/filterHistData.mat f

