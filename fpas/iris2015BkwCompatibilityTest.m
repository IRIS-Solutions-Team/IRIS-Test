function Tests = iris2015BkwCompatibilityTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>

function setupOnce(this)
    % load inputs and outputs from the IRIS 20151016
    this.TestData.tmpModFile = [tempname,'.mod'];

    % mat file
    tmp = load('iris2015.mat');
    tmp2 = load('favar_2015.mat');
    tmp3 = load('bvar2015.mat');
    tmp4 = load('estimate2015.mat');
    tmp5 = load('sspace2015.mat');

    % reading text of model
    char2file(tmp.model.mod_str,this.TestData.tmpModFile); 

    % creating model object
    m = model(this.TestData.tmpModFile,'linear',true); 

    % assigning loaded paramatrization for input model
    mInp = assign(m,tmp.params_inp.par); 

    % assigning loaded paramatrization for output model
    mOut = assign(m,tmp.params_out.par);

    % transforming equations of input model for Kalman filter 
    mInp = solve(mInp); 

    % transforming equations of output model for Kalman filter 
    mOut = solve(mOut); 

    % computing the steady state and saving resulting model to TestData
    this.TestData.model_kalm_inp = sstate(mInp);  
    this.TestData.model_kalm_out = sstate(mOut);   %mod_filt for jforecast

    % adding data for Kalman filter to TestData
    this.TestData.input_kalman = tmp.input_kalman;  
    this.TestData.output_kalman = tmp.output_kalman.db_filt; 
    
    % adding data for jforecast to TestData
    this.TestData.input_jforecast = tmp.jforecast.db_init;
    this.TestData.output_jforecast = tmp.jforecast.db_fcast_full;
    
    % adding data for conditional jforecast to TestData
    this.TestData.output_jforecast_cond = tmp.db_fcast;
    
    % adding data for simulate to TestData    
    this.TestData.output_simulate = tmp.simulate.db_actual;
    this.TestData.output_simulate_shock = tmp.simulate.db_shockdecomp;
    
    % adding data for FAVAR ti TestData
    this.TestData.comCompEst = tmp2.comCompEst;
    this.TestData.dbEstOutput = tmp2.dbEstOutput;
    this.TestData.dbFcastOutput = tmp2.dbFcastOutput;
    this.TestData.dbInput = tmp2.dbInput;
    this.TestData.endFcast = tmp2.endFcast;
    this.TestData.endHist = tmp2.endHist;
    this.TestData.factorsEst = tmp2.factorsEst;
    this.TestData.favarResidEst = tmp2.favarResidEst;
    this.TestData.startHist = tmp2.startHist;
    this.TestData.varResidEst = tmp2.varResidEst;

    % new IRIS dates are stored in the different class - transformation of the
    % old dates to new
    this.TestData.filtRange = DateWrapper(this.TestData.input_kalman.rng_filt);
    this.TestData.fcastRange = DateWrapper(tmp.jforecast.rng_fcast);

    % remove redundand ranges from inputs
    this.TestData.input_kalman = rmfield(this.TestData.input_kalman,'rng_filt');
    % set bvar 
    this.TestData.db                = tmp3.db;
    this.TestData.list_tseries      = tmp3.list_tseries;
    this.TestData.var_order         = tmp3.var_order;
    this.TestData.var_constraints   = tmp3.var_constraints;
    this.TestData.const_constraints = tmp3.const_constraints;
    this.TestData.rngEstim          = tmp3.rngEstim;
    this.TestData.nObsEstim         = tmp3.nObsEstim;
    this.TestData.relstd            = tmp3.relstd;
    this.TestData.A                 = tmp3.A;
    this.TestData.K                 = tmp3.K;
    this.TestData.Omega             = tmp3.Omega;
    this.TestData.E                 = tmp3.E;
    this.TestData.f_cond            = tmp3.f_cond;
    this.TestData.rng_forecast      = tmp3.rng_forecast;
    % set estimate
    this.TestData.estimate = tmp4.p_est;
    % save state-space matrices
    this.TestData.sspace = tmp5;
    % set tolerances
    this.TestData.bvarAbsTol = 1e-7;
    this.TestData.meanSeriesAbsTol = 1e-6;
    this.TestData.kalmanAbsTol = 1e-4;
    this.TestData.jforecastMeanAbsTol = 1e-8;
    this.TestData.jforecastMeanAbsTolCond = 1e-6;
    this.TestData.jforecastStdAbsTol = 1e-7;
    this.TestData.doubleAbsTol = 0;
    this.TestData.simulateAbsTol = 1e-6;
    this.TestData.estimateAbsTol = 1e-3;
    this.TestData.sspaceAbsTol = 1e-12;
