

close all
clear


x = Series(yy(2010):yy(2020), @rand);

r = rephrase.Report("Yearly highlight test");

h = rephrase.Highlight(yy(2015), yy(2020), "shape", struct("a",1));

g = rephrase.Grid("Grid", 1, 2);

ch1 = rephrase.SeriesChart.fromSeries( ...
    {"Chart", yy(2010), yy(2020), "highlight", h} ...
    , {"Series", x} ...
);

ch2 = rephrase.SeriesChart.fromSeries( ...
    {"Chart", yy(2010), yy(2020), "highlight", h} ...
    , {"Series", x} ...
);

g + ch1 + ch2;

r + g;

build(r, "yearlyHighlightTest", [], "source", "web", "saveJson", true);

