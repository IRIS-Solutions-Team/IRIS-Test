% saveAs=databank/fromFredUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once


%% Test Plain Vanilla

    db = databank.fromFred(["GDPC1", "PCE"]);
    assertEqual(testCase, sort(keys(db)), sort(["GDPC1", "PCE"]));
    assertEqual(testCase, db.GDPC1.Frequency, Frequency.QUARTERLY);
    assertEqual(testCase, db.PCE.Frequency, Frequency.MONTHLY);

    db = databank.fromFred(["GDPC1", "PCE"], "Frequency=", "Q");
    assertEqual(testCase, db.GDPC1.Frequency, Frequency.QUARTERLY);
    assertEqual(testCase, db.PCE.Frequency, Frequency.QUARTERLY);

    db = databank.fromFred(["GDPC1->gdp", "PCE->pc"]);
    assertEqual(testCase, sort(keys(db)), sort(["gdp", "pc"]));


%% Test Alias

    db = databank.fromFred(["GDPC1->gdp", "TB3MS->r3m"]);
    assertEqual(testCase, sort(keys(db)), sort(["gdp", "r3m"]));


%% Test Vintage Dates

    db = databank.fromFred( ...
        "GDPC1", "Vintage=", ["2001-09-11", "2019-12-30", "2019-12-31"] ...
    );
    assertEqual(testCase, db.GDPC1(:, 2), db.GDPC1(:, 3));


%% Test All Vintages

    v = databank.fromFred(["GDPC1", "TB3MS"], "Request=", "VintageDates");

    db = databank.fromFred("GDPC1", "Vintage=", v.GDPC1(end-5:end));
    assertEqual(testCase, size(db.GDPC1, 2), 6);
    assertTrue(testCase, all(startsWith(string(db.GDPC1.Comment), "[Vintage:")));

    db = databank.fromFred("TB3MS", "Vintage=", v.TB3MS(end-5:end));
    assertEqual(testCase, size(db.TB3MS, 2), 6);
    assertTrue(testCase, all(startsWith(string(db.TB3MS.Comment), "[Vintage:")));


%% Test AddToDatabank

    db1 = databank.fromFred(["GDPC1", "TB3MS"]);
    db2 = databank.fromFred("GDPC1");
    db2 = databank.fromFred("TB3MS", "AddToDatabank=", db2);
    assertEqual(testCase, sort(keys(db1)), sort(keys(db2)));
    for k = keys(db1)
        assertEqual(testCase, db1.(k).Data, db2.(k).Data);
    end


%% Test Progress Bar

    vintages = ["2001-09-11", "2005-11-15", "2007-05-31", "2008-09-15", "2011-03-09"];
    db = databank.fromFred(["GDPC1", "TB3MS"], "Vintage=", vintages, "Progress=", true);

