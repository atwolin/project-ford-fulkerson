#include <bits/stdc++.h>
#include <stdio.h>
#include <stdlib.h>
// #include "helpers.cuh"
using namespace std;

#define NUMPAD 128

typedef struct _Node_info{
    u_short parent_index;
    u_int potential_flow;
} Node_info;


__global__ void reset(Node_info* node_info, bool* frontier, bool* visited, int source, int total_nodes, u_int* locks);
__global__ void find_augmenting_path(u_short* residual_capacity, Node_info* node_info, bool* frontier, bool* visited, u_int total_nodes, u_int sink, u_int* locks);
__global__ void augment_path(Node_info* node_infos, bool* do_change_capacity , u_int total_nodes, u_short* residual_capacity, u_int bottleneck_flow)
void initialization(u_short* d_residual_capacity, Node_info* d_node_info, bool* d_frontier, bool* d_visited, bool* do_change_capacity, u_int* d_locks,
                   size_t* matrix_size, size_t* node_infos_size, size_t* vertices_size, size_t* locks_size)
void reset_device(Node_info* node_info, bool* frontier, bool* visited, int source, int total_nodes, u_int* locks)
void find_augmenting_path_device(u_short* d_residual_capacity, Node_info* d_node_info, bool* d_frontier, bool* d_visited, u_int N, u_int sink, u_int* d_locks)
void D2H_node_info(Node_info* node_info, Node_info* d_node_info)
void augment_path_device(bool* do_change_capacity, Node_info* d_node_info, bool* d_do_change_capacity, u_int N, u_short* d_residual_capacity, u_int bottleneck_flow)
void free_device(u_short* d_residual_capacity, Node_info* d_node_info, bool* d_frontier, bool* d_visited);

/*
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

    // cudaMalloc((void **)&d_residual_capacity, matrix_size);
    // cudaMalloc((void **)&d_node_info,node_infos_size);
    // cudaMalloc((void **)&d_frontier, vertices_size);
    // cudaMalloc((void **)&d_visited, vertices_size);
    // cudaMalloc((void **)&d_do_change_capacity, vertices_size);
    // cudaMalloc((void **)&d_locks, locks_size);
    // // printf("d_residual_capacity_size: %d,\nd_locks_size: %d,\nd_node_info_size: %d,\nd_frontier: %d,\nd_visited: %d,\nd_do_change_capacity: %d\n",
    // //         matrix_size, locks_size, node_infos_size, vertices_size, vertices_size, vertices_size);

    // cudaMemcpy(d_residual_capacity, residual_capacity, matrix_size, cudaMemcpyHostToDevice);

    // int found_augmenting_path = 0;
    initialization(d_residual_capacity, d_node_info, d_frontier, d_visited, do_change_capacity, d_locks,
                   matrix_size, node_infos_size, vertices_size, locks_size);

    // int threads = 256;
    // int blocks = ceil(N * 1.0 /threads);
    int num_threads = 1024;
    int num_blocks = (N / 1024 <= 0) ? 1 : (N + 1023) / 1024;
    dim3 threads(num_threads);
    dim3 blocks(num_blocks);

    // timer.start();
    do {
        // reset visited, frontier, node_info, locks
        // reset<<<blocks, threads>>>(d_node_info, d_frontier, d_visited, source, N, d_locks);
        reset_device(d_node_info, d_frontier, d_visited, source, N, d_locks)
        reset_host(frontier, source, N, do_change_capacity);

        while(!is_frontier_empty_or_sink_found(frontier, N, sink)){
                // // Invoke kernel
                // find_augmenting_path<<< blocks, threads >>>(d_residual_capacity, d_node_info, d_frontier, d_visited, N, sink, d_locks);

                // // Copy back frontier from device
                // cudaMemcpy(frontier, d_frontier, vertices_size, cudaMemcpyDeviceToHost);
                // // printf("%d\n", found_augmenting_path);
                find_augmenting_path_device(d_residual_capacity, d_node_info, d_frontier, d_visited, N, sink, d_locks);
        }
        found_augmenting_path = frontier[sink];
        // printf("d, %d\n", found_augmenting_path);
        if(!found_augmenting_path){
            break;
        }

        // // copy node_info from device to host
        // cudaMemcpy(node_info, d_node_info, node_infos_size, cudaMemcpyDeviceToHost);
        D2H_node_info(node_info, d_node_info);

        bottleneck_flow = node_info[sink].potential_flow;
        max_flow += bottleneck_flow;

        for(current_vertex = sink; current_vertex != source; current_vertex = current_node_info->parent_index){
            current_node_info = node_info + current_vertex;
            do_change_capacity[current_vertex] = true;
        }

        // cudaMemcpy(d_do_change_capacity, do_change_capacity, vertices_size, cudaMemcpyHostToDevice);
        // augment_path<<< blocks, threads >>>(d_node_info, d_do_change_capacity, N, d_residual_capacity, bottleneck_flow);
        augment_path_device(do_change_capacity, d_node_info, d_do_change_capacity, N, d_residual_capacity, bottleneck_flow)


    } while(found_augmenting_path);


    printf("\nmaxflow %d\n", max_flow);
    double time_taken = ((double)clock() - start_time)/CLOCKS_PER_SEC * milliseconds; // in milliseconds
    printf("%f ms for thread size- %d\n", time_taken, num_threads);
    output(argv[3], max_flow, time_taken);
    // timer.stop("compute total algorithm");
    // output(argv[3], max_flow, double(timer.time));

    free(residual_capacity);
    free(frontier);
    free(node_info);

    // cudaFree(d_is_empty_or_found);
    // cudaFree(d_residual_capacity);
    // cudaFree(d_node_info);
    // cudaFree(d_frontier);
    // cudaFree(d_visited);
    free_device(d_residual_capacity, d_node_info, d_frontier, d_visited) {

    return 0;
}
*/

