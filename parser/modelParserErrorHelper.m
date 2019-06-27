function modelParserErrorHelper(code, expId, varargin)
    testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
    posLast = find(expId==':', 1, 'last');
    fileName = [ strrep(expId(posLast+1:end), ':', ''), '.model' ];
    char2file(code, fileName);
    rehash( );
    actId = '';
    try
        model(fileName, varargin{:});
    catch exc
        actId = exc.identifier;
    end
    expId = exception.Base.underscore2capital(expId);
    try
        assertEqual(testCase, actId, ['IRIS:',expId]);
    catch
        model(fileName, varargin{:});
    end
end%


