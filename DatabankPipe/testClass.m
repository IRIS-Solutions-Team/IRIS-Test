classdef testClass < shared.DatabankPipe
    properties (Dependent)
        NumVariants
        NamesOfAppendables
    end

    methods
        function n = get.NumVariants(this)
            n = 1;
        end%

        
        function list = get.NamesOfAppendables(this)
            list = {'x', 'y', 'z'};
        end%
    end
end

