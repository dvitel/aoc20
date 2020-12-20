module d18

import IO; 
import String;
import List;
import Set;
import Relation;
import ParseTree;
import Boolean;
import util::Math;

lexical NUM = [0-9]+;
layout LAYOUT = [\n\t\f\ ]* !>> [\n\t\f\ ];
start syntax Expr = 
	n: NUM number 
	| bracket "(" Expr ")"
	//> left (left Expr l "*" Expr r
	//	| left Expr l "+" Expr r)
	> left add: Expr l "+" Expr r	
	> left mul: Expr l "*" Expr r 
	;
	
data ExprAST = n(int number) | add(ExprAST l, ExprAST r) | mul(ExprAST l, ExprAST r);	
 
loc file = |project://aoc/inputs/d18|;
list[str] input = readFileLines(file);

//int evalC((Expr)`<NUM number>`) = toInt("<number>"); 
//int evalC((Expr)`<Expr l> * <Expr r>`) = evalC(l) * evalC(r);
//int evalC((Expr)`<Expr l> + <Expr r>`) = evalC(l) + evalC(r);
//int evalC((Expr)`(<Expr e>)`) = evalC(e);

int eval(n(number)) = number; 
int eval(mul(l, r)) = eval(l) * eval(r);
int eval(add(l, r)) = eval(l) + eval(r);

int p2() = (0 | it + eval(line) | l <- input, line := implode(#ExprAST, parse(#Expr, l)));
int p1() = (0 | it + evalC(line) | l <- input, line := parse(#Expr, l));

