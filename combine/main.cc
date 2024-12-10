#include <bits/stdc++.h>
#include <stdio.h>
#include <stdlib.h>
#include <immintrin.h>  // AVX-512
#include "include/ff.cuh"
using namespace std;

#define milliseconds 1e3
#define num_threads 1024
u_int N;

void input(const char* filename, u_int total_nodes, u_short* residual_capacity);
void output(char* filename, int max_flow, double time);
void reset_host(bool* frontier, int source, int total_nodes, bool* do_change_capacity);
bool is_frontier_empty_or_sink_found(bool* frontier, int N, int sink_pos);


int main(int argc, char** argv){
    if(argc < 4){
        printf("Specify filename & number of vertices\n");
        return 1;
    }

    N = atoi(argv[2]);
    // u_int V = atoi(argv[2]);
    // N = (V % NUMPAD == 0) ? V : (V / NUMPAD + 1) * NUMPAD;
    size_t matrix_size = N * N * sizeof(u_short);

    u_short *residual_capacity;
    residual_capacity = (u_short *)malloc(matrix_size);
    memset(residual_capacity, 0, matrix_size);

    input(argv[1], N, residual_capacity);

    u_int source = 0, sink = N - 1;
    u_int current_vertex, bottleneck_flow;
    u_int max_flow = 0;

    clock_t start_time = clock();

    size_t node_infos_size = N * sizeof(Node_info);
    size_t vertices_size = N * sizeof(bool);
    size_t locks_size = N * sizeof(u_int);

    Node_info* current_node_info;
    Node_info* node_info = (Node_info *)malloc(node_infos_size);
    bool* frontier = (bool *)malloc(vertices_size);
    bool* do_change_capacity = (bool *)malloc(vertices_size);

    u_short* d_residual_capacity;
    Node_info* d_node_info;
    bool* d_frontier, *d_visited, *d_do_change_capacity;
    u_int* d_locks;

    int found_augmenting_path;
    initialization_device(d_residual_capacity, residual_capacity, d_node_info, d_frontier, d_visited, d_do_change_capacity, d_locks, &matrix_size, &node_infos_size, &vertices_size, &locks_size);

    do {
        // reset visited, frontier, node_info, locks
        reset_device(d_node_info, d_frontier, d_visited, source, N, d_locks);
        reset_host(frontier, source, N, do_change_capacity);
        while (!is_frontier_empty_or_sink_found(frontier, N, sink)) {
                find_augmenting_path_device(d_residual_capacity, d_node_info, d_frontier, frontier, d_visited, &vertices_size, N, sink, d_locks);
        }
        found_augmenting_path = frontier[sink];
        printf("d, %d\n", found_augmenting_path);
        if(!found_augmenting_path){
            break;
        }

        // D2H_node_info(node_info, d_node_info, &node_infos_size);
        // bottleneck_flow = node_info[sink].potential_flow;
        // max_flow += bottleneck_flow;
        // for(current_vertex = sink; current_vertex != source; current_vertex = current_node_info->parent_index){
        //     current_node_info = node_info + current_vertex;
        //     do_change_capacity[current_vertex] = true;
        // }
        // augment_path_device(do_change_capacity, d_node_info, d_do_change_capacity, N, d_residual_capacity, bottleneck_flow, &vertices_size);

    } while(found_augmenting_path);


    printf("\nmaxflow %d\n", max_flow);
    double time_taken = ((double)clock() - start_time)/CLOCKS_PER_SEC * milliseconds; // in milliseconds
    printf("%f ms for thread size- %d\n", time_taken, num_threads);
    output(argv[3], max_flow, time_taken);

    free(residual_capacity);
    free(frontier);
    free(node_info);
    free_device(d_residual_capacity, d_node_info, d_frontier, d_visited);

    return 0;
}

void input(const char* filename, u_int total_nodes, u_short* residual_capacity) {
    ifstream file;
    file.open(filename);
    if (!file) {
        printf("Error reading file.\n");
        exit(1);
    }

    string line;
    u_int source, destination;
    u_short capacity;
    while (file) {
        getline(file, line);

        if (line.empty()) {
            continue;
        }
        std::stringstream linestream(line);
        linestream >> source >> destination >> capacity;
        residual_capacity[source * total_nodes + destination] = capacity;
    }
    file.close();
}

void output(char* filename, int max_flow, double time) {
    FILE* outfile = fopen(filename, "w");
    fprintf(outfile, "Max Flow: %d\n", max_flow);
    fprintf(outfile, "Time(ms): %.4f\n", time);
    fclose(outfile);
}

void reset_host(bool* frontier, int source, int total_nodes, bool* do_change_capacity) {
    frontier[source] = true;
    do_change_capacity[source] = false;

    for (int i = source+1; i < total_nodes; i++) {
        frontier[i] = false;
        do_change_capacity[i] = false;
    }

    for (int i = 0; i < source; i++) {
        frontier[i] = false;
        do_change_capacity[i] = false;
    }

    // __m512i zero = _mm512_setzero_si512();
    // int i = 0;
    // for (; i <= total_nodes - 16; i += 16) {
    //     _mm512_storeu_si512((__m512i*)&frontier[i], zero);
    //     _mm512_storeu_si512((__m512i*)&do_change_capacity[i], zero);
    // }
    // for (; i < total_nodes; i++) {
    //     frontier[i] = false;
    //     do_change_capacity[i] = false;
    // }

    // for (; i <= total_nodes - 16; i += 16) {
    //     _mm512_storeu_si512((__m512i*)&frontier[i], zero);
    //     _mm512_storeu_si512((__m512i*)&do_change_capacity[i], zero);
    // }
    // for (; i < total_nodes; i++) {
    //     frontier[i] = false;
    //     do_change_capacity[i] = false;
    // }
}

bool is_frontier_empty_or_sink_found(bool* frontier, int N, int sink_pos) {
    for (int i = N-1; i > -1; --i) {
        if(frontier[i]){
            return i == sink_pos;
        }
    }
    printf("in while loop\n");
    return true;

    // __m512i sink_mask = _mm512_set1_epi32(sink_pos);
    // for (int i = 0; i <= N - 16; i += 16) {
    //     __m512i frontier_chunk = _mm512_loadu_si512((__m512i*)&frontier[i]);
    //     __mmask16 mask = _mm512_test_epi32_mask(frontier_chunk, _mm512_set1_epi32(1));
    //     if (mask) {
    //         __m512i indices = _mm512_add_epi32(_mm512_set1_epi32(i), _mm512_set_epi32(15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0));
    //         __mmask16 sink_found_mask = _mm512_cmpeq_epi32_mask(indices, sink_mask);
    //         if (sink_found_mask) {
    //             return true;
    //         }
    //     }
    // }
    // for (int i = (N / 16) * 16; i < N; ++i) {
    //     if (frontier[i]) {
    //         return i == sink_pos;
    //     }
    // }
    // return true;
}

