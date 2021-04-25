function tests = plotTest( )
tests = functiontests(localfunctions);
end%


function setupOnce(this) %#ok<*DEFNU>
    x = randn(40, 1);
    this.TestData.Yearly = Series(yy(2000), x);
    this.TestData.HalfYearly = Series(hh(2000), x);
    this.TestData.Quarterly = Series(qq(2000), x);
    this.TestData.Monthly = Series(qq(2000), x);
    this.TestData.Weekly = Series(ww(2000), x);
    this.TestData.Daily = Series(dd(2000), x);
end%


function testPlainPlot(this)
    if verLessThan('matlab', '9.1')
        return
    end

    list = fieldnames(this.TestData);
    for i = 1 : numel(list)
        x = this.TestData.(list{i});
        if isa(x, 'Series')
            figure('Visible', 'off');
            plot(x);
            close(gcf( ));
        end
    end
end%


function testPlotAxesRange(this)
    if verLessThan('matlab', '9.1')
        return
    end

    list = fieldnames(this.TestData);
    for i = 1 : numel(list)
        x = this.TestData.(list{i});
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
end%


function testDateFormat(this)
    if verLessThan('matlab', '9.1')
        return
    end

    list = fieldnames(this.TestData);
    for i = 1 : numel(list)
        x = this.TestData.(list{i});
        if isa(x, 'Series')
            figure('Visible', 'off');
            h = plot(x, 'DateFormat', 'uuuu');
            dt = h.XData;
            if isa(dt, 'datetime')
                assertEqual(this, dt.Format, 'uuuu');
            end
            close(gcf( ));
        end
    end
end%


function testBar(this)
    if verLessThan('matlab', '9.1')
        return
    end

    q = Series(qq(2000), rand(40,1));
    figure('Visible', 'off');
    plot(q);
    handleAxes = gca( );
    xLim1 = handleAxes.XLim;
    hold on;
    bar(q);
    xLim2 = handleAxes.XLim;
    assertLessThan(this, xLim2(1), xLim1(1));
    assertGreaterThan(this, xLim2(2), xLim1(2));
end%


function teardownOnce(this)
    close all
end%

