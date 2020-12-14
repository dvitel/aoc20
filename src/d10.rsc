module d10

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;

loc file = |project://aoc/inputs/d10|;
list[str] input = readFileLines(file);

int jolts(acc1, acc3, prev, [n, *tl]) = jolts(acc1 + 1, acc3, n, tl)
	when n - prev == 1; 
int jolts(acc1, acc3, prev, [n, *tl]) = jolts(acc1, acc3 + 1, n, tl)
	when n - prev == 3;
int jolts(acc1, acc3, prev, [n, *tl]) = jolts(acc1, acc3, n, tl);
int jolts(acc1, acc3, prev, []) = acc1 * (acc3 + 1);

int p1() = jolts(0, 0, 0, sort([ toInt(p) | p <- input ]));

int arrange([*hd, <y, 0>, <x, n>]) = arrange([*hd, <y, n>, <x, n>]);

int arrange([*hd, <z, 0>, <y, m>, <x, n>]) = 
	arrange([*hd, <z, n + m>, <y, m>, <x, n>])
	when x - z == 2;
	
int arrange([*hd, <z, 0>, <y, m>, <x, n>]) = arrange([*hd, <z, 0>, <y, m>]);

int arrange([*hd, <s, 0>, <z, k>, <y, m>, <x, n>])  = 
	arrange([*hd, <s, n + m + k>, <z, k>, <y, m>])
	when x - s == 3;
	
int arrange([*hd, <s, 0>, <z, k>, <y, m>, <x, n>]) =
	arrange([*hd, <s, 0>, <z, k>, <y, m>]);

int arrange(x) = x[0][1];

list[int] derivative(l) = derivative([], l);
list[int] derivative(acc, [x, y, *tl]) = diff([y - x, *acc], [y, *tl]);
list[int] derivative(acc, _) = acc;


int p2() { 
	nums = sort([ <toInt(p), 0> | p <- input ]);
	nums = <0, 0> + nums;
	nums[size(nums) - 1][1] = 1;
	return arrange(nums);
}
	
	
	