function Tests = diffsrfTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function setupOnce(this)
m = model('3eq.model', 'linear=', true);
m = solve(m);
m = sstate(m);
this.TestData.Model = m;
this.TestData.Tol = 1e-9;
end




function testDiffsrfShk(this)
m = this.TestData.Model;
tol = this.TestData.Tol;
eList = get(m, 'eList');

exp1 = diffsrf(m, 1:20, 'alp4, alp3', 'Select=', eList{1});
exp2 = diffsrf(m, 1:20, 'alp4, alp3', 'Select=', eList{2});
s12 = diffsrf(m, 1:20, 'alp4, alp3', 'Select=', eList([1, 2]));
act1 = dbcol(s12, 1);
act2 = dbcol(s12, 2);

list = fieldnames(exp1);
for i = 1 : length(list)
    name = list{i};
    assertEqual(this, act1.(name)(:), exp1.(name)(:), 'AbsTol', tol);
    assertEqual(this, act2.(name)(:), exp2.(name)(:), 'AbsTol', tol);
end
end




function testDiffsrfPar(this)
m = this.TestData.Model;
tol = this.TestData.Tol;
eList = get(m, 'eList');

exp1 = diffsrf(m, 1:20, 'alp4', 'Select=', eList);
exp2 = diffsrf(m, 1:20, 'alp3', 'Select=', eList);
s12 = diffsrf(m, 1:20, 'alp4, alp3', 'Select=', eList);
act1 = dbpage(s12, 1);
act2 = dbpage(s12, 2);

list = fieldnames(exp1);
for i = 1 : length(list)
    name = list{i};
    assertEqual(this, act1.(name)(:), exp1.(name)(:), 'AbsTol', tol);
    assertEqual(this, act2.(name)(:), exp2.(name)(:), 'AbsTol', tol);
end
end
