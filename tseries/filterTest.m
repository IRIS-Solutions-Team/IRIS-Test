function Tests = tseriesFilterTest()
Tests = functiontests(localfunctions);
end


%**************************************************************************


function setupOnce(this) %#ok<*DEFNU>
range = qq(1,1:20);
this.TestData.x = 1 + tseries(range,sin(1:20));
this.TestData.y = 1 + tseries(range,cos(1:20));
this.TestData.AbsTol = eps()^(2/3);
this.TestData.Range = range;
end


%**************************************************************************


function testHpfBwf(this)
x = this.TestData.x;
y = this.TestData.y;
absTol = this.TestData.AbsTol;
range = this.TestData.Range;

xhp = hpf(x);
xbw = bwf(x,2);
yhp = hpf(y);
ybw = bwf(y,2);
assertEqual(this,xhp,xbw,'absTol',absTol);
assertEqual(this,yhp,ybw,'absTol',absTol);

xhp = hpf(x, 'Log', true);
xbw = bwf(x, 2, 'Log', true);
yhp = hpf(y, 'Log', true);
ybw = bwf(y, 2, 'Log', true);
assertEqual(this,xhp,xbw,'absTol',absTol);
assertEqual(this,yhp,ybw,'absTol',absTol);

xhp = hpf(x,range(1:end-5));
xbw = bwf(x,2,range(1:end-5));
yhp = hpf(y,range(1:end-5));
ybw = bwf(y,2,range(1:end-5));
assertEqual(this,xhp,xbw,'absTol',absTol);
assertEqual(this,yhp,ybw,'absTol',absTol);

xhp = hpf(x,range(1)-5:range(end)+5);
xbw = bwf(x,2,range(1)-5:range(end)+5);
yhp = hpf(y,range(1)-5:range(end)+5);
ybw = bwf(y,2,range(1)-5:range(end)+5);
assertEqual(this,xhp,xbw,'absTol',absTol);
assertEqual(this,yhp,ybw,'absTol',absTol);

xyhp = hpf([x,y],range(1)-5:range(end)+5);
xybw = bwf([x,y],2,range(1)-5:range(end)+5);
assertEqual(this,xyhp,[xhp,yhp],'absTol',absTol);
assertEqual(this,xybw,[xbw,ybw],'absTol',absTol);
assertEqual(this,xyhp,xybw,'absTol',absTol);
end % testHpfBwf()


%**************************************************************************


function testHpfBwfLevelTunes(this)
x = this.TestData.x;
y = this.TestData.y;
absTol = this.TestData.AbsTol;
range = this.TestData.Range;

dates = [range(1),range(end)+5];
values = 1 + [0;0];
l = tseries(dates,values);

xhp = hpf(x,'level',l);
xbw = bwf(x,2,'level',l);
yhp = hpf(y,'level',l);
ybw = bwf(y,2,'level',l);
assertEqual(this,xhp,xbw,'absTol',absTol);
assertEqual(this,yhp,ybw,'absTol',absTol);
assertEqual(this,xhp(dates),values,'absTol',absTol);
assertEqual(this,yhp(dates),values,'absTol',absTol);

xhp = hpf(x,'level',l, 'Log', true);
xbw = bwf(x,2,'level',l, 'Log', true);
yhp = hpf(y,'level',l, 'Log', true);
ybw = bwf(y,2,'level',l, 'Log', true);
assertEqual(this,xhp,xbw,'absTol',absTol);
assertEqual(this,yhp,ybw,'absTol',absTol);
assertEqual(this,xhp(dates),values,'absTol',absTol);
assertEqual(this,yhp(dates),values,'absTol',absTol);

lxhp = hpf(log(x), 'Level', log(l));
assertEqual(this, lxhp(:), log(xhp(:)), 'absTol', absTol);

xhp = hpf(x,range(1:end-5),'level',l);
xbw = bwf(x,2,range(1:end-5),'level',l);
yhp = hpf(y,range(1:end-5),'level',l);
ybw = bwf(y,2,range(1:end-5),'level',l);
assertEqual(this,xhp,xbw,'absTol',absTol);
assertEqual(this,yhp,ybw,'absTol',absTol);
assertEqual(this,xhp(dates),values,'absTol',absTol);
assertEqual(this,yhp(dates),values,'absTol',absTol);

xhp = hpf(x,range(1)-5:range(end)+5,'level',l);
xbw = bwf(x,2,range(1)-5:range(end)+5,'level',l);
yhp = hpf(y,range(1)-5:range(end)+5,'level',l);
ybw = bwf(y,2,range(1)-5:range(end)+5,'level',l);
assertEqual(this,xhp,xbw,'absTol',absTol);
assertEqual(this,yhp,ybw,'absTol',absTol);
assertEqual(this,xhp(dates),values,'absTol',absTol);
assertEqual(this,yhp(dates),values,'absTol',absTol);

