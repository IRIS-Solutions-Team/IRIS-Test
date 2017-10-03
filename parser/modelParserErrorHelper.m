function modelParserErrorHelper(code, expId, varargin)
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
        Assert.equal(actId, ['IRIS:',expId]);
    catch
        model(fileName, varargin{:});
    end
end


