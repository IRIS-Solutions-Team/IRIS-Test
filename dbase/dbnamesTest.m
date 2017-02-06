function Tests = dbnamesTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>


%**************************************************************************


function setupOnce(This)
d = struct();
d.a = [1,2,3];
d.a_u  = [10,20,30];
d.b = 'abcd';
d.b_u = 'ABCD';
d.c = tseries(1:10,1);
d.c_u = tseries(1:10,10);
This.TestData.Dbase = d;
end
    

%**************************************************************************


function testNameFilter(This)
d = This.TestData.Dbase;

actList1 = dbnames(d);
expList1 = fieldnames(d);
assertEqual(This,sort(actList1),sort(expList1));

actList2 = dbnames(d,'nameFilter=',{'a','b','c'});
expList2 = {'a','b','c'};
assertEqual(This,sort(actList2),sort(expList2));

actList3 = dbnames(d,'nameFilter=',rexp('a.*|b.*'));
expList3 = {'a','a_u','b','b_u'};
assertEqual(This,sort(actList3),sort(expList3));

actList4 = dbnames(d,'nameFilter=',rexp('.*_u$'));
expList4 = {'a_u','b_u','c_u'};
assertEqual(This,sort(actList4),sort(expList4));
end % testNameFilter()


%**************************************************************************


function testClassFilter(This)
d = This.TestData.Dbase;

actList1 = dbnames(d,'classFilter=',{'double','char'});
expList1 = {'a','a_u','b','b_u'};
assertEqual(This,sort(actList1),sort(expList1));

actList2 = dbnames(d,'classFilter=','tseries');
expList2 = {'c','c_u'};
assertEqual(This,sort(actList2),sort(expList2));

actList3 = dbnames(d,'classFilter=',rexp('tseries|char'));
expList3 = {'c','c_u','b','b_u'};
assertEqual(This,sort(actList3),sort(expList3));
end % testNameFilter()


%**************************************************************************


function testCombined(This)
d = This.TestData.Dbase;

actList1 = dbnames(d, ...
    'classFilter=',{'double','char'}, ...
    'nameFilter=',{'a','b','c'});
expList1 = {'a','b'};
assertEqual(This,sort(actList1),sort(expList1));

actList2 = dbnames(d, ...
    'classFilter=','tseries', ...
    'nameFilter=',rexp('.*_u'));
expList2 = {'c_u'};
assertEqual(This,sort(actList2),sort(expList2));
end % testCombined()
