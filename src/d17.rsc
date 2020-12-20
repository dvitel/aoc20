module d17

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Boolean;
import util::Math;

loc file = |project://aoc/inputs/d17|;
list[str] input = readFileLines(file);

tuple[rel[tuple[int, int, int], tuple[int, int, int]], rel[tuple[int, int, int], tuple[int, int, int]]] 
	neighbors(activeRel, inactiveRel, <i, j, k>, cube) =
	(<activeRel, inactiveRel> 
		| (neighbor in cube) ? 
			<it[0] + <<i, j, k>, neighbor>, it[1]> 
			: <it[0], it[1] + <neighbor, <i, j, k>>> 
		| di <- [1, 0,-1], dj <- [1, 0, -1], dk <- [1, 0, -1], 
				<di, dj, dk> != <0, 0, 0>,
				neighbor := <i + di, j + dj, k + dk>);	

value p1() {
	initCube = [ split("", line) | line <- input];	
	cube = { <i, j, 0> | i <- index(initCube), j <- index(initCube[i]), initCube[i][j] == "#" };
	//cubeMax = <>; 
	maxStep = 6; 
	i = 0;	
	while (i < maxStep) {		
		//set[tuple[int, int, int]] newCube = {};
		rel[tuple[int, int, int], tuple[int, int, int]] active = {};
		rel[tuple[int, int, int], tuple[int, int, int]] inactive = {};			
		for (activeCell <- cube) {
			<act, inact> = neighbors({}, {}, activeCell, cube);
			//print("<activeCell>: <inct>\n\n");
			active = active + act;
			inactive = inactive + inact;
			//if numActiveNeighbors == 2 || numActiveNeighbors == 3
		}
		cube = { actCell | actCell <- domain(active), size(active[actCell]) in {2,3} };
		cube += { inactCell | inactCell <- domain(inactive), size(inactive[inactCell]) in {3} }; 
		i = i + 1;
	}
	//value res = (0 | it + 1 | <_, "#"> <- cube);
	return size(cube);
}


tuple[rel[tuple[int, int, int, int], tuple[int, int, int, int]], rel[tuple[int, int, int, int], tuple[int, int, int, int]]] 
	neighbors2(activeRel, inactiveRel, <i, j, k, w>, cube) =
	(<activeRel, inactiveRel> 
		| (neighbor in cube) ? 
			<it[0] + <<i, j, k, w>, neighbor>, it[1]> 
			: <it[0], it[1] + <neighbor, <i, j, k, w>>> 
		| di <- [1, 0,-1], dj <- [1, 0, -1], dk <- [1, 0, -1], dw <- [1, 0, -1],
				<di, dj, dk, dw> != <0, 0, 0, 0>,
				neighbor := <i + di, j + dj, k + dk, w + dw>);
	

value p2() {
	initCube = [ split("", line) | line <- input];	
	cube = { <i, j, 0, 0> | i <- index(initCube), j <- index(initCube[i]), initCube[i][j] == "#" };
	//cubeMax = <>; 
	maxStep = 6; 
	i = 0;	
	while (i < maxStep) {		
		//set[tuple[int, int, int]] newCube = {};
		rel[tuple[int, int, int, int], tuple[int, int, int, int]] active = {};
		rel[tuple[int, int, int, int], tuple[int, int, int, int]] inactive = {};			
		for (activeCell <- cube) {
			<act, inact> = neighbors2({}, {}, activeCell, cube);
			//print("<activeCell>: <inct>\n\n");
			active = active + act;
			inactive = inactive + inact;
			//if numActiveNeighbors == 2 || numActiveNeighbors == 3
		}
		cube = { actCell | actCell <- domain(active), size(active[actCell]) in {2,3} };
		cube += { inactCell | inactCell <- domain(inactive), size(inactive[inactCell]) in {3} }; 
		i = i + 1;
	}
	//value res = (0 | it + 1 | <_, "#"> <- cube);
	return size(cube);
}
