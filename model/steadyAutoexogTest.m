function tests = steadyAutoexogTest( )
tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function setupOnce(this)
%{
Model>>>>>
!variables
    y, c, k, r
!parameters
    bet, del, alp
!log_variables
    !all_but
!equations
    r*bet = 1;
    y = del*k + c;
    y = k^alp * 1;
    alp*y = (r+del-1)*k;
!steady_autoexog
    k := del;
    y := alp;
<<<<<Model
%}
fileName = 'steadyAutoexogTest.model';
parser.grabTextFromCaller('Model', fileName);
m = model(fileName);
m.alp = 0.5;
m.bet = 0.95;
m.del = 0.10;
m.k = 20;
m = sstate(m, 'display=', 'none');
this.TestData.Model = m;
end




function compare(this, m1, m2)
v1 = getp(m1, 'Variant');
v2 = getp(m2, 'Variant');
for i = 1 : length(v1)
    assertEqual(this, v1{i}.Quantity, v2{i}.Quantity, 'AbsTol', 1e-10);
    assertEqual(this, v1{i}.StdCorr, v2{i}.StdCorr, 'AbsTol', 1e-10);
end
end





function testAutoexog(this)
m = this.TestData.Model;
m.y = 1.05*m.y;
m.k = 0.95*m.k;
m1 = sstate(m, 'exogenize=', @auto, 'endogenize=', @auto, 'display=', 'none');

m2 = m;
m2.del = m1.del;
m2.alp = m1.alp;
m2 = sstate(m2, 'display=', 'none');

compare(this, m1, m2);

m3 = sstate(m, 'exogenize=', @auto, 'endogenize=', 'alp', 'display=', 'none');

m4 = m;
m4.alp = m3.alp;
m4 = sstate(m4, 'display=', 'none');

compare(this, m3, m4);
end




function testAutoexogAll(this)
m = this.TestData.Model;
m.y = 1.05*m.y;
m.k = 0.95*m.k;
m1 = sstate(m, 'exogenize=', @auto, 'endogenize=', @auto, 'display=', 'none');
m2 = sstate(m, 'exogenize=', 'y,k', 'endogenize=', @auto, 'display=', 'none');
m3 = sstate(m, 'exogenize=', {'k','y'}, 'endogenize=', @auto, 'display=', 'none');
compare(this, m1, m2);
compare(this, m1, m3);
end




function testAutoendog(this)
m = this.TestData.Model;
m1 = m;
m1.k = 0.95*m1.k;
m1 = sstate(m1, 'exogenize=', 'k', 'endogenize=', @auto, 'display=', 'none');
m2 = m;
m2.del = m1.del;
m2 = sstate(m2, 'display=', 'none');
compare(this, m1, m2);
end




function testAutoendogAll(this)
m = this.TestData.Model;
m.y = 1.05*m.y;
m.k = 0.95*m.k;
m1 = sstate(m, 'exogenize=', @auto, 'endogenize=', @auto, 'display=', 'none');
m2 = sstate(m, 'exogenize=', @auto, 'endogenize=', 'del,alp', 'display=', 'none');
m3 = sstate(m, 'exogenize=', @auto, 'endogenize=', {'alp','del'}, 'display=', 'none');
compare(this, m1, m2);
compare(this, m1, m3);
end




function testAutoexogError(this)
m = this.TestData.Model;
m.y = 1.05*m.y;
m.k = 0.95*m.k;
try
    sstate(m, 'exogenize=', 'y,kk', 'endogenize=', @auto, 'display=', 'none');
catch exc
    id = 'IRIS:Blazer:CannotExogenize';
    assertEqual(this, exc.identifier, id);
end

try
    sstate(m, 'exogenize=', 'y,c', 'endogenize=', @auto, 'display=', 'none');
catch exc
    id = 'IRIS:Blazer:CannotAutoexogenize';
    assertEqual(this, exc.identifier, id);
end

try
    sstate(m, 'exogenize=', @auto, 'endogenize=', 'alp,AAA', 'display=', 'none');
catch exc
    id = 'IRIS:Blazer:CannotEndogenize';
    assertEqual(this, exc.identifier, id);
end

try
    sstate(m, 'exogenize=', @auto, 'endogenize=', 'alp,bet', 'display=', 'none');
catch exc
    id = 'IRIS:Blazer:CannotAutoendogenize';
    assertEqual(this, exc.identifier, id);
end
end
