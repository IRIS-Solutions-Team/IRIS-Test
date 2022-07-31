

%% Yield curve test



r = rephrase.Report("Yield curve test");

terms = 0 : 20;

pg = rephrase.Pager("Daily progression of yield curves");

% pg = rephrase.Grid("Daily prog....", 4, 1);

for i = 1 : 4
    t1 = Termer( 1:12, cumsum(rand(12,1)) );

    t2 = Termer( 0:0.2:2, cumsum(rand(11,1)), "PaperId="+string(1000+randi(5000,11,1)) );

    yield = cumsum(rand(10, 1));
    yieldMinusSpread = yield - rand(10,1);
    t3 = Termer(1:10, [yield, yieldMinusSpread], "PaperId="+string(1:10));

    t4 = Termer(1:12, cumsum(rand(12,1)));

    ch = rephrase.CurveChart("Reporting date: "+dater.toString(dd(2022,07,01)+i), 0:2:12, "tickLabels", @(x) string(x) + "Y");

        ch + rephrase.Curve("Data w spread", t3,                              "lineWidth", 0,                "markers", struct("symbol", "square", "size", 10, "color", nan));

        ch + rephrase.Curve("Curve 1", t1);
        ch + rephrase.Curve("Curve 2", t4);

        ch + rephrase.Curve("Data 2", t2,                                     "markers", struct("color", NaN, "symbol", "x-dot", "size", 10), "lineWidth", 0);

        % Clip the t2 curve to maturities 1 year and above, and plot these
        % as squares around the existing X marks
        ch + rephrase.Curve("Data 3", clip(t2, 1, Inf), "markers", struct("color", NaN, "symbol", "square-open", "size", 14, "line", struct("width", 4)), "lineWidth", 0);

    pg + ch;
end

r + pg;


gr = rephrase.Grid("XXX", 1, 2);

fpasDates = [dd(2020,02,13), dd(2020,07,19), dd(2020,10,04)];

hi = {};
for t = fpasDates
    hi{end+1} = rephrase.Highlight(t, t, "shape", struct("fillcolor", "rgba(255,255,255,0)", "line", struct("width", 2, "color", "rgb(125,0,0)")));
end

    ch = rephrase.SeriesChart("Chart 1", mm(2020,1):mm(2020,12), "dateFormat", "YYYY-MM", "highlight", hi);
        ch + rephrase.Series("Aaaaa", Series(mm(2019,1):mm(2026,12), @rand));
        ch + rephrase.Series("Bbbbb", Series(mm(2020,1):mm(2020,06), @rand));
    gr + ch;

    ch = rephrase.SeriesChart("Chart 2", mm(2020,1):mm(2020,12), "dateFormat", "YYYY-MM");
        ch + rephrase.Series("Ccccc", Series(mm(2019,1):mm(2026,12), @rand));
        ch + rephrase.Series("Ddddd", Series(mm(2020,1):mm(2020,06), @rand));
    gr + ch;

r + gr;


table = { {"", "Aaaaa", "Bbbb", "Cccc", "Dddd"}, {"Zzzzz", 10, 20, 30, 40}, {"Xxxx", 100, 200, 300, 400} };

cc = { ["my-header", "my-header", "my-header", "my-header"], [], [] };

r + rephrase.Matrix("Table XXX", table, "cellClasses", cc);

show(r);

build( ...
    r, "testCurve", [] ...
    ... , "template", "./report-template.html" ...
    , "source", "web" ...
    , "saveJson", true ...
);



