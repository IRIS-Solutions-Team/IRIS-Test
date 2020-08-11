
this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test Aggregate
    x = Series(mm(2000, 1:13), 1:13);
    xMean = convert(x, 4, 'Method=', @mean);
    xFirst1 = convert(x, 4, 'Method=', 'first');
    xFirst2 = convert(x, 4, 'Method=', @first);
    xLast1 = convert(x, 4, 'Method=', 'last');
    xLast2 = convert(x, 4, 'Method=', @last);
    xSelect1 = convert(x, 4, 'Select=', 1);
    xSelect2 = convert(x, 4, 'Select=', 1:2);
    actMean = xMean(:);
    actFirst1 = xFirst1(:);
    actFirst2 = xFirst2(:);
    actLast1 = xLast1(:);
    actLast2 = xLast2(:);
    actSelect1 = xSelect1(:);
    actSelect2 = xSelect2(:);
    assertEqual(this, actMean, [2;5;8;11]);
    assertEqual(this, actFirst1, [1;4;7;10;13]);
    assertEqual(this, actFirst2, [1;4;7;10;13]);
    assertEqual(this, actLast1, [3;6;9;12]);
    assertEqual(this, actLast2, [3;6;9;12]);
    assertEqual(this, actSelect1, [1;4;7;10;13]);
    assertEqual(this, actSelect2, [1.5;4.5;7.5;10.5]);



%% Test AggregateIgnoreNaN
    x = Series(mm(2000, 1:13), 1:13);
    xMean = convert(x, 4, 'Method=', @mean, 'IgnoreNaN=', true);
    xFirst1 = convert(x, 4, 'Method=', 'first', 'IgnoreNaN=', true);
    xFirst2 = convert(x, 4, 'Method=', @first, 'IgnoreNaN=', true);
    xLast1 = convert(x, 4, 'Method=', 'last', 'IgnoreNaN=', true);
    xLast2 = convert(x, 4, 'Method=', @last, 'IgnoreNaN=', true);
    xSelect1 = convert(x, 4, 'Select=', 1, 'IgnoreNaN=', true);
    xSelect2 = convert(x, 4, 'Select=', 1:2, 'IgnoreNaN=', true);
    actMean = xMean(:);
    actFirst1 = xFirst1(:);
    actFirst2 = xFirst2(:);
    actLast1 = xLast1(:);
    actLast2 = xLast2(:);
    actSelect1 = xSelect1(:);
    actSelect2 = xSelect2(:);
    assertEqual(this, actMean, [2;5;8;11;13]);
    assertEqual(this, actFirst1, [1;4;7;10;13]);
    assertEqual(this, actFirst2, [1;4;7;10;13]);
    assertEqual(this, actLast1, [3;6;9;12;13]);
    assertEqual(this, actLast2, [3;6;9;12;13]);
    assertEqual(this, actSelect1, [1;4;7;10;13]);
    assertEqual(this, actSelect2, [1.5;4.5;7.5;10.5]);



%% Test CommentAggregate
    expectedComment = {'Aaa', 'Bbb', 'Ccc', 'Ddd', 'Eee', 'Fff'};
    expectedComment = reshape(expectedComment, 1, 2, 3);
    x = Series(mm(2000, 1:40), rand(40, 2, 3), expectedComment);
    y = convert(x, 4);
    actualComment = y.Comment;
    assertEqual(this, actualComment, expectedComment);

        

%% Test CommentInterpolate
    expectedComment = {'Aaa', 'Bbb', 'Ccc', 'Ddd', 'Eee', 'Fff'};
    expectedComment = reshape(expectedComment, 1, 2, 3);
    x = Series(qq(2000, 1:40), rand(40, 2, 3), expectedComment);
    y = convert(x, 12);
    actualComment = y.Comment;
    assertEqual(this, actualComment, expectedComment);

        

%% Test CommentInterpolateAndMatch
    expectedComment = {'Aaa', 'Bbb', 'Ccc', 'Ddd', 'Eee', 'Fff'};
    expectedComment = reshape(expectedComment, 1, 2, 3);
    for freq = [1, 2, 4] 
        x = Series(numeric.datecode(freq, 2001), rand(10*freq, 2, 3), expectedComment);
        y = convert(x, 12, 'Method=', 'QuadSum');
        y1 = convert(x, 12, 'Method=', "QuadSum");
        z = convert(x, 12, 'Method=', 'QuadMean');
        z1 = convert(x, 12, 'Method=', "QuadMean");
        expectedData = x.Data;
        actualSum = zeros(0, 2, 3);
        actualMean = zeros(0, 2, 3);
        within = round(12/freq);
        for i = 1 : within : size(y.Data, 1)
            actualSum = [actualSum; sum(y.Data(i+(0:within-1), :, :), 1)];
            actualMean = [actualMean; mean(z.Data(i+(0:within-1), :, :), 1)];
        end
        assertEqual(this, y.Data, y1.Data, "AbsTol", 1e-14);
        assertEqual(this, z.Data, z1.Data, "AbsTol", 1e-14);
        assertEqual(this, actualSum, expectedData, "AbsTol", 1e-14);
        assertEqual(this, actualMean, expectedData, "AbsTol", 1e-14);
        actualComment = y.Comment;
        assertEqual(this, actualComment, expectedComment);
    end

        
