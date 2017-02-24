function Tests = pseudofuncTest( )
Tests = functiontests(localfunctions);
end




function testDiffDefault(this)
import parser.pseudofunc.Pseudofunc;
actCode = Pseudofunc.parse('diff(diff(y))');
expCode = '((((y)-(y{-1})))-(((y{-1})-(y{-1-1}))))';
assertEqual(this, actCode, expCode);
end




function testDiff(this)
import parser.pseudofunc.Pseudofunc;
actCode = Pseudofunc.parse('diff(diff(y,-2),+1)');
expCode = '((((y)-(y{-2})))-(((y{+1})-(y{+1-2}))))';
assertEqual(this, actCode, expCode);
end




function testDifflog(this)
import parser.pseudofunc.Pseudofunc;
actCode = Pseudofunc.parse('diff(difflog(y,-2),+1)');
expCode = '(((log(y)-log(y{-2})))-((log(y{+1})-log(y{+1-2}))))';
assertEqual(this, actCode, expCode);
end




function testDot(this)
import parser.pseudofunc.Pseudofunc;
actCode = Pseudofunc.parse('dot(y{+1},-2)');
expCode = '((y{+1})/(y{+1-2}))';
assertEqual(this, actCode, expCode);
end




function testMovsum(this)
import parser.pseudofunc.Pseudofunc;
actCode = Pseudofunc.parse('movsum(diff(y,-2),+3)');
expCode = '((((y)-(y{-2})))+(((y{+1})-(y{-2+1})))+(((y{+2})-(y{-2+2}))))';
assertEqual(this, actCode, expCode);
end




function testMovprod(this)
import parser.pseudofunc.Pseudofunc;
actCode = Pseudofunc.parse('movprod(diff(y,-2),+3)');
expCode = '((((y)-(y{-2})))*(((y{+1})-(y{-2+1})))*(((y{+2})-(y{-2+2}))))';
assertEqual(this, actCode, expCode);
end




function testMovavg(this)
import parser.pseudofunc.Pseudofunc;
actCode = Pseudofunc.parse('movavg(diff(y,-2),+3)');
expCode = '(((((y)-(y{-2})))+(((y{+1})-(y{-2+1})))+(((y{+2})-(y{-2+2}))))/3)';
assertEqual(this, actCode, expCode);
end




function testMovgeom(this)
import parser.pseudofunc.Pseudofunc;
actCode = Pseudofunc.parse('movgeom(diff(y,-2),+3)');
expCode = '(((((y)-(y{-2})))*(((y{+1})-(y{-2+1})))*(((y{+2})-(y{-2+2}))))^(1/3))';
assertEqual(this, actCode, expCode);
end
