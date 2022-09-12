


range = qq(2020,1):qq(2025,4);

r = rephrase.Report("Nested large pagers", "interactiveCharts", false, "pass", {"round", 4});

pg1 = rephrase.Pager("Shock report");
for i = 1 : 5
    pg2 = rephrase.Pager("Country "+string(i));
    for j = 1 : 5
        sc = rephrase.Section("Shock "+string(j));
        for k = 1 : 2 
            gr = rephrase.Grid("Response in Country "+string(k), Inf, 3);
            for n = 1 : 9
                ch = rephrase.SeriesChart.fromSeries( ...
                    {"Response in Variable "+string(n), range, "dateFormat", "YYYY-QQ", "showLegend", true} ...
                    , {"Emwo", Series(range, @randn)} ...
                    , {"Qibj", Series(range, @randn)} ...
                );
                gr + ch;
            end
            sc + gr;
        end
        pg2 + sc;
    end
    pg1 + pg2;
end

r + pg1;

% show(r)

build(r, "testNestedPager", [], "source", "web", "userStyle", "user-defined.css");

