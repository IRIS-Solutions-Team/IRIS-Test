
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test For Unnamed
c = '!for 1,2,3 !do x?=?; !end';
actCode = parser.Preparser.parse([ ], c);
expCode = 'x1=1; x2=2; x3=3;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);





%% Test For Named Default
c = '!for ?=1,2,3 !do x?=?; !end';
actCode = parser.Preparser.parse([ ], c);
expCode = 'x1=1; x2=2; x3=3;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);




%% Test For Named
c = '!for ?#=$[1:5]$ !do x?#=?#; !end';
actCode = parser.Preparser.parse([ ], c);
expCode = 'x1=1; x2=2; x3=3; x4=4; x5=5;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);



%% Test For Nested
c = '!for ?@=A,B !do !for ?#=$[1:2]$ !do ?@?#=?#; !end !end';
actCode = parser.Preparser.parse([ ], c);
expCode = 'A1=1; A2=2; B1=1; B2=2;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);




%% Test For Eval
c = '!for ?@=1,2 !do !for ?#=$[1:K]$ !do X?@?#=?@+?#; !end !end';
actCode = parser.Preparser.parse([ ], c, 'assigned', struct('K',2));
expCode = 'X11=1+1; X12=1+2; X21=2+1; X22=2+2;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);



%% Test Stop
c = 'x1=1; x2=2; x3=3; !stop x4=4; !stop x5=5;';
actCode = parser.Preparser.parse([ ], c);
expCode = 'x1=1; x2=2; x3=3;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);





%% Test If
c = '!if sw1==1; x=1; !elseif sw1==2; x=2; !else x=3; !end';

actCode = parser.Preparser.parse([ ], c, 'assigned', struct('sw1',1));
expCode = 'x=1;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);

actCode = parser.Preparser.parse([ ], c, 'assigned', struct('sw1',2));
expCode = 'x=2;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);

q = warning('query');
expId = 'IrisToolbox:Preparser:CtrlEvalIfFailed';
warning('off', expId);
actCode = parser.Preparser.parse([ ], c);
expCode = 'x=3;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);
[~, actId] = lastwarn( );
assertEqual(testCase, actId, expId);
warning(q);




%% Test if inline
c = 'x = !if 1; 1 !end ;';
actCode = parser.Preparser.parse([ ], c);
expCode = 'x = 1 ;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);

c = 'x = !if false; 1 !else 2 !end ;';
actCode = parser.Preparser.parse([ ], c);
expCode = 'x = 2 ;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);

c = 'x = !if false; 1 !elseif true; 2 !else 3 !end ;';
actCode = parser.Preparser.parse([ ], c);
expCode = 'x = 2 ;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);

c = 'x = !if false; 1 !elseif false; 2 !else 3 !end ;';
actCode = parser.Preparser.parse([ ], c);
expCode = 'x = 3 ;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);





%% Test switch
c = '!switch sw1; !case 1; x=1; !case 2; x=2; !otherwise x=3; !end';

actCode = parser.Preparser.parse([ ], c, 'assigned', struct('sw1',1));
expCode = 'x=1;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);

actCode = parser.Preparser.parse([ ], c, 'assigned', struct('sw1',2));
expCode = 'x=2;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);

actCode = parser.Preparser.parse([ ], c, 'assigned', struct('sw1', NaN));
expCode = 'x=3;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);

q = warning('query');
expId = 'IrisToolbox:Preparser:CtrlEvalSwitchFailed';
warning('off', expId);
actCode = parser.Preparser.parse([ ], c);
expCode = 'x=3;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);
[~, actId] = lastwarn( );
assertEqual(testCase, actId, expId);
warning(q);




%% Test control inside labels
c = '!for ?#=$[1:5]$ !do ''!end'' x?#=?#; !end';
actCode = parser.Preparser.parse([ ], c);
expCode = '''!end'' x1=1; ''!end''  x2=2; ''!end''  x3=3; ''!end''  x4=4; ''!end''  x5=5;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);

c = '!for ?#=$[1:5]$ !do "!end" x?#=?#; !end';
actCode = parser.Preparser.parse([ ], c);
expCode = '"!end" x1=1; "!end"  x2=2; "!end"  x3=3; "!end"  x4=4; "!end"  x5=5;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);

c = '!for ?#=$[1:5]$ !do "!for" x?#=?#; !end';
actCode = parser.Preparser.parse([ ], c);
expCode = '"!for" x1=1; "!for"  x2=2; "!for"  x3=3; "!for"  x4=4; "!for"  x5=5;';
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = parser.Preparser.removeInsignificantWhs(expCode);
assertEqual(testCase, actCode, expCode);


%% Test control parameters
c = '!if 0;!end !if 0;!end !if a; A !end';
[actCode, ~, ~, actAssigned] = parser.Preparser.parse([ ], c, 'assigned', struct('a', true));
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = 'A';
expAssigned = "a";
assertEqual(testCase, actCode, expCode);
assertEqual(testCase, actAssigned, expAssigned);

c = '!if a && b; A !else B !end !if b; !if c; C !else D !end !end';
[actCode, ~, ~, actAssigned] = parser.Preparser.parse([ ], c, ...
    'assigned', struct('a', false, 'b', true, 'c', false));
actCode = parser.Preparser.removeInsignificantWhs(actCode);
expCode = 'B D';
expAssigned = ["a", "b", "c"];
assertEqual(testCase, actCode, expCode);
assertEqual(testCase, actAssigned, expAssigned);

c = '!variables x; !equations x= !if a && b; +1 !else +2 !end !if b; !if c; +3 !else +4 !end !end ;';
char2file(c, 'testCtrlParameters.model');
m = Model.fromFile('testCtrlParameters.model', 'a', false, 'b', true, 'c', false);
actEq = get(m, 'xeqtn');
expEq = {'x=+2+4;'};
actPSet = get(m, 'PSet');
expPSet = struct('a', false, 'b', true, 'c', false);
assertEqual(testCase, actEq, expEq);
assertEqual(testCase, actPSet, expPSet);
