

drawnow
close all
clear

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
testCase.TestData.versionCheck = @(minVer) string(regexp(version(), 'R20..[ab]', 'match', 'once'))>=minVer;

if ~testCase.TestData.versionCheck("R2019a")
    return
end

testCase.TestData.db2 = databank.fromSheet("tabularTest.csv");


%% Vanilla test

if ~testCase.TestData.versionCheck("R2019a")
    return
end

db2 = testCase.TestData.db2;
db1 = databank.fromSheet("tabularTest.xlsx");
assertTrue(testCase, isequaln(db2, db1));


%% NaN test

if ~testCase.TestData.versionCheck("R2019a")
    return
end

db2 = testCase.TestData.db2;
databank.toSheet(db2, "tabularTest-nan.csv", "nan", "");
db3 = databank.fromSheet("tabularTest-nan.csv");
assertTrue(testCase, isequaln(db2, db3));


%% Sheet test

if ~testCase.TestData.versionCheck("R2019a")
    return
end

db2 = testCase.TestData.db2;
databank.toSheet(db2, "tabularTest-sheet.xlsx", "nan", "", "sheet", "data");
db4 = databank.fromSheet("tabularTest-sheet.xlsx", "sheet", "data");
assertTrue(testCase, isequaln(db2, db4));


%% Frequencies test

if ~testCase.TestData.versionCheck("R2019a")
    return
end

db2 = testCase.TestData.db2;
dbf = databank.fromSheet("tabularTest-frequencies.csv");
actualFreq = unique(structfun(@getFrequencyAsNumeric, dbf));
assertLength(testCase, actualFreq, 2);


%% Source names test

if ~testCase.TestData.versionCheck("R2019a")
    return
end

db2 = testCase.TestData.db2;
names = ["x", "y"];
databank.toSheet(db2, "tabularTest-names.csv", "sourceNames", names);
dbn = databank.fromSheet("tabularTest-names.csv");
assertEqual(testCase, sort(names), sort(textual.fields(dbn)));

