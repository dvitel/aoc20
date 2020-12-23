module d22

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Map;
import Boolean;
import util::Math;

loc file = |project://aoc/inputs/d22|;
str input = readFile(file);
list[str] players = split("\n\n", input);
list[int] player1 = [ toInt(i) | i <- split("\n", players[0])[1..]];
list[int] player2 = [ toInt(i) | i <- split("\n", players[1])[1..]];

list[int] play([c1, *o1],[c2, *o2]) = play(o1, [*o2, c2, c1])
	when c2 > c1;

list[int] play([c1, *o1],[c2, *o2]) = play([*o1, c1, c2], o2);

list[int] play([], c) = c;
list[int] play(c, []) = c;

int score(c) = (0 | it + r[i] * (1 + i) | r := reverse(c), i <- index(r));

value problem1() = score(play(player1, player2));

data winner = p1(list[int] l) | p2(list[int] l);

winner round([], c, seenConfig) = p2(c);
winner round(c, [], seenConfig) = p1(c);

winner round(a, b, seenConfig) = p1(a)
	when <a, b> in seenConfig;
	
winner round(a, b, seenConfig) = draw(a, b, seenConfig + <a, b>);

winner draw([c1, *o1],[c2, *o2], seenConfig) = {
	switch (round(o1[..c1], o2[..c2], {})) {
		case p1(_): return round([*o1, c1, c2], o2, seenConfig);
		case p2(_): return round(o1, [*o2, c2, c1], seenConfig);
	}	
} when size(o1) >= c1 && size(o2) >= c2;
		
winner draw([c1, *o1],[c2, *o2], seenConfig) = round(o1, [*o2, c2, c1], seenConfig)
	when c2 > c1;
	
winner draw([c1, *o1],[c2, *o2], seenConfig) = round([*o1, c1, c2], o2, seenConfig);	

int score2(p1(c)) = score(c);
int score2(p2(c)) = score(c);

value problem2() = score2(round(player1, player2, {}));
