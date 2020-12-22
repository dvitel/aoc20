module d20

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Map;
import Boolean;
import util::Math;

//data ops = noop() | flipH() | flipV() | rotate(int cnt); //cnt 1 2 3
//data orient = top() | bottom() | lft() | rght() | cells(); 

loc file = |project://aoc/inputs/d20|;
str input = readFile(file);
list[str] tilesPlain = split("\n\n", input);
//set[orient] orients = { top(), lft(), bottom(), rght() };

list[list[&T]] rawRings([]) = [];
list[list[&T]] rawRings(list[list[&T]] strs)  {
	ring = 
		((strs[0] 
			| it + line[size(line) - 1] 
			| line <- strs[1..]) + reverse(strs[size(strs) - 1][..-1])
		| it + line[0] | line <- reverse(strs[1..-1]));
	return [ring] + rawRings([ s[1..-1] | s <- strs[1..-1]]);
} 

list[&T] flipRingH(list[&T] ring) {
	reversedRing = reverse(ring);
	splitPoint = (size(ring) - 4) / 4;
	return reversedRing[splitPoint..] + reversedRing[..splitPoint];
}

list[list[&T]] flipH(list[list[&T]] rings) = [ flipRingH(ring) | ring <- rings];

list[&T] flipRingV(list[&T] ring) {
	reversedRing = reverse(ring);	
	splitPoint = ((size(ring) - 4) / 4) + 2;
	return reversedRing[-splitPoint..] + reversedRing[..-splitPoint];
}

list[list[&T]] flipV(list[list[&T]] rings) = [ flipRingV(ring) | ring <- rings];

list[&T] rotateRingCw(list[&T] ring) {
	splitPoint = ((size(ring) - 4) / 4) + 1;
	return ring[-splitPoint..] + ring[..-splitPoint];
}

list[list[&T]] rotateCw(list[list[&T]] rings) = [ rotateRingCw(ring) | ring <- rings];

list[&T] rotateRingCCw(list[&T] ring) {
	splitPoint = ((size(ring) - 4) / 4) + 1;
	return ring[splitPoint..] + ring[..splitPoint];
}

list[list[&T]] rotateCCw(list[list[&T]] rings) = [ rotateRingCCw(ring) | ring <- rings];

list[&T] ringTop(list[&T] ring) {
	if (size(ring) < 4) return ring;
	splitPoint = ((size(ring) - 4) / 4) + 2;
	return ring[..splitPoint];
}

list[&T] fillTop(list[&T] ring, &T char){
	if (size(ring) < 4) return ring;
	splitPoint = ((size(ring) - 4) / 4);
	return ring[0] + ([] | it + char | _ <- [0..splitPoint]) + ring[(splitPoint + 1)..];
} 

list[&T] ringRight(list[&T] ring) {
	if (size(ring) < 4) return ring;
	splitPoint = ((size(ring) - 4) / 4) + 2;
	return ring[splitPoint-1..2*splitPoint-1];
}

list[&T] fillRight(list[&T] ring, &T char){
	if (size(ring) < 4) return ring;
	splitPoint = ((size(ring) - 4) / 4);
	return ring[..splitPoint+2] + ([] | it + char | _ <- [0..splitPoint]) + ring[2*splitPoint+2..];
} 

list[&T] ringBottom(list[&T] ring) {
	if (size(ring) < 4) return ring;
	splitPoint = ((size(ring) - 4) / 4);
	return reverse(ring[3 + 2*splitPoint-1..4 + 3*splitPoint]);
}

list[&T] fillBottom(list[&T] ring, &T char){
	if (size(ring) < 4) return ring;
	splitPoint = ((size(ring) - 4) / 4);
	return ring[..3 + 2*splitPoint] + ([] | it + char | _ <- [0..splitPoint]) + ring[-(splitPoint+1)..];
} 

list[&T] ringLeft(list[&T] ring) {
	if (size(ring) < 4) return ring;
	splitPoint = ((size(ring) - 4) / 4) + 2;
	return reverse(ring[-(splitPoint-1)..] + ring[0]);
}

