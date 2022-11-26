

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

    h = rephrase.Highlight(1, 2);
    ch = rephrase.CurveChart("Reporting date: "+dater.toString(dd(2022,07,01)+i), 0:2:12, "tickLabels", @(x) string(x) + "Y", "highlight", h);

        ch + rephrase.Curve("Data w spread", t3, "lineWidth", 0, "markers", struct('symbol', "square", 'size', 10, 'color', nan));

        ch + rephrase.Curve("Curve 1", t1);
        ch + rephrase.Curve("Curve 2", t4);

        %
        % Option I: Use option uniqueTerms=false to entery multiple data
        % points with the same term to maturity
        %
        tX = Termer([7;7;7;7], [1;2;3;4], [], "uniqueTerms", false);
        ch + rephrase.Curve("MarkersI", tX, "lineWidth", 0, "markers", struct('symbol', 'square'));

        %
        % Option II: Bypass the Termer object and enter directly a struct
        % with `.Terms` and `.Values` fields, both column vectors
        ch + rephrase.Curve( ...
            "MarkersII", struct("Terms", [6;6;6;6], "Values", [1.5;2.5;3.5;4.5]) ...
            , "lineWidth", 0, "markers", struct('symbol', 'circle') ...
        );

        ch + rephrase.Curve("Data 2", t2, "markers", struct('color', NaN, 'symbol', "x-dot", 'size', 10), "lineWidth", 0);

        % Clip the t2 curve to maturities 1 year and above, and plot these
        % as squares around the existing X marks
        ch + rephrase.Curve("Data 3", clip(t2, 1, Inf), "markers", struct('color', NaN, 'symbol', "square-open", 'size', 14, 'line', struct('width', 4)), 'lineWidth', 0);

    pg + ch;
end

r + pg;
r + rephrase.Pagebreak();

show(r);

build( ...
    r, "curveTest1", [] ...
    ... , "template", "./report-template.html" ...
    , "source", "web" ...
    , "saveJson", true ...
    , "userStyle", "user-defined.css" ...
);



