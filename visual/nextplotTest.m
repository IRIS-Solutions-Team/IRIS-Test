
drawnow();
close all
clear
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

assertFigures = @(n) assertEqual(testCase, numel(get(0, "Children")), n);
assertAxes = @(n) assertEqual(testCase, numel(get(gcf(), "Children")), n);


%% Test nextplot(numRows, numCols)

visual.next(3, 4, 'visible', 'off');
for i = 1 : 12
    visual.next();
    plot(rand(10));
end
assertFigures(1);
assertAxes(12);
drawnow();
close all


%% Test nextplot(numRows, numCols) with more than one figure

visual.next(3, 4, 'visible', 'off');
for i = 1 : 24
    visual.next();
    plot(rand(10));
end
assertFigures(2);
assertAxes(12);
drawnow();
close all


%% Test nextplot([numRows, numCols])

visual.next([3, 4], 'Visible', 'off');
for i = 1 : 12
    visual.next();
    plot(rand(10));
end
assertFigures(1);
assertAxes(12);
drawnow();
close all


%% Test nextplot([numRows, numCols]) with more than one figure

visual.next([3, 4], 'visible', 'off');
for i = 1 : 24
    visual.next();
    plot(rand(10));
end
assertFigures(2);
assertAxes(12);
drawnow();
close all


%% Test nextplot(totalCount)

expectedNumRows = 3;
expectedNumColumns = 4;
expectedTotalCount = expectedNumRows*expectedNumColumns;
visual.next(expectedTotalCount, 'visible', 'off');
for i = 1 : 12
    visual.next();
    plot(rand(10));
end
assertFigures(1);
assertAxes(expectedTotalCount);
numRows = getappdata(gcf(), 'IRIS_NextNumRows');
numColumns = getappdata(gcf(), 'IRIS_NextNumColumns');
assertEqual(testCase, numRows, expectedNumRows);
assertEqual(testCase, numColumns, expectedNumColumns);
drawnow();
close all

%% Test nextplot(totalCount) with more than one figure

expectedNumRows = 3;
expectedNumColumns = 4;
expectedTotalCount = expectedNumRows*expectedNumColumns;
visual.next(expectedTotalCount, 'visible', 'off');
for i = 1 : 24
    visual.next();
    plot(rand(10));
end
assertFigures(2);
assertAxes(expectedTotalCount);
drawnow();
close all


