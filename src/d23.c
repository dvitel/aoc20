#include <stdio.h>
#include <stdlib.h>
#define SZ 9
#define C 1000000
int cups[SZ] = {5, 2, 3, 7, 6, 4, 8, 1, 9};
// int cups[SZ] = {3, 8, 9, 1, 2, 5, 4, 6, 7};
struct nu* cache[C];
struct nu {
    int n;
    struct nu* nxt;
    struct nu* prv;
};
// int cur = 0;
// void swap(int i, int j) {
//     int tmp = cups[i]; 
//     cups[i] = cups[j];
//     cups[j] = tmp;
// }

void main() {
    // for (int i = 0; i < sizeof(a)/sizeof(int); i++) cups[i] = a[i];
    struct nu *ptr = 0; 
    // struct nu startS = { cups[0], 0 };
    // start = ptr = &startS;
    for (int i = 0; i < SZ; i++) {
        struct nu* tmp = (struct nu*)malloc(sizeof(struct nu)); //{ cups[i], 0};
        tmp -> n = cups[i];
        tmp -> prv = ptr;
        if (ptr != 0)
            ptr -> nxt = tmp;
        ptr = tmp;
        cache[cups[i]-1] = ptr;
    }
    for (int i = 10; i <= C; i++) {
        struct nu* tmp = (struct nu*)malloc(sizeof(struct nu)); //{ cups[i], 0};
        tmp -> nxt = 0;
        tmp -> n = i;
        tmp -> prv = ptr;
        ptr -> nxt = tmp;
        ptr = tmp; 
        cache[i-1] = ptr;   
    }
    ptr -> nxt = cache[cups[0]-1];
    cache[cups[0]-1] -> prv = ptr;
    ptr = cache[cups[0]-1];
    struct nu* toInsStart = 0;
    for (int i = 0; i < 10000000; i++) {
        struct nu* nxt1 = ptr -> nxt;
        struct nu* nxt2 = ptr -> nxt -> nxt;
        struct nu* nxt3 = ptr -> nxt -> nxt -> nxt;  
        if ((i % 100000) == 0)
            printf("%d iter\n", i);
        ptr -> nxt = nxt3 -> nxt;  
        nxt3 -> nxt -> prv = ptr;     
        // ptr -> nxt = toInsStart;
        int toInsTarget = (ptr -> n == 1) ? C : (ptr -> n - 1);
        while ((toInsTarget == nxt1 -> n) || (toInsTarget == nxt2 -> n) || (toInsTarget == nxt3 -> n)) {
            toInsTarget--;
            if (toInsTarget == 0) toInsTarget = C;
        }
        toInsStart = cache[toInsTarget - 1]; // (toInsStart == 0) ? ptr -> nxt : toInsStart;
        struct nu* tmp = toInsStart -> nxt;
        toInsStart -> nxt = nxt1;
        nxt1 -> prv = toInsStart;
        nxt3 -> nxt = tmp;
        tmp -> prv = nxt3;        
        ptr = ptr -> nxt;
    }
    // ptr = start;    
    // for (int i = 0; i < 9; i++) {
    //     printf("%d: %d\n", i, ptr -> n);
    //     ptr = ptr -> nxt;
    // }
    printf("%d * %d = %ld\n", cache[0] -> nxt -> n, cache[0] -> nxt -> nxt -> n, (long)(cache[0] -> nxt -> n) * (long)(cache[0] -> nxt -> nxt -> n));
}

