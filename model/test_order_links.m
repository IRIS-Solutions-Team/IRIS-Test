
assertEqual = @(x, y) assert(isequaln(x, y));

m = model('test_order_links.model', 'OrderLinks=', true);
m.f = 1;
m.d = 10;

%**************************************************************************
% Test OrderLinks=

m1 = refresh(m);
assertEqual(m1.e, m1.f);
assertEqual(m1.b, 2*m1.f);
assertEqual(m1.a, m1.b+m1.d+m1.e+m1.f);
assertEqual(m1.c, m1.a);

%**************************************************************************
% Test with Disabled Link

m2 = disable(m, '!links', 'a');
m2 = refresh(m2);
assertEqual(m2.e, m2.f);
assertEqual(m2.b, 2*m2.f);
assertEqual(m2.a, NaN);
assertEqual(m2.c, m2.a);

%**************************************************************************
% Test with Multiple Variants

N = 10;
m3 = alter(m, N);
m3.f = 1 : N;
m3.d = 10 : 10 : 10*N;
m3 = refresh(m3);
assertEqual(m3.e, m3.f);
assertEqual(m3.b, 2*m3.f);
assertEqual(m3.a, m3.b+m3.d+m3.e+m3.f);
assertEqual(m3.c, m3.a);



