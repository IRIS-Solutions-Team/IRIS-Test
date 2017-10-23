function tests = tseriesTest( )
tests = functiontests(localfunctions( ));
end




function setupOnce(this) %#ok<*DEFNU>
this.TestData.x = tseries(qq(1, 1):qq(3, 2), sin(1:10));
this.TestData.absTol = eps( )^(2/3);
this.TestData.IsStats = ~isempty(ver('stats'));
end




function testWrongFreqConcat(this)
a = tseries(dd(1, 1, 1), 1);
b = tseries(qq(2, 2), 2);
assertError(this, @( )[a, b], 'IRIS:Series:CannotCatMixedFrequencies');
assertError(this, @( )[a; b], 'IRIS:Series:CannotCatMixedFrequencies');
end




function testCat(this)
a = tseries(qq(1, 1), 1);
b = tseries(qq(1, 1), 2);
assertEqual(this, double([a, b]), [double(a), double(b)], ....
    'absTol', this.TestData.absTol);

b = tseries(qq(1, 2), 2);
assertEqual(this, double([a; b]), [double(a); double(b)], ...
    'absTol', this.TestData.absTol);
end




function testEmpty(~)
x = tseries( );
Assert.equaln(x.Start, DateWrapper(NaN));
Assert.equaln(x.End, DateWrapper(NaN));
x = tseries.empty(0, 2, 3);
Assert.equal(x.Data, double.empty(0, 2, 3));
Assert.equaln(x.Start, DateWrapper(NaN));
x = tseries.empty([0, 2, 3]);
Assert.equal(x.Data, double.empty(0, 2, 3));
Assert.equaln(x.Start, DateWrapper(NaN));
end




function testGet(~)
sdate = qq(2010,1);
edate = qq(2011,2);
x = tseries(sdate:edate, 1) ;
Assert.equal(get(x,'start'), sdate);
Assert.equal(get(x,'end'), edate);
end




