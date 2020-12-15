module d15

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Boolean;
import util::Math;

loc file = |project://aoc/inputs/d15|;
//str input = readFile(file);
//list[str] input = readFileLines(file);
map[int, list[int]] numbers = 
	(0:[1], 3:[2], 6:[3]); 
	//(0:[1], 12:[2], 6:[3], 13:[4], 20:[5], 1:[6], 17:[7]);

list[int] ns = [0,12,6,13,20,1,17];

int turns(i, prev, map[int, list[int]] numbers) = {
	if ([t1, t2, *tl] := numbers[prev]) {
		spoken = t1 - t2;
		list[int] ts = numbers[spoken] ? []; 
		numbers[spoken] = i + ts;
		return turns(i+1, spoken, numbers); 
	} else {
		spoken = 0;
		list[int] ts = numbers[spoken];
		numbers[spoken] = i + ts;
		return turns(i+1, spoken, numbers); 
	}
	return -1;
} when i < 2021;

int turns(i, prev, _) = prev;
int turn = 2021;

//int turns2(i, prev, numbers) = {
//	list[int] ts = numbers[spoken] ? []; 
//	numbers[spoken] = i + ts;
//	return turns2(i+1, spoken, numbers); 
//} when i < turn && [t1, t2, *tl] := numbers[prev] && spoken := t1 - t2;
//
//int turns2(i, prev, numbers) = {
//	list[int] ts = numbers[spoken];
//	numbers[spoken] = i + ts;
//	return turns2(i+1, spoken, numbers); 
//} when i < turn && spoken := 0;
//
//int turns2(i, prev, _) = prev;

int turns2(i, prev, numbers) = {
	print("<i>:<prev> ");
	list[int] ts = numbers[spoken] ? []; 
	numbers[spoken] = i + ts;
	return spoken;
} when [t1, t2, *tl] := numbers[prev] && spoken := t1 - t2;

int turns2(i, prev, numbers) = {
	print("<i>:<prev> ");
	list[int] ts = numbers[spoken];
	numbers[spoken] = i + ts;
	return spoken; 
} when spoken := 0;

value p1(){
	i = 4; 
	prev = 6;
	while (i < turn) {
		prev = turns2(i, prev, numbers);
		i = i + 1;
	}
	return prev;
}
