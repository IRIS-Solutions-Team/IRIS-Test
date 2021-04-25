
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Remove Comments

p = parser.Preparser( );
p.Code = file2char('testRemoveComments.txt');
parser.Comment.parse(p);
actText = p.Code;
expText = file2char('testRemoveComments_removed.txt');
actText = parser.Preparser.removeInsignificantWhs(actText);
expText = parser.Preparser.removeInsignificantWhs(expText);
assertEqual(testCase, actText, expText);


%% Test Clone

c = '!variables A, Bb, Ccc !equations A=0; Bb=0; Ccc=0;';
actCode = parser.Preparser.cloneAllNames(c, ["US_", ""]);
expCode = '!variables US_A, US_Bb, US_Ccc !equations US_A=0; US_Bb=0; US_Ccc=0;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);


%% Test Pseudosubs

actCode = parser.Preparser.parse('testPseudosubs.model', [ ]);
expCode = file2char('testPseudosubs_preparsed.model');
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);


%% Test Import


actCode = parser.Preparser.parse('testImport1.model', [ ]);
expCode = 'a,b,c d,e,f g,h,i';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);


%% Test Inline If

d = struct( );
d.sw1 = true;
d.sw2 = true;
actCode = parser.Preparser.parse('testInlineIf.model', [ ], 'assigned', d);
expCode = '!transition_variables x !transition_equations x= 1 ;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);

d.sw1 = false;
actCode = parser.Preparser.parse('testInlineIf.model', [ ], 'assigned', d);
expCode = '!transition_variables x !transition_equations x= 10 ;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);

d.sw2 = false;
actCode = parser.Preparser.parse('testInlineIf.model', [ ], 'assigned', d);
expCode = '!transition_variables x !transition_equations x= 100 ;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);

