function Tests = iris2010BkwCompatibilityTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>

function setupOnce(this)
% load inputs and outputs from the IRIS 8.20100429
tmp = load ('iris2010.mat');
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
this.TestData.meanSeriesAbsTol = 1e-2;
this.TestData.stdSeriesAbsTol = 1e-3;
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
