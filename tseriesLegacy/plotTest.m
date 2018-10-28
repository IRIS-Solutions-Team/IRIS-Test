
close all
figureOpt = {'Visible', 'On'};
startDate = qq(2000,1);
x = tseries(startDate, rand(8, 2), 'DateFormat=', 'YPF');
dateFormat = 'PFYYYY';
exp1 = dat2char(x.Start, 'DateFormat=', iris.get('PlotDateFormat'));
exp2 = dat2char(x.Start, 'DateFormat=', dateFormat);


%% Test datxtick with New Range

figure(figureOpt{:});
plot(x);

oldRange = x.Range;
newRange = oldRange(2:end-1);
datxtick(gca( ), newRange);

newRangeDec = dat2dec(newRange, 'c');
xLim = get(gca( ), 'XLim');
check.absTol(newRangeDec(1), xLim(1), 0.001);    
check.absTol(newRangeDec(end), xLim(end), 0.001);    


%% Test Different DatePositions

figure(figureOpt{:});
plot(x);
xTick1 = get(gca(), 'XTick');

figure(figureOpt{:});
plot(x.Range, x, 'DatePosition=', 'end');
xTick2 = get(gca(), 'XTick');

check.greater(xTick2, xTick1);


%% Test Different Plot Functions and DateFormats

list = {@plot, @area, @stem, @scatter, @bar};
visual.next(numel(list), figureOpt{:});
cellfun(@(func) func(visual.next( ), x), list);
act1 = getFirstDate( );

visual.next(numel(list), figureOpt{:});
cellfun(@(func) func(visual.next( ), x.Range, x, 'DatePosition=', 'end', 'DateFormat=', dateFormat), list);
act2 = getFirstDate( );

check.equal(exp1, act1);
check.equal(exp2, act2);


%% Test plotyy with Different DateFormats

figure(figureOpt{:});
plotyy(x.Range, x{:, 1}, x{:, 2});
act1 = getFirstDate( );

figure(figureOpt{:});
plotyy(x.Range, x{:, 1}, x{:, 2}, 'DateFormat=', dateFormat);
act2 = getFirstDate( );

check.equal(exp1, act1);
check.equal(exp2, act2);

%
% Local functions
%

function s = getFirstDate( )
    s = get(gca( ), 'XTickLabel');
    s = s{1};
end%

