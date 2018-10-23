
%% Yearly

d1 = yy(2010);
d2 = yy(2010, 1);
d3 = numeric.datecode(1, 2010);
d4 = numeric.datecode(1, 2010, 1);
check.equal(d1, d2);
check.equal(d1, d3);
check.equal(d1, d4);

%% Half-Yearly

d1 = hh(2010);
d2 = hh(2010, 1);
d3 = numeric.datecode(2, 2010);
d4 = numeric.datecode(2, 2010, 1);
check.equal(d1, d2);
check.equal(d1, d3);
check.equal(d1, d4);

d1 = hh(2010, 2);
d2 = numeric.datecode(2, 2010, 2);
check.equal(d1, d2);

%% Quarterly

d1 = qq(2010);
d2 = qq(2010, 1);
d3 = numeric.datecode(4, 2010);
d4 = numeric.datecode(4, 2010, 1);
check.equal(d1, d2);
check.equal(d1, d3);
check.equal(d1, d4);

d1 = qq(2010, 3);
d2 = numeric.datecode(4, 2010, 3);
check.equal(d1, d2);

%% Monthly

d1 = mm(2010);
d2 = mm(2010, 1);
d3 = numeric.datecode(12, 2010);
d4 = numeric.datecode(12, 2010, 1);
check.equal(d1, d2);
check.equal(d1, d3);
check.equal(d1, d4);

d1 = mm(2010, 11);
d2 = numeric.datecode(12, 2010, 11);
check.equal(d1, d2);

%% Weekly

d1 = ww(2010);
d2 = ww(2010, 1);
d3 = numeric.datecode(52, 2010);
d4 = numeric.datecode(52, 2010, 1);
check.equal(d1, d2);
check.equal(d1, d3);
check.equal(d1, d4);

d1 = ww(2010, 51);
d2 = numeric.datecode(52, 2010, 51);
check.equal(d1, d2);

