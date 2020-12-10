module d8

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;

loc file = |project://aoc/inputs/d8|;
list[str] input = readFileLines(file);

data opt = none() | some(int v);

opt process(acc, i, p) {
	if (size(p) <= i) return some(acc);
	switch (p[i]) {
		case <"acc", n>: {
			p[i] = <"",0>;			
			return process(acc + n, i + 1, p);
		}
		case <"nop", _>: {
			p[i] = <"",0>;
			return process(acc, i + 1, p);
		}
		case <"jmp", n>: {
			p[i] = <"",0>;
			return process(acc, i + n, p);
		}
		default: return none();
	} 
}
				
value p1() = process(0, 0, [ <inst, toInt(n)> | p <- input, /<inst:.*?>\s*?<n:[\+-]\d+>/ := p ]);

value tryc([*before, <"jmp", n>, *after]) {
	switch (process(0, 0, [*before, <"nop", n>, *after])) {
		case some(acc): return acc; 
		default: fail;
	}
}

value p2() {
	inst = [ <inst, toInt(n)> | p <- input, /<inst:.*?>\s*?<n:[\+-]\d+>/ := p ];
	return tryc(inst);
}

//str s = "ashdgjs1ashjhskjda12askdks ad13skdjk da7sad";

//void f(s) {
//	for (/<n:\d+>/ := s) {
//		print("found <n>\n");
//	}
//}

//value f(s) = [ n | /<n:\d+>/ := s ]; 

