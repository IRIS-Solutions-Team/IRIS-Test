function tests = graphTest( )
tests = functiontests( localfunctions );
end


function testStem(this)
    d = struct( );
    d.a = tseries(qq(2001,1:40), @rand);
    d.b = tseries(qq(2001,1:40), @rand);
    x = report.new( );
    x.figure('');
    x.graph('');
    x.series('a', d.a, 'PlotFunc', @stem);
    x.publish('testStem.pdf');
    delete testStem.pdf
end


function testBarcon(this)
    a = tseries(qq(2001,1), randn(20, 6));
    b = sum(a, 2);
    x = report.new( );
    x.figure('');
    x.graph('');
    x.series('a', a, 'PlotFunc', @barcon);
    x.series('b', b);
    x.publish('testBarcon.pdf');
    %delete testBarcon.pdf
end%
