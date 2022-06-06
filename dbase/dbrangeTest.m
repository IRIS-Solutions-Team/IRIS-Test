
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

d = struct( );
range1 = ii(1 : 10);
range2 = ii(5 : 14);
range3 = qq(2000,1):qq(2005,4);
range4 = qq(1990,1):qq(2010,4);
range5 = dd(2000,1,1):dd(2000,12,'end');
d.aa = tseries(range1,@rand);
d.bb = tseries(range2,@rand);
d.cc = tseries(range3,@rand);
d.dd = tseries(range4,@rand);
d.ee = tseries(range5,@rand);
testCase.TestData.Range1 = range1;
testCase.TestData.Range2 = range2;
testCase.TestData.Range3 = range3;
testCase.TestData.Range4 = range4;
testCase.TestData.Range5 = range5;
testCase.TestData.Dbase = d;
% setupOnce()


%**************************************************************************


%% testDbrangeOneFreq(testCase)
d = testCase.TestData.Dbase;
range1 = testCase.TestData.Range1;
range2 = testCase.TestData.Range2;

exp0 = [ ];
act0 = dbrange(d,{ });
assertEqual(testCase,act0,exp0);

exp1 = range1;
act1 = dbrange(d,'aa');
assertEqual(testCase,act1,exp1);

exp2 = range1(1) : range2(end);
act2 = dbrange(d,{'aa','bb'});
assertEqual(testCase,act2,exp2);

exp3 = range2;
act3 = dbrange(d,{'aa','bb'},'startDate','minRange');
assertEqual(testCase,act3,exp3);

exp4 = range1;
act4 = dbrange(d,{'aa','bb'},'endDate','minRange');
assertEqual(testCase,act4,exp4);

exp5 = range2(1) : range1(end);
act5 = dbrange(d,{'aa','bb'},'startDate','minRange','endDate','minRange');
assertEqual(testCase,act5,exp5);
 % testDbrangeOneFreq()


%**************************************************************************


%% testDbrangeMultiFreq(testCase)
d = testCase.TestData.Dbase;
range1 = testCase.TestData.Range1;
range2 = testCase.TestData.Range2;
range3 = testCase.TestData.Range3;
range4 = testCase.TestData.Range4;
range5 = testCase.TestData.Range5;

exp1 = { range4, range5, range1(1):range2(end) };
act1 = dbrange(d);
assertEqual(testCase,act1,exp1);

exp2 = { range3, range5, range2(1):range1(end) };
act2 = dbrange(d,@all,'startDate','balanced','endDate','balanced');
assertEqual(testCase,act2,exp2);

exp3 = exp2;
act3 = dbrange(d,@all,'startDate','balanced','endDate','balanced');
assertEqual(testCase,act3,exp3);



exp5 = exp2;
act5 = dbrange(d,fieldnames(d), ...
    'startDate','minRange','endDate','minRange');
assertEqual(testCase,act5,exp5);
 % testDbrangeOneFreq()


