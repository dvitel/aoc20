module d19

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Boolean;
import util::Math;

lexical NUM = [0-9]+;
lexical CHAR = [a-z];

syntax R101 = R118 R64;
syntax R83 = R132 R118 | R108 R2;
syntax R61 = R19 R2;
syntax R33 = R126 R2 | R68 R118;
syntax R80 = R2 R48 | R118 R91;
syntax R47 = R38 R2 | R64 R118;
syntax R40 = R25 R2 | R93 R118;
syntax R18 = R38 R2 | R108 R118;
syntax R2 = "a";
syntax R74 = R118 R108 | R2 R12;
syntax R41 = R118 R17 | R2 R58;
syntax R56 = R125 R2 | R132 R118;
syntax R66 = R12 R2 | R27 R118;
syntax R62 = R118 R52 | R2 R125;
syntax R58 = R2 R128 | R118 R99;
syntax R89 = R110 R2 | R3 R118;
syntax R30 = R118 R85 | R2 R21;
syntax R20 = R2 R70 | R118 R111;
syntax R85 = R118 R115 | R2 R52;
syntax R98 = R118 R46 | R2 R10;
syntax R12 = R118 R2 | R43 R118;
syntax R99 = R102 R118 | R56 R2;
syntax R127 = R2 R119 | R118 R100;
syntax R53 = R125 R2 | R108 R118;
syntax R15 = R2 R27 | R118 R108;
syntax R22 = R95 R2 | R61 R118;
syntax R109 = R115 R2 | R46 R118;
syntax R90 = R76 R2 | R121 R118;
syntax R37 = R15 R118 | R23 R2;
syntax R27 = R118 R2 | R118 R118;
syntax R104 = R2 R46 | R118 R12;
syntax R32 = R64 R2;
syntax R26 = R35 R118 | R32 R2;
syntax R123 = R131 R2 | R89 R118;
syntax R21 = R118 R132 | R2 R115;
syntax R95 = R112 R118 | R125 R2;
syntax R79 = R88 R2 | R60 R118;
syntax R34 = R107 R2 | R133 R118;
syntax R6 = R2 R101 | R118 R110;
syntax R55 = R118 R112 | R2 R64;
syntax R10 = R2 R118;
syntax R115 = R2 R118 | R2 R2;
syntax R39 = R2 R61 | R118 R81;
syntax R42 = R92 R118 | R124 R2;
syntax R105 = R38 R2 | R10 R118;
syntax R7 = R10 R2 | R27 R118;
syntax R106 = R87 R2 | R1 R118;
syntax R75 = R118 R46;
syntax R28 = R2 R71 | R118 R16;
syntax R120 = R118 R27 | R2 R112;
syntax R100 = R69 R2 | R109 R118;
syntax R102 = R46 R118 | R132 R2;
syntax R5 = R39 R118 | R51 R2;
syntax R14 = R57 R2 | R96 R118;
//syntax R8 = R42;
syntax R8 = R42 | R42 R8;

syntax R25 = R118 R59 | R2 R67;
syntax R3 = R19 R118 | R52 R2;
syntax R59 = R2 R74 | R118 R83;
syntax R87 = R118 R72 | R2 R78;
syntax R130 = R111 R2 | R117 R118;
syntax R112 = R2 R43 | R118 R118;
syntax R116 = R118 R38 | R2 R108;
syntax R17 = R2 R122 | R118 R29;
syntax R124 = R41 R118 | R40 R2;
//syntax R11 = R42 R31;
syntax R11 = R42 R31 | R42 R11 R31;

syntax R38 = R43 R43;
syntax R44 = R118 R123 | R2 R114;
syntax R23 = R12 R2;
syntax R29 = R2 R113 | R118 R129;
syntax R121 = R2 R10 | R118 R19;
syntax R93 = R2 R26 | R118 R36;
syntax R13 = R19 R118 | R46 R2;
syntax R107 = R118 R132 | R2 R10;
syntax R54 = R118 R27 | R2 R12;
syntax R63 = R2 R105 | R118 R82;
syntax R84 = R2 R37 | R118 R73;
syntax R52 = R118 R2 | R2 R118;
syntax R50 = R118 R111 | R2 R9;
syntax R111 = R118 R112 | R2 R27;
syntax R82 = R118 R46 | R2 R108;
syntax R118 = "b";
syntax R133 = R115 R2;
syntax R103 = R34 R2 | R22 R118;
syntax R36 = R66 R2 | R65 R118;
syntax R31 = R33 R118 | R79 R2;
syntax R69 = R12 R2 | R115 R118;
syntax R122 = R54 R118 | R66 R2;
syntax R114 = R6 R118 | R80 R2;
syntax R92 = R118 R14 | R2 R44;
syntax R0 = R8 R11;
syntax R117 = R132 R2 | R108 R118;
syntax R76 = R64 R2 | R27 R118;
syntax R126 = R2 R28 | R118 R127;
syntax R113 = R125 R2 | R19 R118;
syntax R43 = R118 | R2;
syntax R46 = R118 R118 | R2 R118;
syntax R132 = R118 R118 | R2 R2;
syntax R49 = R118 R130 | R2 R50;
syntax R129 = R19 R118 | R27 R2;
syntax R24 = R2 R27 | R118 R52;
syntax R119 = R118 R47 | R2 R98;
syntax R91 = R19 R118 | R10 R2;
syntax R35 = R115 R118 | R46 R2;
syntax R57 = R2 R63 | R118 R90;
syntax R125 = R118 R118 | R43 R2;
syntax R108 = R118 R118;
syntax R4 = R115 R118 | R19 R2;
syntax R94 = R112 R2 | R115 R118;
syntax R1 = R2 R55 | R118 R75;
syntax R9 = R38 R118 | R112 R2;
syntax R71 = R2 R18 | R118 R53;
syntax R60 = R103 R2 | R86 R118;
syntax R51 = R116 R2 | R24 R118;
syntax R128 = R24 R118 | R117 R2;
syntax R45 = R118 R2;
syntax R16 = R104 R2 | R62 R118;
syntax R70 = R118 R115 | R2 R45;
syntax R77 = R118 R13 | R2 R94;
syntax R131 = R61 R2 | R107 R118;
syntax R68 = R2 R49 | R118 R84;
syntax R86 = R118 R97 | R2 R30;
syntax R78 = R118 R38 | R2 R12;
syntax R88 = R5 R2 | R106 R118;
syntax R81 = R2 R45 | R118 R52;
syntax R64 = R2 R2;
syntax R19 = R2 R43 | R118 R2;
syntax R110 = R132 R2 | R64 R118;
syntax R96 = R2 R77 | R118 R20;
syntax R67 = R104 R118 | R4 R2;
syntax R65 = R115 R118 | R38 R2;
syntax R73 = R118 R110 | R2 R120;
syntax R72 = R64 R2 | R115 R118;
syntax R48 = R2 R46 | R118 R10;
syntax R97 = R7 R118 | R133 R2;

start syntax R = R0;

loc file = |project://aoc/inputs/d19|;
str input = readFile(file);

bool tryParse(line) {
	try {
		parse(#R, line);
		return true;
	} 
	catch: 
		return false;
}

value p1() {
	parts = split("\n\n", input);
	lines = split("\n", parts[1]);
	return (0 | it + (tryParse(line) ? 1 : 0) | line <- lines); 
}
