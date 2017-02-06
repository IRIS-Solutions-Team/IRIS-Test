function Tests = tseriesFilterTest()
Tests = functiontests(localfunctions);
end


%**************************************************************************


function setupOnce(This) %#ok<*DEFNU>
range = qq(1,1:20);
This.TestData.x = tseries(range,sin(1:20));
This.TestData.y = tseries(range,cos(1:20));
This.TestData.AbsTol = eps()^(2/3);
This.TestData.Range = range;
end % setupOnce()


%**************************************************************************


function testHpfBwf(This)
x = This.TestData.x;
y = This.TestData.y;
absTol = This.TestData.AbsTol;
range = This.TestData.Range;

xhp = hpf(x);
xbw = bwf(x,2);
yhp = hpf(y);
ybw = bwf(y,2);
assertEqual(This,xhp,xbw,'absTol',absTol);
assertEqual(This,yhp,ybw,'absTol',absTol);

xhp = hpf(x,range(1:end-5));
xbw = bwf(x,2,range(1:end-5));
yhp = hpf(y,range(1:end-5));
ybw = bwf(y,2,range(1:end-5));
assertEqual(This,xhp,xbw,'absTol',absTol);
assertEqual(This,yhp,ybw,'absTol',absTol);

xhp = hpf(x,range(1)-5:range(end)+5);
xbw = bwf(x,2,range(1)-5:range(end)+5);
yhp = hpf(y,range(1)-5:range(end)+5);
ybw = bwf(y,2,range(1)-5:range(end)+5);
assertEqual(This,xhp,xbw,'absTol',absTol);
assertEqual(This,yhp,ybw,'absTol',absTol);

xyhp = hpf([x,y],range(1)-5:range(end)+5);
xybw = bwf([x,y],2,range(1)-5:range(end)+5);
assertEqual(This,xyhp,[xhp,yhp],'absTol',absTol);
assertEqual(This,xybw,[xbw,ybw],'absTol',absTol);
assertEqual(This,xyhp,xybw,'absTol',absTol);
end % testHpfBwf()


%**************************************************************************


function testHpfBwfLevelTunes(This)
x = This.TestData.x;
y = This.TestData.y;
absTol = This.TestData.AbsTol;
range = This.TestData.Range;

dates = [range(1),range(end)+5];
values = [0;0];
l = tseries(dates,values);

xhp = hpf(x,'level=',l);
xbw = bwf(x,2,'level=',l);
yhp = hpf(y,'level=',l);
ybw = bwf(y,2,'level=',l);
assertEqual(This,xhp,xbw,'absTol',absTol);
assertEqual(This,yhp,ybw,'absTol',absTol);
assertEqual(This,xhp(dates),values,'absTol',absTol);
assertEqual(This,yhp(dates),values,'absTol',absTol);

xhp = hpf(x,range(1:end-5),'level=',l);
xbw = bwf(x,2,range(1:end-5),'level=',l);
yhp = hpf(y,range(1:end-5),'level=',l);
ybw = bwf(y,2,range(1:end-5),'level=',l);
assertEqual(This,xhp,xbw,'absTol',absTol);
assertEqual(This,yhp,ybw,'absTol',absTol);
assertEqual(This,xhp(dates),values,'absTol',absTol);
assertEqual(This,yhp(dates),values,'absTol',absTol);

xhp = hpf(x,range(1)-5:range(end)+5,'level=',l);
xbw = bwf(x,2,range(1)-5:range(end)+5,'level=',l);
yhp = hpf(y,range(1)-5:range(end)+5,'level=',l);
ybw = bwf(y,2,range(1)-5:range(end)+5,'level=',l);
assertEqual(This,xhp,xbw,'absTol',absTol);
assertEqual(This,yhp,ybw,'absTol',absTol);
assertEqual(This,xhp(dates),values,'absTol',absTol);
assertEqual(This,yhp(dates),values,'absTol',absTol);

xyhp = hpf([x,y],range(1)-5:range(end)+5,'level=',l);
xybw = bwf([x,y],2,range(1)-5:range(end)+5,'level=',l);
assertEqual(This,xyhp,[xhp,yhp],'absTol',absTol);
assertEqual(This,xybw,[xbw,ybw],'absTol',absTol);
assertEqual(This,xyhp(dates),[values,values],'absTol',absTol);
end % testHpfBwfLevelTunes()


