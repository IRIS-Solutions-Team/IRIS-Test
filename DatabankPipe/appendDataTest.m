
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Pre Scalar

x = testClass( );
startDate = qq(2001,1);
endDate = qq(2005,4);
range = startDate : endDate;
numPeriods = numel(range);
startPresample = startDate-10;
endPostSample = endDate+10;

outputData = struct( );
outputData.x = Series(range, 1:numPeriods);
outputData.y = Series(startDate-1:endDate, 0:numPeriods);
outputData.z = Series(startDate-2:endDate-1, 0:numPeriods);
outputData.a = Series(range, 1:numPeriods);

inputData = struct( );
inputData.x = Series(startPresample:endPostSample, @rand);
inputData.y = Series(startPresample:endPostSample, @rand);
inputData.z = Series(startPresample:endPostSample, @rand);
inputData.a = Series(startPresample:endPostSample, @rand);

inputData1 = struct( );
inputData1.x = Series(startPresample:endPostSample, @rand);
inputData1.y = Series(startPresample:endPostSample, @rand);
inputData1.z = Series(startPresample:endPostSample, @rand);
inputData1.a = Series(startPresample:endPostSample, @rand);

outputData1 = appendData(x, inputData, outputData, range, true, false);

expX = [ 
    inputData.x(startPresample:startDate-1)
    outputData.x(startDate:endDate)
];
actX = outputData1.x(:);
assertEqual(testCase, actX, expX);

expY = [ 
    inputData.y(startPresample:startDate-2)
    outputData.y(startDate-1:endDate)
];
actY = outputData1.y(:);
assertEqual(testCase, actY, expY);

expZ = [ 
    inputData.z(startPresample:startDate-3)
    outputData.z(startDate-2:endDate-1)
];
actZ = outputData1.z(:);
assertEqual(testCase, actZ, expZ);

opt = struct('AppendPresample', inputData, 'AppendPostsample', false);
outputData2 = appendData(x, inputData1, outputData, range, opt);
assertEqual(testCase, outputData1, outputData2);

assertEqual(testCase, outputData1.a(:), outputData.a(:));


%% Test Pre Scalar Missing Series

x = testClass( );
startDate = qq(2001,1);
endDate = qq(2005,4);
range = startDate : endDate;
numPeriods = numel(range);
startPresample = startDate-10;
endPostSample = endDate+10;

outputData = struct( );
outputData.x = Series(range, 1:numPeriods);
outputData.y = Series(startDate-1:endDate, 0:numPeriods);
outputData.z = Series(startDate-2:endDate-1, 0:numPeriods);
outputData.a = Series(range, 1:numPeriods);

inputData = struct( );
inputData.x = Series(startPresample:endPostSample, @rand);
inputData.z = Series(startPresample:endPostSample, @rand);
inputData.a = Series(startPresample:endPostSample, @rand);

outputData1 = appendData(x, inputData, outputData, range, true, false);

expX = [ 
    inputData.x(startPresample:startDate-1)
    outputData.x(startDate:endDate)
];
actX = outputData1.x(:);
assertEqual(testCase, actX, expX);

expY = [ 
    outputData.y(startDate-1:endDate)
];
actY = outputData1.y(:);
assertEqual(testCase, actY, expY);

expZ = [ 
    inputData.z(startPresample:startDate-3)
    outputData.z(startDate-2:endDate-1)
];
actZ = outputData1.z(:);
assertEqual(testCase, actZ, expZ);


%% Test Post Scalar

x = testClass( );
startDate = qq(2001,1);
endDate = qq(2005,4);
range = startDate : endDate;
numPeriods = numel(range);
startPresample = startDate-10;
endPostSample = endDate+10;

outputData = struct( );
outputData.x = Series(range, 1:numPeriods);
outputData.y = Series(startDate-1:endDate, 0:numPeriods);
outputData.z = Series(startDate-2:endDate-1, 0:numPeriods);

inputData = struct( );
inputData.x = Series(startPresample:endPostSample, @rand);
inputData.y = Series(startPresample:endPostSample, @rand);
inputData.z = Series(startPresample:endPostSample, @rand);

inputData1 = struct( );
inputData1.x = Series(startPresample:endPostSample, @rand);
inputData1.y = Series(startPresample:endPostSample, @rand);
inputData1.z = Series(startPresample:endPostSample, @rand);

outputData1 = appendData(x, inputData, outputData, range, true, true);

expX = [ 
    inputData.x(startPresample:startDate-1)
    outputData.x(startDate:endDate)
    inputData.x(endDate+1:endPostSample)
];
actX = outputData1.x(:);
assertEqual(testCase, actX, expX);

expY = [ 
    inputData.y(startPresample:startDate-2)
    outputData.y(startDate-1:endDate)
    inputData.y(endDate+1:endPostSample)
];
actY = outputData1.y(:);
assertEqual(testCase, actY, expY);

expZ = [ 
    inputData.z(startPresample:startDate-3)
    outputData.z(startDate-2:endDate-1)
    NaN
    inputData.z(endDate+1:endPostSample)
];
actZ = outputData1.z(:);
assertEqual(testCase, actZ, expZ);

opt = struct('DbOverlay', true);
outputData2 = appendData(x, inputData, outputData, range, opt);
assertEqual(testCase, outputData1, outputData2);

opt = struct('DbOverlay', inputData);
outputData3 = appendData(x, [ ], outputData, range, opt);
assertEqual(testCase, outputData1, outputData3);

opt = struct('DbOverlay', inputData);
outputData4 = appendData(x, inputData1, outputData, range, opt);
assertEqual(testCase, outputData1, outputData4);


%% Test Pre Multi

x = testClass( );
startDate = qq(2001,1);
endDate = qq(2005,4);
range = startDate : endDate;
numPeriods = numel(range);
startPresample = startDate-10;
endPostSample = endDate+10;

outputData = struct( );
outputData.x = Series(range, repmat((1:numPeriods)', 1, 5, 3));
outputData.y = Series(startDate-1:endDate, repmat((0:numPeriods)', 1, 5, 3));
outputData.z = Series(startDate-2:endDate-1, repmat((0:numPeriods)', 1, 5, 3));

inputData = struct( );
inputData.x = Series(startPresample:endPostSample, @rand);
inputData.y = Series(startPresample:endPostSample, @rand);
inputData.z = Series(startPresample:endPostSample, @rand);

outputData1 = appendData(x, inputData, outputData, range, true, false);

expX = [ 
    repmat(inputData.x(startPresample:startDate-1), 1, 5, 3)
    outputData.x(startDate:endDate)
];
actX = outputData1.x(:);
assertEqual(testCase, actX, expX);

expY = [ 
    repmat(inputData.y(startPresample:startDate-2), 1, 5, 3)
    outputData.y(startDate-1:endDate)
];
actY = outputData1.y(:);
assertEqual(testCase, actY, expY);

expZ = [ 
    repmat(inputData.z(startPresample:startDate-3), 1, 5, 3)
    outputData.z(startDate-2:endDate-1)
];
actZ = outputData1.z(:);
assertEqual(testCase, actZ, expZ);

