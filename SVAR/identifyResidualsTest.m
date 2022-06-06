

rng(0);

% Entire range
range = qq(2010,1):qq(2021,4);

% End of pre-covid 
t = qq(2019,4);

% Order of the VAR
p = 2;

% Generate artificial data
d = struct();
d.x = Series(range(1)-p:range(end), 0);
d.y = Series(range(1)-p:range(end), 0);
d.x = arf(d.x, [1, -1.1, 0.3], Series(range, @randn), range);
d.y = arf(d.y, [1, -1.1, 0.3], Series(range, @randn), range);

%% Test

% Estimate a reduced-form VAR on the pre-covid sample
rv = VAR({'x', 'y'}, "order", p);
[rv, rdb] = estimate(rv, d, range(1):t);

% Convert to structural VAR (still based on pre-covid)
[sv, sdb] = SVAR(rv, rdb, "ordering", ["y", "x"]);


% Apply the pre-covid models to obtain reduced-form and structural residuals
% on the entire sample
%
% Running a filter with the input database containing all observations on the
% entire sample simple reduces to calculating the residuals
%
[~, fr] = filter(rv, d, range(1):t, "meanOnly", true);
[~, fs] = filter(sv, d, range(1):t, "meanOnly", true);


