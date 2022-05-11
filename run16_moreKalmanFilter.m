%% More on Kalman Filter
%
% Run more advanced Kalman filter exercises. Split the data sample into two
% sub-samples, and pass information from one to the other. Run the filter
% with time-varying std deviations of some shocks. Evaluate the likelihood
% function and the contributions of individual time periods to the overall
% likelihood.
%


%% Clear Workspace
%
% Clear workspace, close all graphics figures, clear command window, and
% check the IRIS version.

close all
clear

load mat/estimateParams.mat mest startHist endHist
load mat/prepareDataFromFred.mat c

d = c;


%% Split the Kalman filter into sub-samples
%
% With the range split into two or more sub-samples, and the Kalman
% filter-smoother executed successively on each of them (using the most
% recent result as the initial condition for the next run), the smoothed
% data estimates will differ from those obtained previously (running the
% filter once on the whole range). This is because the individual runs of
% the filter of data will be based on different information sets.
%
% The only exception is, obviously, the last sub-sample, which is by
% construction based on information from the entire range 1..T, and hence
% identical to the information set when the filter is run just once on the
% entire range.
%
% When running the Kalman filter on the last sub-sambple, the
% output database from the previous run, `f1`, is used to set up initical
% condition for the filter (instead of the default asymptotic
% distribution). This is allowed by the fact that the database `f1`
% contains both the point estimates and the MSE matrices.

checkSteady(mest);
mest = solve(mest);

[~, f0, v0, ~, pe0] = filter( ...
    mest, d, startHist:endHist ...
    , "relative", false ...
);

N = 15;

[~, f1, v1, ~, pe1] = filter( ...
    mest, d, startHist:endHist-N ...
    , "relative", false ...
);

f1 

[~, f2, v2, ~, pe2] = filter( ...
    mest, d, endHist-N+1:endHist ...
    , "relative", false ...
    , "initCond", f1 ...
); 


%%%
%
% Print differences between the smoothed data
%

disp("Smoothed estimates differ for the first sub-sample")
dbfun(@maxabs, f0.mean, f1.mean)
dbfun(@maxabs, pe0, pe1)

disp("Smoothed estimates are identical for the last sub-sample")
dbfun(@maxabs, f0.mean, f2.mean)
dbfun(@maxabs, pe0, pe2)

return

%% Run Kalman Filter with Time Varying Std Devs of Some Shocks
%
% Use the option `Vary=` to temporarily change some of the std deviations
% (or also cross-correlations) within the filtered sample. The estimates of
% unobservables and shocks will obviously change: Compare the estimated
% `Ep` shocks from the previous Kalman filter (with fixed std deviations)
% and the Kalman filter with time-varying `std_Ep`.

j = struct( );
j.std_Ep = Series( );
j.std_Ep(endHist-9:endHist-5) = linspace(0.00, 0.4, 5);

[~, f1] = filter(mest, d, startHist:endHist, "override", j);

[j.std_Ep, f1.mean.Ep, f0.mean.Ep] 


%% Evaluate Likelihood Function and Contributions of Individual Time Periods
%
% Run the function `loglik( )` to evaluate the likelihood function. This
% function calls the very same Kalman filter as the function `filter( )`.
% The first output argument returned by `loglik( )` is minus the logarithm
% of the likelihood function; this value is also used as a criterion to be
% minimized (which means maximizing likelihood) within the function
% `estimate( )`.
%
% Set the option `ObjFuncContributions=true` to obtain not only the overall
% likelihood, but also the contributions of individual time periods. They
% are stowed in a column vector with the overall likelihood at the top; the
% length of the vector is therefore $nPer+1$ where $nPer$ is the number of
% periods over which the filter is run.

range = startHist:endHist+10;
nPer = length(range)

mll = loglik(mest, d, range, "relative", false, "returnObjFuncContribs", true); 

size(mll) 

%%%
%
% Because there were no observations available in the input database `d` in
% the last 10 periods of the filter range, i.e. `endHist+1:endHist+10`, the
% contributions of these last 10 periods are zero.

mll 

%%%
%
% Adding up the individual contributions reproduces, of course, the overall
% likelihood. The following two numbers are the same (up to rounding
% errors):

mll(1)    
sum(mll(2:end))


%%%
%
% Visualize the contributions by converting them to a Series object, and
% plotting as a bar graph. Large bars denote periods where the model
% performed poorly (rememeber, this is MINUS the log likelihood, ie. the
% larger the number the smaller the actual likelihood). Again, the last 10
% periods are zeros because no observations were available in the input
% database in those.

x = Series(range, mll(2:end));
bar(x);
grid on
title("Contributions of Individual Time Periods to (Minus Log) Likelihood");


