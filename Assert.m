classdef Assert
    methods (Static)
        function equal(x, y)
            assert(isequal(x, y));
        end

        function absTol(x, y, tol)
            assert(all( abs(x(:)-y(:))<tol ));
        end

        function relTol(x, y, tol)
            assert(all( abs(x(:)-y(:))<tol*(abs(x(:))+abs(y(:))) ));
        end
    end
end
            