function testAssign(this) 
x = tseries( );
x(1:5) = 2 : 6 ;
assertEqual(this, double(x), (2:6)');
assertEqual(this, range(x), DateWrapper(1:5));
end




function testSubsindex(this)
x = this.TestData.x ;
assertEqual(this, x(:), double(x));
end




function testDetrend(this)
x = this.TestData.x ;
actual = double(detrend(x));
expected = [ ...
    0
    0.221770008206370
   -0.392463844370859
   -1.136442781550070
   -1.184620994716695
   -0.351168652063897
    0.739177011042403
    1.225492225135581
    0.802196029942541
    0 ...
    ];
assertEqual(this, actual, expected, 'absTol', this.TestData.absTol);
end




function testIsScalar(this)
assertEqual(this, isscalar(tseries(1, 1)), true);
assertEqual(this, isscalar(tseries(1:2, 1)), true);
assertEqual(this, isscalar(tseries(1, [1 2])), false);
end




function testRound(this)
x = this.TestData.x ;
assertEqual(this, double(round(x)), round(double(x)));
end





function testBxsfun(this)
x = this.TestData.x ;
assertEqual(this, double(bsxfun(@max, x, 0)), bsxfun(@max, double(x), 0));
end




function testAcf(this)
x = this.TestData.x ;
assertEqual(this, acf(x), var(x), 'absTol', this.TestData.absTol);
end




function testMean(this)
x = this.TestData.x ;
assertEqual(this, mean(x), 0.141118837121801, ...
    'absTol', this.TestData.absTol);
end




function testHpf(this)
x = this.TestData.x;

actual = double(hpf(x)); 
expected = [ ...
    0.332158721583314
    0.287235347551190
    0.242630293683581
    0.199050668944550
    0.157140138369643
    0.116944958766749
    0.077813846685613
    0.038847793390374
   -0.000490226884807
   -0.040143170872499 ...
   ];
assertEqual(this, actual, expected, 'absTol', this.TestData.absTol);

actual = double(hpf2(x));
expected = [ ... 
    0.509312263224583
    0.622062079274492
   -0.101510285623714
   -0.955853164252478
   -1.116064413032781
   -0.396360456965675
    0.579172752033176
    0.950510453233008
    0.412608712126564
   -0.503877940016871];
assertEqual(this, actual, expected, 'absTol', this.TestData.absTol);
end




function testIsempty(this)
assertEqual(this, isempty(tseries( )), true);
assertEqual(this, isempty(tseries(1, 1)), false);
end




function testRedate(this)
x = this.TestData.x;
actual = range(redate(x, qq(1, 1), qq(2, 2)));
expected = qq(2, 2) : qq(4, 3);
assertEqual(this, actual, expected, 'absTol', this.TestData.absTol);
end




function testPrctile(this)
    if this.TestData.IsStats
        d = rand(50, 5, 10, 8);
        d(1, 1, 1, 1) = NaN;
        d(20, :, :, :) = NaN;
        x = tseries(1:size(d, 1), d);
        p = [0, 10, 28, 50, 76, 100];

        expPrctile = cell(1, 6);
        actPrctile = cell(1, 6);

        % Run dimensions beyond ndims(d).
        for i = 1 : 6
            % Stat Tbx.
            expPrctile{i} = prctile(d, p, i);

            % IRIS prctile implementation.
            aux = prctile(x, p, i);
            if i > 1
                aux = aux.data;
            end
            actPrctile{i} = aux;
        end

        assertEqual( ...
            this, actPrctile, expPrctile, ...
            'AbsTol', 1e-15, 'RelTol', 1e-15 ...
        );
    end
end




function testConvert(this)
x = tseries(mm(2000, 1:12), 1:12);
xMean = convert(x, 4, 'Method=', @mean);
xFirst1 = convert(x, 4, 'Method=', 'first');
xFirst2 = convert(x, 4, 'Method=', @first);
xLast1 = convert(x, 4, 'Method=', 'last');
xLast2 = convert(x, 4, 'Method=', @last);
actMean = xMean(:);
actFirst1 = xFirst1(:);
actFirst2 = xFirst2(:);
actLast1 = xLast1(:);
actLast2 = xLast2(:);
assertEqual(this, actMean, [2;5;8;11]);
assertEqual(this, actFirst1, [1;4;7;10]);
assertEqual(this, actFirst2, [1;4;7;10]);
assertEqual(this, actLast1, [3;6;9;12]);
assertEqual(this, actLast2, [3;6;9;12]);
end




function testSubsref(this)
si = 1;
sq = qq(2000, 1);
sw = ww(2000, 1);
xi = tseries(si, (1:10).');
xq = tseries(sq, (1:10).');
xw = tseries(sw, (1:10).');
assertEqual( this, xi{-1}, tseries(si+1, (1:10).') );
assertEqual( this, xq{-1}, tseries(sq+1, (1:10).') );
assertEqual( this, xw{-1}, tseries(sw+1, (1:10).') );
assertEqual( this, xi{1}, tseries(si-1, (1:10).') );
assertEqual( this, xq{1}, tseries(sq-1, (1:10).') );
assertEqual( this, xw{1}, tseries(sw-1, (1:10).') );
assertEqual( this, xi{1:5}, tseries(1, (1:5).') );
assertEqual( this, xi{-1}{si+1+(0:4)}, tseries(si+1, (1:5).') );
assertEqual( this, xq{-1}{sq+1+(0:4)}, tseries(sq+1, (1:5).') );
assertEqual( this, xw{-1}{sw+1+(0:4)}, tseries(sw+1, (1:5).') );
assertEqual( this, xi{1}{si-1+(0:4)}, tseries(si-1, (1:5).') );
assertEqual( this, xq{1}{sq-1+(0:4)}, tseries(sq-1, (1:5).') );
assertEqual( this, xw{1}{sw-1+(0:4)}, tseries(sw-1, (1:5).') );
end
