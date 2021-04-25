function tests = getRequiredTest()
tests = functiontests( localfunctions( ) );
end
%#ok<*DEFNU>




function setupOnce(this)
m = model('chkmissing.model', 'Linear', true);
this.TestData.Model = m;
end 




function test1(this)
m = this.TestData.Model;

m = alter(m, 3);
m.a = [1, 1, 1];
m.b = [1, 0, 0];
m = solve(m);

actList = get(m, 'RequiredInitCond');
expList = {'x{-1}', 'y{-1}'};
assertEqual(this, actList, expList);
end




function test2(this)
m = this.TestData.Model;

m = alter(m, 3);
m.a = [0, 0, 0];
m.b = [0, 0, 1];
m = solve(m);

actList = get(m, 'RequiredInitCond');
expList = {'y{-1}'};
assertEqual(this, actList, expList);
end




function test3(this)
m = this.TestData.Model;

m = alter(m, 3);
m.a = [0, 0, 0];
m.b = [0, 0, 0];
m = solve(m);

actList = get(m, 'RequiredInitCond');
expList = cell(1, 0);
assertEqual(this, actList, expList);
end