list[&T] fillLeft(list[&T] ring, &T char){
	if (size(ring) < 4) return ring;
	splitPoint = ((size(ring) - 4) / 4);
	return ring[..4 + 3*splitPoint] + ([] | it + char | _ <- [0..splitPoint]);
}

list[list[&T]] ringRaws(list[list[&T]] rings, &T defaultV) {
	sz = ((size(rings[0]) - 4) / 4) + 2;
	raws = [ [ defaultV | j <- [0..sz]] | i <- [0..sz]];
	for (i <- index(rings)) {
		//print("<i>\n");
		ring = rings[i];
		//print("ringTop\n");
		t = ringTop(ring);
		//print("ringBottom <ring>\n");
		b = ringBottom(ring);
		//print("ringLeft\n");
		l = ringLeft(ring);
		//print("ringRight\n");
		r = ringRight(ring);		
		//print("<i> <t> <b> <l> <r>\n");
		for (j <- [0..size(t)]) {
			//print("<i> <j> <sz>\n");
			raws[i][i + j] = t[j];
			//print("2 <i> <j> <sz>\n");
		}
		for (j <- [0..size(r)]) {
			//print("r <i> <j> <sz>\n");
			raws[i + j][sz - 1 - i] = r[j];
			//print("r 2 <i> <j> <sz>\n");
		}		
		for (j <- [0..size(b)]) {
			//print("b <i> <j> <sz>\n");
			raws[sz - i - 1][i + j] = b[j];
			//print("b 2 <i> <j> <sz>\n");
		}
		for (j <- [0..size(l)]) {
			//print("l <i> <j> <sz>\n");
			raws[i + j][i] = l[j];
			//print("l 2 <i> <j> <sz>\n");
		}		
	}	
	return raws; //[ ([] | it + x | x <- r) | r <- raws ];
}

map[int, list[list[&T]]] getTiles() = 
	( id: rawRings(raws)	
		| tile <- tilesPlain, 
			tileLines := split("\n", tile), 
			/Tile <n:\d+>:/ := tileLines[0], 
			raws := [split("", r) | r <- tileLines[1..]], 
			id := toInt(n));		
		
rel[list[&T], int] cellEdges(map[int, list[list[&T]]] tiles) = 
	({} | it + { <s, id>, <reverse(s), id> | s <- [t, r, b, l] } 
		| id <- tiles,
			[ring0, *_] := tiles[id],
			t := ringTop(ring0),
			r := ringRight(ring0),
			b := ringBottom(ring0),
			l := ringLeft(ring0));	
				
map[int, list[list[str]]] edges(map[int, list[list[str]]] tiles) {
	map[int, list[list[str]]] res = ();
	ce = cellEdges(tiles);	
	for (id <- tiles) {
		rings = tiles[id];
		ring0 = rings[0];
		t = ringTop(ring0);		
		b = ringBottom(ring0);		
		if (ce[t] == {id}) ring0 = fillTop(ring0, "-");
		else if (ce[reverse(t)] == {id}) {
			rings = flipV(rings);
			ring0 = fillTop(rings[0], "-");
		}
		else if (ce[b] == {id}) ring0 = fillBottom(ring0, "-");
		else if (ce[reverse(b)] == {id}) {
			rings = flipV(rings);
			ring0 = fillBottom(rings[0], "-");			
		}
		rings[0] = ring0;
		r = ringRight(ring0);
		l = ringLeft(ring0);
		if (ce[r] == {id}) ring0 = fillRight(ring0, "|");
		else if (ce[reverse(r)] == {id}) {
			rings = flipH(rings);
			ring0 = fillRight(rings[0], "|");
		}
		else if (ce[l] == {id}) ring0 = fillLeft(ring0, "|");
		else if (ce[reverse(l)] == {id}) {
			rings = flipH(rings);
			ring0 = fillLeft(rings[0], "|");		
		}		
		rings[0] = ring0;
		if ("-" in ring0 || "|" in ring0)
			res[id] = rings;
	}
	return res;
}

map[int, list[list[str]]] corners (map[int, list[list[str]]] edges) = 
	( id:edges[id] | id <- edges, [r0, *_] := edges[id], "-" in r0, "|" in r0 );

