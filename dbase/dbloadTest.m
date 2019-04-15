
assertEqual = @(x, y) assert(isequal(x, y));

%% Basic

d = dbload('dbloadTest1.csv');

lsf = fieldnames(d);
assertEqual(sort(lsf), {'X'; 'Y'; 'Z'});
for i = 1 : numel(lsf)
    name = lsf{i};
    x = d.(name);
    assertEqual(x.Start, qq(2001,1));
    assertEqual(x.End, qq(2004,4));
    assertEqual(x.Data, (1:16).'*10^(i-1));
end

%% Option DateFormat=

d = dbload('dbloadTest2.csv', 'DateFormat=', 'YYYY/M/1', 'Freq=', 4);

lsf = fieldnames(d);
assertEqual(sort(lsf), {'X'; 'Y'; 'Z'});
for i = 1 : numel(lsf)
    name = lsf{i};
    x = d.(name);
    assertEqual(x.Start, qq(2001,1));
    assertEqual(x.End, qq(2004,4));
end

d = dbload('dbloadTest2.csv', 'DateFormat=', 'YYYY/M/1', 'Freq=', 12);

lsf = fieldnames(d);
assertEqual(sort(lsf), {'X'; 'Y'; 'Z'});
for i = 1 : numel(lsf)
    name = lsf{i};
    x = d.(name);
    assertEqual(x.Start, mm(2001, 1));
    assertEqual(x.End, mm(2004, 10));
end

%% Option Case=

d = dbload('dbloadTest1.csv', 'Case=', 'lower');
assertEqual(sort(fieldnames(d)), {'x'; 'y'; 'z'});


%% Yearly Dates YYYY

actual = dbload('dbloadTest3.csv', 'DateFormat=', 'YYYY');
expected = struct( 'ts1', Series(yy(2008), [1;1]), ...
                   'ts2', Series(yy(2008), [2;2]) );
assertEqual(actual, expected);


