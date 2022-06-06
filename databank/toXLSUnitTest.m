
%% Test

if verLessThan('matlab', '9.6')
    
    warning('Skipping some tests in %s', mfilename('fullpath'));
    
else

    d = struct();
    for f = Frequency([1, 2, 4, 12, 52, 365])
        for i = 1 : 5
            start = dater.plus(dater.today(f), randi(5));
            num = randi(15);
            d.(lower(string(f))+string(i)) = Series(start, rand(num, 1));
        end
    end

    databank.toXLS(d, "toXLSUnitTest.xlsx");
end
