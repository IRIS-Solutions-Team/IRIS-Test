
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test tseries
    x = report.new( );
    x.figure('Figure Title');
    x.graph('Graph Title');
    x.series('Series Name', tseries( ));
    status = warning('query');
    warning('off');
    x.publish('emptySeriesGraphTest1.pdf', 'compile', false);
    warning(status);


%% Test Series
    x = report.new( );
    x.figure('Figure Title');
    x.graph('Graph Title');
    x.series('Series Name', Series( ));
    status = warning('query');
    warning('off');
    x.publish('emptySeriesGraphTest2.pdf', 'compile', false);
    warning(status);

