rph = rephrase.Report("Test Report Title" ... 
    , "interactiveCharts", true ... % make it `false` for huge reports
  );

rphData = struct();
plotRng = qq(2010,1:22);
rphData.ser1 = Series(plotRng, @randn);
rphData.ser2 = Series(plotRng, @randn);
rphData.ser3 = Series(plotRng, @randn);

chart1 = ...
  rephrase.Chart("Chart 1", plotRng(1), plotRng(end), "DateFormat", "YY[Q]QQ") ...
    < rephrase.Series("Series 1", rphData.ser1) ...
    < rephrase.Series("Series 2", rphData.ser2);

chart2 = ...
  rephrase.Chart("Chart 2", plotRng(1), plotRng(end), "ShowLegend", false) ...
    < rephrase.Series("", rphData.ser3);

pager = rephrase.Pager("Pager Title", "StartPage", 2) < chart1 < chart2;

rph = rph < pager;

d = string(fileparts(mfilename('fullpath')));
fname = fullfile(d, "tst-report");
src = "web";
% src = "local";
% src = "bundle";
build(rph, fname, rphData, "source", src, "saveJson", true);
% web("file://" + fname + "." + src + ".html", "-browser");

