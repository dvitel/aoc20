module d16

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Boolean;
import util::Math;

lexical DESC = [a-z\ ]+;
lexical NUM = [0-9]+;
start syntax Rule = DESC desc ": " NUM start1 "-" NUM end1 " or " NUM start2 "-" NUM end2;

loc file = |project://aoc/inputs/d16|;
str input = readFile(file);
list[str] parts = split("\n\n", input);

bool inRange(n, [<desc, [<s, e>, *tl]>, *otherRules]) = true 
	when s <= n && n <= e;
	
bool inRange(n, [<desc, [_, *tl]>, *otherRules]) = inRange(n, [ <desc, tl>, *otherRules]);

bool inRange(n, [<_, []>, *otherRules]) = inRange(n, otherRules);
bool inRange(n, []) = false;
	
value p1() {
	list[tuple[str, list[tuple[int,int]]]] ranges = 
		[ <"<t.desc>", [ <toInt("<t.start1>"), toInt("<t.end1>")>, <toInt("<t.start2>"), toInt("<t.end2>")> ]>
			| ln <- split("\n", parts[0]), t := parse(#Rule, ln)];
	list[list[int]] nearbyTickets = [ [ toInt(n) | n <- split(",", ln)] | ln <- split("\n", parts[2])[1..]];
	int res = (0 | it + n | ticket <- nearbyTickets, n <- ticket, !inRange(n, ranges));
	return res;
}

bool ticketInRange([n, *tl], rules) = inRange(n, rules) && ticketInRange(tl, rules);
bool ticketInRange([], rules) = true;

value p2() { 
	//parsing ranges
	list[tuple[str, list[tuple[int,int]]]] ranges = 
		[ <"<t.desc>", [ <toInt("<t.start1>"), toInt("<t.end1>")>, <toInt("<t.start2>"), toInt("<t.end2>")> ]>
			| ln <- split("\n", parts[0]), t := parse(#Rule, ln)];
	
	//parsing nearby tickets
	list[list[int]] nearbyTickets = [ [ toInt(n) | n <- split(",", ln)] | ln <- split("\n", parts[2])[1..]];
	
	list[list[int]] validTickets = [ ticket | ticket <- nearbyTickets, ticketInRange(ticket, ranges)];	
	
	//relation: position to ticket number at that position
	rel[int, int] ticketNumbers = { <n, ticket[n]> | ticket <- validTickets, n <- index(ticket) };
	
	//possible positions
	rel[str, int] positions = { <desc, pos> | 
		<desc, rangeIntervals> <- ranges, 
		invalidPositions := { i | 
			i <- domain(ticketNumbers), //iterate over position
			ticketNumber <- ticketNumbers[i], //set of ticket numbers for all tickets at this position i  
			!inRange(ticketNumber, [<desc, rangeIntervals>]) }, //finding position for which number is not in range 
  		<pos, _> <- ticketNumbers,
	  	pos notin invalidPositions //this checks that pos is not in set of positions for which there is a number outside the range	  							
	}; 
	
	rel[str, int] correctPositions = {};
	//we know that at least one position has only one possible field (due to manual check)
	do {
		rel[int, str] positionCounts = { <size(positions[desc]), desc> | desc <- domain(positions) };
		for (desc <- positionCounts[1], p <- positions[desc]) {
			correctPositions = correctPositions + <desc, p>;
		}
		positions = rangeX(positions, range(correctPositions));
	} while (size(positions) > 0);
	list[int] departurePositions = [ pos | <desc, pos> <- correctPositions, startsWith(desc, "departure") ];
	list[int] myTicket = [ toInt(n) | n <- split(",", split("\n", parts[1])[1]) ];
	return (1 | it * myTicket[i] | i <- departurePositions);
}

