
close all
clear

load matlab.mat

shocks = access(m, "all-shocks");
shocks(~startsWith(shocks, "SHKA_")) = [ ];

range = rn(1:3);
range = rn;

p = Plan.forModel(m, range, "Anticipate", false);
p = anticipate(p, true, shocks);

m = differentiate(m);  

tic

s = simulate( ...
    m, ri.dbin, range ...
    , "Plan", p ...
    , "Method", "Stacked" ...
    , "Blocks", false ...
    , "StartIter", "FirstOrder" ...
    , "Solver", {"Iris-Newton", "SkipJacobUpdate", 4,'FunctionTolerance', 1e-5,'StepTolerance',1e-3} ...
);

toc
