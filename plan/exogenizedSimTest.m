function Tests = exogenizedSimTest()
Tests = functiontests( localfunctions );
end
%#ok<*DEFNU>


%**************************************************************************


function setupOnce(This)
m = model('exogenizedSimTest.model','linear=',true);
m = solve(m);
This.TestData.Model = m;
end % setupOnce()


%**************************************************************************


function testUnanticipated(This)
m = This.TestData.Model;
T = 5;
d = zerodb(m,1:10);
d.x(T) = 1;

p = plan(m,1:10);
p = exogenize(p,'x',T);
p = endogenize(p,'ex',T);
s1 = simulate(m,d,1:10,'deviation=',true,'plan=',p,'anticipate=',false);
assertEqual(This,s1.x(T),1);
assertEqual(This,s1.x(1:T-1),zeros(T-1,1));
assertGreaterThan(This,s1.ex(T),0);
assertEqual(This,s1.ex(1:T-1),zeros(T-1,1));

p = reset(p);
p = exogenize(p,'x',T);
p = endogenize(p,'ey',T);
s2 = simulate(m,d,1:10,'deviation=',true,'plan=',p,'anticipate=',false);
assertEqual(This,s2.x(T),1);
assertEqual(This,s2.x(1:T-1),zeros(T-1,1));
assertGreaterThan(This,s2.ey(T),0);
assertEqual(This,s2.ey(1:T-1),zeros(T-1,1));

p = reset(p);
p = exogenize(p,'x',T);
p = endogenize(p,'ey',T,1i);
s3 = simulate(m,d,1:10,'deviation=',true,'plan=',p,'anticipate=',true);
assertEqual(This,s3.x(T),1);
assertEqual(This,s3.x(1:T-1),zeros(T-1,1));
assertGreaterThan(This,imag(s3.ey(T)),0);
assertEqual(This,real(s3.ey(T)),0);
assertEqual(This,s3.ey(1:T-1),zeros(T-1,1));
end % testUnanticipated()


%**************************************************************************


function testUnanticipatedWeights(This)
m = This.TestData.Model;
T = 5;
d = zerodb(m,1:10);
d.x(T) = 1;
warning('off','iris:model:simulate');

p = plan(m,1:10);
p = exogenize(p,'x',T);
p = endogenize(p,'ex',T,2);
p = endogenize(p,'ey',T,1);
s1 = simulate(m,d,1:10,'deviation=',true,'plan=',p,'anticipate=',false);
assertEqual(This,s1.x(T),1,'AbsTol',1e-15);
assertEqual(This,s1.x(1:T-1),zeros(T-1,1));
assertGreaterThan(This,s1.ex(T),0);
assertGreaterThan(This,s1.ey(T),0);
assertEqual(This,s1.ex(1:T-1),zeros(T-1,1));
assertEqual(This,s1.ey(1:T-1),zeros(T-1,1));

p = reset(p);
p = exogenize(p,'x',T);
p = endogenize(p,'ex',T,1i);
p = endogenize(p,'ey',T,2i);
s2 = simulate(m,d,1:10,'deviation=',true,'plan=',p,'anticipate=',true);
assertEqual(This,s2.x(T),1,'AbsTol',1e-15);
assertEqual(This,s2.x(1:T-1),zeros(T-1,1));
assertLessThan(This,imag(s2.ex(T)),s1.ex(T));
assertGreaterThan(This,imag(s2.ey(T)),s1.ey(T));
assertEqual(This,s2.ex(1:T-1),zeros(T-1,1));
assertEqual(This,s2.ey(1:T-1),zeros(T-1,1));

warning('on','iris:model:simulate');
end % testUnanticipatedWeights()


%**************************************************************************


function testAnticipated(This)
m = This.TestData.Model;
T = 5;
d = zerodb(m,1:10);
d.x(T) = 1;

p = plan(m,1:10);
p = exogenize(p,'x',T);
p = endogenize(p,'ex',T);
s1 = simulate(m,d,1:10,'deviation=',true,'plan=',p,'anticipate=',true);
assertEqual(This,s1.x(T),1);
assertNotEqual(This,s1.x(1:T-1),zeros(T-1,1));
assertGreaterThan(This,s1.ex(T),0);
assertEqual(This,s1.ex(1:T-1),zeros(T-1,1));

p = reset(p);
p = exogenize(p,'x',T);
p = endogenize(p,'ey',T);
s2 = simulate(m,d,1:10,'deviation=',true,'plan=',p,'anticipate=',true);
assertEqual(This,s2.x(T),1);
assertNotEqual(This,s2.x(1:T-1),zeros(T-1,1));
assertGreaterThan(This,s2.ey(T),0);
assertEqual(This,s2.ey(1:T-1),zeros(T-1,1));

p = reset(p);
p = exogenize(p,'x',T);
p = endogenize(p,'ey',T,1i);
s3 = simulate(m,d,1:10,'deviation=',true,'plan=',p,'anticipate=',false);
assertEqual(This,s3.x(T),1);
assertNotEqual(This,s3.x(1:T-1),zeros(T-1,1));
assertGreaterThan(This,imag(s3.ey(T)),0);
assertEqual(This,real(s3.ey(T)),0);
assertEqual(This,s3.ey(1:T-1),zeros(T-1,1));
end % testAnticipated()


%**************************************************************************


function testAnticipatedWeights(This)
m = This.TestData.Model;
T = 5;
d = zerodb(m,1:10);
d.x(T) = 1;
warning('off','iris:model:simulate');

p = plan(m,1:10);
p = exogenize(p,'x',T);
p = endogenize(p,'ex',T,2);
p = endogenize(p,'ey',T,1);
s1 = simulate(m,d,1:10,'deviation=',true,'plan=',p,'anticipate=',true);
assertEqual(This,s1.x(T),1,'AbsTol',1e-15);
assertNotEqual(This,s1.x(1:T-1),zeros(T-1,1));
assertGreaterThan(This,s1.ex(T),0);
assertGreaterThan(This,s1.ey(T),0);
assertEqual(This,s1.ex(1:T-1),zeros(T-1,1));
assertEqual(This,s1.ey(1:T-1),zeros(T-1,1));

p = reset(p);
p = exogenize(p,'x',T);
p = endogenize(p,'ex',T,1i);
p = endogenize(p,'ey',T,2i);
s2 = simulate(m,d,1:10,'deviation=',true,'plan=',p,'anticipate=',false);
assertEqual(This,s2.x(T),1,'AbsTol',1e-15);
assertNotEqual(This,s2.x(1:T-1),zeros(T-1,1));
assertLessThan(This,imag(s2.ex(T)),s1.ex(T));
assertGreaterThan(This,imag(s2.ey(T)),s1.ey(T));
assertEqual(This,s2.ex(1:T-1),zeros(T-1,1));
assertEqual(This,s2.ey(1:T-1),zeros(T-1,1));

warning('on','iris:model:simulate');
end % testAnticipatedWeights()
