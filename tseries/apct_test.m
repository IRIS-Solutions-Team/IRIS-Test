
data = exp(cumsum(randn(1000, 4)/10, 1));

%% Test Monthly 

m = tseries(mm(2000, 1), data);
fm = apct(m);
actData = fm.Data;
expData = 100*((data(2:end, :)./data(1:end-1, :)).^12 - 1);
assert(isequal(actData, expData));
actStart = fm.Start;
expStart = mm(2000, 2);
assert(isequal(actStart, expStart));

%% Test Monthly with Lag 

m = tseries(mm(2000, 1), data);
fm = apct(m, -6);
actData = fm.Data;
expData = 100*((data(7:end, :)./data(1:end-6, :)).^2 - 1);
assert(isequal(actData, expData));
actStart = fm.Start;
expStart = mm(2000, 7);
assert(isequal(actStart, expStart));

%% Test Monthly with Lead 

m = tseries(mm(2000, 1), data);
fm = apct(m, +6);
actData = fm.Data;
expData = 100*((data(1:end-6, :)./data(7:end, :)).^2 - 1);
assert(isequal(actData, expData));
actStart = fm.Start;
expStart = mm(2000, 1);
assert(isequal(actStart, expStart));

%% Test Quarterly 

q = tseries(qq(2000, 1), data);
fq = apct(q);
actData = fq.Data;
expData = 100*((data(2:end, :)./data(1:end-1, :)).^4 - 1);
assert(isequal(actData, expData));
actStart = fq.Start;
expStart = qq(2000, 2);
assert(isequal(actStart, expStart));

%% Test Daily 

d = tseries(dd(2000, 1, 1), data);
fd = apct(d);
actData = fd.Data;
expData = 100*((data(2:end, :)./data(1:end-1, :)).^365 - 1);
assert(isequal(actData, expData));
actStart = fd.Start;
expStart = dd(2000, 1, 2);
assert(isequal(actStart, expStart));

