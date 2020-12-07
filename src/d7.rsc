module d7

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
//import Map;

keyword Bag = "bag" | "bags";
keyword Cont = "contain";
keyword No = "no other";
layout LAYOUT = [\t\n\ \r\f]*; 
lexical Word = [a-z]+;
lexical Num = [0-9]+;
syntax Adj = {Word " "}+;
syntax Cnt = No Bag > Num n Adj adj Bag;
start syntax St = Adj adj Bag Cont {Cnt ","}+ c ".";

loc file = |project://aoc/inputs/d7|;
list[str] input = readFileLines(file);

value p1_2() = 
	size(({<"<adj>", "<t.adj>">  
		| p <- input, 
			t := parse(#St, p),
			/Adj adj <- t.c }+)
		["shiny gold"]);
				
int p1() =
	size(({<name, from>  
			| p <- input, 
				/<from:.*?> bags contain <some:.*>/ := p, 
				to <- split(",", some),
				/\s*<n:\d+> <name:.*?> bag/ := to }+)
		["shiny gold"]);

rel[str, tuple[str, int]] bg = 
	{<from, <name, toInt(n)>>  
		| p <- input, 
			/<from:.*?> bags contain <some:.*>/ := p, 
			to <- split(",", some),
			/\s*<n:\d+> <name:.*?> bag/ := to };

int c(cnt, name) = 
	(cnt | it + c(cnt*chldN, chld) | <chld, chldN> <- bg[name], chld != "");

int p2() = c(1, "shiny gold") - 1;
