

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);




%% Test diff default

import parser.Pseudofunc
actCode = Pseudofunc.parse('diff(diff(y))');
expCode = '((((y)-(y{-1})))-(((y{-1})-(y{-1-1}))))';
assertEqual(testCase, actCode, expCode);




%% Test diff
import parser.Pseudofunc;
actCode = Pseudofunc.parse('diff(diff(y,-2),+1)');
expCode = '((((y)-(y{-2})))-(((y{+1})-(y{+1-2}))))';
assertEqual(testCase, actCode, expCode);




%% Test difflog

import parser.Pseudofunc;
actCode = Pseudofunc.parse('diff(difflog(y,-2),+1)');
expCode = '(((log(y)-log(y{-2})))-((log(y{+1})-log(y{+1-2}))))';
assertEqual(testCase, actCode, expCode);





%% Test dot
import parser.Pseudofunc;
actCode = Pseudofunc.parse('dot(y{+1},-2)');
expCode = '((y{+1})/(y{+1-2}))';
assertEqual(testCase, actCode, expCode);





%% Test movsum
import parser.Pseudofunc;
actCode = Pseudofunc.parse('movsum(diff(y,-2),+3)');
expCode = '((((y)-(y{-2})))+(((y{+1})-(y{-2+1})))+(((y{+2})-(y{-2+2}))))';
assertEqual(testCase, actCode, expCode);




%% Test movprod
import parser.Pseudofunc;
actCode = Pseudofunc.parse('movprod(diff(y,-2),+3)');
expCode = '((((y)-(y{-2})))*(((y{+1})-(y{-2+1})))*(((y{+2})-(y{-2+2}))))';
assertEqual(testCase, actCode, expCode);



%% Test movavg
import parser.Pseudofunc;
actCode = Pseudofunc.parse('movavg(diff(y,-2),+3)');
expCode = '(((((y)-(y{-2})))+(((y{+1})-(y{-2+1})))+(((y{+2})-(y{-2+2}))))/3)';
assertEqual(testCase, actCode, expCode);




%% Test movgeom
import parser.Pseudofunc;
actCode = Pseudofunc.parse('movgeom(diff(y,-2),+3)');
expCode = '(((((y)-(y{-2})))*(((y{+1})-(y{-2+1})))*(((y{+2})-(y{-2+2}))))^(1/3))';
assertEqual(testCase, actCode, expCode);


