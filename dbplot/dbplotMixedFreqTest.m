function tests = dbplotMixedFreqTest( )
tests = functiontests(localfunctions);
end%


function setupOnce(this)
    close all
    this.TestData.Visible = 'off';
end%


function testBothInf(this)
    if verLessThan('matlab', '9.1')
        return
    end
    d = struct( );
    d.x = Series(qq(2000,1), randn(40, 4));
    d.y = Series(mm(2000,1), randn(120, 4));
    [ff, aa] = dbplot(d, Inf, {'x', 'y'}, 'Figure=', {'Visible=', this.TestData.Visible});
    xLim1 = get(aa{1}(1), 'XLim');
    xLim2 = get(aa{1}(2), 'XLim');
    assertEqual(this, xLim1(1), datetime(qq(2000,1)));
    assertEqual(this, xLim1(2), datetime(qq(2009,'end')));
    assertEqual(this, xLim2(1), datetime(mm(2000,1)));
    assertEqual(this, xLim2(2), datetime(mm(2009,'end')));
end%


function testOneRange(this)
    if verLessThan('matlab', '9.1')
        return
    end
    d = struct( );
    d.x = Series(qq(2000,1), randn(40, 4));
    d.y = Series(mm(2000,1), randn(120, 4));
    [ff, aa] = dbplot(d, qq(2001,1:8), {'x', 'y'}, 'Figure=', {'Visible=', this.TestData.Visible});
    xLim1 = get(aa{1}(1), 'XLim');
    xLim2 = get(aa{1}(2), 'XLim');
    assertEqual(this, xLim1(1), datetime(qq(2001,1)));
    assertEqual(this, xLim1(2), datetime(qq(2002,'end')));
    assertEqual(this, xLim2(1), datetime(mm(2000,1)));
    assertEqual(this, xLim2(2), datetime(mm(2009,'end')));
end%


function testBothRange(this)
    if verLessThan('matlab', '9.1')
        return
    end
    d = struct( );
    d.x = Series(qq(2000,1), randn(40, 4));
    d.y = Series(mm(2000,1), randn(120, 4));
    [ff, aa] = dbplot(d, {qq(2001,1:8), mm(2001,1:12)}, {'x', 'y'}, 'Figure=', {'Visible=', this.TestData.Visible});
    xLim1 = get(aa{1}(1), 'XLim');
    xLim2 = get(aa{1}(2), 'XLim');
    assertEqual(this, xLim1(1), datetime(qq(2001,1)));
    assertEqual(this, xLim1(2), datetime(qq(2002,'end')));
    assertEqual(this, xLim2(1), datetime(mm(2001,1)));
    assertEqual(this, xLim2(2), datetime(mm(2001,'end')));
end%


function teardownOnce(this)
    close all
end%
