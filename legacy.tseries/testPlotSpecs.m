
% Setup once
x = tseries(qq(2000), rand(20, 4));

%% Test Line Plot with Specs Mixing Letters and Nonletters

f = figure('Visible', 'Off');
plot(x, 'b--');
close(f);

f = figure('Visible', 'Off');
h = plot(x, 'b--', 'LineWidth', 5);
assert(all([h.LineWidth]==5));
close(f);


%% Test Line Plot with Specs Containing Letters Only

f = figure('Visible', 'Off');
plot(x, 'b');
close(f);

f = figure('Visible', 'Off');
h = plot(x, 'b', 'LineWidth', 5);
assert(all([h.LineWidth]==5));
close(f);


%% Test Line Plot with Specs Containing Nonletters Only

f = figure('Visible', 'Off');
plot(x, '--');
close(f);

f = figure('Visible', 'Off');
h = plot(x, 'b', 'LineWidth', 5);
assert(all([h.LineWidth]==5));
close(f);


%% Test Bar Plot with Specs

f = figure('Visible', 'Off');
bar(x, 'stacked');
close(f);

f = figure('Visible', 'Off');
bar(x, 'grouped');
close(f);

