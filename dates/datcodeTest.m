
assertEqual = @(x, y) assert(isequal(x, y));

%% Yearly

d1 = yy(2010);
d2 = yy(2010, 1);
d3 = datcode(1, 2010);
d4 = datcode(1, 2010, 1);
assertEqual(d1, d2);
assertEqual(d1, d3);
assertEqual(d1, d4);

%% Half-Yearly

d1 = hh(2010);
d2 = hh(2010, 1);
d3 = datcode(2, 2010);
d4 = datcode(2, 2010, 1);
assertEqual(d1, d2);
assertEqual(d1, d3);
assertEqual(d1, d4);

d1 = hh(2010, 2);
d2 = datcode(2, 2010, 2);
assertEqual(d1, d2);

%% Quarterly

d1 = qq(2010);
d2 = qq(2010, 1);
d3 = datcode(4, 2010);
d4 = datcode(4, 2010, 1);
assertEqual(d1, d2);
assertEqual(d1, d3);
assertEqual(d1, d4);

d1 = qq(2010, 3);
d2 = datcode(4, 2010, 3);
assertEqual(d1, d2);

%% Bimonthly

d1 = bb(2010);
d2 = bb(2010, 1);
d3 = datcode(6, 2010);
d4 = datcode(6, 2010, 1);
assertEqual(d1, d2);
assertEqual(d1, d3);
assertEqual(d1, d4);

d1 = bb(2010, 5);
d2 = datcode(6, 2010, 5);
assertEqual(d1, d2);

%% Monthly

d1 = mm(2010);
d2 = mm(2010, 1);
d3 = datcode(12, 2010);
d4 = datcode(12, 2010, 1);
assertEqual(d1, d2);
assertEqual(d1, d3);
assertEqual(d1, d4);

d1 = mm(2010, 11);
d2 = datcode(12, 2010, 11);
assertEqual(d1, d2);

%% Weekly

d1 = ww(2010);
d2 = ww(2010, 1);
d3 = datcode(52, 2010);
d4 = datcode(52, 2010, 1);
assertEqual(d1, d2);
assertEqual(d1, d3);
assertEqual(d1, d4);

d1 = ww(2010, 51);
d2 = datcode(52, 2010, 51);
assertEqual(d1, d2);
