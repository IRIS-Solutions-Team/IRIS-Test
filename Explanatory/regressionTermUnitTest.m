
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


% Set up once
    expy = ExplanatoryTest( );
    expy = setp(expy, 'VariableNames', ["x", "y", "z"]);
    output = struct( );
    output.Type = "";
    output.Transform = "";
    output.Incidence = double.empty(1, 0);
    output.Position = NaN;
    output.Shift = 0;
    output.Expression = [ ];
    testCase.TestData.Model = expy;
    testCase.TestData.Output = output;


%% Test Pointer
    expy = testCase.TestData.Model;
    for ptr = 1 : numel(expy.VariableNames)
        act = regression.Term.parseInputSpecs(expy, ptr, @auto, @auto, @all);
        exd = testCase.TestData.Output;
        exd.Type = "Pointer";
        exd.Incidence = complex(ptr, 0);
        exd.Position = ptr;
        assertEqual(testCase, act, exd);
    end


%% Test Name
    expy = testCase.TestData.Model;
    for name = expy.VariableNames
        act = regression.Term.parseInputSpecs(expy, name, @auto, @auto, @all);
        exd = testCase.TestData.Output;
        exd.Type = "Name";
        ptr = find(name==expy.VariableNames);
        exd.Incidence = complex(ptr, 0);
        exd.Position = ptr;
        assertEqual(testCase, act, exd);
    end


%% Test Name Shift
    expy = testCase.TestData.Model;
    for name = expy.VariableNames
        act = regression.Term.parseInputSpecs(expy, name + "{-1}", @auto, @auto, @all);
        exd = testCase.TestData.Output;
        exd.Type = "Transform";
        ptr = find(name==expy.VariableNames);
        exd.Incidence = complex(ptr, -1);
        exd.Position = ptr;
        exd.Shift = -1;
        assertEqual(testCase, act, exd);
    end


%% Test Name Difflog Shift
    expy = testCase.TestData.Model;
    for name = expy.VariableNames
        act = regression.Term.parseInputSpecs(expy, "difflog(" + name + "{-2})", @auto, @auto, @all);
        exd = testCase.TestData.Output;
        exd.Type = "Transform";
        ptr = find(name==expy.VariableNames);
        exd.Transform = "difflog";
        exd.Incidence = [complex(ptr, -2), complex(ptr, -3)];
        exd.Position = ptr;
        exd.Shift = -2;
        assertEqual(testCase, act, exd);
    end


%% Test Transform
    expy = testCase.TestData.Model;
    for name = expy.VariableNames
        for transform = regression.Term.REGISTERED_TRANSFORMS
            shift = randi(5)-10;
            shiftSpecs = sprintf("{%g}", shift);
            act = regression.Term.parseInputSpecs(expy, transform + "(" + name + shiftSpecs + ")", @auto, @auto, @all);
            ptr = find(name==expy.VariableNames);
            exd = testCase.TestData.Output;
            exd.Type = "Transform";
            exd.Transform = transform;
            exd.Incidence = complex(ptr, shift);
            if startsWith(transform, "diff")
                exd.Incidence = [exd.Incidence, complex(ptr, shift-1)];
            end
            exd.Position = ptr;
            exd.Shift = shift;
            assertEqual(testCase, act.Type, exd.Type);
            assertEqual(testCase, act.Transform, exd.Transform);
            assertEqual(testCase, act.Incidence, exd.Incidence);
        end
    end


%% Test Expression
    expy = testCase.TestData.Model;
    act = regression.Term.parseInputSpecs(expy, "x + movavg(y, -2) - z{+3}", @auto, @auto, @all);
    exd = testCase.TestData.Output;
    exd.Type = "Expression";
    exd.Expression = @(x,t,date__,controls__)x(1,t,:)+(((x(2,t,:))+(x(2,t-1,:)))./2)-x(3,t+3,:);
    exd.Incidence = [complex(1, 0), complex(2, 0), complex(2, -1), complex(3, 3)];
    act.Expression = func2str(act.Expression);
    exd.Expression = func2str(exd.Expression);
    assertEqual(testCase, act.Expression, exd.Expression);
    assertEqual(testCase, intersect(act.Incidence, exd.Incidence, 'stable'), act.Incidence);
    assertEqual(testCase, union(act.Incidence, exd.Incidence, 'stable'), act.Incidence);

