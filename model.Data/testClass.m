classdef testClass < model.Data
    properties (Dependent)
        NumVariants
        NamesAppendable
    end

    methods
        function n = get.NumVariants(this)
            n = 1;
        end%

        
        function list = get.NamesAppendable(this)
            list = {'x', 'y', 'z'};
        end%
    end
end

