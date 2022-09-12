%% Uncertainty bands report example

%#ok<*VUNUS>

clear
close all


%% Generate data 

%
% This is the point simulation
%

startDate = qq(2020,1);
endDate = startDate + 19;

d = struct();
d.x = Series(startDate:endDate, cumsum(randn(20,1)));
d.y = Series(startDate:endDate, cumsum(randn(20,1)));


%
% This is the Monte Carlo simulation with 10,000 draws (columns)
%
dmc = struct();
dmc.x = d.x + Series(startDate:endDate, randn(20,10000))*0.5 * Series(startDate:endDate, (0:19)');
dmc.y = d.y + Series(startDate:endDate, randn(20,10000))*0.5 * Series(startDate:endDate, (0:19)');


%% Calculate distributional characteristics

%
% Calculate 5th, 25th, 75th, 95th percentiles
% The resulting series have 4 columns, one for each percentile
% and hence, e.g., d.x_5_25_75_95{:,3} is a time series with the 75th
% percentile
%
d.x_5_25_75_95 = prctile(dmc.x, [5, 20, 80, 95], 2);
d.y_5_25_75_95 = prctile(dmc.y, [5, 20, 80, 95], 2);


%
% Calculate std deviations
%
d.x_std = std(dmc.x, 0, 2);
d.y_std = std(dmc.y, 0, 2);



% Create report 

delete bandsTest.*.html

report = rephrase.Report("Uncertainty bands example");

grid1 = rephrase.Grid("Grrrrrrrid", [], 2, "pass", {"showTitle", true, "dateFormat", "YYYY:Q"});

    highlight1 = rephrase.Highlight(-Inf, qq(2020,4), "line", struct("width", 3 , "color", "#ff0000"));
    highlight2 = rephrase.Highlight(qq(2023,2), Inf, "fillColor", [0, 100, 200, 0.1]);

    % Two bands covering the area of the (25,75)-th percentiles and the (5,95)-th percentiles
    % rephrase.Bands(title, lower, upper, relation, options___)
    %
    % * relation="absolute" means plot [lower, mid, upper]
    %   relation="relative" means plot [mid-lower, mid, mid+upper]
    %
    % * option "alpha" means the RGB opacity of the area color between 1
    % and 0 (1 means the same color as the mid point line, 0 means white
    % line)
    %
    b1 = rephrase.Bands("25th to 75th percentile", d.x_5_25_75_95{:,2}, d.x_5_25_75_95{:,3}, "absolute", "alpha", 0.50);
    b2 = rephrase.Bands("5th to 95th percentile", d.x_5_25_75_95{:,1}, d.x_5_25_75_95{:,4}, "absolute", "alpha", 0.30);

    chart1 = rephrase.Chart("Chart 1", startDate:endDate, "highlight", {highlight1, highlight2}) ...
        + rephrase.Series("Series X", d.x, "bands", {b1, b2}) ...
    ;

    b1 = rephrase.Bands("+/– sigma", d.y_std, d.y_std, "relative", "alpha", 0.30);
    chart2 = rephrase.Chart("Chart 2", startDate:endDate) ...
        + rephrase.Series("Series Y", d.y, "bands", b1) ...
    ;


report + (grid1 + chart1 + chart2);


show(report)


fileNames = build( ...
    report, "bandsTest", [] ...
    , "saveJSON", true ...
    , "source", ["web", "bundle"] ...
    , "colorScheme", "colorScheme.json" ...
);

