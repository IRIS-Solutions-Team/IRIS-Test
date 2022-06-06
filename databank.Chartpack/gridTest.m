
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

d = struct();
d.x = Series(qq(2020,1:40), @rand);
d.y = Series(qq(2020,1:40), @rand);
d.z = Series(qq(2020,1:40), @rand);

%% Test default grid

ch = databank.Chartpack();
ch.Range = qq(2020,1:40);
%ch.FigureSettings = {"visible", "off"};
%ch.ShowFigure = NaN;

add(ch, ["x", "y", "z"]);
info = draw(ch, d);
for i = 1 : 3
    assertTrue(testCase, get(info.AxesHandles{1}(i), "XGrid")=="on");
    assertTrue(testCase, get(info.AxesHandles{1}(i), "YGrid")=="on");
end
%visual.hlegend('bottom', 'xxxxx');

%close all


%% Test xGrid off

ch = databank.Chartpack();
ch.Range = qq(2020,1:40);
ch.FigureSettings = {"visible", "off"};
ch.ShowFigure = NaN;
ch.Grid = [false, true];

add(ch, ["x", "y", "z"]);
info = draw(ch, d);
for i = 1 : 3
    assertTrue(testCase, get(info.AxesHandles{1}(i), "XGrid")=="off");
    assertTrue(testCase, get(info.AxesHandles{1}(i), "YGrid")=="on");
end

close all


%% Test yGrid off

ch = databank.Chartpack();
ch.Range = qq(2020,1:40);
ch.FigureSettings = {"visible", "off"};
ch.ShowFigure = NaN;
ch.Grid = [true, false];

add(ch, ["x", "y", "z"]);
info = draw(ch, d);
for i = 1 : 3
    assertTrue(testCase, get(info.AxesHandles{1}(i), "XGrid")=="on");
    assertTrue(testCase, get(info.AxesHandles{1}(i), "YGrid")=="off");
end

close all


%% Test all off

ch = databank.Chartpack();
ch.Range = qq(2020,1:40);
ch.FigureSettings = {"visible", "off"};
ch.ShowFigure = NaN;
ch.Grid = false;

add(ch, ["x", "y", "z"]);
info = draw(ch, d);
for i = 1 : 3
    assertTrue(testCase, get(info.AxesHandles{1}(i), "XGrid")=="off");
    assertTrue(testCase, get(info.AxesHandles{1}(i), "YGrid")=="off");
end

close all

