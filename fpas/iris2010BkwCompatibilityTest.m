function Tests = iris2010BkwCompatibilityTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>

function setupOnce(this)

% load inputs and outputs from the IRIS 8.20100429
tmp = load ('iris2010.mat');
tmp2 = load('bvar2010.mat');

this.TestData.filtRange = DateWrapper(tmp.filterData.filtRange);
this.TestData.filtForeInp = tmp.filterData.filtForeInp;
this.TestData.filtHistInp = tmp.filterData.filtHistInp;
this.TestData.filtForeOut = tmp.filterData.filtForeOut;
this.TestData.filtHistOut = tmp.filterData.filtHistOut;

% re-create model object suitable for the tested iris
this.TestData.tmpModFile = [tempname,'.mod'];
char2file(tmp.model.modText,this.TestData.tmpModFile);
m = model(this.TestData.tmpModFile,'linear',true);
params = tmp.par;
m = assign(m,params);
m = solve(m);
this.TestData.model = sstate(m);

% set tolerances
this.TestData.doubleAbsTol = 0;
this.TestData.bvarAbsTol = 1e-7;
this.TestData.meanSeriesAbsTol = 1e-2;
this.TestData.stdSeriesAbsTol = 1e-3;

% set bvar 
this.TestData.db                = tmp2.db;
this.TestData.list_tseries      = tmp2.list_tseries;
this.TestData.var_order         = tmp2.var_order;
this.TestData.var_constraints   = tmp2.var_constraints;
this.TestData.const_constraints = tmp2.const_constraints;
this.TestData.e_list            = tmp2.e_list;
this.TestData.rngEstim          = tmp2.rngEstim;
this.TestData.nObsEstim         = tmp2.nObsEstim;
this.TestData.relstd            = tmp2.relstd;
this.TestData.A                 = tmp2.A;
this.TestData.K                 = tmp2.K;
this.TestData.Omega             = tmp2.Omega;
this.TestData.E                 = tmp2.E;
this.TestData.f_cond            = tmp2.f_cond;
this.TestData.rng_forecast      = tmp2.rng_forecast;

end

function teardownOnce(this)
% remove temporary model files
delete(this.TestData.tmpModFile);
end

function testOgiHistStdev(this)
% get the data
m = this.TestData.model;
filtRange = this.TestData.filtRange;
filtHistInp = this.TestData.filtHistInp;
filtHistOut = this.TestData.filtHistOut;

% run the filter
warnStruct = warning('off','IRIS:Dbase:NameNotExist');
[~,filtHistAct] = filter(m,filtHistInp.db,filtRange,filtHistInp.stddev, ...
  'deviation', false, 'relative', false);
warning(warnStruct.state,'IRIS:Dbase:NameNotExist');

% remove 'ttrend' field -- there was no such field in the old IRIS
filtHistAct.std = rmfield(filtHistAct.std,'ttrend');

% compare series
vList = dbnames(filtHistAct.std,'classFilter','tseries');
assertEqual(this,...
  db2array(filtHistAct.std,vList,filtRange),...
  db2array(filtHistOut.std,vList,filtRange),...
  'AbsTol',this.TestData.stdSeriesAbsTol);

% compare non-tseries
assertEqual(this,...
  rmfield(filtHistAct.std,vList),...
  rmfield(filtHistOut.std,vList),...
  'AbsTol',this.TestData.doubleAbsTol);
end

function testOgiForeMean(this)
% get the data
m = this.TestData.model;
filtRange = this.TestData.filtRange;
filtForeInp = this.TestData.filtForeInp;
filtForeOut = this.TestData.filtForeOut;

% run the filter
warnStruct = warning('off','IRIS:Dbase:NameNotExist');
[~,filtForeAct] = filter(m,filtForeInp.db,filtRange,filtForeInp.stddev, ...
  'deviation', false, 'relative', false);
warning(warnStruct.state,'IRIS:Dbase:NameNotExist');

% remove 'ttrend' field -- there was no such field in the old IRIS
filtForeAct.mean = rmfield(filtForeAct.mean,'ttrend');

% compare series
vList = dbnames(filtForeAct.mean,'classFilter','tseries');
assertEqual(this,...
  db2array(filtForeAct.mean,vList,filtRange),...
  db2array(filtForeOut.mean,vList,filtRange),...
  'AbsTol',this.TestData.meanSeriesAbsTol);

% compare non-tseries
assertEqual(this,...
  rmfield(filtForeAct.mean,vList),...
  rmfield(filtForeOut.mean,vList),...
  'AbsTol',this.TestData.doubleAbsTol);
end

function testOgiNtf(this)


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