module d24

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Map;
import Boolean;
import util::Math;

syntax Rule = "e" | "se" | "sw" | "w" | "nw" | "ne";
start syntax Rules = "" | Rule r Rules other;

loc file = |project://aoc/inputs/d24|;
list[str] input = readFileLines(file);

list[str] rTos((Rules)`<Rule r><Rules other>`) = [ "<r>", *rTos(other)];
list[str] rTos(_) = [];

//rewrite e to [ne, se], nw to [ne, w], sw to [se, w], [se, ne] to [ne, se], [w, se] to [se, w] and [w, ne] to [ne, w] 
tuple[int, int, int] rw(b, ["e", *a]) = rw(b + "ne", ["se", *a]);
tuple[int, int, int] rw(b, ["nw", *a]) = rw(b + "ne", ["w", *a]);
tuple[int, int, int] rw(b, ["sw", *a]) = rw(b + "se", ["w", *a]);
tuple[int, int, int] rw(b, [x, *a]) = rw(b + x, a);
tuple[int, int, int] s(<ne, se, w>) {
	minO = min([ne, se, w]);
	return <ne - minO, se - minO, w - minO>;
}
tuple[int, int, int] rw(b, []) {
	occur = distribution(b);
	return s(<occur["ne"] ? 0, occur["se"] ? 0, occur["w"] ? 0>);
}	

rel[tuple[int, int, int], tuple[int, int, int]] neighbors(blackCells) = 
	{ *{<s(<ne + 1, se, w>), c>, <s(<ne + 1, se + 1, w>), c>, <s(<ne, se + 1, w>), c>, 
		<s(<ne, se + 1, w + 1>), c>, <s(<ne, se, w + 1>), c>, <s(<ne + 1, se, w + 1>), c>} 
		| c <- blackCells, <ne, se, w> := c };

value p1() {
	rs = [ rw([], rTos(parse(#Rules, l))) | l <- input ];
	d = distribution(rs);
	return size([x | x <- d, d[x] % 2 == 1]);
}

value p2() {
	allCells = [ rw([], rTos(parse(#Rules, l))) | l <- input ];
	d = distribution(allCells);
	blackCells = {x | x <- d, d[x] % 2 == 1};
	for (i <- [0..100]) {
		nbrs = neighbors(blackCells);		
		blackNbrs = domainR(nbrs, blackCells);
		whiteNbrs = domainX(nbrs, blackCells);
		part1 = { x | x <- domain(blackNbrs), sz := size(blackNbrs[x]), sz == 1 || sz == 2 };
		part2 = { x | x <- domain(whiteNbrs), sz := size(whiteNbrs[x]), sz == 2 };
		blackCells = part1 + part2;
	}
	return size(blackCells);
}