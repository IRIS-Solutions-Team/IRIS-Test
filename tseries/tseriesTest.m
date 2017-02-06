function Tests = tseriesTest()
Tests = functiontests(localfunctions);
end


%**************************************************************************


function setupOnce(This) %#ok<*DEFNU>
This.TestData.x = tseries(qq(1,1):qq(3,2),sin(1:10));
This.TestData.absTol = eps()^(2/3);
end % setupOnce()


%**************************************************************************


function testWrongFreqConcat(This)
a = tseries(dd(1,1,1),1);
b = tseries(qq(2,2),2);
assertError(This, @()[a,b], 'IRIS:tseries:catcheck');
assertError(This, @()[a;b], 'IRIS:tseries:catcheck');
end % testWrongFreqConcat()


%**************************************************************************


function testCat(This)
a = tseries(qq(1,1),1);
b = tseries(qq(1,1),2);
assertEqual(This, double([a, b]), [double(a), double(b)], ....
    'absTol', This.TestData.absTol);

b = tseries(qq(1,2),2);
assertEqual(This, double([a; b]), [double(a); double(b)], ...
    'absTol', This.TestData.absTol);
end % testCat()


%**************************************************************************


function testEmpty(This)
x = tseries();
assertEqual(This, startdate(x), NaN);
assertEqual(This, enddate(x), NaN);
end % testEmpty()


%**************************************************************************


function testAssign(This) 
x = tseries();
x(1:5) = 2 : 6 ;
assertEqual(This, double(x), (2:6)');
assertEqual(This, range(x), 1:5);
end % testAssign()


%**************************************************************************


function testSubsindex(This)
x = This.TestData.x ;
assertEqual(This, x(:), double(x));
end % testSubsindex()


%**************************************************************************


function testDetrend(This)
x = This.TestData.x ;
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
assertEqual(This, actual, expected, 'absTol', This.TestData.absTol);
end % testDetrend()


%**************************************************************************


function testIsScalar(This)
assertEqual(This, isscalar(tseries(1, 1)), true);
assertEqual(This, isscalar(tseries(1:2, 1)), true);
assertEqual(This, isscalar(tseries(1, [1 2])), false);
end % testIsScalar()


%**************************************************************************


function testRound(This)
x = This.TestData.x ;
assertEqual(This, double(round(x)), round(double(x)));
end % testRound



%**************************************************************************


function testBxsfun(This)
x = This.TestData.x ;
assertEqual(This, double(bsxfun(@max, x, 0)), bsxfun(@max, double(x), 0));
end % testBxsfun()


%**************************************************************************


function testAcf(This)
x = This.TestData.x ;
assertEqual(This, acf(x), var(x), 'absTol', This.TestData.absTol);
end % testAcf


%**************************************************************************


function testMean(This)
x = This.TestData.x ;
assertEqual(This, mean(x), 0.141118837121801, ...
    'absTol', This.TestData.absTol);
end % testMean()


%**************************************************************************


function testHpf(This)
x = This.TestData.x;

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
assertEqual(This, actual, expected, 'absTol', This.TestData.absTol);

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
assertEqual(This, actual, expected, 'absTol', This.TestData.absTol);
end % testHpf()


%**************************************************************************


function testIsempty(This)
assertEqual(This, isempty(tseries()), true);
assertEqual(This, isempty(tseries(1,1)), false);
end % testIsempty


%**************************************************************************


function testRedate(This)
x = This.TestData.x;
actual = range(redate(x,qq(1,1),qq(2,2)));
expected = qq(2,2) : qq(4,3);
assertEqual(This, actual, expected, 'absTol', This.TestData.absTol);
end % testRedate


%**************************************************************************


function testPrctile(This)
d = rand(50,5,10,8);
d(1,1,1,1) = NaN;
d(20,:,:,:) = NaN;
x = tseries(1:size(d,1),d);
p = [0,10,28,50,76,100];

expPrctile = cell(1,6);
actPrctile = cell(1,6);

% Run dimensions beyond ndims(d).
for i = 1 : 6
    % Stat Tbx.
    expPrctile{i} = prctile(d,p,i);

    % IRIS prctile implementation.
    aux = prctile(x,p,i);
    if i > 1
        aux = aux.data;
    end
    actPrctile{i} = aux;
end

assertEqual(This, actPrctile, expPrctile, ...
    'AbsTol', 1e-15, 'RelTol', 1e-15);
end


%**************************************************************************


function testConvert(This)
x = tseries(mm(2000,1:12),1:12);
xMean = convert(x,4,'method=',@mean);
xFirst1 = convert(x,4,'method=','first');
xFirst2 = convert(x,4,'method=',@first);
xLast1 = convert(x,4,'method=','last');
xLast2 = convert(x,4,'method=',@last);
actMean = xMean(:);
actFirst1 = xFirst1(:);
actFirst2 = xFirst2(:);
actLast1 = xLast1(:);
actLast2 = xLast2(:);
assertEqual(This, actMean, [2;5;8;11]);
assertEqual(This, actFirst1, [1;4;7;10]);
assertEqual(This, actFirst2, [1;4;7;10]);
assertEqual(This, actLast1, [3;6;9;12]);
assertEqual(This, actLast2, [3;6;9;12]);
end % testConvert()


%**************************************************************************


function testSubsref(This)
si = 1;
sq = qq(2000,1);
sw = ww(2000,1);
xi = tseries(si,(1:10).');
xq = tseries(sq,(1:10).');
xw = tseries(sw,(1:10).');
assertEqual( This, xi{-1}, tseries(si+1,(1:10).') );
assertEqual( This, xq{-1}, tseries(sq+1,(1:10).') );
assertEqual( This, xw{-1}, tseries(sw+1,(1:10).') );
assertEqual( This, xi{1}, tseries(si-1,(1:10).') );
assertEqual( This, xq{1}, tseries(sq-1,(1:10).') );
assertEqual( This, xw{1}, tseries(sw-1,(1:10).') );
assertEqual( This, xi{1:5}, tseries(1,(1:5).') );
assertEqual( This, xi{-1}{si+1+(0:4)}, tseries(si+1,(1:5).') );
assertEqual( This, xq{-1}{sq+1+(0:4)}, tseries(sq+1,(1:5).') );
assertEqual( This, xw{-1}{sw+1+(0:4)}, tseries(sw+1,(1:5).') );
assertEqual( This, xi{1}{si-1+(0:4)}, tseries(si-1,(1:5).') );
assertEqual( This, xq{1}{sq-1+(0:4)}, tseries(sq-1,(1:5).') );
assertEqual( This, xw{1}{sw-1+(0:4)}, tseries(sw-1,(1:5).') );
end % testSubsref()
