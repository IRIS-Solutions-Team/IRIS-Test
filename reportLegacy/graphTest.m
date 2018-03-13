function tests = reportTexTest( )
tests = functiontests( localfunctions );
end


function testStem(this)
    d = struct( );
    d.a = tseries(qq(2001,1:40), @rand);
    d.b = tseries(qq(2001,1:40), @rand);
    x = report.new( );
    x.figure('');
    x.graph('');
    x.series('a', d.a, 'PlotFunc=', @stem);
    x.publish('testStem.pdf');
    delete testStem.pdf
end
