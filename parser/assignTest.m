function Tests = assignTest( )
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function the = readAndAssign(code, inpDbase, opt)
TYPE = @int8;

% Initialize parser.TheParser object.
the = parser.TheParser( );
the.AssignOrd = TYPE(2);
the.DbaseAssigned = inpDbase;

% Initialize parser.theparser.Quantity object.
b = parser.theparser.Quantity( );
b.Type = TYPE(2);

quantity = model.component.Quantity( );

% Run parse on the parser.theparser.Quantity object.
quantity = parse(b, the, code, quantity, [ ], [ ], [ ], opt);

% Run assign on the parser.TheParser object.
assign(the, quantity);
end




function testAssignNoInput(this)
%{
A>>>>>
a=1, b, 'Label:c' c=[1+3i,NaN], 
d = Inf; e=-Inf

f = a+1;
g = -1/d+f;
<<<<<A
%}
code = parser.grabTextFromCaller('A');
the = readAndAssign(code, struct( ), [ ]);
actAssigned = the.DbaseAssigned;
expAssigned = struct( ...
    'a', 1, ...
    'c', [1+3i, NaN], ...
    'd', Inf, ...
    'e', -Inf, ...
    'f', 2, ...
    'g', 2 ...
    );
assertEqual(this, actAssigned, expAssigned);
end




function testAssignInput(this)
a = struct( ...
    'a', 0, ...
    'b', 0, ...
    'g', 0, ...
    'h', 0 ...
    );
code = parser.grabTextFromCaller('A');
the = readAndAssign(code, a, [ ]);
actAssigned = the.DbaseAssigned;
expAssigned = struct( ...
    'a', 0, ...
    'b', 0, ...
    'c', [1+3i, NaN], ...
    'd', Inf, ...
    'e', -Inf, ...
    'f', 1, ...
    'g', 0, ...
    'h', 0 ...
    );
assertEqual(this, actAssigned, expAssigned);
end




function testAssignMultiple(this)
%{
M>>>>>
a=1; b=2; c=3; a=4; b=10*a+c; z=1
<<<<<M
%}
code = parser.grabTextFromCaller('M');
the = readAndAssign(code, struct( ), struct('multiple', true));
actDbase = the.DbaseAssigned;
expDbase = struct( ...
    'a', 4, ...
    'b', 43, ...
    'c', 3, ...
    'z', 1 ...
    );
assertEqual(this, actDbase, expDbase);
end
