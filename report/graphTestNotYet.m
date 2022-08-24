%close all
%clear
%clear classes


w = report.GraphWrapper( )
w.Range = qq(2000,1) : qq(2003,4);
w.Range = 11:30;
%w.Arrange = 1;
w.Orientation = 'landscape';
w.Visible = false;
w.CloseAfterPrinting = true;

g = report.Graph( );
g.Title = 'Title XXX';

left = report.YAxis( );
left.Data = Series(qq(1999,1), rand(100,2));
left.Legend = {'first', 'second'};
left.PlotFunction = @bar;
g.addLeft(left);

right = report.YAxis( );
right.Data = 100*Series(qq(1999,1), rand(100,1));
g.addRight(right);

right = report.YAxis( );
right.Data = 100*Series(qq(1999,1), rand(100,1));
right.Legend = 'third';
g.addRight(right);

g.ShowLegend = true;
w.addGraph(g);

g = report.Graph( );
w.addGraph(g);

g = report.Graph( );
left = report.YAxis( );
left.Data = rand(20,1);
g.addLeft(left);
w.addGraph(g);


w.draw( );
w.print('test')

