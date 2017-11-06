
close all

%% Test Implicit Current Axes 

f = figure('Visible', 'off');
a = gobjects(1, 4);
for i = 1 : 4
    a(i) = subplot(2, 2, i);
    plot(rand(10, i));
end
visual.hlegend('bottom', 'First', 'Second', 'Third', 'Fourth');

%% Test Explicit Axes 

f = figure('Visible', 'off');
a = gobjects(1, 4);
for i = 1 : 4
    a(i) = subplot(2, 2, i);
    plot(rand(10, i));
end
visual.hlegend('bottom', a(4), 'First', 'Second', 'Third', 'Fourth');

%% Test Current Axes in Figure 

f = figure('Visible', 'off');
a = gobjects(1, 4);
for i = 1 : 4
    a(i) = subplot(2, 2, i);
    plot(rand(10, i));
end
visual.hlegend('bottom', f, 'First', 'Second', 'Third', 'Fourth');

%% Test Warning When Current Axes Switched 

f = figure('Visible', 'off');
a = gobjects(1, 4);
for i = 1 : 4
    a(i) = subplot(2, 2, i);
    plot(rand(10, i));
end
lastwarn('');
warning off MATLAB:legend:IgnoringExtraEntries
set(f, 'CurrentAxes', a(1));
visual.hlegend('bottom', f, 'First', 'Second', 'Third', 'Fourth');
warning on
c = lastwarn( );
assert(strncmp(c, 'Ignoring', 8));
lastwarn('');