%**************************************************************************


function testHpfBwfGrowthTunes(This)
x = This.TestData.x;
y = This.TestData.y;
absTol = This.TestData.AbsTol;
range = This.TestData.Range;

dates = [range(1),range(end)+5];
values = [0;0];
g = tseries(dates,values);

xhp = hpf(x,'growth=',g);
xbw = bwf(x,2,'growth=',g);
yhp = hpf(y,'growth=',g);
ybw = bwf(y,2,'growth=',g);
assertEqual(This,xhp,xbw,'absTol',absTol);
assertEqual(This,yhp,ybw,'absTol',absTol);
assertEqual(This,xhp(dates)-xhp(dates-1),values,'absTol',absTol);
assertEqual(This,yhp(dates)-yhp(dates-1),values,'absTol',absTol);

xhp = hpf(x,range(1:end-5),'growth=',g);
xbw = bwf(x,2,range(1:end-5),'growth=',g);
yhp = hpf(y,range(1:end-5),'growth=',g);
ybw = bwf(y,2,range(1:end-5),'growth=',g);
assertEqual(This,xhp,xbw,'absTol',absTol);
assertEqual(This,yhp,ybw,'absTol',absTol);
assertEqual(This,xhp(dates)-xhp(dates-1),values,'absTol',absTol);
assertEqual(This,yhp(dates)-yhp(dates-1),values,'absTol',absTol);

xhp = hpf(x,range(1)-5:range(end)+5,'growth=',g);
xbw = bwf(x,2,range(1)-5:range(end)+5,'growth=',g);
yhp = hpf(y,range(1)-5:range(end)+5,'growth=',g);
ybw = bwf(y,2,range(1)-5:range(end)+5,'growth=',g);
assertEqual(This,xhp,xbw,'absTol',absTol);
assertEqual(This,yhp,ybw,'absTol',absTol);
assertEqual(This,xhp(dates)-xhp(dates-1),values,'absTol',absTol);
assertEqual(This,yhp(dates)-yhp(dates-1),values,'absTol',absTol);

xyhp = hpf([x,y],range(1)-5:range(end)+5,'growth=',g);
xybw = bwf([x,y],2,range(1)-5:range(end)+5,'growth=',g);
assertEqual(This,xyhp,[xhp,yhp],'absTol',absTol);
assertEqual(This,xybw,[xbw,ybw],'absTol',absTol);
assertEqual(This,xyhp(dates)-xyhp(dates-1),[values,values],'absTol',absTol);
end % testHpfBwfLevelTunes()


%**************************************************************************


function testLlfBwf(This)
x = This.TestData.x;
y = This.TestData.y;
absTol = This.TestData.AbsTol;
range = This.TestData.Range;

xll = llf(x);
xbw = bwf(x,1);
yll = llf(y);
ybw = bwf(y,1);
assertEqual(This,xll,xbw,'absTol',absTol);
assertEqual(This,yll,ybw,'absTol',absTol);

xll = llf(x,range(1:end-5));
xbw = bwf(x,1,range(1:end-5));
yll = llf(y,range(1:end-5));
ybw = bwf(y,1,range(1:end-5));
assertEqual(This,xll,xbw,'absTol',absTol);
assertEqual(This,yll,ybw,'absTol',absTol);

xll = llf(x,range(1)-5:range(end)+5);
xbw = bwf(x,1,range(1)-5:range(end)+5);
yll = llf(y,range(1)-5:range(end)+5);
ybw = bwf(y,1,range(1)-5:range(end)+5);
assertEqual(This,xll,xbw,'absTol',absTol);
assertEqual(This,yll,ybw,'absTol',absTol);

xyll = llf([x,y],range(1)-5:range(end)+5);
xybw = bwf([x,y],1,range(1)-5:range(end)+5);
assertEqual(This,xyll,[xll,yll],'absTol',absTol);
assertEqual(This,xybw,[xbw,ybw],'absTol',absTol);
assertEqual(This,xyll,xybw,'absTol',absTol);
end % testLlfBwf()


%**************************************************************************


function testLlfBwfLevelTunes(This)
x = This.TestData.x;
y = This.TestData.y;
absTol = This.TestData.AbsTol;
range = This.TestData.Range;

dates = [range(1),range(end)+5];
values = [0;0];
l = tseries(dates,values);

