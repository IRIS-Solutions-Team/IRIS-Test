
x = tseries(1:10, @rand);
x.Start = double(x.Start);
save loadobjTest.mat x
clear x
load loadobjTest.mat x
assert(isa(x, 'tseries'));
assert(isequal(class(x), 'tseries'));
assert(isa(x.Start, 'DateWrapper'));

