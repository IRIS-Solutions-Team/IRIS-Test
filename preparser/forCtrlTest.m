function Tests = forCtrlTest( )
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function helper(this, inpCode, expCode, assign)
import parser.Preparser;
try, assign; catch, assign = struct( ); end %#ok<VUNUS,NOCOM>
actCode = Preparser.parse([ ], inpCode, assign);
actCode = Preparser.removeInsignificantWhs(actCode);
expCode = Preparser.removeInsignificantWhs(expCode);
assertEqual(this, actCode, expCode);
end




function testForBody(this)
inpCode = '!for ?1=$[1:3]$ !do !for ?2=$[1:?1]$ !do ?1?2 !end !end';
expCode = '11 21 22 31 32 33';
helper(this, inpCode, expCode);
end




function testIfCond(this)
inpCode = '!for ?1=$[1:3]$ !do !for !if ?1==1; ?2=$[0:?1]$ !else ?2=$[1:?1]$ !end !do ?1?2 !end !end';
expCode = '10 11 21 22 31 32 33';
helper(this, inpCode, expCode);
end




function testSwitchExpr(this)
inpCode = '!for ?1=$[1:4]$ !do !switch ?1; !case 1; 100; !case 2; 200; !case 3; 300; !otherwise 400; !end !end';
expCode = '100; 200; 300; 400;';
helper(this, inpCode, expCode);
end




function testImportFileName(this)
char2file('contents1','testImportFileName1.model');
char2file('contents2','testImportFileName2.model');
char2file('contents3','testImportFileName3.model');
rehash( );
inpCode = '!for ?1=$[1:3]$ !do !import(testImportFileName?1.model) !end';
expCode = 'contents1 contents2 contents3';
helper(this, inpCode, expCode);
end




function testExportFileName(this)
import parser.Preparser;
inpCode = '!for $[ list ]$ !do !export(testExportFileName?.model) x=?; !end !end';
expCode = '';
assign = struct('list', [10, 30, 20]);
[actCode, ~, actExportable] = Preparser.parse([ ], inpCode, assign);
actCode = Preparser.removeInsignificantWhs(actCode);
expCode = Preparser.removeInsignificantWhs(expCode);
assertEqual(this, actCode, expCode);
assertEqual(this, length(actExportable), 3);
expFName = { ...
    'testExportFileName10.model', ...
    'testExportFileName30.model', ...
    'testExportFileName20.model', ...
    };
assertEqual(this, actExportable(1, :), expFName);
expContent = { ...
    'x=10;', ...
    'x=30;', ...
    'x=20;', ...
    };
actContent = actExportable(2, :);
actContent = Preparser.removeInsignificantWhs(actContent);
expContent = Preparser.removeInsignificantWhs(expContent);
assertEqual(this, actContent, expContent);
end
