
close all
clear 

d = struct( );
d.x = Series(qq(1990,1), rand(200,2));


% Import Package
%
% Otherwise all function and object names need to be preceeded by `rephase.`
%

import rephrase.*


% Start New Report

r = Report( ...
    'Forecast Report', ...
    'Forecast_Report', ...
    'SingleFile=', true, ...
    'ShowMarks=', @auto, ...
    ... 'Visible=', true, ...
    'AxesOptions=', {'XGrid=', true, 'YGrid=', true}, ...
    'Marks=', {'a','b','&Delta;'} ...
);


% Create New Table

t = Table( ...
    'Table 1', qq(2000,1:20), ...
    'ShowUnits=', true, ...
    'PageBreakAfter=', true, ...
    'AutoData=', @(x) x(:,2)-x(:,1), ...
    'Footnote=', {'XXX', 'YYY'}, ...
    'VlineAfter=', [qq(2000,4), qq(2002,1)], ...
    'VlineBefore=', qq(2000,1), ...
    'Highlight=', qq(2000,1:4) ...
);

       
% Add Elements to the Table

t + table.Series('Series 1', d.x);
t + table.Subheading('Inflation Decomposition');
t + table.Series('Series 2', d.x);


% Add the Table to the Report

r + t


% Start New Figure

sty = struct( );
sty.Axes.FontSize = 5;

f = Figure( ...
    'Figure 1', qq(2001,1:20), [2, 2], ...
    'CropBottom=', 0.50, ...
    'Style=', sty, ...
    'Footnote=', 'ZZZ', ...
    'PageBreakAfter=', true ...
);

        
% Add Elements to the Figure

    ch = figure.Chart( 'Chart 1', [ ], 'Highlight=', qq(2001,1:4));
        ch + figure.chart.Series('Series 1', d.x, {@plot, 'LineWidth=', 2});
    f + ch
    
    
% Add the Figure to the Report

r + f


% Create Another Table and Add It to the Report

t = Table('Table 2', qq(2001,1:20));
t + table.Series('Series 1', d.x)
r + t


% Add a Section Divider to the Report

r + Section('Section 1');


% Create New Matrix

m = Matrix( 'Matrix 1', rand(4,5), ...
            'ColumnNames=', {'First', 'Second'}, ...
            'RowNames=', {'First', 'Second', 'Third'} );

        
% Add the Matrix to the Report

r + m


% Display the Structure of the Report

detail(r)


% Publish the Report to HTML

[fileName, code] = publish(r);
disp(fileName)

