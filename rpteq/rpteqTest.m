function Tests = rpteqTest()
Tests = functiontests( localfunctions );
end
%#ok<*DEFNU>




function setupOnce(This)
dates = 1 : 1000;
xDates = dates(1)-10 : dates(end)+10;

inp = struct();
inp.y = tseries(xDates,@rand);
inp.x = tseries(xDates,0);
inp.z = tseries(xDates,0);
inp.x = [inp.x,inp.x];
inp.y = [inp.y,inp.y];

outp = struct();
outp.y = inp.y;
outp.x = inp.x;
outp.z = [ inp.z, inp.z ];
outp.w = tseries(NaN,nan(1,2));
for t = dates
    outp.x(t) = outp.x(t-1) + inp.y(t+1) - inp.y(t-2) ;
    outp.z(t) = outp.z(t-1) + inp.y(t+1) - inp.y(t-2) ;
    if t == 1
        outp.w(t) = [0,0];
    else
        outp.w(t) = outp.w(t-1) + inp.y(t);
    end
end
outp.x = comment(outp.x,'Eq1');
outp.z = comment(outp.z,'Eq2');
outp.w = comment(outp.w,'Eq3');

outpClip = outp;
% Do not clip `y`.
outpClip.x = resize(outpClip.x,dates);
outpClip.z = resize(outpClip.z,dates);
outpClip.w = resize(outpClip.w,dates);

This.TestData.InpDbase = inp;
This.TestData.OutpDbase = outp;
This.TestData.OutpDbaseClip = outpClip;
This.TestData.Dates = dates;
end



function testRpteqtnFile(This)
dates = This.TestData.Dates;
inp = This.TestData.InpDbase;
q = rpteq('test.rpteq');

expOutp = This.TestData.OutpDbaseClip;
actOutp = run(q,inp,dates);
assertEqual(This,actOutp,expOutp);
end



function testRpteqtnFileOverlay(This)
dates = This.TestData.Dates;
inp = This.TestData.InpDbase;
q = rpteq('test.rpteq');

expOutp = This.TestData.OutpDbase;
actOutp = run(q,inp,dates,'dbOverlay=',true);
assertEqual(This,actOutp,expOutp);
end



function testModelFile(This)
dates = This.TestData.Dates;
inp = This.TestData.InpDbase;
m = model('test.model');
q = get(m, 'reporting');

expOutp = This.TestData.OutpDbaseClip;
actOutp = reporting(m,inp,dates);
assertEqual(This,actOutp,expOutp);

actOutp = run(q, inp, dates);
assertEqual(This,actOutp,expOutp);
end




function testDirectFile(This)
dates = This.TestData.Dates;
inp = This.TestData.InpDbase;
q = rpteq([ ...
    ' "Eq1" x=x{-1} + y{1} - y{-2} ;', ...
    ' "Eq2" z=z{-1} + y{1} - y{-2} ;', ...
    ' "Eq3" w = w{-1} + y !! 0; ', ...
    ]);
expOutp = This.TestData.OutpDbaseClip;
actOutp = run(q,inp,dates);
assertEqual(This,actOutp,expOutp);
end

