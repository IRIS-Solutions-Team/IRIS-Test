
assertEqual = @(x, y) assert(isequal(x, y));

%% Yearly

ac = dat2char(yy(2010));
ex = '2010Y';
assertEqual(ac, ex);

%% Quarterly

ac = dat2char(qq(2010,1));
ex = '2010Q1';
assertEqual(ac, ex);

ac = dat2char(qq(2010,1));
ex = '2010Q1';
assertEqual(ac, ex);

ac = dat2char(qq(2010,1), ...
    'dateFormat=','YYYY-MM-EE');
ex = '2010-01-31';
assertEqual(ac, ex);

ac = dat2char(qq(2010,1), ...
    'dateFormat=','YYYY-MM-WW');
ex = '2010-01-29';
assertEqual(ac, ex);

%% Monthly

ac = dat2char(mm(2010,1));
ex = '2010M01';
assertEqual(ac, ex);

%% Weekly

ac = dat2char(ww(2002,1));
ex = '2002W01';
assertEqual(ac, ex);

ac = dat2char(ww(2002,1), ...
    'dateFormat=','YYYY-MM');
ex = '2002-01';
assertEqual(ac, ex);

ac = dat2char(ww(2002,1), ...
    'dateFormat=','$YYYY-MM-DD');
ex = '2002-01-03';
assertEqual(ac, ex);

%% Daily

ac = dat2char(dd(2002,1,1), ...
    'dateFormat=','$YYYY-Mmm-DD');
ex = '2002-Jan-01';
assertEqual(ac, ex);
