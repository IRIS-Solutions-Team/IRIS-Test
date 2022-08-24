function Tests = parseNamesTest( )
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function testParseNames(this)
TYPE = @int8;

the = parser.TheParser( );
b = parser.theparser.Quantity( );
b.Type = TYPE(2);
code = file2char('parseNamesTest.txt');
attributes = string.empty(1, 0);

equation = model.Equation( );
quantity = model.Quantity( );

quantity = parse(b, the, code, attributes, quantity, equation, [ ]);

actName = quantity.Name;
expName = {'a', 'b', 'c', 'd', 'e'};
nQuan = length(actName);

actType = quantity.Type;
expType = repmat(b.Type, 1, nQuan);

actLabel = quantity.Label;
expLabel = {'Name a', '', 'Name ''c'';', '', 'Name e'};

actValue = the.AssignedString;
expValue = {'', '', '', '1', '2+1i'};

actBounds = quantity.Bounds;
expBounds = repmat(model.Quantity.DEFAULT_BOUNDS, 1, nQuan);

assertEqual(this, actName, expName);
assertEqual(this, actType, expType);
assertEqual(this, actLabel, expLabel);
assertEqual(this, actValue, expValue);
assertEqual(this, actBounds, expBounds);
end
