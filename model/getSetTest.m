function tests = getSetTest( )
tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function setupOnce(this)
m = model('modelGetSetTest.model', 'linear=', true);
this.TestData.Model = m;
end




function testGetParameters(this)
m = this.TestData.Model;

actDbPlain = get(m, 'PlainParameters');
expDbPlain = struct( ...
    'a', [1, 1], ...
    'b', [2, 3], ...
    'c', [4, 4] ...
    );
assertEqual(this, actDbPlain, expDbPlain);

actDbStd = get(m, 'Std');
expDbStd = struct( ...
    'std_uv', [1.5, 1.5], ...
    'std_uw', [2.1, 3.5], ...
    'std_ex', [1, 1], ...
    'std_ey', [0.5, 0.3], ...
    'std_ez', [1, 1] ...
    );
assertEqual(this, actDbStd, expDbStd);

actDbCorr = get(m, 'NonzeroCorr');
expDbCorr = struct( ...
    'corr_uv__uw', [0.5, -0.5], ...
    'corr_ex__ez', [-1, -1], ...
    'corr_uw__ey', [1, -1] ...
    );
assertEqual(this, actDbCorr, expDbCorr);

actDb = get(m, 'Parameters');
expDb = dbmerge( ...
    actDbPlain, ...
    actDbStd, ...
    actDbCorr ...
    );
assertEqual(this, actDb, expDb);
end




function testReset(this)
m = this.TestData.Model;
m1 = reset(m, 'PlainParameters');
actDbPar = get(m1, 'PlainParameters');
expDbPar = struct( ...
    'a', [NaN, NaN], ...
    'b', [NaN, NaN], ...
    'c', [NaN, NaN] ...
    );
assertEqual(this, actDbPar, expDbPar);

m1 = reset(m, 'Std');
actDbStd = get(m1, 'Std');
expDbStd = struct( ...
    'std_uv', [1, 1], ...
    'std_uw', [1, 1], ...
    'std_ex', [1, 1], ...
    'std_ey', [1, 1], ...
    'std_ez', [1, 1] ...
    );
assertEqual(this, actDbStd, expDbStd);

m1 = reset(m, 'Corr');
actDbCorr = get(m1, 'NonzeroCorr');
expDbCorr = struct( );
assertEqual(this, actDbCorr, expDbCorr);
end




function testGetOmega(this)
m = this.TestData.Model;
actOmg = omega(m);
actStd1 = sqrt(diag(actOmg(:, :, 1)));
actStd2 = sqrt(diag(actOmg(:, :, 2)));
expStd1 = [1.5; 2.1; 1; 0.5; 1];
expStd2 = [1.5; 3.5; 1; 0.3; 1];
assertEqual(this, actStd1, expStd1);
assertEqual(this, actStd2, expStd2);
end




function testSetOmega(this)
m = this.TestData.Model;
newOmg = repmat(eye(5), 1, 1, 2);
m1 = omega(m, newOmg);
actOmg = omega(m1);
assertEqual(this, actOmg, newOmg);

actDbStd = get(m1, 'Std');
expDbStd = struct( ...
    'std_uv', [1, 1], ...
    'std_uw', [1, 1], ...
    'std_ex', [1, 1], ...
    'std_ey', [1, 1], ...
    'std_ez', [1, 1] ...
    );
assertEqual(this, actDbStd, expDbStd);

actDbCorr = get(m1, 'NonzeroCorr');
expDbCorr = struct( );
assertEqual(this, actDbCorr, expDbCorr);    
end