end

function teardownOnce(this)
    % remove temporary model files
    delete(this.TestData.tmpModFile);
end

function testKalman(this)
    % getting input and expected data from TestData  
    mInput = this.TestData.model_kalm_inp;
    mOutput = this.TestData.model_kalm_out;
    filtRange = this.TestData.filtRange;
    input_kalman = this.TestData.input_kalman;
    db_expected = this.TestData.output_kalman;

    % run the filter to get actual data
    warnStruct = warning('off','IRIS:Dbase:NameNotExist'); 
    %keyboard
    [mod_actual,db_actual] = filter(mInput, input_kalman.tunedb, filtRange, 'deviation', false,... 
      'std', input_kalman.dbstd, 'relative', false);
    warning(warnStruct.state,'IRIS:Dbase:NameNotExist');

    % remove the fields which didn't exist in the old Iris
    db_actual = rmfield(db_actual,'mse');
    db_actual.mean = rmfield(db_actual.mean,'ttrend');
    db_actual.std = rmfield(db_actual.std,'ttrend');
    stdNameList = fieldnames(get(mInput,'std'));
    db_actual.mean = rmfield(db_actual.mean,stdNameList);
    db_actual.std = rmfield(db_actual.std,stdNameList);

    % compare actual and expected data
    assertEqual(this, mod_actual, mOutput);
    vList = dbnames(db_actual.mean,'classFilter','tseries');
    assertEqual(this, db2array(db_actual.mean,vList,filtRange),...
      db2array(db_expected.mean,vList,filtRange),...
      'AbsTol',this.TestData.kalmanAbsTol);
    assertEqual(this, rmfield(db_actual.mean,vList),...
      rmfield(db_expected.mean,vList),...
      'AbsTol',this.TestData.kalmanAbsTol);
    vList = dbnames(db_actual.std,'classFilter','tseries');
    assertEqual(this, db2array(db_actual.std,vList,filtRange),...
      db2array(db_expected.std,vList,filtRange),...
      'AbsTol',this.TestData.kalmanAbsTol);
    assertEqual(this, rmfield(db_actual.std,vList),...
      rmfield(db_expected.std,vList),...
      'AbsTol',this.TestData.kalmanAbsTol);
end

