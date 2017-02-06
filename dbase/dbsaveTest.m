
assertEqual = @(x, y) assert(isequal(x, y));
assertEqualFields = @(x, y, r) assert(equalFields(x, y, r));

%% dbsave mixing Series and numeric scalars

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), @rand);
d.a = 2;

dbsave(d, 'dbsaveTest1.csv');
dd = dbload('dbsaveTest1.csv');

assertEqualFields(d, dd, 1e-8);

%% dbsave mixing Series and 1-N-N numeric arrays

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), @rand);
d.a = rand(1, 5, 10);

dbsave(d, 'dbsaveTest2.csv');
dd = dbload('dbsaveTest2.csv');

assertEqualFields(d, dd, 1e-8);

%% dbsave mixing Series and N-N-N numeric arrays

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), @rand);
d.a = rand(100, 5, 10);

dbsave(d, 'dbsaveTest3.csv');
dd = dbload('dbsaveTest3.csv');

assertEqualFields(d, dd, 1e-8);

%% dbsave mixing ND Series and 1-N-N numeric arrays

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), rand(20, 3, 5, 6));
d.y = Series(qq(2001, 1):qq(2005, 4), rand(20, 1, 2));
d.a = rand(33, 5, 10);

dbsave(d, 'dbsaveTest4.csv');
dd = dbload('dbsaveTest4.csv');

assertEqualFields(d, dd, 1e-8);

%% dbsave with userdata field

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), rand(20, 3, 5, 6));
d.x = userdata(d.x, {1, 2, 'C'});
d.userdata = struct('A', 1, 'B', 'XXX', 'C', {{1, 2, 3}});

dbsave(d, 'dbsaveTest5.csv');
dd = dbload('dbsaveTest5.csv');

assertEqualFields(d, dd, 1e-8);

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

assertEqual(err.identifier, 'IRIS:Dbase:InvalidLoadFormat');

%% Error mixed frequency

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), rand(20, 3, 5, 6));

dbsave(d, 'dbsaveTest7.csv');
c = file2char('dbsaveTest7.csv');
c = strrep(c, '2001Q1', '2001M1');
char2file(c, 'dbsaveTest7_.csv');

try
    err = MException('', '');
    dbload('dbsaveTest7_.csv');
catch err
end

assertEqual(err.identifier, 'IRIS:Dbase:LoadMixedFrequency');

%% Error invalid NameFunc= option

d = struct( );
d.x = Series(qq(2001, 1):qq(2005, 4), rand(20, 3, 5, 6));

dbsave(d, 'dbsaveTest8.csv');

try
    err = MException('', '');
    dbload('dbsaveTest8.csv', 'NameFunc=', @(x) 1);
catch err
end

assertEqual(err.identifier, 'IRIS:Dbase:InvalidOptionNameFunc');

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

assertEqual(err.identifier, 'IRIS:Dbase:ErrorLoadingUserData');

%% Local functions

function flag = equalFields(d1, d2, tol)
    flag = true;
    list1 = sort(fieldnames(d1));
    list2 = sort(fieldnames(d2));
    if ~isequal(list1, list2)
        flag = false;
        return
    end
    for i = 1 : length(list1)
        name = list1{i};
        x1 = d1.(name);
        x2 = d2.(name);
        if isa(x1, 'tseries') && isa(x2, 'tseries')
            x1 = x1.Data;
            x2 = x2.Data;
        end
        if isnumeric(x1) && isnumeric(x2) && all(size(x1)==size(x2))
            if maxabs(x1(:)-x2(:))>tol
                flag = false;
                return
            end
        elseif ~isequal(x1, x2)
            flag = false;
            return
        end
    end
end

