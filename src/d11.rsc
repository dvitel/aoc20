module d11

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Boolean;

loc file = |project://aoc/inputs/d11|;
//str input = readFile(file);
//list[str] input = readFileLines(file);
list[str] input = readFileLines(file);

//str env("L", nums, j, i) = 
//	toInt((j+1 >= size(nums) || nums[j+1][i] != "#")) +
//	toInt(j-1 < 0 || nums[j-1][i] != "#") +
//	toInt(i + 1 >= size(nums[j]) || nums[j][i + 1] != "#") +
//	toInt(i - 1 < 0 || nums[j][i - 1] != "#")) ? "#" : "L";


	
bool bottomEmpty(nums, j, i) = (j+1) >= size(nums) || nums[j+1][i] != "#";
bool topEmpty(nums, j, i) = (j-1) < 0 || nums[j-1][i] != "#";
bool leftEmpty(nums, j, i) = (i - 1) < 0 || nums[j][i - 1] != "#";
bool rightEmpty(nums, j, i) = (i + 1) >= size(nums[j]) || nums[j][i + 1] != "#";
bool topLeftEmpty(nums, j, i) = (j-1) < 0 || (i - 1) < 0 || nums[j- 1][i - 1] != "#";
bool topRightEmpty(nums, j, i) = (j-1) < 0 || (i + 1) >= size(nums[j]) || nums[j- 1][i + 1] != "#";
bool bottomRightEmpty(nums, j, i) = (j+1) >= size(nums) || (i + 1) >= size(nums[j]) || nums[j+ 1][i + 1] != "#";
bool bottomLeftEmpty(nums, j, i) = (j+1) >= size(nums) || (i - 1) < 0 || nums[j+ 1][i - 1] != "#";

bool bottomOc(nums, j, i) = (j+1) < size(nums) && nums[j+1][i] == "#";
bool topOc(nums, j, i) = (j-1) >= 0 && nums[j-1][i] == "#";
bool leftOc(nums, j, i) = (i - 1) >= 0 && nums[j][i - 1] == "#";
bool rightOc(nums, j, i) = (i + 1) < size(nums[j]) && nums[j][i + 1] == "#";
bool topLeftOc(nums, j, i) = (j-1) >= 0 && (i - 1) >= 0 && nums[j- 1][i - 1] == "#";
bool topRightOc(nums, j, i) = (j-1) >= 0 && (i + 1) < size(nums[j]) && nums[j- 1][i + 1] == "#";
bool bottomRightOc(nums, j, i) = (j+1) < size(nums) && (i + 1) < size(nums[j]) && nums[j+ 1][i + 1] == "#";
bool bottomLeftOc(nums, j, i) = (j+1) < size(nums) && (i - 1) >= 0 && nums[j+ 1][i - 1] == "#";

str env("L", ns, j, i) = 
	(topEmpty(ns, j, i) && bottomEmpty(ns, j, i) 
		&& rightEmpty(ns, j, i) 
		&& leftEmpty(ns, j, i) 
		&& topRightEmpty(ns, j, i) 
		&& topLeftEmpty(ns, j, i) 
		&& bottomRightEmpty(ns, j, i) 
		&& bottomLeftEmpty(ns, j, i)) ? "#" : "L"; 
	 
		
str env("#", ns, j, i) = 
	(toInt(topOc(ns, j, i)) + toInt(bottomOc(ns, j, i)) + 
		toInt(rightOc(ns, j, i)) + toInt(leftOc(ns, j, i)) +
		toInt(topRightOc(ns, j, i)) + toInt(topLeftOc(ns, j, i)) +
		toInt(bottomRightOc(ns, j, i)) + toInt(bottomLeftOc(ns, j, i))) >= 4 ? "L" : "#";		

str env(x, ns, j, i) = x;

