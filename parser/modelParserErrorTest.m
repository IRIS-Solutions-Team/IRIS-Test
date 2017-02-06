function Tests = modelParserErrorTest( )
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>



function helper(this, code, expId, varargin)
posLast = find(expId==':', 1, 'last');
fileName = [ strrep(expId(posLast+1:end), ':', ''), '.model' ];
char2file(code, fileName);
rehash( );
actId = '';
try
    model(fileName, varargin{:});
catch exc
    actId = exc.identifier;
end

expId = exception.Base.underscore2capital(expId);
assertEqual(this, actId, ['IRIS:',expId]);
end




function testAutoexogenizeInvalidDefinition(this)
expId = 'Pairing:INVALID_NAMES_IN_DYNAMIC_AUTOEXOG';
code = '!transition_variables x; !shocks ex; !transition_equations x; !dynamic_autoexog y=ey;';
helper(this, code, expId);
end




function testAutoexogenizeMultipleShock(this)
expId = 'Pairing:MULTIPLE_RHS_AUTOEXOG';
code = '!transition_variables x, y; !shocks ex; !transition_equations x; y; !dynamic_autoexog x=ex; y=ex;';
helper(this, code, expId);
end




function testAutoexogenizeMultipleVar(this)
expId = 'Pairing:MULTIPLE_LHS_AUTOEXOG';
code = '!transition_variables x, y; !shocks ex; !transition_equations x; y; !dynamic_autoexog x=ex; x=ey;';
helper(this, code, expId);
end




function testPrefixMultiplier(this)
expId = 'Model:Postparser:PREFIX_MULTIPLIER';
code = '!transition_variables x, Mu_y; !transition_equations min(0.9) x^2+Mu_y^2; x = Mu_y;';
helper(this, code, expId);
end




function testLossFuncDiscountEmpty(this)
expId = 'Equation:LOSS_FUNC_DISCOUNT_EMPTY';
code = '!transition_variables x, y; !transition_equations min(  ) x^2+y^2; x = y;';
helper(this, code, expId);
end




function testMultipleLossFunc(this)
expId = 'Equation:MULTIPLE_LOSS_FUNC';
code = '!transition_variables x, y; !transition_equations min(0.9) x^2+y^2; min(0.9) x^3+y^3;';
helper(this, code, expId);
end




function testStdCorrInOtherThanLink(this)
expId = 'Equation:STD_CORR_IN_OTHER_THAN_LINK';
code = '!transition_variables x; !transition_shocks ex; !transition_equations x+std_ex;';
helper(this, code, expId);
end




function testInvalidStdCorrInLink(this)
expId = 'Quantity:INVALID_STD_CORR_IN_LINK';
code = '!transition_variables x; !transition_shocks ex; !transition_equations x+std_ex; !links std_ex:=std_aa;';
helper(this, code, expId);
end




function testUndeclaredMistypedName(this)
expId = 'Equation:UNDECLARED_MISTYPED_NAME';
code = '!transition_variables x; !transition_equations x+y;';
helper(this, code, expId);
end




function testSstateRefInLinear(this)
expId = 'Model:Postparser:SSTATE_REF_IN_LINEAR';
code = '!transition_variables x; !transition_equations &x;';
helper(this, code, expId, 'Linear=', true);
end




function testSstateRefInDtrend(this)
expId = 'Model:Postparser:SSTATE_REF_IN_DTREND';
code = '!transition_variables x; !transition_equations x; !measurement_variables X; !measurement_equations X=x; !dtrends X+=&x;';
helper(this, code, expId);
end




function testSstateRefInLink(this)
expId = 'Model:Postparser:SSTATE_REF_IN_LINK';
code = '!transition_variables x; !transition_equations x; !parameters a; !links a:=&x;';
helper(this, code, expId);
end




function testNameCannotBeNonnegative(this)
expId = 'Model:Postparser:NAME_CANNOT_BE_NONNEGATIVE';
code = '!transition_variables x; !measurement_variables X; !transition_equations min(1)x^2; !measurement_equations X;';
helper(this, code, expId, 'Optimal=', {'NonNegative=', 'X'});
end




function testDynamicEquationEmpty(this)
expId = 'Model:Postparser:DYNAMIC_EQUATION_EMPTY';
code = '!transition_variables x; !transition_equations !!x;';
helper(this, code, expId);
end




function testLhsVariablesMustLogInDtrend(this)
expId = 'Equation:LHS_VARIABLE_MUST_LOG_IN_DTREND';
code = '!transition_variables x; !transition_equations x; !log_variables !all_but; !measurement_variables X; !measurement_equations X; !dtrends X+=0;';
helper(this, code, expId);
end




function testInvalidLhsDtrend(this)
expId = 'Equation:INVALID_LHS_DTREND';
code = '!transition_variables x; !transition_equations x; !measurement_variables X; !measurement_equations X; !dtrends Y+=0;';
helper(this, code, expId);
end




function testInvalidLhsLink(this)
expId = 'Equation:INVALID_LHS_LINK';
code = '!transition_variables x; !transition_equations x; !links a:=x;';
helper(this, code, expId);
end




function testInvalidLhsUpdate1(this)
expId = 'Equation:INVALID_LHS_UPDATE';
code = '!transition_variables x; !transition_equations x; !parameters a; !steady_updates a{1}:=x; b{1}:=x;';
helper(this, code, expId);
end




