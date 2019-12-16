
modelObj = Model( );
seriesObj = Series( );
explanatoryEquationObj = ExplanatoryEquation( );

tests = [
    preparePlan(modelObj, '--test')

    init(seriesObj, '--test')

    textual.locate('--test')

    ExplanatoryEquation.fromFile('--test')
    ExplanatoryEquation.fromString('--test')
    regression.Term.parseInputSpecs('--test')
    getDataBlock(explanatoryEquationObj, '--test')
    simulate(explanatoryEquationObj, '--test')
    createModelData(explanatoryEquationObj, '--test')
    defineDependent(explanatoryEquationObj, '--test')
    regress(explanatoryEquationObj, '--test')
    residuals(explanatoryEquationObj, '--test')
    blazer(explanatoryEquationObj, '--test')
];

run(tests);

