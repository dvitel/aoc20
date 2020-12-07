module d5

import IO; 
import ParseTree;
import String;
import Set;
import Boolean;
import List;


int match(chs) = mt(64, chs);
int mt(base, [66, *other]) = base*8 + mt(4, other) when size(other) == 3;
int mt(base, [70, *other]) = mt(4, other) when size(other) == 3;
int mt(base, [66, *other]) = base*8 + mt(base / 2, other);
int mt(base, [70, *other]) = mt(base / 2, other);
int mt(base, [82, *other]) = base + mt(base / 2, other);
int mt(base, [76, *other]) = mt(base / 2, other);
int mt(_, _) = 0;
int next(i, v) = v when v > i; 
int next(i, _) = i;

int p1() = ( 0 | next(it, match(chars(p)))  | p <- readFileLines(|project://aoc/inputs/d5|));

int p2() = {
	s = { match(chars(p)) | p <- readFileLines(|project://aoc/inputs/d5|)};
	for (int x <- [0..(127*8 + 8)]) {
		if (!(x in s) && ((x-1) in s) && ((x+1) in s))
			return x;
	}		
};

//	(0 	| it + toInt(/byr:<byr:\d{4}>(?:\s|$)/ := p && byrv := toInt(byr) && byrv >= 1920 && byrv <= 2002 && 
//				/iyr:<iyr:\d{4}>(?:\s|$)/ := p && iyrv := toInt(iyr) && iyrv >= 2010 && iyrv <= 2020 && 
//				/eyr:<eyr:\d{4}>(?:\s|$)/ := p && eyrv := toInt(eyr) && eyrv >= 2020 && eyrv <= 2030 &&
//				((/hgt:<hgt:\d{3}>cm/ := p && hgtv1 := toInt(hgt) && hgtv1 >= 150 && hgtv1 <= 193) ||
//					(/hgt:<hgti:\d{2}>in/ := p && hgtv2 := toInt(hgti) && hgtv2 >= 59 && hgtv2 <= 76)) &&
//				/hcl:#[0-9a-f]{6}(?:\s|$)/ := p &&
//				/ecl:(amb|blu|brn|gry|grn|hzl|oth)(?:\s|$)/ := p &&
//				/pid:[0-9]{9}(?:\s|$)/ := p)
//		| p <- split("\n\n", readFile(|project://aoc/inputs/d5|)));
//				
