
% Set Up

this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model('test.model', 'linear=', true);
m.std_ex = 1;
m.std_ey = 2;
m.std_ez = 1.5;
m = solve(m);
m = steady(m);

p = Plan.forModel(m, qq(2001,1):qq(2004,4));
p = anticipate(p, false, {'ex', 'x'});
p = swap(p, p.Start+(0:1), {'x', 'ex'});
p = swap(p, p.Start+(2:3), {'x', 'ex'});
p = exogenize(p, p.Start, {'y', 'z'});
p = endogenize(p, p.Start, {'ey', 'ez'});
p = exogenize(p, p.Start+1, {'y'}, 'SwapLink', 2);
p = endogenize(p, p.Start+1, {'ey'});


                                                                           
%% Test Start

p1 = p;
p1.Start = p1.Start + 1;

assertEqual(this, double(p.Start)+1, double(p1.Start), 'AbsTol', 1e-5);
assertEqual(this, double(p.End), double(p1.End), 'AbsTol', 1e-5);
for name = reshape(p.RANGE_DEPENDENT, 1, [ ])
    id = p.(name);
    id1 = p1.(name);
    id = id(:, 2:end);
    if name=="SigmasOfExogenous"
        id(:, 1, :) = NaN;
    else
        id(:, 1) = 0;
    end
    assertEqual(this, id, id1);
end

flag = false;
try
    p2 = p;
    p2.Start = p2.Start + 30;
catch 
    flag = true;
end
assertEqual(this, flag, true);


                                                                           
%% Test End

p1 = p;
p1.End = p1.End - 1;

assertEqual(this, double(p.End)-1, double(p1.End), 'AbsTol', 1e-5);
assertEqual(this, double(p.Start), double(p1.Start), 'AbsTol', 1e-5);
for name = reshape(p.RANGE_DEPENDENT, 1, [ ])
    id = p.(name);
    id1 = p1.(name);
    id = id(:, 1:end-1);
    if name=="SigmasOfExogenous"
        id(:, end) = NaN;
    else
        id(:, end) = 0;
    end
    assertEqual(this, id, id1);
end

flag = false;
try
    p2 = p;
    p2.End = p2.End - 30;
catch 
    flag = true;
end
assertEqual(this, flag, true);

