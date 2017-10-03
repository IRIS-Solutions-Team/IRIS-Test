classdef Assert
    methods (Static)
        function equal(x, y)
            assert(isequal(x, y));
        end

        function equaln(x, y)
            assert(isequaln(x, y));
        end

        function absTol(x, y, tol)
            assert(all( abs(x(:)-y(:))<tol ));
        end

        function relTol(x, y, tol)
            assert(all( abs(x(:)-y(:))<tol*(abs(x(:))+abs(y(:))) ));
        end

        function equalFields(d1, d2, tol)
            flag = true;
            list1 = sort(fieldnames(d1));
            list2 = sort(fieldnames(d2));
            if ~isequal(list1, list2)
                flag = false;
                return
            end
            for i = 1 : length(list1)
                name = list1{i};
                x1 = d1.(name);
                x2 = d2.(name);
                if isa(x1, 'series.Abstract') && isa(x2, 'series.Abstract')
                    x1 = x1.Data;
                    x2 = x2.Data;
                end
                if isnumeric(x1) && isnumeric(x2) && all(size(x1)==size(x2))
                    if maxabs(x1(:)-x2(:))>tol
                        flag = false;
                        return
                    end
                elseif ~isequal(x1, x2)
                    flag = false;
                    return
                end
            end
            assert(flag);
        end

        function numberOfFigures(expectedNumFigures)
            allFigures = get(0, 'Children');
            numFigures = numel(allFigures);
            assert(numFigures==expectedNumFigures);
        end

        function numberOfAxes(expectedNumAxes)
            allFigures = get(0, 'Children');
            numFigures = numel(allFigures);
            for i = 1 : numFigures
                ithFigure = allFigures(i);
                allAxes = get(ithFigure, 'Children');
                numAxes = numel(allAxes);
                assert(numAxes==expectedNumAxes);
            end
        end
    end
end
            
