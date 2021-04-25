 
m = Model('modelFileTest.model');

d = struct( );
d.x = Series(-10:20, @rand);
d.y = Series(-10:20, @rand);
d.cx = Series(-10:30, @rand);

dd = postprocess(m, d, 1:20, 'prependInput', true);

