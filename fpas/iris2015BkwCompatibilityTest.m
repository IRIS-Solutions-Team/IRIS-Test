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

    % set tolerances
    this.TestData.kalmanAbsTol = 1e-4;
    this.TestData.jforecastMeanAbsTol = 1e-8;
    this.TestData.jforecastMeanAbsTolCond = 1e-6;
    this.TestData.jforecastStdAbsTol = 1e-7;
    this.TestData.doubleAbsTol = 0;
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