__global__ void reset(Node_info* node_info, bool* frontier, bool* visited, int source, int total_nodes, u_int* locks) {
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    if(id < total_nodes){
        frontier[id] = (id == source);
        visited[id] = false;
        node_info[id].potential_flow = UINT_MAX;
        locks[id] = 0;
    }
}

__global__ void augment_path(Node_info* node_infos, bool* do_change_capacity , u_int total_nodes, u_short* residual_capacity, u_int bottleneck_flow) {
    int node_id = blockIdx.x * blockDim.x + threadIdx.x;
    if(node_id < total_nodes && do_change_capacity[node_id]){
        Node_info* current_node_info = node_infos + node_id;
        residual_capacity[current_node_info->parent_index * total_nodes + node_id] -= bottleneck_flow;
        residual_capacity[node_id * total_nodes + current_node_info->parent_index] += bottleneck_flow;
    }
}

__global__ void find_augmenting_path(u_short* residual_capacity, Node_info* node_info, bool* frontier, bool* visited,
    u_int total_nodes, u_int sink, u_int* locks){

    int node_id = blockIdx.x * blockDim.x + threadIdx.x;

    if(!frontier[sink] && node_id < total_nodes && frontier[node_id]){

        frontier[node_id] = false;
        visited[node_id] = true;

        Node_info *neighbour;
        Node_info current_node_info = node_info[node_id];
        u_int capacity;

        for (u_int i = node_id; i < total_nodes; ++i){

            if(frontier[i] || visited[i] || ((capacity = residual_capacity[node_id * total_nodes + i]) <= 0)){
                continue;
            }

            if(atomicCAS(locks+i, 0 , 1) == 1 || frontier[i]){
                continue;
            }

            frontier[i] = true;
            locks[i] = 0;

            neighbour = node_info + i;
            neighbour->parent_index = node_id;
            neighbour->potential_flow =  min(current_node_info.potential_flow, capacity);
        }


        for (u_int i = 0; i < node_id; ++i){

            if(frontier[i] || visited[i] || ((capacity = residual_capacity[node_id * total_nodes + i]) <= 0)){
                continue;
            }

            if(atomicCAS(locks+i, 0 , 1) == 1 || frontier[i]){
                continue;
            }

            frontier[i] = true;
            locks[i] = 0;

            neighbour = node_info + i;
            neighbour->parent_index = node_id;
            neighbour->potential_flow =  min(current_node_info.potential_flow, capacity);
        }
    }
}

