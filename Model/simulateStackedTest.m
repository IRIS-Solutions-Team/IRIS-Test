
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once
    %
    m = Model.fromFile("simulateStackedTest.model");
    m.cross = 0.1;
    for i = 1 : 4
        m.("a"+i) = 0.4+i/100;
        m.("b"+i) = 0.3+i/100;
    end
    m = steady(m);
    m = solve(m);
    maxLag = get(m, "maxLag");
    %
    table(m, ["steadyLevel", "steadyChange"]);
    %
    listE = "e" + (1 : 4);
    listU = "u" + (1 : 4);
    p = Plan.forModel(m, 1:10);
    p = anticipate(p, true, listE);
    p = anticipate(p, false, listU);
    %
    d = steadydb(m, 1:10);
    %
    de = steadydb(m, 1:10);
    te = [1, 3, 5];
    for n = 1 : 4
        de.("e"+n)(te) = 1;
    end
    %
    du = steadydb(m, 1:10);
    deu = de;
    tu = [2, 4, 6];
    for n = 1 : 4
        du.("u"+n)(tu) = 1;
        deu.("u"+n) = du.("u"+n);
    end


%% Test Simulations of Anticipated Shocks
    %
    s1_1 = simulate(m, de, 1:10, "systemProperty", "A", "method", "stacked");
    s1_2 = simulate(m, de, 1:10, "systemProperty", "A", "method", "selective");
    assertEqual(testCase, s1_1.CallerData.FrameColumns{1}, [1, 10]-maxLag);
    assertEqual(testCase, s1_2.CallerData.FrameColumns{1}, [1, 10+1]-maxLag);
    %
    [s1_f, ~, f1_f] = simulate(m, de, 1:10);
    [s1_t, ~, f1_t] = simulate(m, de, 1:10, "method", "stacked");
    [s1_e, ~, f1_e] = simulate(m, de, 1:10, "method", "selective");
            



%% Test Simulations of Unanticipated Shocks
    %
    z2_1 = simulate(m, du, 1:10, "systemProperty", "A", "anticipate", false, "method", "stacked");
    z2_2 = simulate(m, du, 1:10, "systemProperty", "A", "plan", p, "method", "stacked");
    assertEqual(testCase, z2_1.CallerData.FrameColumns{1}, [1, 10; 2, 11; 4, 13; 6, 15]-maxLag);
    assertEqual(testCase, z2_2.CallerData.FrameColumns{1}, [1, 10; 2, 11; 4, 13; 6, 15]-maxLag);
    %
    s2_f1 = simulate(m, du, 1:10, "anticipate", false);
    s2_f2 = simulate(m, du, 1:10, "plan", p);
    [s2_t1, ~, f2_t1] = simulate(m, du, 1:10, "anticipate", false, "method", "stacked");
    [s2_t2, ~, f2_t2] = simulate(m, du, 1:10, "plan", p, "method", "stacked");
    %
    for n = 1 : 4
        assertEqual(testCase, s2_f1.("x"+n).Data, s2_f2.("x"+n).Data, "AbsTol", 1e-11);
        assertEqual(testCase, s2_f1.("x"+n).Data, s2_t1.("x"+n).Data, "AbsTol", 1e-11);
        assertEqual(testCase, s2_f1.("x"+n).Data, s2_t2.("x"+n).Data, "AbsTol", 1e-11);
    end



