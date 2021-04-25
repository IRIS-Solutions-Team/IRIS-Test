function Tests = blazerTest()
Tests = functiontests(localfunctions);
end%
%#ok<*DEFNU>




function testBlazerTriangular(this)
m = model('testBlazerTriangular.model');
[actNameBlk, actEqtnBlk] = blazer(m);
expNameBlk = repmat({struct('Level', string.empty(1, 0), 'Change', string.empty(1, 0))}, 1, 3);
expNameBlk{1}.Level = "x";
expNameBlk{2}.Level = "y";
expNameBlk{3}.Level = "z";
expEqtnBlk = { ["a*x;"], ["a*x+b*y;"], ["a*x+b*y+c*z;"] };
assertEqual(this, actEqtnBlk, expEqtnBlk);
assertEqual(this, actNameBlk, expNameBlk);
end%




function testBlazerTriangularEndg(this)
m = model('testBlazerTriangular.model');
[actNameBlk, actEqtnBlk] = blazer(m,'endogenize',{'a','b'},'exogenize',{'x','y'});
expNameBlk = repmat({struct('Level', string.empty(1, 0), 'Change', string.empty(1, 0))}, 1, 3);
expNameBlk{1}.Level = "a";
expNameBlk{2}.Level = "b";
expNameBlk{3}.Level = "z";
expEqtnBlk = { ["a*x;"], ["a*x+b*y;"], ["a*x+b*y+c*z;"] };
assertEqual(this, actEqtnBlk, expEqtnBlk);
assertEqual(this, actNameBlk, expNameBlk);
end%