xyhp = hpf([x,y],range(1)-5:range(end)+5,'level',l);
xybw = bwf([x,y],2,range(1)-5:range(end)+5,'level',l);
assertEqual(this,xyhp,[xhp,yhp],'absTol',absTol);
assertEqual(this,xybw,[xbw,ybw],'absTol',absTol);
assertEqual(this,xyhp(dates),[values,values],'absTol',absTol);
end % testHpfBwfLevelTunes()


%**************************************************************************


function testHpfBwfGrowthTunes(this)
x = this.TestData.x;
y = this.TestData.y;
absTol = this.TestData.AbsTol;
range = this.TestData.Range;

dates = [range(1),range(end)+5];
values = [0;0];
g = tseries(dates,values);

xhp = hpf(x,'growth',g);
xbw = bwf(x,2,'growth',g);
yhp = hpf(y,'growth',g);
ybw = bwf(y,2,'growth',g);
assertEqual(this,xhp,xbw,'absTol',absTol);
assertEqual(this,yhp,ybw,'absTol',absTol);
assertEqual(this,xhp(dates)-xhp(dates-1),values,'absTol',absTol);
assertEqual(this,yhp(dates)-yhp(dates-1),values,'absTol',absTol);

xhp = hpf(x,range(1:end-5),'growth',g);
xbw = bwf(x,2,range(1:end-5),'growth',g);
yhp = hpf(y,range(1:end-5),'growth',g);
ybw = bwf(y,2,range(1:end-5),'growth',g);
assertEqual(this,xhp,xbw,'absTol',absTol);
assertEqual(this,yhp,ybw,'absTol',absTol);
assertEqual(this,xhp(dates)-xhp(dates-1),values,'absTol',absTol);
assertEqual(this,yhp(dates)-yhp(dates-1),values,'absTol',absTol);

xhp = hpf(x,range(1)-5:range(end)+5,'growth',g);
xbw = bwf(x,2,range(1)-5:range(end)+5,'growth',g);
yhp = hpf(y,range(1)-5:range(end)+5,'growth',g);
ybw = bwf(y,2,range(1)-5:range(end)+5,'growth',g);
assertEqual(this,xhp,xbw,'absTol',absTol);
assertEqual(this,yhp,ybw,'absTol',absTol);
assertEqual(this,xhp(dates)-xhp(dates-1),values,'absTol',absTol);
assertEqual(this,yhp(dates)-yhp(dates-1),values,'absTol',absTol);

xyhp = hpf([x,y],range(1)-5:range(end)+5,'growth',g);
xybw = bwf([x,y],2,range(1)-5:range(end)+5,'growth',g);
assertEqual(this,xyhp,[xhp,yhp],'absTol',absTol);
assertEqual(this,xybw,[xbw,ybw],'absTol',absTol);
assertEqual(this,xyhp(dates)-xyhp(dates-1),[values,values],'absTol',absTol);
end % testHpfBwfLevelTunes()


%**************************************************************************


function testLlfBwf(this)
x = this.TestData.x;
y = this.TestData.y;
absTol = this.TestData.AbsTol;
range = this.TestData.Range;

xll = llf(x);
xbw = bwf(x,1);
yll = llf(y);
ybw = bwf(y,1);
assertEqual(this,xll,xbw,'absTol',absTol);
assertEqual(this,yll,ybw,'absTol',absTol);

xll = llf(x,range(1:end-5));
xbw = bwf(x,1,range(1:end-5));
yll = llf(y,range(1:end-5));
ybw = bwf(y,1,range(1:end-5));
assertEqual(this,xll,xbw,'absTol',absTol);
assertEqual(this,yll,ybw,'absTol',absTol);

xll = llf(x,range(1)-5:range(end)+5);
xbw = bwf(x,1,range(1)-5:range(end)+5);
yll = llf(y,range(1)-5:range(end)+5);
ybw = bwf(y,1,range(1)-5:range(end)+5);
assertEqual(this,xll,xbw,'absTol',absTol);
assertEqual(this,yll,ybw,'absTol',absTol);

xyll = llf([x,y],range(1)-5:range(end)+5);
xybw = bwf([x,y],1,range(1)-5:range(end)+5);
assertEqual(this,xyll,[xll,yll],'absTol',absTol);
assertEqual(this,xybw,[xbw,ybw],'absTol',absTol);
assertEqual(this,xyll,xybw,'absTol',absTol);
end % testLlfBwf()


