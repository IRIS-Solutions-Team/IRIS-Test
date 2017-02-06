function Tests = findOccurrenceTest( )
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function testFindOccurrence(this)
m = model('findOccurrenceTest.model');
actOccur = get(m, 'occurrence');
expOccur = struct( );
expOccur.Dynamic = cat(3, false(9), logical(eye(9)), false(9));
expOccur.Steady = logical(eye(9));
assertEqual(this, actOccur, expOccur);
end