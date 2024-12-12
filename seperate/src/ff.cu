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
__global__ void augment_path(Node_info* node_infos, bool* do_change_capacity , u_int total_nodes, u_short* residual_capacity, u_int bottleneck_flow);
void initialization_device(u_short* d_residual_capacity, u_short* residual_capacity, Node_info* d_node_info, bool* d_frontier, bool* d_visited, bool* d_do_change_capacity, u_int* d_locks, size_t* matrix_size, size_t* node_infos_size, size_t* vertices_size, size_t* locks_size);
void reset_device(Node_info* d_node_info, bool* d_frontier, bool* d_visited, int source, int N, u_int* d_locks);
void find_augmenting_path_device(u_short* d_residual_capacity, Node_info* d_node_info, bool* d_frontier, bool* frontier, bool* d_visited, size_t* vertices_size, u_int N, u_int sink, u_int* d_locks);
void D2H_node_info(Node_info* node_info, Node_info* d_node_info, size_t* node_infos_size);
void augment_path_device(bool* do_change_capacity, Node_info* d_node_info, bool* d_do_change_capacity, u_int N, u_short* d_residual_capacity, u_int bottleneck_flow, size_t* vertices_size);
void free_device(u_short* d_residual_capacity, Node_info* d_node_info, bool* d_frontier, bool* d_visited);


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

__global__ void find_augmenting_path(u_short* residual_capacity, Node_info* node_info, bool* frontier, bool* visited, u_int total_nodes, u_int sink, u_int* locks) {

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

void initialization_device(
    u_short* d_residual_capacity,
    u_short* residual_capacity,
    Node_info* d_node_info,
    bool* d_frontier,
    bool* d_visited,
    bool* d_do_change_capacity,
    u_int* d_locks,
    size_t* matrix_size,
    size_t* node_infos_size,
    size_t* vertices_size,
    size_t* locks_size
) {
    cudaMalloc((void **)&d_residual_capacity, *matrix_size);
    cudaMalloc((void **)&d_node_info, *node_infos_size);
    cudaMalloc((void **)&d_frontier, *vertices_size);
    cudaMalloc((void **)&d_visited, *vertices_size);
    cudaMalloc((void **)&d_do_change_capacity, *vertices_size);
    cudaMalloc((void **)&d_locks, *locks_size);

    cudaMemcpy(d_residual_capacity, residual_capacity, *matrix_size, cudaMemcpyHostToDevice);
}

void reset_device(Node_info* d_node_info, bool* d_frontier, bool* d_visited, int source, int N, u_int* d_locks) {
    int num_threads = 1024;
    int num_blocks = (N / 1024 <= 0) ? 1 : (N + 1023) / 1024;
    dim3 threads(num_threads);
    dim3 blocks(num_blocks);

    reset<<<blocks, threads>>>(d_node_info, d_frontier, d_visited, source, N, d_locks);
}

void find_augmenting_path_device(u_short* d_residual_capacity, Node_info* d_node_info, bool* d_frontier, bool* frontier, bool* d_visited, size_t* vertices_size, u_int N, u_int sink, u_int* d_locks) {
    int num_threads = 1024;
    int num_blocks = (N / 1024 <= 0) ? 1 : (N + 1023) / 1024;
    dim3 threads(num_threads);
    dim3 blocks(num_blocks);

    // Invoke kernel
    find_augmenting_path<<<blocks, threads>>>(d_residual_capacity, d_node_info, d_frontier, d_visited, N, sink, d_locks);

    // Copy back frontier from device
    cudaMemcpy(frontier, d_frontier, *vertices_size, cudaMemcpyDeviceToHost);
}

void D2H_node_info(Node_info* node_info, Node_info* d_node_info, size_t* node_infos_size) {
    // copy node_info from device to host
    cudaMemcpy(node_info, d_node_info, *node_infos_size, cudaMemcpyDeviceToHost);
}

void augment_path_device(bool* do_change_capacity, Node_info* d_node_info, bool* d_do_change_capacity, u_int N, u_short* d_residual_capacity, u_int bottleneck_flow, size_t* vertices_size) {
    int num_threads = 1024;
    int num_blocks = (N / 1024 <= 0) ? 1 : (N + 1023) / 1024;
    dim3 threads(num_threads);
    dim3 blocks(num_blocks);

    cudaMemcpy(d_do_change_capacity, do_change_capacity, *vertices_size, cudaMemcpyHostToDevice);
    augment_path<<< blocks, threads >>>(d_node_info, d_do_change_capacity, N, d_residual_capacity, bottleneck_flow);
}

void free_device(u_short* d_residual_capacity, Node_info* d_node_info, bool* d_frontier, bool* d_visited) {
    cudaFree(d_residual_capacity);
    cudaFree(d_node_info);
    cudaFree(d_frontier);
    cudaFree(d_visited);
}