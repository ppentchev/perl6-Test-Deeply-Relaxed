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
		
		when Bool {
			return False unless $got ~~ Bool;
			return ?$got == ?$expected;
		}

		when Numeric {
			return False unless $got ~~ Numeric && $got !~~ Bool;
			return $got == $expected;
		}
		
		default {
			return False;
		}
	}
}

sub test-deeply-relaxed($got, $expected, Bool:D :$whine = True) returns Bool:D is export(:test)
{
	return True if check-deeply-relaxed($got, $expected);
	if $whine {
		try diag "Expected:\n\t$expected.perl()\nGot:\n\t$got.perl()\n";
		diag 'Could not output the mismatched deeply-relaxed values' if $!;
	}
	return False;
}

sub is-deeply-relaxed($got, $expected, $name = Str) is export
{
	ok test-deeply-relaxed($got, $expected), $name;
}

sub isnt-deeply-relaxed($got, $expected, $name = Str) is export
{
	nok test-deeply-relaxed($got, $expected, :!whine), $name;
}
