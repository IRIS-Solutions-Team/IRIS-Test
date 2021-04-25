
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Saving to And Loading from CSV

load csvTest.mat dbcab
databank.toCSV(dbcab, 'temp1.csv', Inf, 'Decimals', 15);
db = databank.fromCSV('temp1.csv');
flag = compareDatabanks(dbcab, db);
assertEqual(testCase, flag, true);


%
% Local Functions
%

function flag = compareDatabanks(in1, in2)
    list = intersect(string(fieldnames(in1)), string(fieldnames(in2)));
    flag = true;
    for each = reshape(list, 1, [ ])
        x1 = in1.(each);
        x2 = in2.(each);
        if ~isequal(size(x1), size(x2))
            flag = false;
            return
            % fprintf('Incorrect size: %s\n', each);
        end
        disc = maxabs(x1, x2);
        if disc>1e-14
            flag = false;
            return
            % fprintf('Intolerable discrepancy: %s %g\n', each, disc);
        end
    end
end%

