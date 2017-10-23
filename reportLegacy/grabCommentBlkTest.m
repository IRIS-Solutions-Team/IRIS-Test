function Tests = grabCommentBlkTest()
Tests = functiontests( localfunctions );
end
%#ok<*DEFNU>




function testGrabCommentBlk1(this)
BR = sprintf('\n');
caller = dbstack('-completenames');
caller = caller(1);
actStr = report.texobj.grabCommentBlk(caller);
%{
aaaa
%}
%{
bbbb
%}
expStr = ['aaaa',BR];
%{
cccc
%}
assertEqual(this, actStr, expStr);
end




function testGrabCommentBlk2(this)
BR = sprintf('\n');
caller = dbstack('-completenames');
caller = caller(1);
actStr = report.texobj.grabCommentBlk(caller);
expStr = ['cccc',BR];
assertEqual(this, actStr, expStr);
%{
cccc
%}
end