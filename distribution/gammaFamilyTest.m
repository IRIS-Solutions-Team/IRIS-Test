function tests = gammaFamilyTest( )
tests = functiontests(localfunctions);
end%


function setupOnce(this)
    this.TestData.AlphaVec = [1, 2, 3, 5, 9, 7.5, 0.5];
    this.TestData.BetaVec = [2, 2, 2, 1, 0.5, 1, 1];
end%


function testGammaConstructors(this)
    alphaVec = this.TestData.AlphaVec;
    betaVec = this.TestData.BetaVec;
    for i = 1 : numel(alphaVec)
        alpha = alphaVec(i);
        beta = betaVec(i);
        g1 = distribution.Gamma.fromAlphaBeta(alpha, beta);
        g2 = distribution.Gamma.fromMeanVar(g1.Mean, g1.Var);
        this.assertEqual(g1.Alpha, g2.Alpha, 'AbsTol', 1e-10);
        this.assertEqual(g1.Beta, g2.Beta, 'AbsTol', 1e-10);
        mode = max(0, (alpha-1)*beta);
        this.assertEqual(g1.Mode, mode, 'AbsTol', 1e-10);
        this.assertEqual(g2.Mode, mode, 'AbsTol', 1e-10);
        if alpha>1
            g3 = distribution.Gamma.fromModeVar(g1.Mode, g1.Var);
            this.assertEqual(g1.Alpha, g3.Alpha, 'AbsTol', 1e-10);
            this.assertEqual(g1.Beta, g3.Beta, 'AbsTol', 1e-10);
            g4 = distribution.Gamma.fromModeStd(g1.Mode, g1.Std);
            this.assertEqual(g1.Alpha, g4.Alpha, 'AbsTol', 1e-10);
            this.assertEqual(g1.Beta, g4.Beta, 'AbsTol', 1e-10);
        end
    end
end%
    

function testInvGammaConstructors(this)
    alphaVec = this.TestData.AlphaVec;
    betaVec = this.TestData.BetaVec;
    alphaVec2 = alphaVec + 2;
    for i = 1 : numel(alphaVec2)
        alpha = alphaVec2(i);
        beta = betaVec(i);
        g1 = distribution.InvGamma.fromAlphaBeta(alpha, beta);
        g2 = distribution.InvGamma.fromMeanVar(g1.Mean, g1.Var);
        g3 = distribution.InvGamma.fromShapeScale(g1.Shape, g1.Scale);
        this.assertEqual(g1.Alpha, g2.Alpha, 'AbsTol', 1e-10);
        this.assertEqual(g1.Beta, g2.Beta, 'AbsTol', 1e-10);
        this.assertEqual(g1.Alpha, g3.Alpha, 'AbsTol', 1e-10);
        this.assertEqual(g1.Beta, g3.Beta, 'AbsTol', 1e-10);
        mode = beta/(alpha+1);
        this.assertEqual(g1.Mode, mode, 'AbsTol', 1e-10);
        this.assertEqual(g2.Mode, mode, 'AbsTol', 1e-10);
        this.assertEqual(g3.Mode, mode, 'AbsTol', 1e-10);
    end
end%