set[list[list[str]]] matchKeyWithFlips(list[str] keyTop, list[str] keyLeft, list[list[str]] rings, int recur) {
	set[list[list[str]]] res = {};
	ring0 = rings[0];
	t = ringTop(ring0);	
	if ("|" in t || "-" in t) t = ["e"];	
	l = ringLeft(ring0);
	if ("|" in l || "-" in l) l = ["e"];
	r = ringRight(ring0);
	if ("|" in r || "-" in r) r = ["e"];
	b = ringBottom(ring0);
	if ("|" in b || "-" in b) b = ["e"];	
	//print("-- <t>:<keyTop>\n-- <l>:<keyLeft>\n\n");		
	if (t == keyTop && l == keyLeft) {
		//print("asis <rings[0]>\n");
		res += rings;
	}
	if (reverse(t) == keyTop && r == keyLeft) {
		flipped = flipV(rings);
		//print("flipV <flipped[0]>\n");
		res += flipped;
	}
	if (b == keyTop && reverse(l) == keyLeft) {
		flipped = flipH(rings);
		//print("flipH <flipped[0]>\n");		
		res += flipped;
	}
	if (reverse(b) == keyTop && reverse(r) == keyLeft) {
		flipped = flipV(flipH(rings));
		//print("flipV flipH <flipped[0]>\n");		
		res += flipped;
	}
	if (recur > 0) {
		//print("rotateCw\n");
		newRings = matchKeyWithFlips(keyTop, keyLeft, rotateCw(rings), recur - 1);
		if (newRings != {}) {
			//print("rotateCw\n");		
			res += newRings;
		}
		//print("rotateCCw\n");
		newRings = matchKeyWithFlips(keyTop, keyLeft, rotateCCw(rings), recur - 1);
		if (newRings != {}) {
			//print("rotateCCw\n");
			res += newRings;
		}
	}
	return res;	
}

tuple[int, set[list[list[str]]]] getForKey(keyTop, keyLeft, map[int, list[list[str]]] tiles) {	
	for (id <- tiles) {
		ringVersions = matchKeyWithFlips(keyTop, keyLeft, tiles[id], 1);
		if (size(ringVersions) > 0)
			return <id, ringVersions>;
	}
	return <-1, {}>;
} 

//orient nextSide(top()) = rght();
//orient nextSide(rght()) = bottom();
//orient nextSide(bottom()) = lft();
//orient nextSide(lft()) = top();

list[&T] ringNoCorners(list[&T] ring) {
	if (size(ring) < 4) return [];
	sz = (size(ring) - 4) / 4;
	return ring[1..1+sz] + ring[2+sz..2+2*sz] + ring[3+2*sz..3+3*sz] + ring[4+3*sz..]; 
}

bool isCorner(list[str] ring) = "|" in ring && "-" in ring;

list[list[&T]] asis(ring) = ring;
list[list[&T]] rcw(rings) = rotateCw(rings);
list[list[&T]] rcw2(rings) = rotateCw(rotateCw(rings));
list[list[&T]] rcw3(rings) = rotateCw(rotateCw(rotateCw(rings)));

