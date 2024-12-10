#include <stdio.h>
#include <stdlib.h>
#include <immintrin.h>
using namespace std;

void reset_host_cpp(bool* frontier, int source, int total_nodes, bool* do_change_capacity) {
    frontier[source] = true;
    do_change_capacity[source] = false;

    // for (int i = source+1; i < total_nodes; i++) {
    //     frontier[i] = false;
    //     do_change_capacity[i] = false;
    // }

    __m512i false_vec = _mm512_set1_epi32(0);
    int i;
    for (i = source + 1; i <= total_nodes - 16; i += 16) {
        _mm512_storeu_si512((__m512i*)&frontier[i], false_vec);
        _mm512_storeu_si512((__m512i*)&do_change_capacity[i], false_vec);
    }
    for (; i < total_nodes; i++) {
        frontier[i] = false;
        do_change_capacity[i] = false;
    }

    for (int i = 0; i < source; i++) {
        frontier[i] = false;
        do_change_capacity[i] = false;
    }
}