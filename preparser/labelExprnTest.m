function Tests = labelExprnTest()
Tests = functiontests( localfunctions );
end
%#ok<*DEFNU>




function testLabelExprnCell(this)
import parser.Helper;
c = {'"''Label''" X+1', 'Y', '^''"Label"'' Z+''a''' };
[actExprn, actLabel] = Helper.parseLabelExprn(c);
expExprn = { 'X+1', 'Y', 'Z+''a''' };
expLabel = { '''Label''', '', '"Label"' };
assertEqual(this, actExprn, expExprn);
assertEqual(this, actLabel, expLabel);
end




function testLabelExprnChar(this)
import parser.Helper;
c = '"''Label''" X+1'; %'Y', '^''"Label"'' Z+''a''' };
[actExprn, actLabel] = Helper.parseLabelExprn(c);
expExprn = 'X+1'; % 'Y' % 'Z+''a''' };
expLabel = '''Label'''; %'', '"Label"' };
assertEqual(this, actExprn, expExprn);
assertEqual(this, actLabel, expLabel);

c = 'Y'; %'^''"Label"'' Z+''a''' };
[actExprn, actLabel] = Helper.parseLabelExprn(c);
expExprn = 'Y'; % 'Z+''a''' };
expLabel = '';% '"Label"' };
assertEqual(this, actExprn, expExprn);
assertEqual(this, actLabel, expLabel);

c = '^''"Label"'' Z+''a''';
[actExprn, actLabel] = Helper.parseLabelExprn(c);
expExprn = 'Z+''a''';
expLabel = '"Label"';
assertEqual(this, actExprn, expExprn);
assertEqual(this, actLabel, expLabel);
end