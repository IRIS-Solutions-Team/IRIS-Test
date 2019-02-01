function tests = autoexogenizeTest()
tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function setupOnce(this)
m = model('autoexogenizeTest.model');
this.TestData.Model = m;
end




function testEmpty(this) %#ok<INUSD>
end




function test1(this)
m = this.TestData.Model;
p = plan(m, 1:10);
p = autoexogenize(p, 'x', 1:5);
p = autoexogenize(p, 'y', 2:6);
p = autoexogenize(p, 'z', 3:7);

expXAnch = false(4, 10);
expXAnch(1, 1:5) = true;
expXAnch(2, 2:6) = true;
expXAnch(3, 3:7) = true;

assertEqual( this, p.XAnch, expXAnch );
end 




function test2(this)
m = this.TestData.Model;
p = plan(m, 1:10);
p = autoexogenize(p, {'x', 'y'}, 1:5);

expXAnch = false(4, 10);
expXAnch(1:2, 1:5) = true;
assertEqual( this, p.XAnch, expXAnch );
end 




function test3(this)
m = this.TestData.Model;
p = plan(m, 1:10);
p = autoexogenize(p, {'x', 'y', 'z'}, 1:5);

expXAnch = false(4, 10);
expXAnch(1:3, 1:5) = true;
assertEqual( this, p.XAnch, expXAnch );
end 




function testAll(this)
m = this.TestData.Model;
p = plan(m, 1:10);
p = autoexogenize(p, @all, 1:5);

expXAnch = false(4, 10);
expXAnch(1:3, 1:5) = true;
assertEqual( this, p.XAnch, expXAnch );
end 




function testAutoexogenizeErr(this)
m = this.TestData.Model;
p = plan(m, 1:10);

isErr = false;
try
    p = autoexogenize(p, 'a', 1:5);
catch
    isErr = true;
end

expXAnch = false(4, 10);

assertEqual( this, isErr, true );
assertEqual( this, p.XAnch, expXAnch );
end
