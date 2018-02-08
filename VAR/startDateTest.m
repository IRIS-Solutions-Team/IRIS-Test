function tests = startDateTest( )
tests = functiontests(localfunctions);
end
%#ok<*DEFNU>


function setupOnce(this)
    range = qq(2000, 1):qq(2015, 4);
    d = struct( );
    d.x = hpf2(cumsum(Series(range, @randn)));
    d.y = hpf2(cumsum(Series(range, @randn)));
    d.z = hpf2(cumsum(Series(range, @randn)));
    d.a = hpf2(cumsum(Series(range, @randn)));
    d.b = hpf2(cumsum(Series(range, @randn)));
    this.TestData.range = range;
    this.TestData.d = d;
end


function testStartDate(this)
    d = this.TestData.d;
    range = this.TestData.range;
    v1 = VAR( {'x', 'y', 'z'} );
    v2 = VAR( {'x', 'y', 'z'} );
    v3 = VAR( {'x', 'y', 'z'} );
    v1 = estimate(v1, d, range, 'Order=', 2);
    v2 = estimate(v2, d, range, 'Order=', 2, 'StartDate=', 'Presample');
    v3 = estimate(v3, d, range(3:end), 'Order=', 2, 'StartDate=', 'Fit');
    assertEqual(this, v1.A, v2.A, 'AbsTol', 1e-14);
    assertEqual(this, v1.A, v3.A, 'AbsTol', 1e-14);
end

