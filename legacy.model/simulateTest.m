function Tests = simulateTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function setupOnce(This)
m = model('3eq.model','linear',true);
m = solve(m);
m = sstate(m);
This.TestData.model = m;

d = zerodb(m,1:20);
d.ey(1) = m.std_ey;
s1 = simulate(m,d,1:20,'deviation',true);

d = zerodb(m,1:20);
d.epie(1) = m.std_epie;
s2 = simulate(m,d,1:20,'deviation',true);

d = zerodb(m,1:20);
d.er(1) = m.std_er;
s3 = simulate(m,d,1:20,'deviation',true);

s = s1 & s2 & s3;
s.y = clip(s.y,1:20);
s.pie = clip(s.pie,1:20);
s.r = clip(s.r,1:20);

This.TestData.Std = s;

d = zerodb(m,1:20);
d.ey(1) = 1;
s1 = simulate(m,d,1:20,'deviation',true);

d = zerodb(m,1:20);
d.epie(1) = 1;
s2 = simulate(m,d,1:20,'deviation',true);

d = zerodb(m,1:20);
d.er(1) = 1;
s3 = simulate(m,d,1:20,'deviation',true);

s = s1 & s2 & s3;
s.Y = clip(s.Y,1:20);
s.y = clip(s.y,1:20);
s.pie = clip(s.pie,1:20);
s.r = clip(s.r,1:20);

This.TestData.One = s;

end 




function testSrfDefault(This)
m = This.TestData.model;
actS = srf(m,1:20);
actS = dbclip(actS,1:20);
expS = This.TestData.Std;
xNames = get(m,'xNames');
for i = 1 : length(xNames)
    name = xNames{i};
    assertEqual(This,actS.(name)(:),expS.(name)(:),'AbsTol',1e-15);
end

actS = srf(m,1:20,'size',@auto);
actS = dbclip(actS,1:20);
expS = This.TestData.Std;
for i = 1 : length(xNames)
    name = xNames{i};
    assertEqual(This,actS.(name)(:),expS.(name)(:),'AbsTol',1e-15);
end
end 




function testSrfSizeOne(This)
m = This.TestData.model;
actS = srf(m,1:20,'size',1);
actS = dbclip(actS,1:20);
expS = This.TestData.One;
xNames = get(m,'xNames');
for i = 1 : length(xNames)
    name = xNames{i};
    assertEqual(This,actS.(name)(:),expS.(name)(:),'AbsTol',1e-15);
end
end 




function testSrfSelect(This)
m = This.TestData.model;
eNames = get(m,'eNames');
xNames = get(m,'xNames');
actS = srf(m,1:20,'select',@all);
actS = dbclip(actS,1:20);
expS = This.TestData.Std;
for i = 1 : length(xNames)
    name = xNames{i};
    assertEqual(This,actS.(name)(:),expS.(name)(:),'AbsTol',1e-15);
end

select = [1,2];
actS = srf(m,1:20,'select',eNames(select));
actS = dbclip(actS,1:20);
expS = dbcol(This.TestData.Std,select);
for i = 1 : length(xNames)
    name = xNames{i};
    assertEqual(This,actS.(name)(:),expS.(name)(:),'AbsTol',1e-15);
end
end




function testResample(This)
m = This.TestData.model;
xNames = get(m,'xNames');

d1 = sstatedb(m,1:100);
r1 = resample(m,d1,1:100,50,'randomInitCond',false);
s1 = simulate(m,r1,1:100,'anticipate',false);
for i = 1 : length(xNames)
    name = xNames{i};
    assertEqual(This,r1.(name)(:),s1.(name)(:),'AbsTol',1e-10);
end

d2 = sstatedb(m,1:100);
r2 = resample(m,d2,1:100,50,'randomInitCond',false, ...
    'method','bootstrap');
s2 = simulate(m,r2,1:100,'anticipate',false);
for i = 1 : length(xNames)
    name = xNames{i};
    assertEqual(This,r2.(name)(:),s2.(name)(:),'AbsTol',1e-10);
end

d3 = sstatedb(m,1:100);
r3 = resample(m,d3,1:100,50,'randomInitCond',false, ...
    'method','bootstrap','bootstrapMethod','wild');
s3 = simulate(m,r3,1:100,'anticipate',false);
for i = 1 : length(xNames)
    name = xNames{i};
    assertEqual(This,r3.(name)(:),s3.(name)(:),'AbsTol',1e-10);
end

d4 = sstatedb(m,1:100);
r4 = resample(m,d4,1:100,50,'randomInitCond',false, ...
    'method','bootstrap','bootstrapMethod',3);
s4 = simulate(m,r4,1:100,'anticipate',false);
for i = 1 : length(xNames)
    name = xNames{i};
    assertEqual(This,r4.(name)(:),s4.(name)(:),'AbsTol',1e-10);
end

d5 = sstatedb(m,1:100);
r5 = resample(m,d5,1:100,50,'randomInitCond',false, ...
    'method','bootstrap','bootstrapMethod',0.4);
s5 = simulate(m,r5,1:100,'anticipate',false);
for i = 1 : length(xNames)
    name = xNames{i};
    assertEqual(This,r5.(name)(:),s5.(name)(:),'AbsTol',1e-10);
end
end 