%% Test Anticipated Exogenized
    %
    s3_0 = simulate(m, de, 1:10, "plan", p, "method", "firstOrder");
    s3_1 = simulate(m, de, 1:10, "plan", p, "method", "selective");
    s3_2 = simulate(m, de, 1:10, "plan", p, "method", "stacked");
    %
    for n = 1 : 4
        assertEqual(testCase, s3_0.("x"+n).Data, s3_1.("x"+n).Data, "AbsTol", 1e-11);
        assertEqual(testCase, s3_0.("x"+n).Data, s3_2.("x"+n).Data, "AbsTol", 1e-11);
    end
    %
    p3 = p;
    p3 = swap(p3, te, ["x1", "e1"], ["x2", "e2"], ["x3", "e3"], ["x4", "e4"]);
    d3 = d;
    for n = 1 : 4
        d3.("x"+n)(te) = s3_1.("x"+n)(te);
    end
    s3_3 = simulate(m, d3, 1:10, "plan", p3, "method", "firstOrder", "prependInput", true);
    s3_4 = simulate(m, d3, 1:10, "plan", p3, "method", "selective", "prependInput", true);
    s3_5 = simulate(m, d3, 1:10, "plan", p3, "method", "stacked", "prependInput", true);
    %
    for n = 1 : 4
        assertEqual(testCase, s3_3.("e"+n).Data, de.("e"+n).Data, "AbsTol", 1e-11);
        assertEqual(testCase, s3_4.("e"+n).Data, de.("e"+n).Data, "AbsTol", 1e-11);
        assertEqual(testCase, s3_5.("e"+n).Data, de.("e"+n).Data, "AbsTol", 1e-11);
    end



%% Test Unanticipated Exogenized
    %
    s4_f = simulate(m, du, 1:10, "plan", p, "method", "firstOrder");
    s4_t = simulate(m, du, 1:10, "plan", p, "method", "stacked");
    s4_e = simulate(m, du, 1:10, "plan", p, "method", "selective");
    %
    for n = 1 : 4
        assertEqual(testCase, s4_f.("x"+n).Data, s4_e.("x"+n).Data, "AbsTol", 1e-11);
        assertEqual(testCase, s4_f.("x"+n).Data, s4_t.("x"+n).Data, "AbsTol", 1e-11);
    end
    assertEqual(testCase, s4_e.z.Data, s4_e.z.Data, "AbsTol", 1e-6);
    %
    p4_2 = p;
    p4_2 = anticipate(p4_2, false, ["x1", "x2", "x3", "x4"]);
    p4_2 = swap(p4_2, tu, ["x1", "u1"], ["x2", "u2"], ["x3", "u3"], ["x4", "u4"]);
    %
    d4_2 = d;
    for n = 1 : 4
        d4_2.("x"+n)(tu) = s4_e.("x"+n)(tu);
    end
    [s4_t, info4_2] = simulate(m, d4_2, 1:10, "plan", p4_2, "method", "stacked", "prependInput", true);
    %
    for n = 1 : 4
        assertEqual(testCase, s4_t.("u"+n).Data, du.("u"+n).Data, "AbsTol", 1e-11);
    end



%% Test Combined Shocks
    %
    s5_t = simulate(m, deu, 1:10, "systemProperty", "A", "method", "stacked", "plan", p);
    s5_e = simulate(m, deu, 1:10, "systemProperty", "A", "method", "selective", "plan", p);
    assertEqual(testCase, s5_t.CallerData.FrameColumns{1}, [1, 10; 2, 11; 4, 13; 6, 15]-maxLag);
    assertEqual(testCase, s5_e.CallerData.FrameColumns{1}, [1, 10+1; 2, 11+1; 4, 13+1; 6, 15+1]-maxLag);
    %
    s5_f = simulate(m, deu, 1:10, "plan", p);
    [s5_t, info5_t] = simulate(m, deu, 1:10, "method", "stacked", "plan", p);
    s5_e = simulate(m, deu, 1:10, "method", "selective", "plan", p);
    %
    for n = 1 : 4
        assertEqual(testCase, s5_f.("x"+n).Data, s5_t.("x"+n).Data, "AbsTol", 1e-11);
        assertEqual(testCase, s5_f.("x"+n).Data, s5_e.("x"+n).Data, "AbsTol", 1e-11);
    end
    assertEqual(testCase, s5_t.z.Data, s5_t.z.Data, "AbsTol", 1e-6);
    assertEqual(testCase, s5_t.z(1:10), (s5_t.x1(1:10).^(1/4) .* s5_t.x2(1:10).^(1/4) .* s5_t.x3(1:10).^(1/4) .* s5_t.x4(1:10).^(1/4)), "AbsTol", 1e-12);
    %
    s__ = databank.clip(deu, -Inf, 1);
    for t = 1 : 10
        for i = 1 : 4
            s__.("e"+i) = deu.("e"+i);
            s__.("u"+i) = clip(deu.("u"+i), -Inf, t);
        end
        [s__, info__] = simulate(m, s__, t:t+9, "method", "stacked", "prependInput", true);
        s__ = databank.clip(s__, -Inf, t);
    end
    %
    for n = 1 : 4
        assertEqual(testCase, s5_t.("x"+n).Data, s__.("x"+n).Data, "AbsTol", 1e-11);
    end