function testJforecast(this)
    % getting input and expected data from TestData
    mInput = this.TestData.model_kalm_out;
    mInput.std_shock_dl_cpi_disc = 0;
    mInput.std_shock_pie_tar = 0;
    mInput.std_shock_debt_lin_approx = 0;
    fcastRange = this.TestData.fcastRange;
    db_init = this.TestData.input_jforecast;
    db_expected = this.TestData.output_jforecast;

    % create empty plan of the forecast
    p = plan(mInput, fcastRange);

    % add tunes
    %- "external sector" tunes
    list_var_plan  = {'l_y_gap_f','l_cpi_f','rn_f','rr_tnd_f','l_oil',...
    'l_roil_tnd','l_food','l_rfood_tnd'};
    list_shck_plan = {'shock_l_y_gap_f','shock_dl_cpi_f','shock_rn_f',...
    'shock_rr_tnd_f','shock_l_roil_gap','shock_dl_roil_tnd',...
    'shock_l_rfood_gap','shock_dl_rfood_tnd'};
    p = exogenize(p, list_var_plan, fcastRange);
    p = endogenize(p, list_shck_plan, fcastRange);
    %- "domestic" tunes
    p = exogenize(p,'pie_tar',fcastRange);
    p = endogenize(p,'shock_pie_tar',fcastRange);
    p = exogenize(p,'dl_y',qq(2017,3));
    p = endogenize(p,'shock_l_y_non_agr_gap',qq(2017,3));
    p = exogenize(p,'l_y_observed',qq(2017,3));
    p = endogenize(p,'shock_obs_l_y',qq(2017,3));

    % run forecast
    db_actual = jforecast(mInput, db_init, fcastRange, 'plan', p,...
      'anticipate', true, 'initcond', 'fixed'); % fix intital condition for mean trajectory

    % remove the fields which didn't exist in the old Iris
    db_actual.mean = rmfield(db_actual.mean,'ttrend');
    db_actual.std = rmfield(db_actual.std,'ttrend');
    stdNameList = fieldnames(get(mInput,'std'));
    db_actual.mean = rmfield(db_actual.mean,stdNameList);
    db_actual.std = rmfield(db_actual.std,stdNameList);

    % compare actual and expected data
    vList = dbnames(db_actual.mean,'classFilter','tseries');
    %- all tseries from .mean
    assertEqual(this, db2array(db_actual.mean,vList,fcastRange),...
      db2array(db_expected.mean,vList,fcastRange),...
      'AbsTol',this.TestData.jforecastMeanAbsTol);
    %- all non-tseries from .mean
    assertEqual(this, rmfield(db_actual.mean,vList),...
      rmfield(db_expected.mean,vList),...
      'AbsTol',this.TestData.doubleAbsTol);
    vList = dbnames(db_actual.std,'classFilter','tseries');
    % {
    %- all tseries from .std
    assertEqual(this, db2array(db_actual.std,vList,fcastRange),...
      db2array(db_expected.std,vList,fcastRange),...
      'AbsTol',this.TestData.jforecastStdAbsTol);
    %- all non-tseries from .std
    assertEqual(this, rmfield(db_actual.std,vList),...
      rmfield(db_expected.std,vList),...
      'AbsTol',this.TestData.doubleAbsTol);
    %}
end