//str env("#", nums, j, i) = 
//	(toInt(topEmpty(nums, j, i)) + toInt(bottomEmpty(num, j, i)) + 
//		toInt(rightEmpty(nums, j, i)) + toInt(leftEmpty(nums, j, i)) +
//		toInt(topRightEmpty(nums, j, i)) + toInt(topLeftEmpty()(nums, j, i)) +
//		toInt(bottomRightEmpty(nums, j, i)) + toInt(bottomLeftEmpty()(nums, j, i))) < 4 ? "L" : "#";
int next(acc, newNums, nums, h, w) {
	for (j <- [0..h], i <- [0..w]) {
		newNums[j][i] = env(nums[j][i], nums, j, i);
		if (newNums[j][i] != nums[j][i]) 
			acc += 1; 
	}
	//for (r <- newNums)
	//	println(r);
	//println("\n\n");
	if (acc == 0) {
		return (0 | it + 1 | r <- newNums, c <- r, c == "#");
	} else {
		return next(0, nums, newNums, h, w);
	}
}
 
str tst = "L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL";
 
value p1() {
	nums = [ split("", p) | p <- input ];
	h = size(nums);
	w = size(nums[0]);
	newNums = [ [ "." | j <- [0..w] ] | i <- [0..h]];
	res = next(0, newNums, nums, h, w);
	return res;
}

bool isEmpty(nums, <j, i>, _, <h, w>) = true
	when j < 0 || j >= h || i >= w || i < 0; 

bool isEmpty(ns, <j, i>, <dj, di>, <h, w>) = isEmpty(ns, <j + dj, i + di>, <dj, di>, <h, w>)
	when ns[j][i] == ".";

bool isEmpty(ns, <j, i>, <dj, di>, <h, w>) = true
	when ns[j][i] == "L";

bool isEmpty(ns, <j, i>, <dj, di>, <h, w>) = false
	when ns[j][i] == "#";
	
bool bottom(nums, j, i) = isEmpty(nums, <j+1, i>, <1, 0>, <size(nums), size(nums[0])>);
bool top(nums, j, i) = isEmpty(nums, <j-1, i>, <-1, 0>, <size(nums), size(nums[0])>); 
bool left(nums, j, i) = isEmpty(nums, <j, i-1>, <0, -1>, <size(nums), size(nums[0])>);
bool right(nums, j, i) = isEmpty(nums, <j, i+1>, <0, 1>, <size(nums), size(nums[0])>);
bool topLeft(nums, j, i) = isEmpty(nums, <j-1, i-1>, <-1, -1>, <size(nums), size(nums[0])>);
bool topRight(nums, j, i) = isEmpty(nums, <j-1, i+1>, <-1, 1>, <size(nums), size(nums[0])>); 
bool bottomRight(nums, j, i) = isEmpty(nums, <j+1, i+1>, <1, 1>, <size(nums), size(nums[0])>);
bool bottomLeft(nums, j, i) = isEmpty(nums, <j+1, i-1>, <1, -1>, <size(nums), size(nums[0])>);	

str env2("L", ns, j, i) = 
	(top(ns, j, i) && bottom(ns, j, i) 
		&& right(ns, j, i) 
		&& left(ns, j, i) 
		&& topRight(ns, j, i) 
		&& topLeft(ns, j, i) 
		&& bottomRight(ns, j, i) 
		&& bottomLeft(ns, j, i)) ? "#" : "L"; 
	 
		
str env2("#", ns, j, i) = 
	(toInt(!top(ns, j, i)) + toInt(!bottom(ns, j, i)) + 
		toInt(!right(ns, j, i)) + toInt(!left(ns, j, i)) +
		toInt(!topRight(ns, j, i)) + toInt(!topLeft(ns, j, i)) +
		toInt(!bottomRight(ns, j, i)) + toInt(!bottomLeft(ns, j, i))) >= 5 ? "L" : "#";		

str env2(x, ns, j, i) = x; 
		
int next2(acc, newNums, nums, h, w) {
	for (j <- [0..h])
	for (i <- [0..w]) 
	{
		newNums[j][i] = env2(nums[j][i], nums, j, i);
		if (newNums[j][i] != nums[j][i]) 
			acc += 1; 
	}
	//for (r <- newNums)
	//	println(r);
	if (acc == 0) {
		return (0 | it + 1 | r <- newNums, c <- r, c == "#");
	} else {
		return next2(0, nums, newNums, h, w);
	}
}

int p2() { 
	nums = [ split("", p) | p <- input ];
	h = size(nums);
	w = size(nums[0]);
	newNums = [ [ "." | j <- [0..w] ] | i <- [0..h]];
	res = next2(0, newNums, nums, h, w);
	return res;
}
	
		