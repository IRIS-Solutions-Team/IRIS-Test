function Tests = linearKalmanTest()
Tests = functiontests(localfunctions);
end



function setupOnce(This)
m = model('linearKalmanTest.model','linear',true);
m = solve(m);
m = sstate(m);
t = 1 : 100;
d = struct();
d.XY = tseries(t,sin(t/3));
d.Z = tseries(t,cos(t/6));
This.TestData.Model = m;
This.TestData.Dbase = d;
This.TestData.Range = t;
end % setupOnce( )



function testOutOfLik(This)
m = This.TestData.Model;
d = This.TestData.Dbase;
t = This.TestData.Range;
[mf,~,v,dlt] = filter(m,d,t,'outOfLik','alpha,beta');
assertEqual(This,dlt.alpha,-0.335027881140906,'RelTol',1e-14);
assertEqual(This,dlt.beta,0.281864368642865,'RelTol',1e-14);
assertEqual(This,v,0.106218584336833,'RelTol',1e-14);
assertEqual(This,mf.std_a^2,0.106218584336833,'RelTol',1e-14);
end % testOutOfLik( )



function testChkFmse(This)
m = This.TestData.Model;
d = This.TestData.Dbase;
t = This.TestData.Range;
l = loglik(m,d,t,'chkFmse',true,'fmseCondTol',0.9);
assertEqual(This,l,model.OBJ_FUNC_PENALTY);
l = loglik(m,d,t,'chkFmse',true,'fmseCondTol',0.9,'objDecomp',true);
assertEqual(This,l(1),model.OBJ_FUNC_PENALTY);
assertEqual(This,isnan(l(2:end)),true(size(l(2:end))));
end % testChkFmse( )
