module d13

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Boolean;
import util::Math;

loc file = |project://aoc/inputs/d13|;
list[str] input = readFileLines(file);

value p1() {
	time = toInt(input[0]);
	busses = [ toInt(b) | b <- split(",", input[1]), b != "x"];
	closest = min([ b - time % b  | b <- busses]);
	b = [ b * (b - time % b) | b <- busses, b - time % b == closest ];
	return b;
}

str tstx1 = "7,13,x,x,59,x,31,19";
str tstx2 = "17,x,13,19";	

tuple[int, int, list[int]] findBusShift(acc, [0, *tl]) = findBusShift(acc + 1, tl);
tuple[int, int, list[int]] findBusShift(acc, [b, *tl]) = <acc + 1, b, tl>;
tuple[int, int, list[int]] findBusShift(acc, []) = <acc, 0, []>;
	
list[tuple[int, int]] findShifts(acc, t, l) {
	<nt, b, tl> = findBusShift(t, l);
	if (b == 0){
		return acc;
	} else {
		return findShifts(acc + <b, nt>, nt, tl);
	}
}

int findFirstSameDepart(firstBus, i, shift, nextBus) = i
	when (firstBus * i + shift) % nextBus == 0;
	
int findFirstSameDepart(firstBus, i, shift, nextBus) = findFirstSameDepart(firstBus, i + 1, shift, nextBus);

int findStep(from, to, st) = ((to - from) / st) + ((((to - from) % st) == 0) ? 0 : 1);

tuple[int, int] findSameDepart(fst, fstP, snd, sndP) = <fst, fstP * sndP>
	when fst == snd;     

tuple[int, int] findSameDepart(fst, fstP, snd, sndP) = findSameDepart(fst + findStep(fst, snd, fstP) * fstP, fstP, snd, sndP)
	when fst < snd;

tuple[int, int] findSameDepart(fst, fstP, snd, sndP) = findSameDepart(fst, fstP, snd + findStep(snd, fst, sndP) * sndP, sndP);
	
value p2() {
	buses = [ b == "x" ? 0 : toInt(b) | b <- split(",", input[1]) ];
	firstBus = buses[0];
	other = buses[1..];
	res1 = reverse(sort(findShifts([], firstBus, other)));	
	res2 = [<findFirstSameDepart(firstBus, 1, sh, b), b> | <b, sh> <- res1 ];
	<ressh, resp> = (res2[0] | <sh, p> := it ? findSameDepart(sh, p, bsh, bp) : it | <bsh, bp> <- res2[1..]);
	return ressh * firstBus + firstBus;
}