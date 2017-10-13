function Tests = filterTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>

function setupOnce(this)
% load inputs and outputs from the IRIS 8.20100429
tmp = load('filterData.mat');
this.TestData.filtRange = DateWrapper(tmp.filtRange);
this.TestData.filtForeInp = tmp.filtForeInp;
this.TestData.filtHistInp = tmp.filtHistInp;
this.TestData.filtForeOut = tmp.filtForeOut;
this.TestData.filtHistOut = tmp.filtHistOut;

% re-create model object suitable for the tested iris
this.TestData.tmpModFile = [tempname,'.mod'];
tmp = load('model.mat');
char2file(tmp.modText,this.TestData.tmpModFile);
m = model(this.TestData.tmpModFile,'linear',true);
tmp = load('modpar.mat');
params = tmp.par;
m = assign(m,params);
m = solve(m);
this.TestData.model = sstate(m);

% set tolerances
this.TestData.meanSeriesAbsTol = 1e-2;
this.TestData.stdSeriesAbsTol = 1e-3;
this.TestData.doubleAbsTol = 0;
end

function teardownOnce(this)
% remove temporary model file
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