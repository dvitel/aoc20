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

loc z3File = |project://aoc/src/d21.z3|;

value p2_2() {
	decls = ("" | it + "(declare-const " + i + "_" + a + " Bool)\n" | <i, a> <- pos);
	//rules = [ "(assert (or " + (" " | it + (i + "_" + a) + " " | <i, a> <- l) + "))"  | l <- lines ];
	lrx = invert(lines[0]);
//	for (a <- domain(lrx)) {
//
//	}
	//	rses = ({"(and"} | 	
	//					{ acc + " " + i + "_" + a + " "  | <acc, i> <- it * lrx[a] }	 
	//					| a <- domain(lrx) );
	//	print("<rses>\n");
	//return 0;
	rules = 
		 [ 
		 	("(assert (or" | it + " " + andClause + ") " 
				|andClause <- 
					({"(and"} | 	
						{ acc + " " + i + "_" + a + " "  | <acc, i> <- it * lr[a] }	 
						| a <- domain(lr) ) ) + "))"	
		 	| l <- lines, lr := invert(l) ];
	print("step1\n");
	allRules = ("" | it + x + "\n" | x <- rules);
	//rules for uniqueness of alergen, ingridient pair
	al = invert(pos); 
	rules = [ 
		"(and " + i + "_" + a + 
			(" " | it + "(not " + i + "_" + otherA + ") "  | otherA <- pos[i] - a) +
			(" " | it + "(not " + otherI + "_" + a + ") "  | otherI <- al[a] - i) + ")"
		| <a, i> <- al ];
	rule = ("(assert (or " | it + x | x <- rules) + "))\n"; 
	content = decls + allRules + rule + "(check-sat)\n(get-model)\n";
	writeFile(z3File, content);
	return 0;
}


value p2_3() {	
	lists = [ <split(" ", ings), split(", ", alergs)>
				|  l <- split("\n", input), /^<ings:.*?>\s\(contains\s<alergs:.*>\)$/ := l ];
	pairs = { *(is * as) | <is, as> <- lists };
	decls = ("" | "<it>\n(declare-const <i>_<a> Bool)" | <i, a> <- pairs);	
	rules = 
		("" | 
				"<it>\n(assert (or <("" | "<it> <i>_<a>"  | i <- is)>))" 
			| <is, as> <- lists, a <- as);
	//constraints 
	<is, as> = (<{}, {}> | <it[0] + {*is}, it[1] + {*as}> | <is, as> <- lists);
	//one ingridient could have at max one alergen 
	constraints = 
		for (i <- is, a <- as, <i,a> in pairs) {
			append "(assert (=\> <i>_<a> (and <("" | "<it> (not <i>_<a2>)" | a2 <- as - a, <i, a2> in pairs )>)))";
		}
	constr = ("" | "<it>\n<c>" | c <- constraints);
	
	//one alergen should be only in one ingridient 
	constraints2 = 
		for (a <- as, i <- is, <i,a> in pairs) {
			append "(assert (=\> <i>_<a> (and <("" | "<it> (not <i2>_<a>)" | i2 <- is - i, <i2, a> in pairs )>)))";
		}
	constr2 = ("" | "<it>\n<c>" | c <- constraints2);
	content = decls + "\n" + rules + "\n" + constr + "\n" + constr2 + "\n(check-sat)\n(get-model)\n";
	writeFile(z3File, content);
	return 0;
}

//mtnh_soy
//rsbxb_fish
//glf_eggs
//mptbpz_wheat
//cxsvdm_dairy
//txdmlzd_peanuts
//vlblq_sesame
//xbnmzr_nuts

