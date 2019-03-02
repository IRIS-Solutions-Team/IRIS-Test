
clear all
clear classes

import reptile.*

d = struct( );
d.x = Series(qq(1990,1), rand(200,2));

r = Report( 'Forecast Report', ...
            'Forecast_Report', ...
            'SingleFile=', true, ...
            'ShowMarks=', @auto, ...
            ... 'Visible=', true, ...
            'AxesOptions=', {'XGrid=', true, 'YGrid=', true}, ...
            'Marks=', {'a','b','&Delta;'} );

t = Table( 'Table 1', qq(2000,1:20), ...
           'ShowUnits=', true, ...
           'PageBreakAfter=', true, ...
           'AutoData=', @(x) x(:,2)-x(:,1), ...
           'Footnote=', {'XXX', 'YYY'}, ...
           'VlineAfter=', [qq(2000,4), qq(2002,1)], ...
           'VlineBefore=', qq(2000,1), ...
           'Highlight=', qq(2000,1:4) );
t + table.Series('Series 1', d.x);
t + table.Subheading('Inflation Decomposition');
t + table.Series('Series 2', d.x);
r + t

sty = struct( );
sty.Axes.FontSize = 5;

f = Figure( 'Figure 1', qq(2001,1:20), [2, 2], ...
            'CropBottom=', 0.50, ...
            'Style=', sty, ...
            'Footnote=', 'ZZZ', ...
            'PageBreakAfter=', true);
    ch = figure.Chart( 'Chart 1', [ ], ...
                       'Highlight=', qq(2001,1:4));
    ch + figure.chart.Series('Series 1', d.x, {@plot, 'LineWidth=', 4});
    f + ch
r + f

t = Table('Table 2', qq(2001,1:20));
t + table.Series('Series 1', d.x)
r + t

r + Section('Section 1');

m = Matrix( 'Matrix 1', rand(4,5), ...
            'ColumnNames=', {'First', 'Second'}, ...
            'RowNames=', {'First', 'Second', 'Third'} );
r + m

% detail(r)

tic
[fileName, code] = publish(r);
toc



