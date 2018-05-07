function Tests = preparserTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function testRemoveComments(this)
import parser.*;
p = Preparser( );
p.Code = file2char('testRemoveComments.txt');
Comment.parse(p);
actText = p.Code;
expText = file2char('testRemoveComments_removed.txt');
actText = Preparser.removeInsignificantWhs(actText);
expText = Preparser.removeInsignificantWhs(expText);
assertEqual(this, actText, expText);
end




function testClone(this)
import parser.*;
c = '!variables A, Bb, Ccc !equations A=0; Bb=0; Ccc=0;';
actCode = Preparser.cloneAllNames(c, 'US_$');
expCode = '!variables US_A, US_Bb, US_Ccc !equations US_A=0; US_Bb=0; US_Ccc=0;';
actCode = Preparser.removeInsignificantWhs(actCode);
expCode = Preparser.removeInsignificantWhs(expCode);
assertEqual(this, actCode, expCode);
end




function testPseudosubs(this)
import parser.*;
actCode = Preparser.parse('testPseudosubs.model', [ ]);
expCode = file2char('testPseudosubs_preparsed.model');
actCode = Preparser.removeInsignificantWhs(actCode);
expCode = Preparser.removeInsignificantWhs(expCode);
assertEqual(this, actCode, expCode);
end 




function testImport(this)
import parser.*;
actCode = Preparser.parse('testImport1.model', [ ]);
expCode = 'a,b,c d,e,f g,h,i';
actCode = Preparser.removeInsignificantWhs(actCode);
expCode = Preparser.removeInsignificantWhs(expCode);
assertEqual(this, actCode, expCode);
end




function testInlineIf(this)
import parser.*;
d = struct( );
d.sw1 = true;
d.sw2 = true;
actCode = Preparser.parse('testInlineIf.model', [ ], 'assigned=', d);
expCode = '!transition_variables x !transition_equations x= 1 ;';
actCode = Preparser.removeInsignificantWhs(actCode);
expCode = Preparser.removeInsignificantWhs(expCode);
assertEqual(this, actCode, expCode);

d.sw1 = false;
actCode = Preparser.parse('testInlineIf.model', [ ], 'assigned=', d);
expCode = '!transition_variables x !transition_equations x= 10 ;';
actCode = Preparser.removeInsignificantWhs(actCode);
expCode = Preparser.removeInsignificantWhs(expCode);
assertEqual(this, actCode, expCode);

d.sw2 = false;
actCode = Preparser.parse('testInlineIf.model', [ ], 'assigned=', d);
expCode = '!transition_variables x !transition_equations x= 100 ;';
actCode = Preparser.removeInsignificantWhs(actCode);
expCode = Preparser.removeInsignificantWhs(expCode);
assertEqual(this, actCode, expCode);
end