//list[tuple[int, list[list[str]]]] prevRing, 
list[tuple[int, list[list[str]]]] buildRing(edges) {	
	//cornerIds = domain(corners);
	//print("<cornerIds>\n");
	keyTop = ["e"];
	keyLeft = ["e"];
	i = 0;
	cornersNum = -1;
	cornerAct = asis;
	//if (prevRing != []) {
	//	//check corner
	//	adj = ringNoCorners(prevRing);
	//	adj = last(adj) + adj[..-1];
	//	<_, secondCellRings> = adj[2*i];
	//	keyTop = ringRight(secondCellRings[0]);
	//	<_, lastCellRings> = adj[2*i + 1];
	//	keyLeft = ringBottom(lastCellRings[0]);
	//}	
	acc = 
	do {
		//print("<i> <id> <key> <orient>\n");
		//we try only one version
		<id, ringVersions> = getForKey(keyTop, keyLeft, edges);
		if (id == -1) break;		
		rings = [v | v <- ringVersions][0];
		//print("<i> <id> <rings[0]>\n");
		rings = cornerAct(rings);
		append <id, rings>;				
		i+=1;
		edges = delete(edges, id);
		//if (prevRing == []) {
	 	if (isCorner(rings[0])) {
	 		cornersNum += 1;
	 		keyTop = ["e"];
	 		keyLeft = ["e"];
	 		if (cornersNum == 1) cornerAct = rcw;
	 		else if (cornersNum == 2) cornerAct = rcw2; 
	 		else if (cornersNum == 3) cornerAct = rcw3; 
	 	} 
	 	if (cornersNum == 0) keyLeft = ringRight(rings[0]);
	 	else if (cornersNum == 1) keyLeft = reverse(ringBottom(rings[0]));
	 	else if (cornersNum == 2) keyLeft = reverse(ringLeft(rings[0]));
	 	else if (cornersNum == 3) keyLeft = ringTop(rings[0]);
		//} else {
		//	<_, secondCellRings> = prevRing[1 + i];
		//	keyTop = ringBottom(secondCellRings[0]);			
		//}		
	} while(true);
	return acc;
}

list[tuple[int, list[list[str]]]] buildRingFromPrev(edges, prevRing) {	

	curRingSize = (size(prevRing) - 4) / 4;
	i = 0;
	
	adj = ringNoCorners(prevRing);
	//adj = last(adj) + adj[..-1];
	<_, lastCellRing> = last(adj);
	keyLeft = ringRight(lastCellRing[0]);
	<_, secondCellRing> = adj[0];
	keyTop = ringBottom(secondCellRing[0]);
	
	cornerAct = asis;
	acc = 
	do {
		//print("<i> <id> <key> <orient>\n");
		//we try only one version
		<id, ringVersions> = getForKey(keyTop, keyLeft, edges);
		if (id == -1) break;		
		rings = [v | v <- ringVersions][0];
		//print("<i> <id> <rings[0]>\n");
		rings = cornerAct(rings);
		append <id, rings>;				
		i+=1;
		edges = delete(edges, id);
		//if (prevRing == []) {
	 	if (i < curRingSize) {
			<_, prevRng> = adj[i];
			keyTop = ringBottom(prevRng[0]);					
			keyLeft = ringRight(rings[0]);
	 	} else if (i >= curRingSize && i < (2*curRingSize - 1))
	 	{
	 		cornerAct = rcw;
			<_, prevRng> = adj[i+1];
			keyTop = ringLeft(prevRng[0]);					
			keyLeft = reverse(ringBottom(rings[0]));	 		
	 	} else if (i >= (2*curRingSize - 1) && i < (3*curRingSize - 2))
	 	{
	 		cornerAct = rcw2;
			<_, prevRng> = adj[i+2];
			keyTop = reverse(ringTop(prevRng[0]));					
			keyLeft = reverse(ringLeft(rings[0]));
	 	} else {
	 		cornerAct = rcw3;
	 		<_, prevRng> = adj[i+3];
	 		keyTop = reverse(ringRight(prevRng[0]));
	 		keyLeft = ringTop(rings[0]);
	 	}	 	
	 	//	cornersNum += 1;
	 	//	keyTop = ["e"];
	 	//	keyLeft = ["e"];
	 	//	if (cornersNum == 1) cornerAct = rcw;
	 	//	else if (cornersNum == 2) cornerAct = rcw2; 
	 	//	else if (cornersNum == 3) cornerAct = rcw3; 
	 	//} 
	 	//if (cornersNum == 0) keyLeft = ringRight(rings[0]);
	 	//else if (cornersNum == 1) keyLeft = reverse(ringBottom(rings[0]));
	 	//else if (cornersNum == 2) keyLeft = reverse(ringLeft(rings[0]));
	 	//else if (cornersNum == 3) keyLeft = ringTop(rings[0]);
		//} else {
		//	<_, secondCellRings> = prevRing[1 + i];
		//	keyTop = ringBottom(secondCellRings[0]);			
		//}		
	} while(true);
	return acc;
}

		
value p1() {
	e = edges(tiles);
	c = corners(e); 
	return (1 | it * x | x <- domain(c)); //buildBorder(e, c, tiles);
}

