
%% Test nextplot(numRows, numCols)
close all;
grfun.nextplot(3, 4, 'Visible', 'off');
for i = 1 : 12
    grfun.nextplot( );
    plot(rand(10));
end
Assert.numberOfFigures(1);
Assert.numberOfAxes(12);
close all;

%% Test nextplot(numRows, numCols) with more than one figure
close all;
grfun.nextplot(3, 4, 'Visible', 'off');
for i = 1 : 24
    grfun.nextplot( );
    plot(rand(10));
end
Assert.numberOfFigures(2);
Assert.numberOfAxes(12);
close all;

%% Test nextplot([numRows, numCols])
close all;
grfun.nextplot([3, 4], 'Visible', 'off');
for i = 1 : 12
    grfun.nextplot( );
    plot(rand(10));
end
Assert.numberOfFigures(1);
Assert.numberOfAxes(12);
close all;

%% Test nextplot([numRows, numCols]) with more than one figure
close all;
grfun.nextplot([3, 4], 'Visible', 'off');
for i = 1 : 24
    grfun.nextplot( );
    plot(rand(10));
end
Assert.numberOfFigures(2);
Assert.numberOfAxes(12);
close all;

%% Test nextplot(totalCount)
close all;
expectedNumRows = 3;
expectedNumColumns = 4;
expectedTotalCount = expectedNumRows*expectedNumColumns;
grfun.nextplot(expectedTotalCount, 'Visible', 'off');
for i = 1 : 12
    grfun.nextplot( );
    plot(rand(10));
end
Assert.numberOfFigures(1);
Assert.numberOfAxes(expectedTotalCount);
numRows = getappdata(gcf( ), 'IRIS_NextNumRows');
numColumns = getappdata(gcf( ), 'IRIS_NextNumColumns');
assert(numRows==expectedNumRows);
assert(numColumns==expectedNumColumns);
close all;

%% Test nextplot(totalCount) with more than one figure
close all;
close all;
expectedNumRows = 3;
expectedNumColumns = 4;
expectedTotalCount = expectedNumRows*expectedNumColumns;
grfun.nextplot(expectedTotalCount, 'Visible', 'off');
for i = 1 : 24
    grfun.nextplot( );
    plot(rand(10));
end
Assert.numberOfFigures(2);
Assert.numberOfAxes(expectedTotalCount);
close all;


