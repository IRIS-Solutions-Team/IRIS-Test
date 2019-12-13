
%% Test Autoexogenize Invalid Definition

expId = 'Pairing:INVALID_NAMES_IN_DYNAMIC_AUTOEXOG';
code = '!transition_variables x; !shocks ex; !transition_equations x; !dynamic_autoexog y=ey;';
modelParserErrorHelper(code, expId);


%% Test Autoexogenize Multiple Shocks

expId = 'Pairing:MULTIPLE_RHS_AUTOEXOG';
code = '!transition_variables x, y; !shocks ex; !transition_equations x; y; !dynamic_autoexog x=ex; y=ex;';
modelParserErrorHelper(code, expId);


%% Test Autoexogenize Multiple Var

expId = 'Pairing:MULTIPLE_LHS_AUTOEXOG';
code = '!transition_variables x, y; !shocks ex; !transition_equations x; y; !dynamic_autoexog x=ex; x=ey;';
modelParserErrorHelper(code, expId);


%% Test Prefix Multiplier

expId = 'Model:Postparser:PREFIX_MULTIPLIER';
code = '!transition_variables x, Mu_y; !transition_equations min(0.9) x^2+Mu_y^2; x = Mu_y;';
modelParserErrorHelper(code, expId);


%% Test Loss Func Discount Empty

expId = 'Equation:LOSS_FUNC_DISCOUNT_EMPTY';
code = '!transition_variables x, y; !transition_equations min(  ) x^2+y^2; x = y;';
modelParserErrorHelper(code, expId);


%% Test Multiple Loss Func

expId = 'Equation:MULTIPLE_LOSS_FUNC';
code = '!transition_variables x, y; !transition_equations min(0.9) x^2+y^2; min(0.9) x^3+y^3;';
modelParserErrorHelper(code, expId);


%% Test Undeclared Mistyped Name

expId = 'Equation:UNDECLARED_MISTYPED_NAME';
code = '!transition_variables x; !transition_equations x+y;';
modelParserErrorHelper(code, expId);


%% Test Sstate Ref In Linear

expId = 'Model:Postparser:SSTATE_REF_IN_LINEAR';
code = '!transition_variables x; !transition_equations x=&x;';
modelParserErrorHelper(code, expId, 'Linear=', true);


%% Test Sstate Ref In Dtrend

expId = 'Model:Postparser:SSTATE_REF_IN_DTREND';
code = '!transition_variables x; !transition_equations x; !measurement_variables X; !measurement_equations X=x; !dtrends X+=&x;';
modelParserErrorHelper(code, expId);


%% Test Sstate Ref in Link

expId = 'Model:Postparser:SSTATE_REF_IN_LINK';
code = '!transition_variables x; !transition_equations x; !parameters a; !links a:=&x;';
modelParserErrorHelper(code, expId);


%% Test Lhs Variables Must Log in Dtrend

expId = 'Equation:LHS_VARIABLE_MUST_LOG_IN_DTREND';
code = '!transition_variables x; !transition_equations x; !log_variables !all_but; !measurement_variables X; !measurement_equations X; !dtrends X+=0;';
modelParserErrorHelper(code, expId);


%% Test Invalid Lhs Dtrend

expId = 'Equation:INVALID_LHS_DTREND';
code = '!transition_variables x; !transition_equations x; !measurement_variables X; !measurement_equations X; !dtrends Y+=0;';
modelParserErrorHelper(code, expId);


%% Test Invalid Lhs Link

expId = 'Equation:INVALID_LHS_LINK';
code = '!transition_variables x; !transition_equations x; !links a:=x;';
modelParserErrorHelper(code, expId);


%% Test Multiple Lhs Dtrend

expId = 'Equation:MULTIPLE_LHS_DTREND';
code = '!transition_variables x; !transition_equations x; !measurement_variables X; !measurement_equations X; !dtrends X+=0; X+=1;';
modelParserErrorHelper(code, expId);


%% Test Measurement Shift

expId = 'Model:Postparser:MEASUREMENT_SHIFT';
code = '!transition_variables x; !transition_equations x; !measurement_variables X; !measurement_equations X+X{-1};';
modelParserErrorHelper(code, expId);


%% Test Measurement Variable in Transition

expId = 'Model:Postparser:MEASUREMENT_VARIABLE_IN_TRANSITION';
code = '!transition_variables x; !measurement_variables X; !transition_equations x+X; !measurement_equations X;';
modelParserErrorHelper(code, expId);


