#!/usr/bin/env perl6

unit module Test::Deeply::Relaxed;

use v6.c;

use Test;

sub check-deeply-relaxed($got, $expected) returns Bool:D
{
	given $expected {
		when Associative {
			return False unless $got ~~ Associative;
			return False if Set.new($got.keys) ⊖ Set.new($expected.keys);
			return ?( $got.keys.map(
			    { check-deeply-relaxed($got{$_}, $expected{$_}) }
			    ).all);
		}
		
		when Positional {
			return False unless $got ~~ Positional;
			return False unless $got.elems == $expected.elems;
			return ?( ($got.list Z $expected.list).map(-> ($g, $e)
			    { check-deeply-relaxed($g, $e) }
			    ).all);
			return True;
		}
		
		when Str {
			return False unless $got ~~ Str;
			return $got eq $expected;
		}
		
		when Numeric {
			return False unless $got ~~ Numeric;
			return $got == $expected;
		}
		
		default {
			return False;
		}
	}
}

sub test-deeply-relaxed($got, $expected) returns Bool:D
{
	return True if check-deeply-relaxed($got, $expected);
	diag "Expected:\n\t$expected.perl()\nGot:\n\t$got.perl()\n";
	return False;
}

sub is-deeply-relaxed($got, $expected, $name) is export
{
	ok test-deeply-relaxed($got, $expected), $name;
}

sub isnt-deeply-relaxed($got, $expected, $name) is export
{
	nok test-deeply-relaxed($got, $expected), $name;
}
