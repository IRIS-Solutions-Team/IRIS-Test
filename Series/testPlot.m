function tests = tseriesFilterTest()
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
    list = fieldnames(this.TestData);
    for i = 1 : numel(list)
        x = this.TestData.(list{i});
        if isa(x, 'Series')
            figure('Visible', 'off');
            h = plot(x, 'DateFormat=', 'uuuu');
            dt = h.XData;
            assertEqual(this, dt.Format, 'uuuu');
            close(gcf( ));
        end
    end
end%

