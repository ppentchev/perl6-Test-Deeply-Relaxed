#!/usr/bin/env perl6

unit module Test::Deeply::Relaxed;

use v6.c;

use Test;

sub check-deeply-relaxed($got, $expected) returns Bool:D
{
	given $expected {
		when Baggy {
			return False unless $got ~~ Baggy;
			return $got ≼ $expected && $got ≽ $expected;
		}

		when Setty {
			return False unless $got ~~ Set;
			return !($got ⊖ $expected);
		}

		when Associative {
			return False unless $got ~~ Associative &&
			    $got !~~ Setty && $got !~~ Baggy;
			return False if set($got.keys) ⊖ set($expected.keys);
			return ?( $got.keys.map(
			    { check-deeply-relaxed($got{$_}, $expected{$_}) }
			    ).all);
		}
		
		when Array {
			return False unless $got ~~ Array;
			return False unless $got.elems == $expected.elems;
			return ?( ($got.list Z $expected.list).map(-> ($g, $e)
			    { check-deeply-relaxed($g, $e) }
			    ).all);
			return True;
		}

		when Iterable {
			return False unless $got ~~ Iterable &&
			    $got !~~ Array && $got !~~ Associative;
			my $i-exp = $expected.iterator;
			my $i-got = $got.iterator;
			loop {
				my $v-exp := $i-exp.pull-one;
				my $v-got := $i-got.pull-one;
				if $v-exp =:= IterationEnd {
					return $v-got =:= IterationEnd;
				} elsif $v-got =:= IterationEnd {
					return False;
				}
				return False unless check-deeply-relaxed($v-got, $v-exp);
			}
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
