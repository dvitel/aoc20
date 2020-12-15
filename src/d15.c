#include "stdio.h"
int turns[30000000][2]; 

void main() {
	//init 
	turns[0][0] = 1;
	turns[12][0] = 2;
	turns[6][0] = 3;
	turns[13][0] = 4;
	turns[20][0] = 5;
	turns[1][0] = 6;
	turns[17][0] = 7;	
	
	int turn = 8; 
	int spoken = 17;
	int maxTurn = 30000000; //2020;
	while (1) { 
		int* spokenOc = turns[spoken];
		if (spokenOc[0] == 0 || spokenOc[1] == 0) {
			spoken = 0; 			
		} else {
			spoken = spokenOc[0] - spokenOc[1];
		}
		spokenOc = turns[spoken];
		spokenOc[1] = spokenOc[0];
		spokenOc[0] = turn;
		if (turn == maxTurn)
		{
			printf("%d", spoken);
			return;
		}		
		turn++;
	}
}
