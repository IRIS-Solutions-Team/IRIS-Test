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
        actId = string(exc.identifier);
    end
    expId = "IrisToolbox:" + string(exception.Base.underscore2capital(expId));
    assertEqual(testCase, actId, expId);
end%
