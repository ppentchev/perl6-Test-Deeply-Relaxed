#!/usr/bin/env perl6

use v6.c;

use Test;

use Test::Deeply::Relaxed;

plan 35;

is-deeply-relaxed 'this', 'this', 'string - same';
isnt-deeply-relaxed 'this', 'that', 'string - different';

is-deeply-relaxed 1, 1, 'number - same';
isnt-deeply-relaxed 1, 1.001, 'number - different';

isnt-deeply-relaxed '1', 1, 'string and number';
isnt-deeply-relaxed 1, '1', 'number and string';

is-deeply-relaxed True, True, 'bool true - same';
is-deeply-relaxed False, False, 'bool false - same';
isnt-deeply-relaxed True, False, 'bool true and false - different';
isnt-deeply-relaxed False, True, 'bool false and true - different';

isnt-deeply-relaxed 0, False, 'zero and false - different';
isnt-deeply-relaxed False, 0, 'false and zero - different';
isnt-deeply-relaxed Str, False, 'undef string and false - different';
isnt-deeply-relaxed False, Str, 'false and undef string - different';

isnt-deeply-relaxed 1, True, 'one and true - different';
isnt-deeply-relaxed True, 1, 'true and one - different';
isnt-deeply-relaxed '', True, 'empty string and true - different';
isnt-deeply-relaxed True, '', 'true and empty string - different';

is-deeply-relaxed [], [];
is-deeply-relaxed [1, 2], [1, 2], 'non-empty array - same';
isnt-deeply-relaxed [], [1, 2], 'empty and non-empty array - different';
isnt-deeply-relaxed [1, 2], [], 'non-empty and empty array - different';

isnt-deeply-relaxed [1, 2], '1 2', 'array and string - different';
isnt-deeply-relaxed '1 2', [1, 2], 'string and array - different';
isnt-deeply-relaxed [1], 1, 'array and number - different';
isnt-deeply-relaxed 1, [1], 'array and number - different';

is-deeply-relaxed {}, {}, 'empty hash -same';
is-deeply-relaxed {:a(42), :password('mellon')}, {password => 'mellon', a => 42}, 'non-empty hash - same';
isnt-deeply-relaxed {}, {:password('mellon')}, 'empty and non-empty hash - different';
isnt-deeply-relaxed {:a(42)}, {}, 'non-empty and empty hash - different';

isnt-deeply-relaxed {}, [];
isnt-deeply-relaxed [], {}, 'empty array and empty hash - different';
isnt-deeply-relaxed {:a(42)}, ['a', 42], 'hash and array - different';
isnt-deeply-relaxed ['a', 42], {:a(42)}, 'array and hash - different';

is-deeply-relaxed {:a([1, 2, 3]), :more({:how('deep'), :does(['this', 'thing', 'go'])})},
    {:more({:does(<this thing go>), how => 'deep'}), :a([1, 2, 3])},
    'a weird and wonderful hash';
