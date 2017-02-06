function Tests = commentTest()
Tests = functiontests( localfunctions );
end
%#ok<*DEFNU>




function testLineComment(this)
import parser.Comment;
BR = sprintf('\n');

c = 'aaaa%bbbb';
actStr = Comment.parse(c);
expStr = 'aaaa';
assertEqual(this, actStr, expStr);

c = ['aaaa%bbbb',BR,'cccc'];
actStr = Comment.parse(c);
expStr = ['aaaa',BR,'cccc'];
assertEqual(this, actStr, expStr);
end




function testBlockComment(this)
import parser.Comment;
BR = sprintf('\n');

c = ['aaaa%{bbbb',BR,'cccc%}dddd'];
actStr = Comment.parse(c);
expStr = 'aaaadddd';
assertEqual(this, actStr, expStr);

c = ['aaaa',BR,'%{',BR,'bbbb',BR,'cccc',BR,'%}',BR,'dddd'];
actStr = Comment.parse(c);
expStr = ['aaaa',BR,BR,'dddd'];
assertEqual(this, actStr, expStr);
end




function testContinuation(this)
import parser.Comment;
BR = sprintf('\n');

c = ['aaaa ... bbbb',BR,'cccc'];
actStr = Comment.parse(c);
expStr = 'aaaa cccc';
assertEqual(this, actStr, expStr);

c = 'aaaa %{ ... %} dddd';
actStr = Comment.parse(c);
expStr = 'aaaa  dddd';
assertEqual(this, actStr, expStr);
end