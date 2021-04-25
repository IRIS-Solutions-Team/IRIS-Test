% Basic ERT model with 'diagnosed' state
% 
% Dynare code
% (c) Antti Ripatti, 2020-
%%
%% Definitions
var  ﻿n, ns, ni, nd, nr, c, cs, ci, cd, cr, w, tau,
   lambdab, lambdas, lambdai, lambdad, lambdar, lambdatau, s, i, d, r,
   e, pop,
   dlambdab, dlambdas, dlambdai, dlambdad, dlambdar, dlambdatau,
   dns, dni, dnd, dnr, dcs, dci, dcd, dcr, dw;

   
parameters
  A = 1.943; % level of technology
  beta = (1/1.03)^(1/52); % discount rate
  pi1 = 3.194e-7;
  pi2 = 1.593e-4;
  pi3 = 0.499;
  pidi = 0.0;
  piei = 7*0.002/14;
  piri = 7*1/14 - piei;
  pied = 7*0.002/14-0.0001;
  pird = 7*1/14 - pied-0.0001;
  theta = 0.0015; % labor supply parameter
  


%% Model block
!transition_equations
  
  % New infections
  tau =# pi1*s{-1}*cs*i{-1}*ci + pi2*s{-1}*ns*i{-1}*ni + pi3*s{-1}*i{-1};
  % Total suseptibles
  s = s{-1} - tau;
  % Total infected
  i = i{-1} + tau - (piri+pidi+piei)*i{-1};
  % Total detected
  d = d{-1} + pidi*i{-1} - (pird+pied)*d{-1};
  % Total recovered
  r = r{-1} + piri*i{-1} + pird*d{-1};
  % Total deaths 
  e = e{-1} + piei*i{-1} + pied*d{-1};
  % Population
  pop = pop{-1} - piei*i{-1} - pied*d{-1};
  % real wages
  w = A + eps;
  % production
  c = A*n;
  % Aggregate hours
  n =# s{-1}*ns + i{-1}*ni + d{-1}*nd + r{-1}*nr;
  % Aggregate consumption
  c =# s{-1}*cs + i{-1}*ci + d{-1}*cd + r{-1}*cr;
  % First order condition, consumption susceptibles
  1/cs =# lambdab - lambdatau*pi1*i{-1}*ci;
  % First order condition, consumption infected
  1/ci =# lambdab;
  % First order condition, consumption detected
  1/cd =# lambdab;
  % First order condition, consumption recovered
  1/cr =# lambdab;
  % First order condition, hours susceptibles
  theta*ns =# lambdab*w + lambdatau*pi2*i{-1}*ni;
  % First order condition, hours infected
  theta*ni =# lambdab*w;
  % First order condition, hours detected
  theta*ni =# lambdab*w;
  % First order condition, hours recovered
  theta*nr =# lambdab*w;
  % First order condition, new infected, ie tau
  lambdai = lambdatau + lambdas;
  % First order condition, susceptibles
  log(cs*dcs{+1}) - theta/2*(ns*dns{+1})^2
    + lambdatau*dlambdatau{+1}*( pi1*cs*dcs{+1}*i*ci*dci{+1}+pi2*ns*dns{+1}*i*ni*dni{+1}+pi3*i )
    + lambdab*dlambdab{+1}*( w*dw{+1}*ns*dns{+1}-cs*dcs{+1} )
    - lambdas/beta + lambdas*dlambdas{+1} =# 0;
  % First order condition, infected
  log(ci*dci{+1}) - theta/2*(ni*dni{+1})^2
    + lambdab*dlambdab{+1}*( w*dw{+1}*ni*dni{+1}-ci*dci{+1} )
    - lambdai/beta + lambdai*dlambdai{+1}*(1-piri-pidi-piei) + lambdad*dlambdad{+1}*pidi + lambdar*dlambdar{+1}*piri =# 0;
  % First order condition, detected
  log(cd*dcd{+1}) - theta/2*(nd*dnd{+1})^2
    + lambdab*dlambdab{+1}*( w*dw{+1}*nd*dnd{+1}-cd*dcd{+1} )
    -lambdad/beta + lambdad*dlambdad{+1}*(1-pird-pied) + lambdar*dlambdar{+1}*pird =# 0;
  % First order condition, recovered
  log(cr*dcr{+1})-theta/2*(nr*dnr{+1})^2
    + lambdab*dlambdab{+1}*( w*dw{+1}*nr*dnr{+1}-cr*dcr{+1} )
    - lambdar/beta + lambdar*dlambdar{+1} =# 0;
  % accumulation equations for growth rate varibles
  dcs =# cs/cs{-1};
  dns =# ns/ns{-1};
  dci =# ci/ci{-1};
  dni =# ni/ni{-1};
  dcd =# cd/cd{-1};
  dnd =# nd/nd{-1};
  dcr =# cr/cr{-1};
  dnr =# nr/nr{-1};
  dw =# w/w{-1};
  dlambdas =# lambdas/lambdas{-1};
  dlambdatau =# lambdatau/lambdatau{-1};
  dlambdab =# lambdab/lambdab{-1};
  dlambdai =# lambdai/lambdai{-1};
  dlambdad =# lambdad/lambdad{-1};
  dlambdar =# lambdar/lambdar{-1};

