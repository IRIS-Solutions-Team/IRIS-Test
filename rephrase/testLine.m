
%% Clear workspace for testing

drawnow();
close all
clear
rehash path
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test low-level "line"

startDate = qq(2020,1);
endDate = qq(2025,4);
d = struct();
d.x = Series(startDate:endDate, @rand);
d.y = Series(startDate:endDate, @rand);
d.z = Series(startDate:endDate, @rand);

r = rephrase.Report("Low-level Line Test");

g1 = rephrase.Grid("Grid 1", 2, 2, "pass", {"dateFormat", "Y_QQ"});


g1 = g1 + rephrase.SeriesChart.fromSeries( ...
    {"Chart 1.1", startDate:endDate, } ...
    , {"x", d.x, "lineDash", "dash"} ...
);

g1 = g1 + rephrase.SeriesChart.fromSeries( ...
    {"Chart 1.2", startDate:endDate, } ...
    , {"y", d.y, "line", struct("dash", "dash"), } ...
);

g1 = g1 + rephrase.SeriesChart.fromSeries( ...
    {"Chart 1.2", startDate:endDate, } ...
    , {"z", d.z, "line", struct("shape", "spline"), } ...
);

r = r + g1;


%% Build report

build(r, "testLine");


