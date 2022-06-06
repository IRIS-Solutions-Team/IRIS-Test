classdef testClass < iris.mixin.DatabankPipe
    methods
        function n = countVariants(this)
            n = 1;
        end%


        function list = nameAppendables(this)
            list = {'x', 'y', 'z'};
        end%


        function [minSh, maxSh] = getActualMinMaxShifts(this)
            minSh = 0;
            maxSh = 0;
        end%
    end
end

