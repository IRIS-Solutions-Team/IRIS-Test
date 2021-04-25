% saveAs=dater/fromIsoStringUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Full String
    assertEqual(testCase, dater.fromIsoString(Frequency.DAILY, "2020-05-15"), dater.dd(2020,05,15));
    assertEqual(testCase, dater.fromIsoString(Frequency.WEEKLY, "2020-05-15"), dater.ww(2020,05,15));
    assertEqual(testCase, dater.fromIsoString(Frequency.MONTHLY, "2020-05-15"), dater.mm(2020,05));
    assertEqual(testCase, dater.fromIsoString(Frequency.QUARTERLY, "2020-05-15"), dater.qq(2020,2));
    assertEqual(testCase, dater.fromIsoString(Frequency.YEARLY, "2020-05-15"), dater.yy(2020));


%% Test Year Month String
    assertEqual(testCase, dater.fromIsoString(Frequency.DAILY, "2020-05"), dater.dd(2020,05,01));
    assertEqual(testCase, dater.fromIsoString(Frequency.WEEKLY, "2020-05"), dater.ww(2020,05,01));
    assertEqual(testCase, dater.fromIsoString(Frequency.MONTHLY, "2020-05"), dater.mm(2020,05));
    assertEqual(testCase, dater.fromIsoString(Frequency.QUARTERLY, "2020-05"), dater.qq(2020,2));
    assertEqual(testCase, dater.fromIsoString(Frequency.YEARLY, "2020-05"), dater.yy(2020));
    

%% Test Year String
    assertEqual(testCase, dater.fromIsoString(Frequency.DAILY, "2020"), dater.dd(2020,01,01));
    assertEqual(testCase, dater.fromIsoString(Frequency.WEEKLY, "2020"), dater.ww(2020,01,01));
    assertEqual(testCase, dater.fromIsoString(Frequency.MONTHLY, "2020"), dater.mm(2020,01));
    assertEqual(testCase, dater.fromIsoString(Frequency.QUARTERLY, "2020"), dater.qq(2020,1));
    assertEqual(testCase, dater.fromIsoString(Frequency.YEARLY, "2020"), dater.yy(2020));
    