
%% Test nextplot(numRows, numCols)
close all;
grfun.nextplot(3, 4, 'Visible', 'off');
for i = 1 : 12
    grfun.nextplot( );
    plot(rand(10));
end
checkNumberOfFigures(1);
checkNumberOfAxes(12);
close all;

%% Test nextplot(numRows, numCols) with more than one figure
close all;
grfun.nextplot(3, 4, 'Visible', 'off');
for i = 1 : 24
    grfun.nextplot( );
    plot(rand(10));
end
checkNumberOfFigures(2);
checkNumberOfAxes(12);
close all;

%% Test nextplot([numRows, numCols])
close all;
grfun.nextplot([3, 4], 'Visible', 'off');
for i = 1 : 12
    grfun.nextplot( );
    plot(rand(10));
end
checkNumberOfFigures(1);
checkNumberOfAxes(12);
close all;

%% Test nextplot([numRows, numCols]) with more than one figure
close all;
grfun.nextplot([3, 4], 'Visible', 'off');
for i = 1 : 24
    grfun.nextplot( );
    plot(rand(10));
end
checkNumberOfFigures(2);
checkNumberOfAxes(12);
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
checkNumberOfFigures(1);
checkNumberOfAxes(expectedTotalCount);
numRows = getappdata(gcf( ), 'IRIS_NEXTPLOT_NUM_ROWS');
numColumns = getappdata(gcf( ), 'IRIS_NEXTPLOT_NUM_COLUMNS');
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
checkNumberOfFigures(2);
checkNumberOfAxes(expectedTotalCount);
close all;


function checkNumberOfFigures(expectedNumFigures)
    allFigures = get(0, 'Children');
    numFigures = numel(allFigures);
    assert(numFigures==expectedNumFigures);
end


function checkNumberOfAxes(expectedNumAxes)
    allFigures = get(0, 'Children');
    numFigures = numel(allFigures);
    for i = 1 : numFigures
        ithFigure = allFigures(i);
        allAxes = get(ithFigure, 'Children');
        numAxes = numel(allAxes);
        assert(numAxes==expectedNumAxes);
    end
end
