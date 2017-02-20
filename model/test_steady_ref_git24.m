
m = model('test_steady_ref_git24.model');

m0 = m;
m0.a = 1;
m0 = sstate(m0);
m0 = solve(m0);
[~, r0] = sspace(m0);

m1 = m;
m1.a = 0;
m1 = sstate(m1);
m1 = solve(m1);
[~, r1] = sspace(m1);

