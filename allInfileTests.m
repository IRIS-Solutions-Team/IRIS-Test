function tests = allInfileTests( )

modelObj = Model( );
planObj = Plan( );
seriesObj = Series( );
explanatoryEquationObj = Explanatory( );

tests = [
    ... Model
    preparePlan(modelObj, '--test')

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

    ... Explanatory
    getDataBlock(explanatoryEquationObj, '--test')
    createModelData(explanatoryEquationObj, '--test')
    regress(explanatoryEquationObj, '--test')
    residuals(explanatoryEquationObj, '--test')
    checkUniqueLhs(explanatoryEquationObj, '--test')
    lookup(explanatoryEquationObj, '--test')
];

end%