list[list[str]] addCells([l1, *c1], [l2, *c2]) = [l1 + l2] + addCells(c1, c2);
list[list[str]] addCells([], []) = []; 
list[list[str]] addAllCells([cl1, cl2]) = addCells(cl1, cl2);
list[list[str]] addAllCells([cl, *cls]) = addCells(cl, addAllCells(cls));	

str monsterStr = "                  # 
#    ##    ##    ###
 #  #  #  #  #  #   ";
list[list[str]] monsterPic() = [ split("", l) | l <- split("\n", monsterStr) ];
//list[list[str]] monsterRegex() = [  | l <- split("\n", monsterStr) ];		

bool matchMonsterLine([" ", *tl], [_, *other]) = matchMonsterLine(tl, other);
bool matchMonsterLine(["#", *tl], ["#", *other]) = matchMonsterLine(tl, other);
bool matchMonsterLine([], []) = true;
bool matchMonsterLine(_, _) = false;

bool matchMonsterLines([mline, *mbody], [line, *body]) = matchMonsterLine(mline, line) && matchMonsterLines(mbody, body);
bool matchMonsterLines([], []) = true;

list[list[str]] correctPic(i, j, monster, pict) {
	for (r <- [0..size(monster)], c <- [0..size(monster[0])]) {
		if (monster[r][c] == "#") {			
			pict[i+r][j+c] = "O";
			//print("Correcting <i+r> <j+c> <pict[i+r][j+c]>\n");
			//pc = ( "\n" | it + ("" | it + z | z <- x )  | x <- pict);
			//for (rp <- pict)
			//	print("<("" | it + z | z <- rp )>\n");			
		}
	}
	return pict;
}

list[list[str]] findMonster(monster, list[list[str]] picture) {
	int acc = 0;
	for (i <- [0..size(picture) - size(monster)], j <- [0..size(picture[0]) - size(monster[0])]) {
		subpic = [ r[j..j + size(monster[0])] | r <- picture[i..i+size(monster)]];	
		if (matchMonsterLines(monster, subpic)) {
			picture = correctPic(i, j, monster, picture);
			//for (rp <- picture)
			//	print("<("" | it + z | z <- rp )>\n");			
			print("Monster at <i> <j>\n");
			//pc = ( "\n" | it + ("" | it + z | z <- x )  | x <- picture);
			//print("<pc>\n");			
			acc += 1;
		}
	}
	return picture;
}
 
list[list[str]] flipPicV(l) = [ reverse(r) | r <- l ];
list[list[str]] flipPicH(l) = reverse(l);
list[list[str]] rotatePicCw(l) = reverse(l);
 
