module d6

import IO; 
import String;
import List;
import Set;
//import Map;

loc file = |project://aoc/inputs/d6|;
//str input = readFile(file);
//list[str] input = readFileLines(file);
list[str] input = split("\n\n", readFile(file));

int match(v) = 0;

int next(acc, v) = acc;
 
set[int] cnt(p) = ({} | it + toSet(chars(x)) | x <- split("\n", p));
int p1() = ( 0 | it + size(cnt(p))  | p <- input);

set[int] cnt2([h, *tl]) = (toSet(chars(h)) | it & toSet(chars(x)) | x <- tl);

int p2() = (0 | it + size(cnt2(split("\n", p)))  | p <- input);
	
//int p2() { 
//	s = ( 0 | next(it, match(chars(p)))  | p <- input);
//	return 
//}
