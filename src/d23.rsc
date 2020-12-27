module d23


import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Map;
import Boolean;
import util::Math;

list[int] cups() = [5, 2, 3, 7, 6, 4, 8, 1, 9];
list[int] rotateCw(cups) = cups[1..] + cups[0];
tuple[int,list[int],list[int]] pick3(cups) = <cups[0], cups[1..4], cups[4..]>;
list[int] nextCurr(<target, cups, lft>) {
	<dist, nextCur> = min([ <target - ((n > target) ? (n - 9) : n), i>  | i <- index(lft), n := lft[i] ]);
	return rotateCw(target + lft[..nextCur+1] + cups + lft[nextCur+1..]);
}
list[int] rotateTillAndSkip(t, [h, *tl]) = tl 
	when t == h;

list[int] rotateTillAndSkip(t, [h, *tl]) = rotateTillAndSkip(t, tl + h);

value p1() {
	c = cups();
	for (i <- [0..100]) {
		c = nextCurr(pick3(c));
	}
	return ("" | "<it><i>" | i <- rotateTillAndSkip(1, c)); 
}

//0: (5), 2, 3, 7, 6, 4, 8, 1, 9
//1: 5, (6), 4, [2, 3, 7], 8, 1, 9
//2: 5, [4, 2, 3], 6, (7), 8, 1, 9
//3. 5, 4, 2, 3, 6, [8, 1, 9], 7 --> (10)

//3 turns till now
// 10 -> 9 11 12 13 ... | 7 10
// 14 -> 9 11 12 13 15 16 17 | 7 10 14
// 18 -> 9 11 12 13 15 16 17 19 20 21 | 7 10 14 18
// 22 -> 9 11 12 13 15 16 17 19 20 21 23 24 25 | 7 10 14 18 22 ...
// ... 
// 9999994 -> 9 11 12 13 15 16 17 19 20 21 23 24 25 ... 9999995 9999996 9999997 | 7 10 14 18 22 ... 9999994
// (9999998) 9999999 10000000 5 4 2 3 6 8 1 9 11 .. 9999997 7 .. 9999994
// (4) 2 3 6 8 1 9 11 .. 9999997 [9999999 10000000 5] 7 .. 9999994 9999998
//      seq: 4 2 3 6 8 1 9 s1={10 + 4 * i + j, i=0..2499996, j=1,2,3 } 9999999 10000000 5 7 s2={10 + 4j, j=0..2499997}
// after 2.5M turns
// (4) 2 3 6 8 1 9 11 .. 9999997 [9999999 10000000 5] 7 .. 9999994 9999998
// 1. 4 (8) 1 [2 3 6] 9 s1 9999999 10000000 5 7 s2
// 2. 4 8 (6) 9 s1 9999999 10000000 5 7 1 2 3 s2
// 3. 4 8 6 (13) {s1, i=1} 999999 10000000 5 9 11 12 7 1 2 3 s2
// 4. 4 8 6 {13 (19)} {s1, i=2} 999999 10000000 5 9 11 12 {15 16 17} 7 1 2 3 s2
// 5. 4 8 6 {13 19 (24)} 25 {s1, i=4} 999999 10000000 5 9 11 12 {15 16 17} 7 1 2 3 10 14 18 {20 21 23} {s2, i = 3}
// ----
// 4 8 6 13 s3={each 4th of s1 starting with i=2, j=1 (19)} ...
// s0 = {10..10M}
// s1 = {not each 4th of s0, start from 10}
// s2 = {each 4th of s0, start from 10}
//---------- 
//s1={10 + 4 * i + j, i=0..2499996, j=1,2,3 }
//9 11 12 13 15 16 17 19 20 21 23 24 25
//13 15 16 17 19 20 21 23 24 25

9 11 12