value p2() {
	tiles = getTiles();
	i = 0;
	//int startCornerId = -1;
	list[list[tuple[int, list[list[str]]]]] cameraRings = [];
	e = edges(tiles);
	list[tuple[int, list[list[str]]]] ring0 = buildRing(e);
	ids = { id | <id, _> <- ring0 };
	print("<[id | <id, _> <- ring0]>\n");
	tiles = domainX(tiles, ids);
	cameraRings += [ring0];	
	ring = ring0;
	cameraRings +=
		do {
			//print("<size(domain(tiles))>\n\n");			
			ring = buildRingFromPrev(tiles, ring);
			ids = { id | <id, _> <- ring };
			print("<[id | <id, _> <- ring]>\n");
			append ring;
			tiles = domainX(tiles, ids);
			//i += 1;
			//if (i == 2)
			//	break;
		} while (size(tiles) > 0);
	raws = ringRaws(cameraRings, <-1, []>);
	for (rw <- raws) {
		//sz = size(rw[0][1]);
		rwpr = [ ringRaws(cl, "_") | <id, cl> <- rw ];
		sz = size(rwpr[0]);
		for (j <- [0..sz]) {
			for (cl <- rwpr) {			
				print("<("" | it + x | x <- cl[j])> ");
			}
			print("\n");
		}
		print("\n");
	}	
	//print("RAWS <size(raws)> <size(raws[0])> <size(raws[0][0][1])>\n");
	//idRaws = [ [ id | <id, cell> <- raw] | raw <- raws];
	//print("<idRaws>\n");
	strRaws = [ addAllCells([ringRaws(r, "_") | <_, [_, *r]> <- raw]) | raw <- raws];
	pictureRaws = ([] | it + x | x <- strRaws);
	//pictureRaws = reverse(pictureRaws);
	//pictureRaws = [ reverse (rw) | rw <- pictureRaws ];
	//pictureRaws = ringRaws(rotateCCw(rawRings(pictureRaws)), "_");
	print("PIC <size(pictureRaws)> <size(pictureRaws[0])>\n");
	m = monsterPic();
	//pictureRaws = findMonster(m, pictureRaws);	
	
	//pictureRaws = reverse(pictureRaws);
	//pictureRaws = findMonster(m, pictureRaws);	
	//pictureRaws = reverse(pictureRaws);
	//
	pictureRaws = [ reverse (rw) | rw <- pictureRaws ];
	pictureRaws = findMonster(m, pictureRaws);
	pictureRaws = [ reverse (rw) | rw <- pictureRaws ];
	
	//pictureRaws = reverse(pictureRaws);
	//pictureRaws = [ reverse (rw) | rw <- pictureRaws ];
	//pictureRaws = findMonster(m, pictureRaws);
	//pictureRaws = [ reverse (rw) | rw <- pictureRaws ];
	//pictureRaws = reverse(pictureRaws);
	//
	//pictureRaws = ringRaws(rotateCw(rawRings(pictureRaws)), "_");
	//
	//pictureRaws = findMonster(m, pictureRaws);
	//
	//pictureRaws = reverse(pictureRaws);
	//pictureRaws = findMonster(m, pictureRaws);	
	//pictureRaws = reverse(pictureRaws);
	//
	//pictureRaws = [ reverse (rw) | rw <- pictureRaws ];
	//pictureRaws = findMonster(m, pictureRaws);
	//pictureRaws = [ reverse (rw) | rw <- pictureRaws ];
	//
	//pictureRaws = reverse(pictureRaws);
	//pictureRaws = [ reverse (rw) | rw <- pictureRaws ];
	//pictureRaws = findMonster(m, pictureRaws);
	//pictureRaws = [ reverse (rw) | rw <- pictureRaws ];
	//pictureRaws = reverse(pictureRaws);		
	//
	//pictureRaws = ringRaws(rotateCCw(rawRings(pictureRaws)), "_");
	//
	//pictureRaws = ringRaws(rotateCCw(rawRings(pictureRaws)), "_");
	//
	//pictureRaws = findMonster(m, pictureRaws);
	//
	//pictureRaws = reverse(pictureRaws);
	//pictureRaws = findMonster(m, pictureRaws);	
	//pictureRaws = reverse(pictureRaws);
	//
	//pictureRaws = [ reverse (rw) | rw <- pictureRaws ];
	//pictureRaws = findMonster(m, pictureRaws);
	//pictureRaws = [ reverse (rw) | rw <- pictureRaws ];
	//
	//pictureRaws = reverse(pictureRaws);
	//pictureRaws = [ reverse (rw) | rw <- pictureRaws ];
	//pictureRaws = findMonster(m, pictureRaws);
	//pictureRaws = [ reverse (rw) | rw <- pictureRaws ];
	//pictureRaws = reverse(pictureRaws);
	//
	//pictureRaws = ringRaws(rotateCw(rawRings(pictureRaws)), "_");	
	
	for (rp <- pictureRaws)
		print("<("" | it + z | z <- rp )>\n");		
	//print("Monsters in PIC <res>\n");
	
	//picture = ( "\n" | it + ("" | it + z | z <- x )  | x <- pictureRaws);
	//print("<picture>\n");
	//[ ( | cell <- raw) | raw <- strRaws]
	return (0 | it + 1| rw <- pictureRaws, cl <- rw, cl == "#");
	// return 0;
}




