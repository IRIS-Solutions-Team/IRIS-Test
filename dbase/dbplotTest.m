function Tests = dbplotTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function setupOnce(This)
d = struct( );
range = 1 : 100;
for name = 'a' : 'z'
    d.(name) = tseries(range, @rand);
end
This.TestData.Dbase = d;
This.TestData.Range = range;
end




function testDbplot1(This)
d = This.TestData.Dbase;
range = This.TestData.Range;
list = fieldnames(d);
nList = length(list);

[Fig,Ax] = dbplot(d, 'figureOpt=', {'visible=','off'});
assertEqual(This, length(Fig), 1);
assertEqual(This, length(Ax), 1);
assertEqual(This, length(Ax{1}), nList);
for i = 1 : length(Ax{1})
    xLim = get(Ax{1}(i), 'xLim');
    assertEqual(This, xLim, range([1,end]));
end
close all;
end




function testDbplot2(This)
d = This.TestData.Dbase;
list = fieldnames(d);
nList = length(list);

[Fig,Ax] = dbplot( d, ...
    'maxPerFigure=', 4, ...
    'figureOpt=', {'visible=','off'} ...
    );
assertEqual(This, length(Fig), ceil(nList/4));
assertEqual(This, length(Ax), ceil(nList/4));
for i = 1 : length(Ax)-1
    assertEqual(This, length(Ax{i}), 4);
end
close all;
end




function testDbplot3(This)
d = This.TestData.Dbase;
list = fieldnames(d);
nList = length(list);

range = 2 : 5;
[Fig,Ax] = dbplot( d, range, ...
    'figureOpt=',{'visible=','off'} );
assertEqual(This, length(Fig), 1);
assertEqual(This, length(Ax), 1);
assertEqual(This, length(Ax{1}), nList);
for i = 1 : length(Ax{1})
    xLim = get(Ax{1}(i),'xLim');
    assertEqual(This, xLim, range([1,end]));
end
close all;
end
