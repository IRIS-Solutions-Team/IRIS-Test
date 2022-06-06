
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model.fromFile('linearKalmanTest.model','linear',true);
m = solve(m);
m = steady(m);
t = 1 : 100;
d = struct();
d.XY = Series(t,sin(t/3));
d.Z = Series(t,cos(t/6));
testCase.TestData.Model = m;
testCase.TestData.Dbase = d;
testCase.TestData.Range = t;


%% Test OutOfLik

m = testCase.TestData.Model;
d = testCase.TestData.Dbase;
t = testCase.TestData.Range;

[~, mf, info] = kalmanFilter( ...
    m, d, t ...
    , "outlik", ["alpha","beta"] ...
    , "relative", true ...
    , "unitRootInitials", "fixedUnknown" ...
);

assertEqual(testCase,info.Outlik.Mean.alpha,-0.335027881140906,'AbsTol',1e-14);
assertEqual(testCase,info.Outlik.Mean.beta,0.281864368642865,'AbsTol',1e-14);
assertEqual(testCase,info.VarScale,0.106218584336833,'AbsTol',1e-14);
assertEqual(testCase,mf.std_a^2,0.106218584336833,'AbsTol',1e-14);


%% Test ChkFmse

m = testCase.TestData.Model;
d = testCase.TestData.Dbase;
t = testCase.TestData.Range;

l1 = loglik(m,d,t,'checkFmse',true,'fmseCondTol',0.9);
assertEqual(testCase,l1,model.OBJ_FUNC_PENALTY);

l2 = loglik(m,d,t,'checkFmse',true,'fmseCondTol',0.9,'returnObjFuncContribs',true);
assertEqual(testCase,isnan(l2),true(size(l2)));