function testJforecast_condition(this)
    % getting input and expected data from TestData
    mInput = this.TestData.model_kalm_out;
    mInput.std_shock_dl_cpi_disc = 0;
    mInput.std_shock_pie_tar = 0;
    mInput.std_shock_debt_lin_approx = 0;
    fcastRange = this.TestData.fcastRange;
    db_init = this.TestData.input_jforecast;
    db_expected = this.TestData.output_jforecast_cond;

    % create empty plan of the forecast
    p = plan(mInput, fcastRange);

    % add tunes
    %- "external sector" tunes
    list_var_plan  = {'l_y_gap_f','l_cpi_f','rn_f','rr_tnd_f','l_oil',...
    'l_roil_tnd','l_food','l_rfood_tnd'};
    list_shck_plan = {'shock_l_y_gap_f','shock_dl_cpi_f','shock_rn_f',...
    'shock_rr_tnd_f','shock_l_roil_gap','shock_dl_roil_tnd',...
    'shock_l_rfood_gap','shock_dl_rfood_tnd'};
    p = exogenize(p, list_var_plan, fcastRange);
    p = endogenize(p, list_shck_plan, fcastRange);
    %- "domestic" tunes
    p = exogenize(p,'pie_tar',fcastRange);
    p = endogenize(p,'shock_pie_tar',fcastRange);
    p = exogenize(p,'dl_y',qq(2017,3));
    p = endogenize(p,'shock_l_y_non_agr_gap',qq(2017,3));
    p = exogenize(p,'l_y_observed',qq(2017,3));
    p = endogenize(p,'shock_obs_l_y',qq(2017,3));

    % run forecast baseline
    db_actual = jforecast(mInput, db_init, fcastRange, 'plan', p,...
      'anticipate', true, 'initcond', 'fixed'); % fix intital condition for mean trajectory
  
    db_init = db_actual;
    p = plan(mInput, fcastRange);
   
    db_init.mean.l_z_gap(qq(2018,2)) = 0;
    p = condition(p,{'l_z_gap'},qq(2018,2));
    
    db_actual = jforecast(mInput, db_init, fcastRange, 'plan', p,...
      'anticipate', true, 'initcond', 'fixed'); % fix intital condition for mean trajectory

    % remove the fields which didn't exist in the old Iris
    db_actual.mean = rmfield(db_actual.mean,'ttrend');
    db_actual.std = rmfield(db_actual.std,'ttrend');
    stdNameList = fieldnames(get(mInput,'std'));
    db_actual.mean = rmfield(db_actual.mean,stdNameList);
    db_actual.std = rmfield(db_actual.std,stdNameList);
    
    % compare actual and expected data
    vList = dbnames(db_actual.mean,'classFilter','tseries');
    %- all tseries from .mean
    assertEqual(this, db2array(db_actual.mean,vList,fcastRange),...
      db2array(db_expected.mean,vList,fcastRange),...
      'AbsTol',this.TestData.jforecastMeanAbsTolCond);
    %- all non-tseries from .mean
    assertEqual(this, rmfield(db_actual.mean,vList),...
      rmfield(db_expected.mean,vList),...
      'AbsTol',this.TestData.doubleAbsTol);
    vList = dbnames(db_actual.std,'classFilter','tseries');
    % {
    %- all tseries from .std
    assertEqual(this, db2array(db_actual.std,vList,fcastRange),...
      db2array(db_expected.std,vList,fcastRange),...
      'AbsTol',this.TestData.jforecastStdAbsTol);
    %- all non-tseries from .std
    assertEqual(this, rmfield(db_actual.std,vList),...
      rmfield(db_expected.std,vList),...
      'AbsTol',this.TestData.doubleAbsTol);
    %}
end

function testSimulate(this)
    % getting input and expected data from TestData
    mInput = this.TestData.model_kalm_out;
    mInput.std_shock_dl_cpi_disc = 0;
    mInput.std_shock_pie_tar = 0;
    mInput.std_shock_debt_lin_approx = 0;
    fcastRange = this.TestData.fcastRange;
    db_init = this.TestData.input_jforecast;
    db_expected = this.TestData.output_simulate;
    db_expected_shockdecomp = this.TestData.output_simulate_shock;

    % create empty plan of the forecast
    p = plan(mInput, fcastRange);

    % add tunes
    %- "external sector" tunes
    list_var_plan  = {'l_y_gap_f','l_cpi_f','rn_f','rr_tnd_f','l_oil',...
    'l_roil_tnd','l_food','l_rfood_tnd'};
    list_shck_plan = {'shock_l_y_gap_f','shock_dl_cpi_f','shock_rn_f',...
    'shock_rr_tnd_f','shock_l_roil_gap','shock_dl_roil_tnd',...
    'shock_l_rfood_gap','shock_dl_rfood_tnd'};
    p = exogenize(p, list_var_plan, fcastRange);
    p = endogenize(p, list_shck_plan, fcastRange);
    %- "domestic" tunes
    p = exogenize(p,'pie_tar',fcastRange);
    p = endogenize(p,'shock_pie_tar',fcastRange);
    p = exogenize(p,'dl_y',qq(2017,3));
    p = endogenize(p,'shock_l_y_non_agr_gap',qq(2017,3));
    p = exogenize(p,'l_y_observed',qq(2017,3));
    p = endogenize(p,'shock_obs_l_y',qq(2017,3));

    % run simulate wiht plan
    db_actual = simulate(mInput, db_init, fcastRange, 'plan', p,...
      'anticipate', true);
  
    % run forecast for shock_decomp
    db_actual_orig = jforecast(mInput, db_init, fcastRange, 'plan', p,...
      'anticipate', true, 'initcond', 'fixed');
  
    % run shockdecomp
    db_shockdecomp = simulate(mInput, db_actual_orig.mean, fcastRange,...
       'deviation',false,'contributions',true);

    % remove the fields which didn't exist in the old Iris
    db_actual = rmfield(db_actual,'ttrend');
    
    % compare actual and expected data
    vList = dbnames(db_actual,'classFilter','tseries');
    %- all tseries
    assertEqual(this, db2array(db_actual,vList,fcastRange),...
      db2array(db_expected,vList,fcastRange),...
      'AbsTol',this.TestData.simulateAbsTol);
  
  % compare shock decomp
    db_shockdecomp = rmfield(db_shockdecomp,'ttrend');
    vList = dbnames(db_shockdecomp,'classFilter','tseries');
    
    assertEqual(this, db2array(db_shockdecomp,vList,fcastRange),...
      db2array(db_expected_shockdecomp,vList,fcastRange),...
      'AbsTol',this.TestData.simulateAbsTol);

