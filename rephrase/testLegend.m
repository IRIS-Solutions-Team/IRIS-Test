
drawnow();
close all
clear
rehash path

folder = string(mfilename());
mkdir(folder)


startDate = qq(2020,1);
endDate = qq(2025,4);
d = struct();
d.x = Series(startDate:endDate, @rand);
d.y = Series(startDate:endDate, @rand);
d.z = Series(startDate:endDate, @rand);

r = rephrase.Report("Legend Test");

markers = struct('Symbol', "square", 'Size', 20);

g1 = rephrase.Grid("Grid 1", 2, 2, "pass", {"dateFormat", "Y_QQ"});

g1 = g1 + rephrase.SeriesChart.fromSeries( ...
    {"Chart 1.1", startDate:endDate, "pass", {"markers", struct('Size', 20)}} ...
    , {"x", d.x, "stackGroup", "1", "fill", "tonexty", "fillColor","half-transparent"} ...
    , {"y", d.y, "stackGroup", "1", "fill", "tonexty", "fillColor","half-transparent"} ...
    , {"z", d.z, "stackGroup", "1", "fill", "tonexty"} ...
);

g1 = g1 + rephrase.SeriesChart.fromSeries( ...
    {"Chart 1.2", startDate:endDate, "displayTitle", false, "DateFormat", "YYYY-MM-DD", "showLegend", false} ...
    , {"x", -d.x, "showLegend", false, "color", [0,0,1]} ...
    , {"y", -d.y, "lineWidth", 0} ...
    , {"z", -d.z} ...
);

r = r + g1;

finalize(r, rephrase.Counter());

show(r)



build(r, fullfile(folder, "report"), d, "saveJSON", true, "source", "web");

