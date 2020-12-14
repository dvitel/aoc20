module d12

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Boolean;
import util::Math;

loc file = |project://aoc/inputs/d12|;
//str input = readFile(file);
//list[str] input = readFileLines(file);
list[str] input = readFileLines(file);

str t = 
"F10
N3
F7
R90
F11";


value mov(<orient, x, y>, [<"F", d>, *tl] ) =
	mov(<orient, x + d * cos (orient * PI() / 180 ), y + d * sin (orient * PI() / 180 )>, tl);
	
value mov(<orient, x, y>, [<"N", d>, *tl] ) = 	
	mov(<orient, x, y + d>, tl);

value mov(<orient, x, y>, [<"S", d>, *tl] ) = 	
	mov(<orient, x, y - d>, tl);
	
value mov(<orient, x, y>, [<"W", d>, *tl] ) = 	
	mov(<orient, x - d, y>, tl);

value mov(<orient, x, y>, [<"E", d>, *tl] ) = 	
	mov(<orient, x + d, y>, tl);

value mov(<orient, x, y>, [<"L", d>, *tl] ) = 	
	mov(<orient + d, x, y>, tl);

value mov(<orient, x, y>, [<"R", d>, *tl] ) = 	
	mov(<orient - d, x, y>, tl);	
				
value mov(<orient, x, y>, []) = 
	abs(x) + abs(y);
 
value p1() {
	pos = <0, 0, 0>;
	nums = [ <p[0], toInt(p[1..])>  | p <- input ];	
	return mov(pos, nums);
}


value mov2(<x, y, wx, wy>, [<"F", d>, *tl] ) = mov2(<x + d * wx, y + d * wy, wx, wy>, tl);
	
value mov2(<x, y, wx, wy>, [<"N", d>, *tl] ) = 	
	mov2(<x, y, wx, wy + d>, tl);

value mov2(<x, y, wx, wy>, [<"S", d>, *tl] ) = 	
	mov2(<x, y, wx, wy - d>, tl);
	
value mov2(<x, y, wx, wy>, [<"W", d>, *tl] ) = 	
	mov2(<x, y, wx - d, wy>, tl);

value mov2(<x, y, wx, wy>, [<"E", d>, *tl] ) = 	
	mov2(<x, y, wx + d, wy>, tl);

value mov2(<x, y, wx, wy>, [<"L", d>, *tl] ) = 	
	mov2(<x, y, wx * cos (d * PI() / 180) - wy * sin(d * PI() / 180), wx * sin (d * PI() / 180) + wy * cos(d * PI() / 180)>, tl);

value mov2(<x, y, wx, wy>, [<"R", d>, *tl] ) = 	
	mov2(<x, y, wx * cos (d * PI() / 180) + wy * sin(d * PI() / 180), wy * cos(d * PI() / 180) - wx * sin (d * PI() / 180)>, tl);	
				
value mov2(<x, y, wx, wy>, []) = 
	abs(x) + abs(y);
	
value p2() {
	pos = <0, 0, 10, 1>;
	nums = [ <p[0], toInt(p[1..])>  | p <- input ];	
	return mov2(pos, nums);
}

