
%% %%  testForBody(this)

inpCode = '!for ?1=$[1:3]$ !do !for ?2=$[1:?1]$ !do ?1?2 !end !end';
expCode = '11 21 22 31 32 33';
forCtrlHelper(inpCode, expCode);


%%  testIfCond(this)

inpCode = '!for ?1=$[1:3]$ !do !for !if ?1==1; ?2=$[0:?1]$ !else ?2=$[1:?1]$ !end !do ?1?2 !end !end';
expCode = '10 11 21 22 31 32 33';
forCtrlHelper(inpCode, expCode);


%%  testSwitchExpr(this)

inpCode = '!for ?1=$[1:4]$ !do !switch ?1; !case 1; 100; !case 2; 200; !case 3; 300; !otherwise 400; !end !end';
expCode = '100; 200; 300; 400;';
forCtrlHelper(inpCode, expCode);


%%  testImportFileName(this)

char2file('contents1', 'testImportFileName1.model');
char2file('contents2', 'testImportFileName2.model');
char2file('contents3', 'testImportFileName3.model');
rehash( );
inpCode = '!for ?1=$[1:3]$ !do !import(testImportFileName?1.model) !end';
expCode = 'contents1 contents2 contents3';
forCtrlHelper(inpCode, expCode);


%%  testExportFileName(this)

import parser.Preparser;
inpCode = '!for $[list]$ !do !export(testExportFileName?.model) x=?; !end !end';
expCode = '';
assign = struct('list', [10, 30, 20]);
[actCode, ~, actualExport] = Preparser.parse([ ], inpCode, 'assigned=', assign);
actCode = Preparser.removeInsignificantWhs(actCode);
expCode = Preparser.removeInsignificantWhs(expCode);

Assert.equal(actCode, expCode);
Assert.equal(length(actualExport), 3);
expectedFileName = { ...
    'testExportFileName10.model', ...
    'testExportFileName30.model', ...
    'testExportFileName20.model', ...
    };
Assert.equal({actualExport.FileName}, expectedFileName);
expectedContents = { ...
    'x=10;', ...
    'x=30;', ...
    'x=20;', ...
    };
actualContents = {actualExport.Contents};
actualContents = Preparser.removeInsignificantWhs(actualContents);
expectedContents = Preparser.removeInsignificantWhs(expectedContents);
Assert.equal(actualContents, expectedContents);

