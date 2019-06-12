function tests = emptySeriesGraphTest
tests = functiontests( localfunctions );
end%


function test_tseries(this)
    x = report.new( );
    x.figure('Figure Title');
    x.graph('Graph Title');
    x.series('Series Name', tseries( ));
    status = warning('query');
    warning('off');
    x.publish('emptySeriesGraphTest1.pdf', 'compile=', false);
    warning(status);
end%


function test_Series(this)
    x = report.new( );
    x.figure('Figure Title');
    x.graph('Graph Title');
    x.series('Series Name', Series( ));
    status = warning('query');
    warning('off');
    x.publish('emptySeriesGraphTest2.pdf', 'compile=', false);
    warning(status);
end%

