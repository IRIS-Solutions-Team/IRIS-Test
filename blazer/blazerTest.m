function Tests = blazerTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function testBlazerTriangular(this)
m = model('testBlazerTriangular.model');
[actNameBlk, actEqtnBlk] = blazer(m);
expNameBlk = { {'x'}, {'y'}, {'z'} };
expEqtnBlk = { {'a*x;'}, {'a*x+b*y;'}, {'a*x+b*y+c*z;'} };
assertEqual(this, actEqtnBlk, expEqtnBlk);
assertEqual(this, actNameBlk, expNameBlk);
end




function testBlazerTriangularEndg(this)
m = model('testBlazerTriangular.model');
[actNameBlk, actEqtnBlk] = blazer(m,'endogenize=',{'a','b'},'exogenize=',{'x','y'});
expNameBlk = { {'a'}, {'b'}, {'z'} };
expEqtnBlk = { {'a*x;'}, {'a*x+b*y;'}, {'a*x+b*y+c*z;'} };
assertEqual(this, actEqtnBlk, expEqtnBlk);
assertEqual(this, actNameBlk, expNameBlk);
end