void initialization(u_short* d_residual_capacity, Node_info* d_node_info, bool* d_frontier, bool* d_visited, bool* do_change_capacity, u_int* d_locks,
                   size_t* matrix_size, size_t* node_infos_size, size_t* vertices_size, size_t* locks_size) {
    cudaMalloc((void **)&d_residual_capacity, matrix_size);
    cudaMalloc((void **)&d_node_info,node_infos_size);
    cudaMalloc((void **)&d_frontier, vertices_size);
    cudaMalloc((void **)&d_visited, vertices_size);
    cudaMalloc((void **)&d_do_change_capacity, vertices_size);
    cudaMalloc((void **)&d_locks, locks_size);
    // printf("d_residual_capacity_size: %d,\nd_locks_size: %d,\nd_node_info_size: %d,\nd_frontier: %d,\nd_visited: %d,\nd_do_change_capacity: %d\n",
    //         matrix_size, locks_size, node_infos_size, vertices_size, vertices_size, vertices_size);

    cudaMemcpy(d_residual_capacity, residual_capacity, matrix_size, cudaMemcpyHostToDevice);

    int found_augmenting_path = 0;
}

void reset_device(Node_info* node_info, bool* frontier, bool* visited, int source, int total_nodes, u_int* locks) {
    int num_threads = 1024;
    int num_blocks = (N / 1024 <= 0) ? 1 : (N + 1023) / 1024;
    dim3 threads(num_threads);
    dim3 blocks(num_blocks);

    reset<<<blocks, threads>>>(d_node_info, d_frontier, d_visited, source, N, d_locks);
}

void find_augmenting_path_device(u_short* d_residual_capacity, Node_info* d_node_info, bool* d_frontier, bool* d_visited, u_int N, u_int sink, u_int* d_locks) {
    int num_threads = 1024;
    int num_blocks = (N / 1024 <= 0) ? 1 : (N + 1023) / 1024;
    dim3 threads(num_threads);
    dim3 blocks(num_blocks);

    // Invoke kernel
    find_augmenting_path<<<blocks, threads>>>(d_residual_capacity, d_node_info, d_frontier, d_visited, N, sink, d_locks);

    // Copy back frontier from device
    cudaMemcpy(frontier, d_frontier, vertices_size, cudaMemcpyDeviceToHost);
}

void D2H_node_info(Node_info* node_info, Node_info* d_node_info) {
    // copy node_info from device to host
    cudaMemcpy(node_info, d_node_info, node_infos_size, cudaMemcpyDeviceToHost);
}

void augment_path_device(bool* do_change_capacity, Node_info* d_node_info, bool* d_do_change_capacity, u_int N, u_short* d_residual_capacity, u_int bottleneck_flow) {
    cudaMemcpy(d_do_change_capacity, do_change_capacity, vertices_size, cudaMemcpyHostToDevice);
    augment_path<<< blocks, threads >>>(d_node_info, d_do_change_capacity, N, d_residual_capacity, bottleneck_flow);
}

void free_device(u_short* d_residual_capacity, Node_info* d_node_info, bool* d_frontier, bool* d_visited) {
    cudaFree(d_is_empty_or_found);
    cudaFree(d_residual_capacity);
    cudaFree(d_node_info);
    cudaFree(d_frontier);
    cudaFree(d_visited);
}