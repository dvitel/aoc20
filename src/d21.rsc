module d21

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Map;
import Boolean;
import util::Math;

loc file = |project://aoc/inputs/d21|;
str input = readFile(file);
list[rel[str, str]] lines =
	[ { <ing, alerg> | ing <- split(" ", ings), alerg <- split(", ", alergs)}
		|  l <- split("\n", input), /^<ings:.*?>\s\(contains\s<alergs:.*>\)$/ := l ];
rel[str, str] pos = { x | l <- lines, x <- l };
			
rel[str, str] findBinds(rel[str, str] pos, list[rel[str, str]] lines, rel[str, str] binding) {
	if (size(pos) == 0) return {};
	<<i, a>, newPos1> = takeOneFrom(pos);
	rel[str, str] newBindings = binding + <i, a>; 
	rel[str, str] newPos = { x | x <- newPos1, x[0] != i, x[1] != a };
	list[rel[str, str]] newLines = [ domainX( ((<i, a> in r) ? rangeX(r, {a}) : r), {i}) | r <- lines ]; //{ <ins - i, newAls> | <ins, als>  <- lines, newAls := (als - a), newAls != {}};
	newLines = [l | l <- newLines, l != {}];
	if (size(newLines) == 0) {		
		return newBindings;
	} if (size(newPos) == 0) {		
		print("TST <newBindings> <size(newLines)>\n");
		return findBinds(newPos1, lines, binding);
	} else {
		rel[str, str] res = findBinds(newPos, newLines, newBindings);
		if (res == {}) {
			return findBinds(newPos1, lines, binding);
		}
		return res;
	}
}			

value p1() {	
	set[str] canBe = {};
	wPos = pos;
	//print("<wPos>\n");
	wLines = lines;
	wBinds = {};	
	do {		
		res = findBinds(wPos, wLines, wBinds);
		if (res == {}) {
			if (wBinds == {}) {
				//canNotBe = domain(pos) - canBe;
				print("<[ domain(domainX(l, canBe)) | l <- lines]>\n");
				return (0 | it + x | x <- [ size(domain(domainX(l, canBe))) | l <- lines]);
			} else 
				res = wBinds;
		} else {
			canBe += domain(res);
			print("<res>\n");
		}								
		<<i, a>, wBinds> = takeOneFrom(res);
		wPos = domainX(wPos, domain(res));	
		ings = domain(wBinds);
		algs = range(wBinds);		
		wLines = [ domainX( rangeX(r, {a1 | <i1, a1> <- r, <i1, a1> in wBinds}), ings) | r <- lines ]; //{ <ins - ings, newAls> | <ins, als>  <- lines, newAls := als - algs };
	} while (true);
	
	//print("<size(domain(pos))> <size(range(pos))>");
	return 0;
}

value p1_1() {
	//li = [ ( al:rl[al] | rl := , al <- domain(rl)) | r <- lines ];
	acc = ();
	for (r <- lines) {
		rl = invert(r);
		//print("<rl>");
		for (x <- domain(rl)) {
			ings = rl[x];
			if (x in acc) {
				acc[x] = acc[x] & ings;
			} else {
				acc[x] = ings;
			}
		}
	}
	canBe = ({} | it + acc[id] | id <- acc);
	print("<acc>\n");
	return (0 | it + x | x <- [ size(domain(domainX(l, canBe))) | l <- lines]);
}

value p2() {
	//li = [ ( al:rl[al] | rl := , al <- domain(rl)) | r <- lines ];
	acc = ();
	for (r <- lines) {
		rl = invert(r);
		//print("<rl>");
		for (x <- domain(rl)) {
			ings = rl[x];
			if (x in acc) {
				acc[x] = acc[x] & ings;
			} else {
				acc[x] = ings;
			}
		}
	}
	pos = { <x, id> | id <- acc, x <- acc[id]};
	canBe = ({} | it + acc[id] | id <- acc);
	lines = [ domainR(r, canBe) | r <- lines ];
	res = [ x | x <- invert(findBinds(pos, lines, {})) ];
	res = sort(res);
	print("<res>\n");
	r = ( "" | (it == "") ? xyz : (it + "," + xyz) | <a, xyz> <- res );
	return r;
}
