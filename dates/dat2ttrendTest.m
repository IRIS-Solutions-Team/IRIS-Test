
assertEqual = @(x, y) assert(isequal(x, y));

%**************************************************************************
% Base Year Input Argument

for freq = [1, 2, 4, 12]
    rng = datcode(freq, 1990) : datcode(freq, 2100);
    nPer = length(rng);
    for b = 1980 : 10 : 2110
        ty = dat2ttrend(rng, b);
        dy = diff(ty);
        assertEqual(dy, ones(1, nPer-1));
        if b==1990
            assertEqual(ty(1), 0);
        end
        if b==2100
            assertEqual(ty(end), 0);
        end
    end
end


%**************************************************************************
% Base Year From Config

baseYear = iris.get('BaseYear');
for freq = [1, 2, 4, 12]
    rng = datcode(freq, 1990) : datcode(freq, 2100);
    nPer = length(rng);
    for b = 1980 : 10 : 2110
        iris.set('BaseYear', b);
        ty = dat2ttrend(rng);
        dy = diff(ty);
        assertEqual(dy, ones(1, nPer-1));
        if b==1990
            assertEqual(ty(1), 0);
        end
        if b==2100
            assertEqual(ty(end), 0);
        end
    end
end
iris.set('BaseYear', baseYear);

%**************************************************************************
% Base Year From Model

m = model( );
for freq = [1, 2, 4, 12]
    rng = datcode(freq, 1990) : datcode(freq, 2100);
    nPer = length(rng);
    for b = 1980 : 10 : 2110
        m = set(m, 'BaseYear', b);
        ty = dat2ttrend(rng, m);
        dy = diff(ty);
        assertEqual(dy, ones(1, nPer-1));
        if b==1990
            assertEqual(ty(1), 0);
        end
        if b==2100
            assertEqual(ty(end), 0);
        end
    end
end
