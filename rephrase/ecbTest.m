
clear

list = ["YEN", "YENT", "YENTG", "YER_M"];

d = struct();
for n = list
    d.(n) = cumsum(Series(yy(1990):yy(2030), @randn));
end

r = rephrase.Report("ECB Test Report");
r2 = rephrase.Report("ECB Test Report 2");


gr = rephrase.Grid("GDP summary", [], 2, "pass", {"dateFormat", "YYYY"}); %#ok<*CLARRSTR> 
ta = rephrase.Table("GDP summary", yy(2001):yy(2005), "dateFormat", "YYYY");

for n =  list
    ch = rephrase.SeriesChart.fromSeries( ...
        {n, yy(2001):yy(2024)} ...
        , {"Baseline", d.(n)} ...
        , {"Alternative", d.(n) + 1} ...
    );
    gr + ch;

    ds = rephrase.DiffSeries(n, pct(d.(n)), pct(d.(n)+1), "units", "EUR B");
    ta + ds;
end

r + gr
r + ta;

r2 + ta;

show(r)

build(r, "ecbTest", [], "source", ["web", "bundle"], "saveJson", true);
build(r2, "ecbTest2", [], "source", ["web", "bundle"]);