function testInvalidLhsUpdate2(this)
expId = 'Equation:INVALID_LHS_UPDATE';
code = '!transition_variables x; !transition_equations x; !parameters a; !steady_updates a:=x;';
helper(this, code, expId);
end




function testMultipleLhsDtrend(this)
expId = 'Equation:MULTIPLE_LHS_DTREND';
code = '!transition_variables x; !transition_equations x; !measurement_variables X; !measurement_equations X; !dtrends X+=0; X+=1;';
helper(this, code, expId);
end





function testMeasurementShift(this)
expId = 'Model:Postparser:MEASUREMENT_SHIFT';
code = '!transition_variables x; !transition_equations x; !measurement_variables X; !measurement_equations X+X{-1};';
helper(this, code, expId);
end




function testMeasurementVariableInTransition(this)
expId = 'Model:Postparser:MEASUREMENT_VARIABLE_IN_TRANSITION';
code = '!transition_variables x; !measurement_variables X; !transition_equations x+X; !measurement_equations X;';
helper(this, code, expId);
end




function testLeadOfTransitionInMeasurement(this)
expId = 'Model:Postparser:LEAD_OF_TRANSITION_IN_MEASUREMENT';
code = '!transition_variables x; !measurement_variables X; !transition_equations x; !measurement_equations X+x{1};';
helper(this, code, expId);
end




function testNoCurrentMeasurement(this)
expId = 'Model:Postparser:NO_CURRENT_MEASUREMENT';
code = '!transition_variables x; !measurement_variables X; !transition_equations x; !measurement_equations 1;';
helper(this, code, expId);
end




function testTransitionShockInMeasurement(this)
expId = 'Model:Postparser:TRANSITION_SHOCK_IN_MEASUREMENT';
code = '!transition_variables x; !transition_shocks ex; !measurement_variables X; !transition_equations x; !measurement_equations X+ex;';
helper(this, code, expId);
end




function testMeasurementShockInTransition(this)
expId = 'Model:Postparser:MEASUREMENT_SHOCK_IN_TRANSITION';
code = '!transition_variables x; !measurement_shocks ex; !transition_equations x+ex;';
helper(this, code, expId);
end




function testOtherThanParametersExogenousInDtrend(this)
expId = 'Model:Postparser:OTHER_THAN_PARAMETER_EXOGENOUS_IN_DTREND';
code = '!transition_variables x; !transition_equations x; !measurement_variables X; !measurement_equations X; !dtrends X+=x;';
helper(this, code, expId);
end




function testExogenousInOtherThanDtrend(this)
expId = 'Model:Postparser:EXOGENOUS_IN_OTHER_THAN_DTREND';
code = '!transition_variables x; !exogenous_variables y; !transition_equations x+y;';
helper(this, code, expId);
end




function testMisplacedTimeSubscript(this)
expId = 'Model:Postparser:SHOCK_SHIFT';
code = '!transition_variables x; !transition_shocks ex; !transition_equations x+ex{-1};';
helper(this, code, expId);

expId = 'Model:Postparser:MISPLACED_TIME_SUBSCRIPT';
code = '!transition_variables x; !transition_equations x+{-1};';
helper(this, code, expId);
end




function testMisplacedSteadyReference(this)
expId = 'Model:Postparser:MISPLACED_STEADY_REFERENCE';
code = '!transition_variables x; !parameters p; !transition_equations x&+p;';
helper(this, code, expId);
end




function testNoCurrentDateDynamic(this)
expId = 'Model:Postparser:NO_CURRENT_DATE_IN_DYNAMIC';
code = '!transition_variables x; !transition_equations x{-1};';
helper(this, code, expId);

expId = 'Model:Postparser:NO_CURRENT_DATE_IN_DYNAMIC';
code = '!transition_variables x; !measurement_variables X, Y; !transition_equations x; !measurement_equations Y; Y;';
helper(this, code, expId);
end




function testNoCurrentDateSteady(this)
expId = 'Model:Postparser:NO_CURRENT_DATE_IN_STEADY';
code = '!transition_variables x, y; !transition_equations x!!x; y!!x;';
helper(this, code, expId);

expId = 'Model:Postparser:NO_CURRENT_DATE_IN_STEADY';
code = '!transition_variables x; !transition_equations x; !measurement_variables X; !measurement_equations X!!x;';
helper(this, code, expId);
end




function testNoTransitionVariableInEquation(this)
expId = 'Model:Postparser:NO_TRANSITION_VARIABLE_IN_DYNAMIC';
code = '!transition_variables x, y; !transition_equations x+y; 1;';
helper(this, code, expId);

expId = 'Model:Postparser:NO_TRANSITION_VARIABLE_IN_STEADY';
code = '!transition_variables x, y; !transition_equations x!!x+y; y!!1;';
helper(this, code, expId);
end




function testNumberEquationsVariables(this)
expId = 'Model:Postparser:NUMBER_TRANSITION_EQUATIONS_VARIABLES';
code = '!transition_variables x, y; !transition_equations x; y; y;';
helper(this, code, expId);

expId = 'Model:Postparser:NUMBER_MEASUREMENT_EQUATIONS_VARIABLES';
code = '!transition_variables x; !transition_equations x; !measurement_variables X, Y; !measurement_equations X; Y; Y;';
helper(this, code, expId);
end
