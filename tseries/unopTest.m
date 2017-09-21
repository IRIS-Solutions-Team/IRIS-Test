function tests = tseriesTest( )
tests = functiontests(localfunctions( ));
end




function testPrctile(this)
row = 10;
col = 20;
pag = 4;
data = rand(row, col, pag);
x = tseries(1, data);

x1 = prctile(x, [30, 70], 1);
p1 = tseries.myprctile(data, [30, 70], 1);
assertEqual(this, x1, p1);
assertClass(this, x1, 'double');

x2 = prctile(x, [30, 70], 2);
p2 = tseries.myprctile(data, [30, 70], 2);
assertClass(this, x2, 'tseries');
assertEqual(this, x2.Data, p2);
assertEqual(this, x2.Comment, repmat({''}, 1, 2, pag));

x3 = prctile(x, [30, 70], 3);
p3 = tseries.myprctile(data, [30, 70], 3);
assertClass(this, x3, 'tseries');
assertEqual(this, x3.Data, p3);
assertEqual(this, x3.Comment, repmat({''}, 1, col, 2));
end
