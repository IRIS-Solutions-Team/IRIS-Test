function Tests = preparser2ModelTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function testImport(This)
m = model('testP2MImport1.model', ...
    'sw1',true,'sw2',true,'sw3',true);
pSet = get(m,'PSet');
xList = get(m,'XList');
assertEqual(This,pSet,struct('sw1',true,'sw2',true,'sw3',true));
assertEqual(This,xList,{'x','y','z'});
end % testImport()




function testExport(This)
if exist('testExport.m','file')==2
    delete('testExport.m');
end
m = model('testP2MExport.model','sw1',true);
flag = exist('testExport.m','file');
assertEqual(This,flag,2);
delete('testExport.m');
pSet = get(m,'pSet');
xList = get(m,'xList');
assertEqual(This,pSet,struct('sw1',true));
assertEqual(This,xList,{'x','y','z'});
end % testExport()
