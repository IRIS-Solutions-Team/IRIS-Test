classdef testClass < shared.DatabankPipe
    properties (Dependent)
        NumOfVariants
        NamesOfAppendables
    end

    methods
        function n = get.NumOfVariants(this)
            n = 1;
        end%

        
        function list = get.NamesOfAppendables(this)
            list = {'x', 'y', 'z'};
        end%
    end
end