end

function testBVAR(this)


dummyobs = BVAR.litterman(0,sqrt(this.TestData.nObsEstim)*this.TestData.relstd,1);
w=VAR(this.TestData.list_tseries);
[w,data] = estimate(w,this.TestData.db,this.TestData.rngEstim,'order',this.TestData.var_order,...
    'covParameters',true,'A',this.TestData.var_constraints,'C',this.TestData.const_constraints,'bvar',dummyobs);

f_cond=forecast(w,this.TestData.db,this.TestData.rng_forecast,this.TestData.db,'meanOnly',true);
% for test
E = eig(w);
A = get(w,'A*');
K = get(w,'K');
Omega = get(w,'Omega');

% compare estimate results
assertEqual(this,...
  this.TestData.A,...
  A,...
  'AbsTol',this.TestData.bvarAbsTol);

assertEqual(this,...
  this.TestData.K,...
  K,...
  'AbsTol',this.TestData.bvarAbsTol);

assertEqual(this,...
  sort(this.TestData.E),...
  sort(E),...
  'AbsTol',this.TestData.bvarAbsTol);

assertEqual(this,...
  this.TestData.Omega,...
  Omega,...
  'AbsTol',this.TestData.bvarAbsTol);

% compare series
vList = dbnames(f_cond,'classFilter','tseries');
assertEqual(this,...
  db2array(this.TestData.f_cond,vList,this.TestData.rng_forecast),...
  db2array(f_cond,vList,this.TestData.rng_forecast),...
  'AbsTol',this.TestData.meanSeriesAbsTol);

end

function testFAVAR(this)
% estimate FAVAR model
variables2include = fieldnames(this.TestData.dbInput);

f = FAVAR(variables2include);

[fEst,dbEstOutput,comCompEst,factorsEst,varResidEst,favarResidEst,CTF,estimRng] = ...
  estimate(f,this.TestData.dbInput,this.TestData.startHist:this.TestData.endHist,[1,3],'order',1);

% forecast with FAVAR model
[fFcast,dbFcastOutput,comCompFcast,factorsFcast] = filter(fEst,dbEstOutput,...
  this.TestData.startHist:this.TestData.endFcast);

% testing estimate results
    assertEqual(this, (this.TestData.factorsEst(:)),...
      (factorsEst(:)),...
      'AbsTol',this.TestData.jforecastMeanAbsTolCond);
  
% testing estimate results II.
    assertEqual(this, (this.TestData.favarResidEst(:)),...
      (favarResidEst(:)),...
      'AbsTol',this.TestData.jforecastMeanAbsTolCond);
  
% testin FAVAR forecast
    vList = dbnames(dbFcastOutput.mean,'classFilter','tseries');
    assertEqual(this, db2array(dbFcastOutput.mean,vList,this.TestData.startHist:this.TestData.endFcast),...
      db2array(this.TestData.dbFcastOutput.mean,vList,this.TestData.startHist:this.TestData.endFcast),...
      'AbsTol',this.TestData.jforecastMeanAbsTolCond);

end

