
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

d = struct();
d.x = Series(qq(2020,1:40), @rand);
d.y = Series(qq(2020,1:40), @rand);
d.z = Series(qq(2020,1:40), @rand);

%% Test add

for obj = {Chartpack(), databank.Chartpack()}
    ch = obj{:}; 
    ch.Range = qq(2020,1:40);
    ch.FigureSettings = {"visible", "off"};
    ch.ShowFigure = NaN;

    add(ch, ["x", "y"]);
    info = draw(ch, d);
    assertEqual(testCase, numel(ch.Charts), 2);
    assertEqual(testCase, numel(info.AxesHandles{1}), 2);

    add(ch, "z");
    info = draw(ch, d);
    assertEqual(testCase, numel(ch.Charts), 3);
    assertEqual(testCase, numel(info.AxesHandles{1}), 3);

    drawnow();
    close all
end


%% Test string

for obj = {Chartpack(), databank.Chartpack()}
    ch = obj{:}; 
    ch.Range = qq(2020,1:40);
    ch.FigureSettings = {"visible", "off"};
    ch.ShowFigure = NaN;

    ch.Charts = ["x", "y"];
    info = draw(ch, d);
    assertEqual(testCase, numel(ch.Charts), 2);
    assertEqual(testCase, numel(info.AxesHandles{1}), 2);

    ch.Charts(end+1) = "z";
    info = draw(ch, d);
    assertEqual(testCase, numel(ch.Charts), 3);
    assertEqual(testCase, numel(info.AxesHandles{1}), 3);

    drawnow();
    close all
end