%% Test Lead of Transition in Measurement

expId = 'Model:Postparser:LEAD_OF_TRANSITION_IN_MEASUREMENT';
code = '!transition_variables x; !measurement_variables X; !transition_equations x; !measurement_equations X+x{1};';
modelParserErrorHelper(code, expId);


%% Test No Current Measurement

expId = 'Model:Postparser:NO_CURRENT_MEASUREMENT';
code = '!transition_variables x; !measurement_variables X; !transition_equations x; !measurement_equations 1;';
modelParserErrorHelper(code, expId);


%% Trest Transition Shock In Measurement 

expId = 'Model:Postparser:TRANSITION_SHOCK_IN_MEASUREMENT';
code = '!transition_variables x; !transition_shocks ex; !measurement_variables X; !transition_equations x; !measurement_equations X+ex;';
modelParserErrorHelper(code, expId);


%% Test Measurement Shock In Transition 

expId = 'Model:Postparser:MEASUREMENT_SHOCK_IN_TRANSITION';
code = '!transition_variables x; !measurement_shocks ex; !transition_equations x+ex;';
modelParserErrorHelper(code, expId);


%% Test Other Than Parameters Exogenous in Dtrends

expId = 'Model:Postparser:OTHER_THAN_PARAMETER_EXOGENOUS_IN_DTREND';
code = '!transition_variables x; !transition_equations x; !measurement_variables X; !measurement_equations X; !dtrends X+=x;';
modelParserErrorHelper(code, expId);


%% Test Exogenous In Other Than Dtrends

expId = 'Model:Postparser:EXOGENOUS_IN_OTHER_THAN_DTREND';
code = '!transition_variables x; !exogenous_variables y; !transition_equations x+y;';
modelParserErrorHelper(code, expId);


%% Test Misplaced Time Subscript

expId = 'Model:Postparser:SHOCK_SHIFT';
code = '!transition_variables x; !transition_shocks ex; !transition_equations x+ex{-1};';
modelParserErrorHelper(code, expId);

expId = 'Model:Postparser:MISPLACED_TIME_SUBSCRIPT';
code = '!transition_variables x; !transition_equations x+{-1};';
modelParserErrorHelper(code, expId);


%% testMisplacedSteadyReference(this)
expId = 'Model:Postparser:MISPLACED_STEADY_REFERENCE';
code = '!transition_variables x; !parameters p; !transition_equations x&+p;';
modelParserErrorHelper(code, expId);


%% testNoCurrentDateDynamic(this)
expId = 'Model:Postparser:NO_CURRENT_DATE_IN_DYNAMIC';
code = '!transition_variables x; !transition_equations x{-1};';
modelParserErrorHelper(code, expId);

expId = 'Model:Postparser:NO_CURRENT_DATE_IN_DYNAMIC';
code = '!transition_variables x; !measurement_variables X, Y; !transition_equations x; !measurement_equations Y; Y;';
modelParserErrorHelper(code, expId);


%% testNoCurrentDateSteady(this)
expId = 'Model:Postparser:NO_CURRENT_DATE_IN_STEADY';
code = '!transition_variables x, y; !transition_equations x!!x; y!!x;';
modelParserErrorHelper(code, expId);

expId = 'Model:Postparser:NO_CURRENT_MEASUREMENT';
code = '!transition_variables x; !transition_equations x; !measurement_variables X; !measurement_equations X!!x;';
modelParserErrorHelper(code, expId);


%% testNoTransitionVariableInEquation(this)
expId = 'Model:Postparser:NO_TRANSITION_VARIABLE_IN_DYNAMIC';
code = '!transition_variables x, y; !transition_equations x+y; 1;';
modelParserErrorHelper(code, expId);

expId = 'Model:Postparser:NO_TRANSITION_VARIABLE_IN_STEADY';
code = '!transition_variables x, y; !transition_equations x!!x+y; y!!1;';
modelParserErrorHelper(code, expId);


%% testNumberEquationsVariables(this)
expId = 'Model:Postparser:NUMBER_TRANSITION_EQUATIONS_VARIABLES';
code = '!transition_variables x, y; !transition_equations x; y; y;';
modelParserErrorHelper(code, expId);

expId = 'Model:Postparser:NUMBER_MEASUREMENT_EQUATIONS_VARIABLES';
code = '!transition_variables x; !transition_equations x; !measurement_variables X, Y; !measurement_equations X; Y; Y;';
modelParserErrorHelper(code, expId);