function testEstimate(this)
% loading inputs from filter results
mInput = this.TestData.model_kalm_out;
rng_filt = this.TestData.filtRange;
rng_fcast = this.TestData.fcastRange;
% estimation range
startHist = rng_filt(1);
endHist = rng_fcast(1)-1;

db_obs = this.TestData.input_kalman;

% setting priors
priors = struct();

priors.c1_l_y_non_agr_gap = {nan,0.1,0.9,logdist.beta(mInput.c1_l_y_non_agr_gap,0.05)};
priors.c1_rn = {nan,0.2,0.99,logdist.normal(mInput.c1_rn,0.01)};
priors.w_rn_rule = {nan,0.1,0.99,logdist.normal(mInput.w_rn_rule,0.03)};
priors.c1_dl_cpi_core = {nan,0.1,0.99,logdist.beta(mInput.c1_dl_cpi_core,0.02)};
% running optimization function
  opts = optimset('MaxIter',15000,'MaxFunEvals',15000,'tolFun',1e-1,...
    'display','iter');
  optimizer = @(F,P0,PLow,PHigh,OptimSet) ...
                   fminsearch(@(X) F(X)+chkbnd(X,PLow,PHigh),P0,opts);              
% running estimation               
warnStruct = warning('off','IRIS:Dbase:NameNotExist');
[p_est,~,~,~,mod_est] = estimate(mInput,db_obs.tunedb,DateWrapper(startHist:endHist),priors,[],...
  'initVal=','model',...
  'noSolution=','penalty',...
  'tolFun=',1e-8,...
  'tolX=',1e-8,...
  'maxFunEvals=',10000,...
  'maxIter=',1000,...
  'filter=',{'relative',false,'std',db_obs.dbstd},...
  'solver',optimizer);
warning(warnStruct.state,'IRIS:Dbase:NameNotExist');

% testing estimate results
    assertEqual(this, struct2cell(this.TestData.estimate),...
      struct2cell(p_est),...
      'AbsTol',this.TestData.estimateAbsTol);

[p_est1,~,~,~,mod_est1] = estimate(mInput,db_obs.tunedb,DateWrapper(startHist:endHist),priors,[],...
  'initVal=','model',...
  'noSolution=','penalty',...
  'filter=',{'relative',false,'std',db_obs.dbstd},...
  'solver',{'fminsearch', 'TolFun', 1e-8, 'TolX', 1e-8, 'MaxFunEvals', 10000, 'MaxIter', 1000});

assertEqual(this, struct2cell(this.TestData.estimate),...
  struct2cell(p_est1),...
  'AbsTol',this.TestData.estimateAbsTol);
end

function testSolve(this)
sspaceExpected = this.TestData.sspace;
[tActual,rActual,kActual,zActual,hActual,dActual,uActual,omgActual] = ...
  sspace(this.TestData.model_kalm_inp,'triangular',false);

assertEqual(this,tActual,sspaceExpected.T,...
  'AbsTol',this.TestData.sspaceAbsTol);
assertEqual(this,rActual,sspaceExpected.R,...
  'AbsTol',this.TestData.sspaceAbsTol);
assertEqual(this,kActual,sspaceExpected.K,...
  'AbsTol',this.TestData.sspaceAbsTol);
assertEqual(this,zActual,sspaceExpected.Z,...
  'AbsTol',this.TestData.sspaceAbsTol);
assertEqual(this,hActual,sspaceExpected.H,...
  'AbsTol',this.TestData.sspaceAbsTol);
assertEqual(this,dActual,sspaceExpected.D,...
  'AbsTol',this.TestData.sspaceAbsTol);
assertEqual(this,uActual,sspaceExpected.U,...
  'AbsTol',this.TestData.sspaceAbsTol);
assertEqual(this,omgActual,sspaceExpected.Omg,...
  'AbsTol',this.TestData.sspaceAbsTol);
end

function res = chkbnd(x,low,high)

if any(x < low) || any(x > high)
  res = inf;
else
  res = 0;
end
end