xll = llf(x,'level=',l);
xbw = bwf(x,1,'level=',l);
yll = llf(y,'level=',l);
ybw = bwf(y,1,'level=',l);
assertEqual(This,xll,xbw,'absTol',absTol);
assertEqual(This,yll,ybw,'absTol',absTol);
assertEqual(This,xll(dates),values,'absTol',absTol);
assertEqual(This,yll(dates),values,'absTol',absTol);

xll = llf(x,range(1:end-5),'level=',l);
xbw = bwf(x,1,range(1:end-5),'level=',l);
yll = llf(y,range(1:end-5),'level=',l);
ybw = bwf(y,1,range(1:end-5),'level=',l);
assertEqual(This,xll,xbw,'absTol',absTol);
assertEqual(This,yll,ybw,'absTol',absTol);
assertEqual(This,xll(dates),values,'absTol',absTol);
assertEqual(This,yll(dates),values,'absTol',absTol);

xll = llf(x,range(1)-5:range(end)+5,'level=',l);
xbw = bwf(x,1,range(1)-5:range(end)+5,'level=',l);
yll = llf(y,range(1)-5:range(end)+5,'level=',l);
ybw = bwf(y,1,range(1)-5:range(end)+5,'level=',l);
assertEqual(This,xll,xbw,'absTol',absTol);
assertEqual(This,yll,ybw,'absTol',absTol);
assertEqual(This,xll(dates),values,'absTol',absTol);
assertEqual(This,yll(dates),values,'absTol',absTol);

xyll = llf([x,y],range(1)-5:range(end)+5,'level=',l);
xybw = bwf([x,y],1,range(1)-5:range(end)+5,'level=',l);
assertEqual(This,xyll,[xll,yll],'absTol',absTol);
assertEqual(This,xybw,[xbw,ybw],'absTol',absTol);
assertEqual(This,xyll(dates),[values,values],'absTol',absTol);
end % testLlfBwfLevelTunes()


%**************************************************************************


function testLlfBwfGrowthTunes(This)
x = This.TestData.x;
y = This.TestData.y;
absTol = This.TestData.AbsTol;
range = This.TestData.Range;

dates = [range(1),range(end)+5];
values = [0;0];
g = tseries(dates,values);

xll = llf(x,'growth=',g);
xbw = bwf(x,1,'growth=',g);
yll = llf(y,'growth=',g);
ybw = bwf(y,1,'growth=',g);
assertEqual(This,xll,xbw,'absTol',absTol);
assertEqual(This,yll,ybw,'absTol',absTol);
assertEqual(This,xll(dates)-xll(dates-1),values,'absTol',absTol);
assertEqual(This,yll(dates)-yll(dates-1),values,'absTol',absTol);

xll = llf(x,range(1:end-5),'growth=',g);
xbw = bwf(x,1,range(1:end-5),'growth=',g);
yll = llf(y,range(1:end-5),'growth=',g);
ybw = bwf(y,1,range(1:end-5),'growth=',g);
assertEqual(This,xll,xbw,'absTol',absTol);
assertEqual(This,yll,ybw,'absTol',absTol);
assertEqual(This,xll(dates)-xll(dates-1),values,'absTol',absTol);
assertEqual(This,yll(dates)-yll(dates-1),values,'absTol',absTol);

xll = llf(x,range(1)-5:range(end)+5,'growth=',g);
xbw = bwf(x,1,range(1)-5:range(end)+5,'growth=',g);
yll = llf(y,range(1)-5:range(end)+5,'growth=',g);
ybw = bwf(y,1,range(1)-5:range(end)+5,'growth=',g);
assertEqual(This,xll,xbw,'absTol',absTol);
assertEqual(This,yll,ybw,'absTol',absTol);
assertEqual(This,xll(dates)-xll(dates-1),values,'absTol',absTol);
assertEqual(This,yll(dates)-yll(dates-1),values,'absTol',absTol);

xyll = llf([x,y],range(1)-5:range(end)+5,'growth=',g);
xybw = bwf([x,y],1,range(1)-5:range(end)+5,'growth=',g);
assertEqual(This,xyll,[xll,yll],'absTol',absTol);
assertEqual(This,xybw,[xbw,ybw],'absTol',absTol);
assertEqual(This,xyll(dates)-xyll(dates-1),[values,values],'absTol',absTol);
end % testLlfBwfLevelTunes()
