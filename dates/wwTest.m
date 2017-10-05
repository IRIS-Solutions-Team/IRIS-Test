
assertEqualTol = @(x, y) assert(all(abs(double(x) - double(y))<1e-3));
assertClass = @(x, cl) assert(isa(x, 'DateWrapper'));

%**************************************************************************
% One Input Argument

ac = ww(0);
ex = 0.52;
assertClass(ac);
assertEqualTol(ac, ex);

ac = ww(1);
ex = 52.52;
assertClass(ac);
assertEqualTol(ac, ex);

%**************************************************************************
% Two Input Arguments

ac = ww(0, 1:52);
ex = (0 : 51) + 0.52;
assertEqualTol(ac, ex);

%**************************************************************************
% Three Input Arguments

ac = ww(2017, 1, 1);
ex = ww(2016, 12, 31);
assertEqualTol(ac, ex);

ac = ww(2017, 1, 2);
assertEqualTol(ac, ex+1);

