
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);



%% Test line comment
import parser.Comment
BR = sprintf('\n');

c = 'aaaa%bbbb';
actStr = Comment.parse(c);
expStr = 'aaaa';
assertEqual(testCase, actStr, expStr);

c = ['aaaa%bbbb',BR,'cccc'];
actStr = Comment.parse(c);
expStr = ['aaaa',BR,'cccc'];
assertEqual(testCase, actStr, expStr);



%% Test block comment
import parser.Comment
BR = sprintf('\n');

c = ['aaaa%{bbbb',BR,'cccc%}dddd'];
actStr = Comment.parse(c);
expStr = 'aaaadddd';
assertEqual(testCase, actStr, expStr);

c = ['aaaa',BR,'%{',BR,'bbbb',BR,'cccc',BR,'%}',BR,'dddd'];
actStr = Comment.parse(c);
expStr = ['aaaa',BR,BR,'dddd'];
assertEqual(testCase, actStr, expStr);





%% Test ellipsis
import parser.Comment
BR = sprintf('\n');

c = ['aaaa ... bbbb',BR,'cccc'];
actStr = Comment.parse(c);
expStr = 'aaaa cccc';
assertEqual(testCase, actStr, expStr);

c = 'aaaa %{ ... %} dddd';
actStr = Comment.parse(c);
expStr = 'aaaa  dddd';
assertEqual(testCase, actStr, expStr);
