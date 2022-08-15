
try
    yyaxis left
catch
    return
end

drawnow();
close all

f = figure('Visible', 'off');
ax = gobjects(1, 0);
x = Series(qq(2000,1), rand(40, 1)-0.5);
for i = 1 : 4
    ax(end+1) = subplot(2, 2, i);
    yyaxis left
    plot(x);
    visual.hline(ax(i), -0.1, 'LineWidth', 2);
    visual.highlight(qq(2001,1:4));
    visual.vline(qq(2001,1), 'LineWidth', 2);
    visual.zeroline( );

    yyaxis right
    plot(x+0.1);
    visual.highlight(qq(2002,4:8));
    visual.zeroline( );

    yyaxis left
end
visual.vline(ax, qq(2007,3), 'Text', 'This is 6', 'LineWidth', 2);
visual.highlight(ax, qq(2005,1:4));
visual.zeroline(ax);
visual.hline(ax, 2);


%% Test Highlight 

try
    f;
catch
    return
end

h = findobj(f, 'Tag', 'highlight');
assert(numel(h)==12);


%% Test VLine 

try
    f;
catch
    return
end

v = findobj(f, 'Tag', 'vline');
assert(numel(v)==8);

%% Test VLine-Caption 

try
    f;
catch
    return
end

c = findobj(f, 'Tag', 'vline-caption');
assert(numel(c)==4);


%% Test ZeroLine 

try
    f;
catch
    return
end

z = findobj(f, 'Tag', 'zeroline');
assert(numel(z)==12);

%% Test HLine 

try
    f;
catch
    return
end

o = findobj(f, 'Tag', 'hline');
assert(numel(o)==8);