%**************************************************************************


function testLlfBwfLevelTunes(this)
x = this.TestData.x;
y = this.TestData.y;
absTol = this.TestData.AbsTol;
range = this.TestData.Range;

dates = [range(1),range(end)+5];
values = [0;0];
l = tseries(dates,values);

xll = llf(x,'level',l);
xbw = bwf(x,1,'level',l);
yll = llf(y,'level',l);
ybw = bwf(y,1,'level',l);
assertEqual(this,xll,xbw,'absTol',absTol);
assertEqual(this,yll,ybw,'absTol',absTol);
assertEqual(this,xll(dates),values,'absTol',absTol);
assertEqual(this,yll(dates),values,'absTol',absTol);

xll = llf(x,range(1:end-5),'level',l);
xbw = bwf(x,1,range(1:end-5),'level',l);
yll = llf(y,range(1:end-5),'level',l);
ybw = bwf(y,1,range(1:end-5),'level',l);
assertEqual(this,xll,xbw,'absTol',absTol);
assertEqual(this,yll,ybw,'absTol',absTol);
assertEqual(this,xll(dates),values,'absTol',absTol);
assertEqual(this,yll(dates),values,'absTol',absTol);

xll = llf(x,range(1)-5:range(end)+5,'level',l);
xbw = bwf(x,1,range(1)-5:range(end)+5,'level',l);
yll = llf(y,range(1)-5:range(end)+5,'level',l);
ybw = bwf(y,1,range(1)-5:range(end)+5,'level',l);
assertEqual(this,xll,xbw,'absTol',absTol);
assertEqual(this,yll,ybw,'absTol',absTol);
assertEqual(this,xll(dates),values,'absTol',absTol);
assertEqual(this,yll(dates),values,'absTol',absTol);

xyll = llf([x,y],range(1)-5:range(end)+5,'level',l);
xybw = bwf([x,y],1,range(1)-5:range(end)+5,'level',l);
assertEqual(this,xyll,[xll,yll],'absTol',absTol);
assertEqual(this,xybw,[xbw,ybw],'absTol',absTol);
assertEqual(this,xyll(dates),[values,values],'absTol',absTol);
end % testLlfBwfLevelTunes()


%**************************************************************************


function testLlfBwfGrowthTunes(this)
x = this.TestData.x;
y = this.TestData.y;
absTol = this.TestData.AbsTol;
range = this.TestData.Range;

dates = [range(1),range(end)+5];
values = [0;0];
g = tseries(dates,values);

xll = llf(x,'growth',g);
xbw = bwf(x,1,'growth',g);
yll = llf(y,'growth',g);
ybw = bwf(y,1,'growth',g);
assertEqual(this,xll,xbw,'absTol',absTol);
assertEqual(this,yll,ybw,'absTol',absTol);
assertEqual(this,xll(dates)-xll(dates-1),values,'absTol',absTol);
assertEqual(this,yll(dates)-yll(dates-1),values,'absTol',absTol);

xll = llf(x,range(1:end-5),'growth',g);
xbw = bwf(x,1,range(1:end-5),'growth',g);
yll = llf(y,range(1:end-5),'growth',g);
ybw = bwf(y,1,range(1:end-5),'growth',g);
assertEqual(this,xll,xbw,'absTol',absTol);
assertEqual(this,yll,ybw,'absTol',absTol);
assertEqual(this,xll(dates)-xll(dates-1),values,'absTol',absTol);
assertEqual(this,yll(dates)-yll(dates-1),values,'absTol',absTol);

xll = llf(x,range(1)-5:range(end)+5,'growth',g);
xbw = bwf(x,1,range(1)-5:range(end)+5,'growth',g);
yll = llf(y,range(1)-5:range(end)+5,'growth',g);
ybw = bwf(y,1,range(1)-5:range(end)+5,'growth',g);
assertEqual(this,xll,xbw,'absTol',absTol);
assertEqual(this,yll,ybw,'absTol',absTol);
assertEqual(this,xll(dates)-xll(dates-1),values,'absTol',absTol);
assertEqual(this,yll(dates)-yll(dates-1),values,'absTol',absTol);

xyll = llf([x,y],range(1)-5:range(end)+5,'growth',g);
xybw = bwf([x,y],1,range(1)-5:range(end)+5,'growth',g);
assertEqual(this,xyll,[xll,yll],'absTol',absTol);
assertEqual(this,xybw,[xbw,ybw],'absTol',absTol);
assertEqual(this,xyll(dates)-xyll(dates-1),[values,values],'absTol',absTol);
end % testLlfBwfLevelTunes()
