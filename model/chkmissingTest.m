function tests = chkmissingTest()
tests = functiontests( localfunctions( ) );
end
%#ok<*DEFNU>




function setupOnce(this)
m = model('chkmissing.model', 'Linear=', true);
m = alter(m, 4);
m.a = [1, 1, 0, 0];
m.b = [1, 0, 1, 0];
m = solve(m);
this.TestData.Model = m;
end 




function test1(this)
m = this.TestData.Model;

d = struct( );
d.x = tseries(0, 1);
d.y = tseries(0, NaN);

[actFlag, actLsMissing] = chkmissing(m, d, 1, 'Error=', false);
expFlag = false;
expLsMissing = {'y'};
assertEqual(this, actFlag, expFlag);
assertEqual(this, actLsMissing, expLsMissing);
end




function test2(this)
m = this.TestData.Model;

d = struct( );
d.x = tseries(0, [1, 1, 1, 1]);
d.y = tseries(0, [NaN, NaN, NaN, NaN]);

[actFlag, actLsMissing] = chkmissing(m, d, 1, 'Error=', false);
expFlag = false;
expLsMissing = {'y'};
assertEqual(this, actFlag, expFlag);
assertEqual(this, actLsMissing, expLsMissing);
end




function test3(this)
m = this.TestData.Model;

d = struct( );
d.x = tseries(0, [1, 1, 1, 1]);
d.y = tseries(0, [1, NaN, 1, NaN]);

[actFlag, actLsMissing] = chkmissing(m, d, 1, 'Error=', false);
expFlag = true;
expLsMissing = cell(1, 0);
assertEqual(this, actFlag, expFlag);
assertEqual(this, actLsMissing, expLsMissing);
end




function test4(this)
m = this.TestData.Model;

d = struct( );
d.x = tseries(0, [1, 1, 1, 1]);
d.y = tseries(0, [NaN, 1, NaN, 1]);

[actFlag, actLsMissing] = chkmissing(m, d, 1, 'Error=', false);
expFlag = false;
expLsMissing = {'y'};
assertEqual(this, actFlag, expFlag);
assertEqual(this, actLsMissing, expLsMissing);
end




function test5(this)
m = this.TestData.Model;

d = struct( );
d.x = tseries(0, [1, NaN, 1, NaN]);
d.y = tseries(0, [NaN, 1, NaN, 1]);

[actFlag, actLsMissing] = chkmissing(m, d, 1, 'Error=', false);
expFlag = false;
expLsMissing = {'x', 'y'};
assertEqual(this, actFlag, expFlag);
assertEqual(this, actLsMissing, expLsMissing);
end




function test6(this)
m = this.TestData.Model;

d = struct( );
d.x = tseries(0, [1, 1, NaN, NaN]);
d.y = tseries(0, [1, NaN, 1, NaN]);

[actFlag, actLsMissing] = chkmissing(m, d, 1, 'Error=', false);
expFlag = true;
expLsMissing = cell(1, 0);
assertEqual(this, actFlag, expFlag);
assertEqual(this, actLsMissing, expLsMissing);
end
