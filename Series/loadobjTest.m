
x = Series(1:10, @rand);
x.Start = double(x.Start);
save loadobjTest.mat x
clear x
load loadobjTest.mat x
assert(isa(x, 'Series'));
assert(isequal(class(x), 'Series'));
assert(isequal(x.Start, 1));
