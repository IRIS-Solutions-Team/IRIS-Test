classdef testClass < model.Data
    properties (Dependent)
        NumOfVariants
        NamesOfAppendablesInData
    end

    methods
        function n = get.NumOfVariants(this)
            n = 1;
        end%

        
        function list = get.NamesOfAppendablesInData(this)
            list = {'x', 'y', 'z'};
        end%
    end
end

