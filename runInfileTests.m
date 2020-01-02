
modelObj = Model( );
seriesObj = Series( );
explanatoryEquationObj = ExplanatoryEquation( );

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
    blazer(explanatoryEquationObj, '--test')

    ... regression.Term
    regression.Term.parseInputSpecs('--test')
];

run(tests);

