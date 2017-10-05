
assertEqual = @(x, y) assert(isequal(x, y));

%**************************************************************************
% Basic

d = dbload('dbloadTest1.csv');

lsf = fieldnames(d);
assertEqual(sort(lsf), {'X'; 'Y'; 'Z'});
for i = 1 : numel(lsf)
    name = lsf{i};
    x = d.(name);
    assertEqual(startDate(x), qq(2001,1));
    assertEqual(endDate(x), qq(2004,4));
    assertEqual(x.Data, (1:16).'*10^(i-1));
end

%**************************************************************************
% Option DateFormat=

d = dbload('dbloadTest2.csv', 'DateFormat=', 'YYYY/M/1', 'Freq=', 4);

lsf = fieldnames(d);
assertEqual(sort(lsf), {'X'; 'Y'; 'Z'});
for i = 1 : numel(lsf)
    name = lsf{i};
    x = d.(name);
    assertEqual(startDate(x), qq(2001,1));
    assertEqual(endDate(x), qq(2004,4));
end

d = dbload('dbloadTest2.csv', 'DateFormat=', 'YYYY/M/1', 'Freq=', 12);

lsf = fieldnames(d);
assertEqual(sort(lsf), {'X'; 'Y'; 'Z'});
for i = 1 : numel(lsf)
    name = lsf{i};
    x = d.(name);
    assertEqual(startDate(x), mm(2001, 1));
    assertEqual(endDate(x), mm(2004, 10));
end

%**************************************************************************
% Option Case=

d = dbload('dbloadTest1.csv', 'Case=', 'lower');
assertEqual(sort(fieldnames(d)), {'x'; 'y'; 'z'});
