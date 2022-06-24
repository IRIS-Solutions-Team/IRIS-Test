

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% setupOnce %#ok<*DEFNU>

    x = randn(40, 1);
    testCase.TestData.Yearly = Series(yy(2000), x);
    testCase.TestData.HalfYearly = Series(hh(2000), x);
    testCase.TestData.Quarterly = Series(qq(2000), x);
    testCase.TestData.Monthly = Series(qq(2000), x);
    testCase.TestData.Weekly = Series(ww(2000), x);
    testCase.TestData.Daily = Series(dd(2000), x);
%


%% testPlainPlot

    list = fieldnames(testCase.TestData);
    for i = 1 : numel(list)
        x = testCase.TestData.(list{i});
        if isa(x, 'Series')
            figure('Visible', 'off');
            plot(x);
            close(gcf( ));
        end
    end
    close all

%


%% testPlotAxesRange

    
    list = fieldnames(testCase.TestData);
    for i = 1 : numel(list)
        x = testCase.TestData.(list{i});
        if isa(x, 'Series')
            range = x.Range;
            figure('Visible', 'off');
            plot(range, x);
            close(gcf( ));
            figure('Visible', 'off');
            plot(range(2:end-1), x);
            close(gcf( ));
            figure('Visible', 'off');
            plot(gca( ), x);
            close(gcf( ));
            figure('Visible', 'off');
            plot(gca( ), range(2:end-1), x);
            close(gcf( ));
        end
    end
    close all

%


%% testDateFormat

    list = fieldnames(testCase.TestData);
    for i = 1 : numel(list)
        x = testCase.TestData.(list{i});
        if isa(x, 'Series')
            figure('Visible', 'off');
            h = plot(x, 'DateFormat', 'uuuu');
        end
    end

    close all

%


%% testBar
    
    q = Series(qq(2000), rand(40,1));
    figure('Visible', 'off');
    plot(q);
    handleAxes = gca( );
    xLim1 = handleAxes.XLim;
    hold on;
    bar(q);
    xLim2 = handleAxes.XLim;
    assertLessThan(testCase, xLim2(1), xLim1(1));
    assertGreaterThan(testCase, xLim2(2), xLim1(2));
    
    close all

%




