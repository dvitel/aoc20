module d14

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Boolean;
import util::Math;

lexical NUM = [0-9]+;
start syntax Ln = "mem[" NUM addr "] = " NUM val;

loc file = |project://aoc/inputs/d14|;
//str input = readFile(file);
list[str] input = readFileLines(file);
//list[str] input = split("\n\n", readFile(file));

list[str] test1 = split("\n", 
"mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1"
);

list[int] numToList(i, acc, n) = 
	numToList(i + 1, acc + ((n % 2 == 1) ? 49 : 48), n / 2)
	when i < 36;  

list[int] numToList(i, acc, n) = acc; 

int listToNum(i, n, [49, *tl]) = 
	listToNum(i + 1, n + pow(2, i), tl)
	when i < 36;  

int listToNum(i, n, [48, *tl]) = 
	listToNum(i + 1, n, tl);
	
int listToNum(i, n, []) = round(n);  
	
//tuple[int, int] getMask(m1, m2, acc, [48, *tl]) = getMask(m1, m2, acc+1, tl);
//tuple[int, int] getMask(m1, m2, acc, [49, *tl]) = getMask(m1, m2, acc+1, tl);

value applyMask(acc, [88, *mtl], [x, *tl]) = applyMask(acc + x, mtl, tl);
value applyMask(acc, [49, *mtl], [_, *tl]) = applyMask(acc + 49, mtl, tl);
value applyMask(acc, [48, *mtl], [_, *tl]) = applyMask(acc + 48, mtl, tl);
value applyMask(acc, _, _) = acc;

//map[str, value] process(mem, _, [/mask = <mask:[X01]{36}>$/, *tl]) = process(mem, reverse(chars(mask)), tl);
//map[str, value] process(mem, mask, [/mem\[<addr:\d+?>\] = <v:\d+?>$/, *tl]) {
//	//print("<mem>");
//	mem[addr] = applyMask([], mask, numToList(0, [], toInt(v)));
//	return process(mem, mask, tl);
//} 
//map[str, value] process(mem, _, _) = mem;

value p1(){
	map[str, value] mem = ();
	map[str, value] res = process(mem, [ 88 | i <- [0..36]], input);
	//return res;	
	return (0 | it + listToNum(0, 0, res[k]) | k <- res );
}

list[list[int]] addBit(list[list[int]] accs, int x) = [ acc + x | acc <- accs ];
list[list[int]] applyMask2(acc, [48, *mtl], [x, *tl]) = applyMask2(addBit(acc, x), mtl, tl);
list[list[int]] applyMask2(acc, [49, *mtl], [_, *tl]) = applyMask2(addBit(acc, 49), mtl, tl);
list[list[int]] applyMask2(acc, [88, *mtl], [_, *tl]) = applyMask2(addBit(acc, 48) + addBit(acc, 49), mtl, tl);
list[list[int]] applyMask2(acc, _, _) = acc;
	 
map[int, int] process(mem, _, [/mask = <mask:[X01]{36}>$/, *tl]) = process(mem, reverse(chars(mask)), tl);
map[int, int] process(mem, mask, [/mem\[<addr:\d+?>\] = <v:\d+?>$/, *tl]) {
	list[list[int]] addrList = applyMask2([[]], mask, numToList(0, [], toInt(addr))); 
	for (list[int] addr <- addrList) {
		mem[listToNum(0, 0, addr)] = toInt(v);
	} 
	return process(mem, mask, tl);
} 
map[int, int] process(mem, _, _) = mem;


value p2(){
	map[int, int] mem = ();
	map[int, int] res = process(mem, [ 88 | i <- [0..36]], input);
	return (0 | it + res[k] | k <- res );
}