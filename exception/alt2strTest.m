function Tests = alt2strTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function testAlt2str1(this)
label = exception.Base.ALT2STR_DEFAULT_LABEL;
x = [1,5,6,7,8,9,10,100];
actStr = exception.Base.alt2str(x);
expStr = ['[',label,'#1 #5-#10 #100]'];
assertEqual(this, actStr, expStr);

x = [1,21,22,23,24,26,28,29,30];
actStr = exception.Base.alt2str(x);
expStr = ['[',label,'#1 #21-#24 #26 #28-#30]'];
assertEqual(this, actStr, expStr);
end




function testAlt2str2(this)
x = [1,5,6,7,8,9,10,100];
actStr = exception.Base.alt2str(x,'');
expStr = '[#1 #5-#10 #100]';
assertEqual(this, actStr, expStr);
end