function tests = behaviorTest( )
tests = functiontests(localfunctions);
end


function setupOnce(this)
    this.TestData.Model = model('behaviorTest.model');
end


function testLogStyleInSolutionVectors(this)
    m = this.TestData.Model;
    actualVector = get(m, 'XVector');
    expectedVector = {'log_x'; 'log_y'; 'z'};
    this.assertEqual(actualVector, expectedVector);
    m = set(m, 'Behavior:LogStyleInSolutionVectors', 'log()');
    actualVector = get(m, 'XVector');
    expectedVector = {'log(x)'; 'log(y)'; 'z'};
    this.assertEqual(actualVector, expectedVector);
    m = set(m, 'Behavior:LogStyleInSolutionVectors', 'log_');
    actualVector = get(m, 'XVector');
    expectedVector = {'log_x'; 'log_y'; 'z'};
    this.assertEqual(actualVector, expectedVector);
end

