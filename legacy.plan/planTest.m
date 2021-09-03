function Tests = planTest()
Tests = functiontests( localfunctions );
end
%#ok<*DEFNU>


%**************************************************************************


function testExogenize(This)
p = plan([], qq(2000,1):qq(2001,4), ...
    {'x','y','z'}, ...
    {'ex','ey','ez'});

p = exogenize(p,'x',qq(2000,1:2));
p = exogenize(p,'y,z',qq(2001,1:2));
expXAnch = false(3,8);
expXAnch(1,1:2) = true;
expXAnch(2:3,5:6) = true;
actXAnch = p.XAnch;
assertEqual(This,actXAnch,expXAnch);

p = endogenize(p,'y',qq(2001,1:2));
expXAnch = false(3,8);
expXAnch(1,1:2) = true;
expXAnch(3,5:6) = true;
actXAnch = p.XAnch;
assertEqual(This,actXAnch,expXAnch);
end % testExogenize()


%**************************************************************************


function testEndogenize(This)
p = plan([], qq(2000,1):qq(2001,4), ...
    {'x','y','z'}, ...
    {'ex','ey','ez'});

p = endogenize(p,'ex',qq(2000,1:2));
p = endogenize(p,'ey,ez',qq(2001,1:2));
expNAnchReal = false(3,8);
expNAnchImag = false(3,8);
expNAnchReal(1,1:2) = true;
expNAnchReal(2:3,5:6) = true;
actNAnchReal = p.NAnchReal;
actNAnchImag = p.NAnchImag;
assertEqual(This,actNAnchReal,expNAnchReal);
assertEqual(This,actNAnchImag,expNAnchImag);

p = exogenize(p,'ey',qq(2001,1:2));
expNAnchReal = false(3,8);
expNAnchImag = false(3,8);
expNAnchReal(1,1:2) = true;
expNAnchReal(3,5:6) = true;
actNAnchReal = p.NAnchReal;
actNAnchImag = p.NAnchImag;
assertEqual(This,actNAnchReal,expNAnchReal);
assertEqual(This,actNAnchImag,expNAnchImag);

p = reset(p);
p = endogenize(p,'ex',qq(2000,1:2),1i);
p = endogenize(p,'ey,ez',qq(2001,1:2),1i);
expNAnchReal = false(3,8);
expNAnchImag = false(3,8);
expNAnchImag(1,1:2) = true;
expNAnchImag(2:3,5:6) = true;
actNAnchReal = p.NAnchReal;
actNAnchImag = p.NAnchImag;
assertEqual(This,actNAnchReal,expNAnchReal);
assertEqual(This,actNAnchImag,expNAnchImag);
end % testEndogenize()


%**************************************************************************


function testWeights(This)
p = plan([ ], qq(2000,1):qq(2001,4), ...
    {'x','y','z'}, ...
    {'ex','ey','ez'});

p = endogenize(p,'ex',qq(2000,1:2),2);
p = endogenize(p,'ey,ez',qq(2001,1:2),10);
expNWghtReal = zeros(3,8);
expNAnchImag = zeros(3,8);
expNWghtReal(1,1:2) = 2;
expNWghtReal(2:3,5:6) = 10;
actNAnchReal = p.NWghtReal;
actNAnchImag = p.NWghtImag;
assertEqual(This,actNAnchReal,expNWghtReal);
assertEqual(This,actNAnchImag,expNAnchImag);

p = exogenize(p,'ey',qq(2001,1:2));
expNWghtReal = zeros(3,8);
expNAnchImag = zeros(3,8);
expNWghtReal(1,1:2) = 2;
expNWghtReal(3,5:6) = 10;
actNAnchReal = p.NWghtReal;
actNAnchImag = p.NWghtImag;
assertEqual(This,actNAnchReal,expNWghtReal);
assertEqual(This,actNAnchImag,expNAnchImag);

p = reset(p);
p = endogenize(p,'ex',qq(2000,1:2),2i);
p = endogenize(p,'ey,ez',qq(2001,1:2),10i);
expNWghtReal = zeros(3,8);
expNAnchImag = zeros(3,8);
expNAnchImag(1,1:2) = 2;
expNAnchImag(2:3,5:6) = 10;
actNAnchReal = p.NWghtReal;
actNAnchImag = p.NWghtImag;
assertEqual(This,actNAnchReal,expNWghtReal);
assertEqual(This,actNAnchImag,expNAnchImag);
end % testWeights()
