module d9

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;

loc file = |project://aoc/inputs/d9|;
list[str] input = readFileLines(file);

value tail([h, *tl]) = tl;
bool preamble([n], x) = false;		
bool preamble([n, *tl], x) {
	for ([*before, k, *after] := tl) {
		if (n != k && (n + k) == x)
			return true;  
	}
	return preamble(tl, x);
}

int pr([h, *tl], [x, *y]) {
	if (preamble([h, *tl], x)) {
		return pr([*tl, x], y);
	} else 
		return x;	
}
				
int p1() = nums := [ toInt(p) | p <- input ] ? pr(nums[0..25], nums[25..]) : -1;

int t = p1();

int sm(acc, [*tl, n], l) = min([n, *l]) + max([n, *l])  when acc + n == t;
int sm(acc, [*tl, n], l) = sm(acc + n, tl, [n, *l]) when acc + n < t;
int sm(acc, [*tl, n], [*hd, m]) = sm(acc - m, [*tl, n], hd) when acc + n > t;
int sm(acc, [*tl, n], []) = sm(acc + n, tl, [n]);
int sm(acc, [], _) = -1;

int r([ *before, t, *after ]) = sm(0, before, []);
int p2() = [ *before, t, *after ] := [ toInt(p) | p <- input ] ? sm(0, before, []) : -1;
	
	