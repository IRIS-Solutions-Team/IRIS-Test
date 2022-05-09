%% Posterior Simulator with saveEvery= Option                            
%
% In this file, we show two features of convenience when running larger
% posterior simulations. First, the posterior simulator can be run with the
% option `SaveEvery=` to split the simulated posterior chain into smaller
% bits and saving them each in a separate data file. This is a way to get
% around possible out-of-memory problems when simulating larger models
% and/or longer chains. Second, a large posterior simulation can executed
% incrementally in smaller chunks, with the final state of one simulation
% being used as the initial state for the next one.


%% Clear Workspace
%
% Clear workspace, close all graphics figures, clear command window, and
% check the IRIS version.

close all
clear

load mat/estimateParams.mat pos


%% Run Posterior Simulator and Statistics 
%
% Reset the random number generator and run the posterior simulator the
% normal way (because this is just an illustration of how the functions
% work, keep the number of draws). Then compute some of the posterior
% statistics.
%

N = 100;

rng(0);

disp("Run the posterior simulator at once")

tic( )
[theta1, logPost1, ar1, pos1] = arwm(pos, N, "Progress", true); %#ok<ASGLU>
toc( )


%% Run Again Saving Every N Draws
%
% Reset the random number generator again to reproduce the above numbers, 
% and run the posterior simulator saving now every 20 draws in a separate
% HDF5 (hierarchical data file). Note that you must assign a valid file
% name through the option `SaveAs=` whenever using `SaveEvery=`.
%

if exist("myposter.h5", "file")
    delete("myposter.h5");
end

rng(0);

N = 100;
disp("Run the posterior simulator saving every 20 draws")

tic( )
arwm(pos, N, "Progress", true, "SaveEvery", N, "SaveAs", "myposter.h5");
toc( )


%% Compute Posterior Statistics
%
% To compute the posterior statistics, use the function `stats( )` and pass
% in 
%
% * either the simulated posterior chain, `theta1`, and posterior log
% densities, `logPost1`;
% * or the file name under which the batches where saved when running
% `arwm( )` with the option `SaveEvery=`, i.e. `"myposter"` in this
% example.
%
% In a real-life simulation, remember to exclude `"chain"` from the list of
% requested outputs in `stats( )` in the latter case, i.e. add the option
% `Chain=false`. You use the option `SaveEvery=` to breake the
% simulated chain down into smaller bits because the length of the chain
% would be overwhelming for your computer memory; you don"t therefore want
% the chains to be restored in full length.
%

tic( )
stats1 = stats(pos, theta1, logPost1, "mode", true, "cov", true);
toc( )

tic( )
stats2 = stats(pos, "myposter.h5", [], "mode", true, "cov", true);
toc( )

disp(" ")


%% Compare Results
%
% Display the max abs differences between the chains simulated in a plain
% run of the posterior simulatior, and in a run with the `SaveEvery=`
% option.
%

disp("Compare the two runs of the posterior simulator")
disp("Max discrepancy in simulate chain, mean, and std devs")
maxabs(stats1.chain, stats2.chain) ...
    & maxabs(stats1.mean, stats2.mean) ...
    & maxabs(stats1.std, stats2.std) %#ok<NOPTS>

disp("Max discrepancy in covariance matrix")
maxabs(stats1.cov, stats2.cov)


%% Incremental Runs of Posterior Simulator
%
% First, run a posterior simulation of 100 draws with 20 burn-ins. Then, 
% run the same simulation split into two steps. Using the posterior object
% returned from the first to initialize the second one reproduces exactly
% the results of the original simulation.
%
% The second incremental simulation, is based on the posterior object
% `pos21` returned from the first simulation, the third is based on the
% simulation object from the second, etc. This is the way to initialize the
% posterior simulation by the final results obtained in the previous step.
%
% Note that the number of burn-ins must be set to the original number (i.e.
% 50) in the very first simulation, and to zero in all subsequent
% simulations.

%%%
%
% Simulate 300 draws with 50 burn-ins at the beginning.
%

rng(1);
[theta1, logPost1, ar1] = arwm(pos, 300, ...
    "Progress", true, ...
    "Burnin", 50); 

%%%
%
% Simulate 300 draw incrementally (by 100 in each simulation).
%

rng(1);
[theta21, logPost21, ar21, pos21] = arwm(pos, 100, ... 
    "Progress", true, ...
    "Burnin", 50);

[theta22, logPost22, ar22, pos22] = arwm(pos21, 100, ... 
    "Progress", true, ...
    "Burnin", 0); 

[theta23, logPost23, ar23, pos23] = arwm(pos22, 100, ...
    "Progress", true, ...
    "Burnin", 0); 

%%%
%
% Combine the three simulation results.
%

theta2 = [theta21, theta22, theta23];
logPost2 = [logPost21, logPost22, logPost23];
ar2 = [ar21, ar22, ar23];

%%%
%
% Verify that the original and the incremental simulation results are
% identical (up to rounding errors).
%

disp("Max discrepancy in simulated chain")
maxabs(theta1, theta2)

disp("Max discrepancy in log posterior density")
maxabs(logPost1, logPost2)

disp("Max discrepancy in cumulative acceptance ratios")
maxabs(ar1, ar2)

%%%
%
% Look into the posterior objects as they are updated throughout the
% incremental simulations.
%

pos %#ok<NOPTS>
pos21 %#ok<NOPTS>
pos22 %#ok<NOPTS>
pos23 %#ok<NOPTS>

