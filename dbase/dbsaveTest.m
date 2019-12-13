
% Set up

this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% dbsave mixing Series and numeric scalars

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), @rand);
d.a = 2;

dbsave(d, 'dbsaveTest1.csv');
dd = dbload('dbsaveTest1.csv');

assertEqualStructs(this, d, dd);


%% dbsave mixing Series and 1-N-N numeric arrays

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), @rand);
d.a = rand(1, 5, 10);

dbsave(d, 'dbsaveTest2.csv');
dd = dbload('dbsaveTest2.csv');

assertEqualStructs(this, d, dd);


%% dbsave mixing Series and N-N-N numeric arrays

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), @rand);
d.a = rand(100, 5, 10);

dbsave(d, 'dbsaveTest3.csv');
dd = dbload('dbsaveTest3.csv');

assertEqualStructs(this, d, dd);


%% dbsave mixing ND Series and 1-N-N numeric arrays

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), rand(20, 3, 5, 6));
d.y = Series(qq(2001, 1):qq(2005, 4), rand(20, 1, 2));
d.a = rand(33, 5, 10);

dbsave(d, 'dbsaveTest4.csv');
dd = dbload('dbsaveTest4.csv');

assertEqualStructs(this, d, dd);


%% dbsave with userdata field

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), rand(20, 3, 5, 6));
d.x = userdata(d.x, {1, 2, 'C'});
d.userdata = struct('A', 1, 'B', 'XXX', 'C', {{1, 2, 3}});

dbsave(d, 'dbsaveTest5.csv');
dd = dbload('dbsaveTest5.csv');

assertEqualStructs(this, d, dd);


%% Error invalid data format

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), rand(20, 3, 5, 6));
d.y = Series(qq(2001, 1):qq(2005, 4), rand(20, 1, 2));
d.a = rand(33, 5, 10);

dbsave(d, 'dbsaveTest6.csv');
c = file2char('dbsaveTest6.csv');
c = strrep(c, ',', ';');
char2file(c, 'dbsaveTest6_.csv');

try
    err = MException('', '');
    dbload('dbsaveTest6_.csv');
catch err
end

assertEqual(this, err.identifier, 'IRIS:Dbase:InvalidLoadFormat');


%% Error mixed frequency

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), rand(20, 3, 5, 6));

dbsave(d, 'dbsaveTest7.csv');
c = file2char('dbsaveTest7.csv');
c = strrep(c, '2001Q1', '2001M1');
char2file(c, 'dbsaveTest7_.csv');

errorID = '';
try
    dbload('dbsaveTest7_.csv');
catch err
    errorID = err.identifier;
end

assertEqual(this, errorID, 'IRIS:Dates:MixedFrequency');


%% Error invalid NameFunc= option

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), rand(20, 3, 5, 6));

dbsave(d, 'dbsaveTest8.csv');

try
    err = MException('', '');
    dbload('dbsaveTest8.csv', 'NameFunc=', @(x) 1);
catch err
end

assertEqual(this, err.identifier, 'IRIS:Dbase:InvalidOptionNameFunc');


%% Error loading userdata field

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), rand(20, 3, 5, 6));
d.x = userdata(d.x, {1, 2, 'C'});
d.userdata = struct('A', 1, 'B', 'XXX', 'C', {{1, 2, 3}});

dbsave(d, 'dbsaveTest9.csv');
c = file2char('dbsaveTest9.csv');
c = strrep(c, '"struct(', '"xxx(');
char2file(c, 'dbsaveTest9_.csv');

try
    err = MException('', '');
    dbload('dbsaveTest9_.csv');
catch err
end

assertEqual(this, err.identifier, 'IRIS:Dbase:ErrorLoadingUserData');


%
% Local Functions
%

function assertEqualStructs(this, d1, d2)
    list = fieldnames(d1);
    assertEqual(this, sort(list), sort(fieldnames(d2)));
    for i = 1 : numel(list)
        x1 = d1.(list{i});
        x2 = d2.(list{i});
        assertEqual(this, class(x1), class(x2));
        if isa(x1, 'TimeSubscriptable') 
           x1 = x1.Data;
           x2 = x2.Data;
        end
        assertEqual(this, x1, x1, 'AbsTol', 1e-8);
    end
end%



