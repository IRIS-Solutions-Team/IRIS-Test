classdef ExplanatoryTest ...
    < Explanatory

    methods
        function this = setp(this, name, value)
            this.(name) = value;
        end%

        function value = getp(this, name)
            value = this.(name);
        end%
    end


    methods (Static)
        function this = fromString(varargin)
            this = Explanatory.fromString(varargin{:}, 'InitObject', ExplanatoryTest( ));
        end%

        function this = fromFile(varargin)
            this = Explanatory.fromFile(varargin{:}, 'InitObject', ExplanatoryTest( ));
        end%
    end
end
