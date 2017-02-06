function Tests = reportTexTest( )
Tests = functiontests( localfunctions );
end
%#ok<*DEFNU>




function testTexObj(this)
BR = sprintf('\n');
x = report.new( );
x.tex('Title');
actInput = x.children{1}.userinput;
expInput = ['\[',BR,'\alpha + \beta',BR,'\]',BR];
assertEqual(this, actInput, expInput);
delete(x);
%{
\[
\alpha + \beta
\]
%}
end