%% Test Combined Exogenized
    %
    [s6_1, info6_1, f6_1] = simulate(m, deu, 1:10, "method", "stacked", "plan", p);
    %
    p6 = p;
    p6 = swap(p6, te, ["x1", "e1"; "x2", "e2"; "x3", "e3"; "x4", "e4"]);
    p6 = swap(p6, tu, ["x1", "u1"; "x2", "u2"; "x3", "u3"; "x4", "u4"], "Anticipate", false);
    %
    [s6_2, info6_2, f6_2] = simulate(m, s6_1, 1:10, "method", "stacked", "plan", p6);
    [s6_3, info6_3, f6_3] = simulate(m, s6_2, 1:10, "method", "stacked", "plan", p);
    %
    % NB: Variables x1, ..., x4 are the same in s6_1 and s6_2 but shocks
    % are different
    %
    for n = 1 : 4
        assertEqual(testCase, s6_1.("x"+n).Data, s6_2.("x"+n).Data, "AbsTol", 1e-11);
    end


%% Test Anticipated Exogenized A, Z
    %
    p7 = p;
    p7 = swap(p7, 1:5, ["z", "e1"; "a", "e2"], "anticipate", true);
    d7 = d;
    d7.z(1:5) = d.z(1:5)*1.10;
    d7.a(1:5) = d.a(1:5)*0.90;
    s7_t = simulate(m, d7, 1:10, "method", "stacked", "plan", p7, "blocks", true);
    %
    assertEqual(testCase, d7.a(1:5), s7_t.a(1:5), "absTol", 1e-11);
    assertEqual(testCase, d7.z(1:5), s7_t.z(1:5), "absTol", 1e-11);



%% Test Unanticipated Exogenized A, Z
    %
    p8 = p;
    p8 = swap(p8, 1:5, ["a", "u1"; "z", "u2"], "anticipate", false);
    d8 = d;
    d8.z(1:5) = d.z(1:5)*1.10;
    d8.a(1:5) = d.a(1:5)*0.90;
    s8_t = simulate(m, d8, 1:10, "method", "stacked", "plan", p8, "blocks", true, "startIter", "data");
    %
    assertEqual(testCase, d8.a(1:5), s8_t.a(1:5), "absTol", 1e-11);
    assertEqual(testCase, d8.z(1:5), s8_t.z(1:5), "absTol", 1e-11);



%% Test Unanticipated Exogenized A, Z with W
    %
    p8 = p;
    p8 = swap(p8, 1:5, ["a", "u1"; "z", "w"], "anticipate", false);
    d8 = d;
    d8.z(1:5) = d.z(1:5)*1.10;
    d8.a(1:5) = d.a(1:5)*0.90;
    s8_t = simulate(m, d8, 1:10, "method", "stacked", "plan", p8, "blocks", true, "startIter", "data");
    %
    assertEqual(testCase, d8.a(1:5), s8_t.a(1:5), "absTol", 1e-11);
    assertEqual(testCase, d8.z(1:5), s8_t.z(1:5), "absTol", 1e-11);

