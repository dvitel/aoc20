module d3

import IO; 
import String;
import List;

int tree = 35; //code for #
//slide 3 right 1 down 
int slideDown(int r, int d, int x, int y, int t, s) =
	slideRight(r, d, x, y + d, t + (s[y][x] == tree ? 1 : 0), s);
int slideRight(r, d, x, y, t, s) = slideDown(r, d, (x + r) % size(s[y]), y, t, s)
	when size(s) > y;
default int slideRight(_, _, _, _, t, _) = t;

int p1() = slideDown(3, 1, 0, 0, 0, [ chars(p) | p <- readFileLines(|project://aoc/inputs/d3|), size(p) > 0]);

int trySlope(slope, tries) = (1 | it * slideDown(r, d, 0, 0, 0, slope) | <r, d> <- tries);

int p2() {
	slope = [ chars(p) | p <- readFileLines(|project://aoc/inputs/d3|), size(p) > 0];
	tries = [<1,1>, <3,1>, <5,1>, <7,1>, <1,2>];
	return trySlope(slope, tries);
}

str t1str = "..##.......\n
#...#...#..\n
.#....#..#.\n
..#.#...#.#\n
.#...##..#.\n
..#.##.....\n
.#.#.#....#\n
.#........#\n
#.##...#...\n
#...##....#\n
.#..#...#.#\n";
list[list[int]] t1slope = [ chars(ln) | ln <- split("\n", t1str), size(ln) > 0 ];
//list[tuple[int, int]] testTries = [<1,1>, <3,1>, <5,1>, <7,1>, <1,2>];

test bool tst1() = slideDown(1,1,0,0,0, t1slope) == 2;
test bool tst2() = slideDown(3,1,0,0,0, t1slope) == 7;
test bool tst3() = slideDown(5,1,0,0,0, t1slope) == 3;
test bool tst4() = slideDown(7,1,0,0,0, t1slope) == 4;
test bool tst5() = slideDown(1,2,0,0,0, t1slope) == 2;
test bool tst6() = trySlope(t1slope, [<1,1>, <3,1>, <5,1>, <7,1>, <1,2>]) == 336;
