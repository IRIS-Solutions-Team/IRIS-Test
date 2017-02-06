function Tests = dbrangeTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>


%**************************************************************************


function setupOnce(This)
d = struct( );
range1 = 1 : 10;
range2 = 5 : 14;
range3 = qq(2000,1):qq(2005,4);
range4 = qq(1990,1):qq(2010,4);
range5 = dd(2000,1,1):dd(2000,12,'end');
d.aa = tseries(range1,@rand);
d.bb = tseries(range2,@rand);
d.cc = tseries(range3,@rand);
d.dd = tseries(range4,@rand);
d.ee = tseries(range5,@rand);
This.TestData.Range1 = range1;
This.TestData.Range2 = range2;
This.TestData.Range3 = range3;
This.TestData.Range4 = range4;
This.TestData.Range5 = range5;
This.TestData.Dbase = d;
end % setupOnce()


%**************************************************************************


function testDbrangeOneFreq(This)
d = This.TestData.Dbase;
range1 = This.TestData.Range1;
range2 = This.TestData.Range2;

exp0 = [ ];
act0 = dbrange(d,{ });
assertEqual(This,act0,exp0);

exp1 = range1;
act1 = dbrange(d,'aa');
assertEqual(This,act1,exp1);

exp2 = range1(1) : range2(end);
act2 = dbrange(d,{'aa','bb'});
assertEqual(This,act2,exp2);

exp3 = range2;
act3 = dbrange(d,{'aa','bb'},'startDate=','minRange');
assertEqual(This,act3,exp3);

exp4 = range1;
act4 = dbrange(d,{'aa','bb'},'endDate=','minRange');
assertEqual(This,act4,exp4);

exp5 = range2(1) : range1(end);
act5 = dbrange(d,{'aa','bb'},'startDate=','minRange','endDate=','minRange');
assertEqual(This,act5,exp5);
end % testDbrangeOneFreq()


%**************************************************************************


function testDbrangeMultiFreq(This)
d = This.TestData.Dbase;
range1 = This.TestData.Range1;
range2 = This.TestData.Range2;
range3 = This.TestData.Range3;
range4 = This.TestData.Range4;
range5 = This.TestData.Range5;

exp1 = { range1(1):range2(end), range4, range5 };
act1 = dbrange(d);
assertEqual(This,act1,exp1);

exp2 = { range2(1):range1(end), range3, range5 };
act2 = dbrange(d,'startDate=','minRange','endDate=','minRange');
assertEqual(This,act2,exp2);

exp3 = exp2;
act3 = dbrange(d,@all,'startDate=','minRange','endDate=','minRange');
assertEqual(This,act3,exp3);

exp4 = exp2;
act4 = dbrange(d,Inf,'startDate=','minRange','endDate=','minRange');
assertEqual(This,act4,exp4);

exp5 = exp2;
act5 = dbrange(d,fieldnames(d), ...
    'startDate=','minRange','endDate=','minRange');
assertEqual(This,act5,exp5);
end % testDbrangeOneFreq()


%**************************************************************************


function testDbrangeRegexp(This)
d = This.TestData.Dbase;
range1 = This.TestData.Range1;
range2 = This.TestData.Range2;

exp1 = [ ];
act1 = dbrange(d,rexp('^z.*'));
assertEqual(This,act1,exp1);

exp1 = range1;
act1 = dbrange(d,rexp('a.'));
assertEqual(This,act1,exp1);

exp2 = range1(1) : range2(end);
act2 = dbrange(d,rexp('[ab]{2}'));
assertEqual(This,act2,exp2);
end % testDbrangeRegexp()
