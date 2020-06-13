
list = listUnitTests( );
wd = fileparts(mfilename("fullpath"));

for func = list
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
        "TimeSubscriptable/init"
        "+databank/filter"
        "+databank/batch"
        "dates/isfreq"
        "Model/createTrendArray"
        ..."+model/+component/@Quantity/initializeLogStatus"
        ..."Explanatory/initializeLogStatus"
        "Explanatory/getDataBlock"
        "Explanatory/lookup"
        "Explanatory/createModelData"
        "Explanatory/regress"
        "Explanatory/residuals"
        "Explanatory/checkUniqueLhs"
        "+parser/Interp.m"
        "+parser/+theparser/@Equation/parse"
        "+textual/locate"
        "+textual/abbreviate"
        "+simulate/if"
    ];
    list = reshape(list, 1, [ ]);
end%

