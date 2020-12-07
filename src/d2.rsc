module d2

import IO; 
import ParseTree;
import String;

lexical Nat = [0-9]+;
lexical Char = [a-zA-Z0-9];
lexical Pwd = Char+;
start syntax Line = Nat "-" Nat " " Char ": " Pwd;

int cnt(c, [*before, c, *after]) = 1 + cnt(c, after);
default int cnt(c, s) = 0;

bool match((Line)`<Nat p1>-<Nat p2> <Char ch>: <Pwd pwd>`) {
	n1 = toInt("<p1>");
	n2 = toInt("<p2>");
	c = cnt(chars("<ch>")[0], chars("<pwd>"));
	return c >= n1 && c <= n2;
}
default bool match(ast) = false; //should be runtime error

int p1() = (0 | it + 1 | p <- readFileLines(|project://aoc/inputs/d2|), match(parse(#Line, p)));
