
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test import
m = Model.fromFile('testP2MImport1.model', ...
    'sw1',true,'sw2',true,'sw3',true);
pSet = get(m,'PSet');
xList = get(m,'XList');
assertEqual(testCase,pSet,struct('sw1',true,'sw2',true,'sw3',true));
assertEqual(testCase,xList,{'x','y','z'});




%% Test export
if exist('testExport.m','file')==2
    delete('testExport.m');
end
m = Model.fromFile('testP2MExport.model','sw1',true);
flag = exist('testExport.m','file');
assertEqual(testCase,flag,2);
delete('testExport.m');
pSet = get(m,'pSet');
xList = get(m,'xList');
assertEqual(testCase,pSet,struct('sw1',true));
assertEqual(testCase,xList,{'x','y','z'});
