
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);



%% Test label exprn cell

import parser.Helper
c = {'"''Label''" X+1', 'Y', '^''"Label"'' Z+''a''' };
[actExprn, actLabel] = Helper.parseLabelExprn(c);
expExprn = { 'X+1', 'Y', 'Z+''a''' };
expLabel = { '''Label''', '', '"Label"' };
assertEqual(testCase, actExprn, expExprn);
assertEqual(testCase, actLabel, expLabel);



%% Test label exprn char

import parser.Helper
c = '"''Label''" X+1'; %'Y', '^''"Label"'' Z+''a''' };
[actExprn, actLabel] = Helper.parseLabelExprn(c);
expExprn = 'X+1'; % 'Y' % 'Z+''a''' };
expLabel = '''Label'''; %'', '"Label"' };
assertEqual(testCase, actExprn, expExprn);
assertEqual(testCase, actLabel, expLabel);

c = 'Y'; %'^''"Label"'' Z+''a''' };
[actExprn, actLabel] = Helper.parseLabelExprn(c);
expExprn = 'Y'; % 'Z+''a''' };
expLabel = '';% '"Label"' };
assertEqual(testCase, actExprn, expExprn);
assertEqual(testCase, actLabel, expLabel);

c = '^''"Label"'' Z+''a''';
[actExprn, actLabel] = Helper.parseLabelExprn(c);
expExprn = 'Z+''a''';
expLabel = '"Label"';
assertEqual(testCase, actExprn, expExprn);
assertEqual(testCase, actLabel, expLabel);
