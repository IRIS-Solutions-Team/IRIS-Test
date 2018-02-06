function tests = duplicateTest( )
tests = functiontests(localfunctions( ));
end


function testDuplicateNone(this)
   list = {'a', 'b', 'c', 'd', 'aa', 'bb', 'A'};
   actual = textual.duplicate(list);
   expected = cell.empty(1, 0);
   assertEqual(this, actual, expected);
end


function testDuplicateSome(this)
   list = {'a', 'b', 'c', 'd', 'aa', 'bb', 'A', 'b', 'bb', 'aa'};
   actual = textual.duplicate(list);
   expected = {'b', 'aa', 'bb'};
   assertEqual(this, actual, expected);
end


function testDuplicateAll(this)
   list0 = {'a', 'b', 'c', 'd', 'aa', 'bb', 'A'};
   list = repmat(list0, 1, 3);
   actual = textual.duplicate(list);
   expected = list0;
   assertEqual(this, actual, expected);
end

