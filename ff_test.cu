#include <bit/stdc++.h>
#include <stdio.h>
#include <stdlib.h>
#include "helpers.cuh"
using namespace std;

#define milliseconds 1e3
#define NUMPAD 128



u_int N;

typedef struct _Node_info {
    u_short parent_index;
    u_int potential_flow;
} Node_info;
void input(const char* filename, u_int total_nodes, u_short* residual_capacity);
void output(char* filename, int max_flow, double time);

__global__ void reset(Node_info* node_info, bool* frontier, bool* visited, int source, int total_nodes, u_int* locks);

int main(int argc, char** argv) {
    if (argc < 4) {
        printf("Required input filename, data size, and output filename")
    }
    Timer timer;

    N = atoi(argv[2]);
    // u_int V = atoi(argv[2]);
    // N = (V % NUMPAD == 0) ? V : (V / NUMPAD + 1) * NUMPAD;
    size_t matrix_size = N * N sizeof(u_short);

    u_short *residual_capacity;
    residual_capacity = (u_short *)malloc(matrix_size);
    memset(residual_capacity, 0, matrix_size);

    input(argv[1], N, residual_capacity);

    u_int source = 0, sink = N - 1;
    u_int current_vertex, bottleneck_flow;
    u_int max_flow = 0;
    bool found_augmenting_path;

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

    cudaMalloc((void **)&d_residual_capacity, matrix_size);
    cudaMalloc((void **)&d_node_info,node_infos_size);
    cudaMalloc((void **)&d_frontier, vertices_size);
    cudaMalloc((void **)&d_visited, vertices_size);
    cudaMalloc((void **)&d_do_change_capacity, vertices_size);
    cudaMalloc((void **)&d_locks, locks_size);
    printf("d_residual_capacity_size: %d,\nd_locks_size: %d,\nd_node_info_size: %d,\nd_frontier: %d,\nd_visited: %d,\nd_do_change_capacity: %d\n",
            matrix_size, locks_size, node_infos_size, vertices_size, vertices_size, vertices_size);

    cudaMemcpy(d_residual_capacity, residual_capacity, matrix_size, cudaMemcpyHostToDevice);

    int num_threads = 1024;
    int num_blocks = (N / 1024 <= 0) ? 1 : (N + 1023) / 1024;
    dim3 threads(num_threads);
    dim3 blocks(num_blocks);

    do {
        reset<<<num_blocks, num_threads>>>(d_node_info, d_frontier, d_visited, source, N, d_locks, d_do_change_capacity);
    } while(found_augmenting_path);

}


void input(const char* filename, u_int total_nodes, u_short* residual_capacity) {
    ifstream file;
    file.open(filename);

    if (!file) {
        printf("Error reading file.\n");
        exit(true);
    }

    string line;
    u_int source, destination;
    u_short capacity;

    while (file) {
        getline(file, line);
        if (line.empty()) {
            continue;
        }
        stringstream linestream(line);
        linestream >> source >> destination >> capacity;
        residual_capacity[source * total_nodes + destination] = capacity;
    }
    file.close();
}

void output(char* filename, int max_flow, double time) {
    FILE* outfile = fopen(filename, "w");
    fprintf(outfile, "Max Flow: %d\n", max_flow);
    fprintf(outfile, "Time(ms): %.2f\n", time);
    fclose(outfile);
}

__global__ void reset(Node_info* node_info, bool* frontier, bool* visited, int source, int total_nodes, u_int* locks, bool* do_change_capacity) {
    int id = threadIdx.x + blockIdx.x * blockDim.x;
    if(id < total_nodes){
        // frontier[id] = id == source;
        visited[id] = false;
        node_info[id].potential_flow = UINT_MAX;
        locks[id] = 0;
    }

    // in reset_host
    for (int i = 0; i < total_nodes; ++i) {
        frontier[i] = false;
        do_change_capacity[i] = false;
    }
}