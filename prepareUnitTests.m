
list = listUnitTests( );
wd = fileparts(mfilename("fullpath"));

for func = reshape(list, 1, [ ])
    code = grabcode(which(func));
    saveAs = regexp(code, "^%\s*saveAs\s*=\s*(.*?)$", "LineAnchors", "Tokens", "Once");
    if isempty(saveAs) || isempty(saveAs{1}) || isequal(saveAs{1}, "")
        error("UnitTest:InvalidFile", "Invalid saveAs= in unit test code: %s", func)
    end
    saveAs = saveAs{1};
    saveAs = fullfile(wd, saveAs);
    disp(saveAs);
    if exist(saveAs, 'file')
        delete(saveAs)
    end
    fid = fopen(saveAs, 'w+t');
    fwrite(fid, code, 'char');
    fclose(fid);
end
rehash path




function list = listUnitTests( )
    list = [
        "+shared/@Plan/preparePlan"
        "NumericTimeSubscriptable/rmse"
        "NumericTimeSubscriptable/roc"
        "NumericTimeSubscriptable/genip"
        "NumericTimeSubscriptable/grow"
        "NumericTimeSubscriptable/convert"
        "NumericTimeSubscriptable/regress"
        "Series/implementPlot"
        "TimeSubscriptable/init"
        "TimeSubscriptable/getDataFromMultiple"
        "+databank/apply"
        "+databank/filter"
        "+databank/batch"
        "+databank/fromFred"
        "+databank/minusControl"
        "+databank/toSeries"
        "+databank/+backend/resolveRange"
        "+databank/+backend/extractSeriesData"
        "dates/isfreq"
        "+dater/fromIsoString"
        "Model/createTrendArray"
        "Model/fromSnippet"
        "Model/fromString"
        "+model/+component/@Quantity/implementGet"
        "+model/+component/@Quantity/initializeLogStatus"
        "Explanatory/regress"
        "Explanatory/initializeLogStatus"
        "Explanatory/getDataBlock"
        "Explanatory/lookup"
        "Explanatory/createData4Regress"
        "Explanatory/createData4Simulate"
        "Explanatory/residuals"
        "Explanatory/checkUniqueLhs"
        "Explanatory/fromFile"
        "Explanatory/fromModel"
        "Explanatory/fromString"
        "Explanatory/defineDependentTerm"
        "Explanatory/simulate"
        "+parser/DoubleDot.m"
        "+parser/Interp.m"
        "+parser/+theparser/@Equation/parse"
        "+textual/locate"
        "+textual/abbreviate"
        "+simulate/if"
        "+x13/season"
        "namedmat/subsref"
    ];
end%

