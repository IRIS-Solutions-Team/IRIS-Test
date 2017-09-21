
assertWithinTol = @(x) assert(all(abs(x(:))<=1e-10));
assertOutsideTol = @(x) assert(all(abs(x(:))>1e-10));

m = model('lhsmrhsTest.model');
m.x_bar = 1;
m.dy_bar = 0.5;
m.dz_bar = 2;
m.x = m.x_bar;
m.y = 0 + 1i*m.dy_bar;
m.z = 10 + 1i*m.dz_bar;

%% Test CHKSSTATE

flag = chksstate(m, 'Kind=', 'Steady');
assert(flag);
flag = chksstate(m, 'Kind=', 'Dynamic');
assert(flag);

%% Test CHKSSTATE with Mulitiple Variants

m2 = alter(m, 20);
m2.z(2) = 11 + 2i;

flag = chksstate(m2, 'Kind=', 'Steady', 'Error=', false);
assert( all(flag([1, 3:20])) );
assert( ~flag(2) );
flag = chksstate(m2, 'Kind=', 'Dynamic');
assert( all(flag) );

%% Test LHSMRHS with Steady-State Databank Integer Frequency

range = 1 : 10;
d = sstatedb(m, range);
dcy = lhsmrhs(m, d, range, 'Kind=', 'Dynamic');
assertWithinTol(dcy);

dcy = lhsmrhs(m, d, range, 'Kind=', 'Steady');
assertWithinTol(dcy(1:2, :));
assertOutsideTol(dcy(3, :));


%% Test LHSMRHS with Steady-State Databank Quarterly Frequency

range = qq(2000, 1) : qq(2003, 4);
d = sstatedb(m, range);
dcy = lhsmrhs(m, d, range, 'Kind=', 'Dynamic');
assertWithinTol(dcy);

dcy = lhsmrhs(m, d, range, 'Kind=', 'Steady');
assertWithinTol(dcy(1:2, :));
assertOutsideTol(dcy(3, :));


%% Test LHSMRHS with Random Databank Integer Frequency

range = 1 : 20;
d = sstatedb(m, range, 'ShockFunc=', @randn);

eqtn = get(m, 'Eqtn:Dynamic');
actualDcy = lhsmrhs(m, d, range, 'Kind=', 'Dynamic');
for i = 1 : length(eqtn)
    expectedDcy = dbeval(d, m, eqtn{i});
    expectedDcy = -expectedDcy(range).';
    assert(isequal(size(actualDcy(i, :)), size(expectedDcy)));
    assertWithinTol(actualDcy(i, :) - expectedDcy(range));
end

eqtn = get(m, 'Eqtn:Steady');
actualDcy = lhsmrhs(m, d, range, 'Kind=', 'Steady');
for i = 1 : length(eqtn)
    expectedDcy = dbeval(d, m, eqtn{i});
    expectedDcy = -expectedDcy(range).';
    assert(isequal(size(actualDcy(i, :)), size(expectedDcy)));
    assertWithinTol(actualDcy(i, :) - expectedDcy);
end


%% Test LHSMRHS with Random Databank Integer Frequency Multiple Variants

m2 = alter(m, 2);
m2.x_bar(2) = m2.x_bar(2) + 1;
m2.dy_bar(2) = m2.dy_bar(2) + 1;
m2.x = m2.x_bar;
m2.y = 0 + 1i*m2.dy_bar;
m2.z = 10 + 1i*m2.dz_bar;

range = mm(2000, 1) : mm(2010, 12);
d = sstatedb(m2, range, 'ShockFunc=', @randn);
actualDcy = lhsmrhs(m2, d, range, 'Kind=', 'Dynamic');
eqtn = get(m2, 'Eqtn:Dynamic');
for v = 1 : length(m2)
    for i = 1 : length(eqtn)
        expectedDcy = dbeval(dbcol(d, v),  m2(v), eqtn{i});
        expectedDcy = -expectedDcy(range).';
        assert(isequal(size(actualDcy(i, :, v)), size(expectedDcy)));
        assertWithinTol(actualDcy(i, :, v) - expectedDcy);
    end
end
