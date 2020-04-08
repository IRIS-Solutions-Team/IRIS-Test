function tests = allInfileTests( )

modelObj = Model( );
planObj = Plan( );
seriesObj = Series( );
explanatoryEquationObj = ExplanatoryEquation( );

tests = [
    ... Model
    preparePlan(modelObj, '--test')

    ... Plan
    exogenizeWhenData(planObj, '--test')

    ... Series
    init(seriesObj, '--test')

    ... Textual
    textual.locate('--test')
    textual.abbreviate('--test')

    ... Simulate
    simulate.if('--test')

    ... Parser
    parse(parser.theparser.Equation, '--test')
    parser.Interp.parse('--test')

    ... Dates
    isfreq('--test')

    ... ExplanatoryEquation
    ExplanatoryEquation.fromFile('--test')
    ExplanatoryEquation.fromString('--test')
    getDataBlock(explanatoryEquationObj, '--test')
    simulate(explanatoryEquationObj, '--test')
    createModelData(explanatoryEquationObj, '--test')
    defineDependent(explanatoryEquationObj, '--test')
    regress(explanatoryEquationObj, '--test')
    residuals(explanatoryEquationObj, '--test')
    checkUniqueLhs(explanatoryEquationObj, '--test')
    lookup(explanatoryEquationObj, '--test')

    ... regression.Term
    regression.Term.parseInputSpecs('--test')
];

end%

