module d25

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Map;
import Boolean;
import util::Math;

int s1 = 9232416;
int s2 = 14144084;
//int s1 = 5764801;
//int s2 = 17807724;

tuple[int, int] loop(int s1, int s2) {
	subject_num = 7;
	res = <0, 0>;
	val = 1;
	i = 1;
	while (true) {
		//print("<i> <val> <((val * subject_num) < 20201227)>\n");
		val = val * subject_num;
		val = val % 20201227;
		if (val == s1) { res[0] = i; if (res[1] != 0) break; }
		if (val == s2) { res[1] = i; if (res[0] != 0) break; }
		i += 1;	
	}
	return res;
}

int transform(int loop_size, int s) {
	subject_num = s;
	val = 1;
	i = 0;
	while (i < loop_size) {
		val = val * subject_num;
		val = val % 20201227;
		i += 1;	
	}
	return val;
}

value p1() {
	<l1, l2> = loop(s1, s2);
	res = transform(l1, s2);
	return res;
}