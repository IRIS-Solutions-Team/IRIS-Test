
% Setup once

m = Model( 'testSimulateContributions.model', ...
           'Growth', true );

m.alpha = 1.03^(1/4);
m.beta = 0.985^(1/4);
m.gamma = 0.60;
m.delta = 0.03;
m.pi = 1.025^(1/4);
m.eta = 6;
m.k = 10;
m.psi = 0.25;

m.chi = 0.85;
m.xiw = 60;
m.xip = 300;
m.rhoa = 0.90;

m.rhor = 0.85;
m.kappap = 3.5;
m.kappan = 0;

m.Short_ = -2;
m.Infl_ = 1.5;
m.Growth_ = 1;
m.Wage_ = 2;

m.std_Mp = 0;
m.std_Mw = 0;
m.std_Ea = 0.001;

m = sstate( m, ...
            'Solver', {'IRIS-Qnsd', 'Display', false} );
chksstate(m);
m = solve(m);

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Shock Responses

listOfY = get(m, 'YNames');
listOfE = get(m, 'ENames');
s1 = srf(m, 1:10, 'Size', log(1.01));
for i = 1 : numel(listOfE)
    name = listOfE{i};
    d = zerodb(m, 1:10);
    d.(name)(1) = log(1.01);
    s2 = simulate(m, d, 1:10, 'Deviation', true);
    for j = 1 : numel(listOfY)
        assertEqual( testCase, ...
                     s1.(listOfY{j})(1:10, i), ...
                     s2.(listOfY{j})(1:10), ...
                     'AbsTol', 1e-12 );
    end
end


%% Test Shock Responses with Select=

listOfY = get(m, 'YNames');
listOfE = get(m, 'ENames');
selectionOfE = fliplr(listOfE(1:2:end));
s1 = srf(m, 1:10, 'Size', log(1.01), 'Select', selectionOfE);
for i = 1 : numel(selectionOfE)
    name = selectionOfE{i};
    d = zerodb(m, 1:10);
    d.(name)(1) = log(1.01);
    s2 = simulate(m, d, 1:10, 'Deviation', true);
    for j = 1 : numel(listOfY)
        assertEqual( testCase, ...
                     s1.(listOfY{j})(1:10, i), ...
                     s2.(listOfY{j})(1:10), ...
                     'AbsTol', 1e-12 );
    end
end


%% Test Init Cond Responses

listOfY = get(m, 'YNames');
listOfInit = get(m, 'InitCond');
s1 = icrf(m, 1:10);
for i = 1 : numel(listOfInit)
    initCond = listOfInit{i};
    [name, lag] = getNameLag(initCond);
    d = zerodb(m, 1:10);
    d.(name)(1+lag) = 1.01;
    s2 = simulate(m, d, 1:10, 'Deviation', true);
    for j = 1 : numel(listOfY)
        assertEqual( testCase, ...
                     s1.(listOfY{j})(1:10, i), ...
                     s2.(listOfY{j})(1:10), ...
                     'AbsTol', 1e-12 );
    end
end


%
% Local Functions
%

function [name, lag] = getNameLag(initCond)
    tkn = regexp(initCond, '(\w+)\{(\-\d+)\}', 'tokens', 'once');
    name = tkn{1};
    lag = str2num(tkn{2});
end%

