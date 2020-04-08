
% Create Model Object from text file

m = Model('pam_albania.model', 'Linear', false);

% Set initial parameter values

m.beta    = 0.98; % discount factor
m.sigma   = 1.00; % inter-temporal elasticity of sustitution (1/sigma)
m.chi     = 0.00; % habit persistence
m.psi     = 0.00; % DLI in consumption
m.eta     = 0.00; % elasticity of labor supply to the real wage
m.theta   = 1.00; % labor supply scale parameter
m.nu      = 0.001; % net worth slope 
m.nu0     = 0.5;  % net worth intercept

m.gammaNd = 0.3; % labor intensity of production
m.gammaKd = 0.3; % capital intensity of production
m.nd      = 0.3; % share of fixed labor  

m.gammaNx = 0.5; % labor intensity of production
m.gammaKx = 0.3; % capital intensity of production
m.nx      = 0.3; % share of fixed labor

m.delta =  0.065;  % depreciation of capital

m.mu  =  1.1;    % mark-up parameter
m.mux =  1.2;    % mark-up parameter

m.zeta1 = 0.1; % premium reaction to external position 
m.zeta0 = 0.1; % intercept

m.xiId    = 2; % investment adjustment cost
m.phid    = 1; % weight of investment/capital in adjustment cost
m.xiNdMd  = 5;    % labor/import adjustment cost

m.xiIx    = 2; % investment adjustment cost
m.phix    = 1; % weight of investment/capital in adjustment cost
m.xiNxMx  = 5; % labor/import adjustment cost
m.xiYx    = 1; % export production adjustment cost

m.xiP     = 10.00;   % price adjustment cost

m.ss_dP        =  1.03;  % inflation target
m.rho_Rg       =  0.5;   % interest rate smoothing
m.kappa_dP     =  2.5;   % weight to inflation in MP rule
m.rho_Rg_bar   =  0.8;   % neutral rate peristence

m.ss_Bg_NGDP  = 0.45;  % target of debt to output ratio
m.rho_B       = 0.98;  % persistence of gov. debt (fiscal rule)

m.rho_PG_NGDP  =  0.50;  % persistence of gov. spendings

m.ss_PG_NGDP    =  0.111; % gov. spending to GDP
m.ss_tauL       =  0.10;  % income tax rate
m.ss_tauC       =  0.20;  % VAT rate
m.ss_tauPIE     =  0.01;  % profit tax rate
m.ss_TAXls_NGDP =  0.0;   % lump sum tax ratio
m.ss_WG_NGDP    =  0.058; % gov. wage ratio

m.sw_TAXls_NGDP = 1;
m.sw_PG_NGDP    = 0;
m.sw_WG_NGDP    = 0;
m.sw_tauL       = 0;
m.sw_tauC       = 0;
m.sw_tauPIE     = 0;

m.rho_W   =  0.6;   % persistence in Real Wage

m.ss_dA   =  1.035; % productivity growth
m.rho_dA  =  0.5;   % persistence of productvity growth shock

m.ss_Ax   =  1;     % productivity growth
m.rho_Ax  =  0.5;        % persistence Relative Export-Specific Productivity shock

m.ss_dPw_star   =  1.02;  % foreign inflation
m.ss_Rw_star    =  1.02;  % foreign nominal interest rate
m.rho_Rw_star   =  0.70;  % persistence of foreign variables
m.rho_dPw_star  =  0.70;  % persistence of foreign variables

% Calculate initial steady state

m.A       = 1 + 1i*m.ss_dA;         % we set as "1" for simplicity
m.Pw_star = 1 + 1i*m.ss_dPw_star;   % we set as "1" for simplicity

m.V_A_nu0       = 0;

endoExoList = {
  'nu0'       'V_A_nu0'
  };

ssOptions = {
  'Growth=',     true, ...
  'Solver=',     {'IRIS-Qnsd', 'SpecifyObjectiveGradient=', false, 'Display=', false}, ...
  'Fix=',        {'A', 'Pw_star'}, ...
  'Endogenize=', endoExoList(:,1), ...
  'Exogenize=',  endoExoList(:,2) ...
  };

m.check1 = 0;
m = steady(m, ssOptions{:});
checkSteady(m);
m = solve(m);
m0 = m;

% Set target steady state values

m.RRg           = 1.04; % temporary higher real rate (in this version we have fixed RER, no apppreciation)
m.PM_NGDP       = 0.45; % average of import to GDP (from data)
%m.WN_NGDP       = 0.40;  % share of wages on GDP (estimation)
m.PRkK_NGDP     = 0.237;
m.Bh_fcy_NGDP   = 0;
m.TAXL_NGDP     = 0.074;
m.TAXC_NGDP     = 0.085;
m.TAXPIE_NGDP   = 0.0185;
m.N             = 1;

endoExoList = {
  'nu0'       'V_A_nu0'
  'beta'      'RRg'
  'zeta0'     'Bh_fcy_NGDP'
  'gammaNd'   'PM_NGDP'
  'mu'        'WN_NGDP'
  'gammaKd'   'PRkK_NGDP'
  'ss_tauL'   'TAXL_NGDP'
  'ss_tauC'   'TAXC_NGDP'
  'ss_tauPIE' 'TAXPIE_NGDP'
  'theta'     'N'
  };

% Calculate the steady state

% Calculation options
ssOptions = {
  'Growth=',     true, ...
  'Solver=',     {'IRIS-Qnsd', 'SpecifyObjectiveGradient=', false, 'Display=', false}, ...
  'Fix=',        {'A', 'Pw_star'}, ...
  'Endogenize=', endoExoList(:,1), ...
  'Exogenize=',  endoExoList(:,2) ...
  };

m = steady(m, ssOptions{:});
checkSteady(m);
m = solve(m);

% Make sure that the exogenous equation for net transfers is consistent
% with the calculated steady-state
m.TAXls_NGDP_exog = real(m.TAXls_NGDP);
m.ss_TAXls_NGDP   = real(m.TAXls_NGDP);

% Set further parameters by divide-and-conquer (when necessary)

% Number of steps
N = 1;

% Target parameter values
p.chi = 0.3;
p.psi = 0.3;
p.mux = 1.4;

pNames  = fieldnames(p);
pNum    = length(pNames);

for i = 1:pNum
  p.(pNames{i}) = linspace(m.(pNames{i}), p.(pNames{i}), N);
end

for n = 1:N
  for i = 1:pNum
    m.(pNames{i}) = p.(pNames{i})(n);
  end
  m = steady(m, ssOptions{:});
end

checkSteady(m);
m = solve(m);

