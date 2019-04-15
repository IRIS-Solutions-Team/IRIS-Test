
assertEqual = @(x, y) assert(isequal(x, y));
listRoman = {'i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii', 'viii', 'ix', 'x', 'xi', 'xii'};

%% Monthly

ac = str2dat('01-2010', ...
    'DateFormat=', 'MM-YYYY', 'Freq=', 12);
ex = mm(2010, 1);
assertEqual(ac, ex);

%% Quarterly

ac = str2dat('01-2010', ...
    'DateFormat=', 'MM-YYYY', 'Freq=', 4);
ex = qq(2010, 1); 
assertEqual(ac, ex);

%% Monthly

ac = dat2char(str2dat('01-2010', ...
    'DateFormat=', 'MM-YYYY', 'Freq=', 1));
ex = '2010Y';
assertEqual(ac, ex);

%% Daily

ac = str2dat('2001-12-31', ...
    'DateFormat=', '$YYYY-MM-DD', 'Freq=', 52);
ex = ww(2002, 1);
assertEqual(ac, ex);

%% Monthly from List of Months

lsMonth = iris.get('months');
for i = 1 : 12
    m = lsMonth{i}(1:3);
    
    % Monthly frequency.
    ac = str2dat(['01-', m, '-2010'], ...
        'DateFormat=', 'DD-Mmm-YYYY', 'Freq=', 12);
    ex = mm(2010, i);
    assertEqual(ac, ex);
end

%% Daily from List of Months

lsMonth = iris.get('months');
for i = 1 : 12
    m = lsMonth{i}(1:3);

    % Daily frequency.
    ac = str2dat(['12-', m, '-2010'], ...
        'DateFormat=', '$DD-Mmm-YYYY');
    ex = dd(2010, i, 12);
    assertEqual(ac, ex);
end

%% Monthly from Roman Month 

for i = 1 : 12
    string = [listRoman{i}, '-2000'];
    actual = str2dat(string, 'DateFormat=', 'Q-YYYY', 'EnforceFrequency=', 12);
    expected = mm(2000, i);
    assertEqual(actual, expected);
end

%% Quarterly from Roman Month 

for i = 1 : 12
    string = [listRoman{i}, '-2000'];
    actual = str2dat(string, 'DateFormat=', 'Q-YYYY', 'EnforceFrequency=', 4);
    expected = qq(2000, ceil(i/3));
    assertEqual(actual, expected);
end

%% Quarterly from Roman Period 

for i = 1 : 12
    string = [listRoman{i}, '-2000'];
    actual = str2dat(string, 'DateFormat=', 'R-YYYY', 'EnforceFrequency=', 4);
    expected = qq(2000, i);
    assertEqual(actual, expected);
end


%% Yearly

actual = str2dat('2020Y');
expected = yy(2020);
assertEqual(actual, expected);

actual = str2dat('2020Y', 'DateFormat=', 'YYYYF');
expected = yy(2020);
assertEqual(actual, expected);


%% Yearly Year Only

actual = str2dat('2020', 'DateFormat=', 'YYYY');
expected = yy(2020);
assertEqual(actual, expected);

