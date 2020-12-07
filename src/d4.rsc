module d4

import IO; 
import ParseTree;
import String;
import Set;
import Boolean;

//layout Whitespace = [\t-\n\r\ ]*;
//lexical Nat = [0-9]+;
//lexical Nat = [0-9]+;
//lexical Char = [a-zA-Z0-9];
//lexical Str = Char+;
//syntax Key = "byr" ":" Nat
//	| "iyr" ":" Nat
//	| "eyr" ":" Nat
//	| "hgt" ":" Nat
//	| "hcl" ":" Str
//	| "ecl" ":" Str
//	| "pid" ":" Str
//	| "cid" ":" Str
//start syntax Line = Nat "-" Nat " " Char ": " Pwd;

//int cnt(c, [*before, c, *after]) = 1 + cnt(c, after);
//default int cnt(c, s) = 0;
//
//bool match((Line)`<Nat p1>-<Nat p2> <Char ch>: <Pwd pwd>`) {
//	n1 = toInt("<p1>");
//	n2 = toInt("<p2>");
//	c = cnt(chars("<ch>")[0], chars("<pwd>"));
//	return c >= n1 && c <= n2;
//}
//default bool match(ast) = false; //should be runtime error

set[str] keys = { "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"  };

str s = "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
";

//bool match(/byr:<n:\d{4}>/) = byrc(toInt(n));
//bool match(/iyr:<n:\d{4}>/) = iyrc(toInt(n));
//bool match(/eyr:<n:\d{4}>/) = eyrc(toInt(n));
//bool match(/hgt:<n:\d{3}cm>/) = hgtcm(toInt(n));
//bool match(/hgt:<n:\d{2}in>/) = hgtin(toInt(n));
//bool match(/hcl:#[0-9a-f]{6}/) = true;
//bool match(/ecl:(amb|blu|brn|gry|grn|hzl|oth)/) = true;
//bool match(/pid:[0-9]{9}/) = true;
//bool match(_) = false;
 
value tst() = [ size({p | 
					(/byr:<byr:\d{4}><x1:(\s|$)>/ := p && byrc(toInt(byr))) && 
					(/iyr:<iyr:\d{4}><x2:(\s|$)>/ := p && iyrc(toInt(iyr))) && 
					(/eyr:<eyr:\d{4}><x3:(\s|$)>/ := p && eyrc(toInt(eyr))) &&
					((/hgt:<hgt:\d{3}>cm/ := p && hgtcm(toInt(hgt))) ||
						(/hgt:<hgti:\d{2}>in/ := p && hgtin(toInt(hgti)))) &&
					(/hcl:#[0-9a-f]{6}<x4:(\s|$)>/ := p) &&
					(/ecl:(amb|blu|brn|gry|grn|hzl|oth)<x5:(\s|$)>/ := p) &&
					(/pid:[0-9]{9}<x6:(\s|$)>/ := p) 
					}) | p <- split("\n\n", s)];


int p1() = ( 0 | it + ((keys == { x | /<x:\w{3}>:/i := p, x != "cid"  }) ? 1 : 0) | p <- split("\n\n", readFile(|project://aoc/inputs/d4|)));

int p2() = 
	(0 	| it + toInt(/byr:<byr:\d{4}>(?:\s|$)/ := p && byrv := toInt(byr) && byrv >= 1920 && byrv <= 2002 && 
				/iyr:<iyr:\d{4}>(?:\s|$)/ := p && iyrv := toInt(iyr) && iyrv >= 2010 && iyrv <= 2020 && 
				/eyr:<eyr:\d{4}>(?:\s|$)/ := p && eyrv := toInt(eyr) && eyrv >= 2020 && eyrv <= 2030 &&
				((/hgt:<hgt:\d{3}>cm/ := p && hgtv1 := toInt(hgt) && hgtv1 >= 150 && hgtv1 <= 193) ||
					(/hgt:<hgti:\d{2}>in/ := p && hgtv2 := toInt(hgti) && hgtv2 >= 59 && hgtv2 <= 76)) &&
				/hcl:#[0-9a-f]{6}(?:\s|$)/ := p &&
				/ecl:(amb|blu|brn|gry|grn|hzl|oth)(?:\s|$)/ := p &&
				/pid:[0-9]{9}(?:\s|$)/ := p)
		| p <- split("\n\n", readFile(|project://aoc/inputs/d4|)));
				
