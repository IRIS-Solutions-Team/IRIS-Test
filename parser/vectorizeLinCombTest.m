function Tests = parserLinCombTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function testLinComb2Vec1(this)
[actZ, actC, actIsValid] = parser.vectorizeLinComb( ...
    '1+x-2*log(y)', ...
    {'a','b','x','c','log(y)'} ...
    );
expZ = [0,0,1,0,-2];
expC = 1;
expIsValid = true;
assertEqual(this, actZ, expZ);
assertEqual(this, actC, expC);
assertEqual(this, actIsValid, expIsValid);

[~, ~, actIsValid] = parser.vectorizeLinComb( ...
    '1+xx-2*log(y)', ...
    {'a','b','x','c','log(y)'} ...
    );
expIsValid = false;
assertEqual(this, actIsValid, expIsValid);
end




function testLinComb2Vec2(this)
[actZ, actC, actIsValid] = parser.vectorizeLinComb( ...
    {'1+x-2*log(y)','a+a+b+a'}, ...
    {'a','b','x','c','log(y)'} ...
    );
expZ = [ 0,0,1,0,-2; 3,1,0,0,0 ];
expC = [ 1; 0 ];
expIsValid = [true,true];
assertEqual(this, actZ, expZ);
assertEqual(this, actC, expC);
assertEqual(this, actIsValid, expIsValid);
end