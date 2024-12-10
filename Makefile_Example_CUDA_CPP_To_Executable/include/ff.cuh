typedef struct _Node_info{
    u_short parent_index;
    u_int potential_flow;
} Node_info;

void initialization(u_short* d_residual_capacity, Node_info* d_node_infos, bool* d_frontier, bool* d_visited, bool* do_change_capacity, u_int* d_locks,
                   size_t* matrix_size, size_t* node_infos_size, size_t* vertices_size, size_t* locks_size);
void reset_device(Node_info* node_info, bool* frontier, bool* visited, int source, int total_nodes, u_int* locks);
void find_augmenting_path_device(u_short* d_residual_capacity, Node_info* d_node_info, bool* d_frontier, bool* d_visited, u_int N, u_int sink, u_int* d_locks);
void D2H_node_info(Node_info* node_info, Node_info* d_node_info);
void augment_path_device(bool* do_change_capacity, Node_info* d_node_infos, bool* d_do_change_capacity, u_int N, u_short* d_residual_capacity, u_int bottleneck_flow);
void free_device(u_short* d_residual_capacity, Node_info* d_node_info, bool* d_frontier, bool* d_visited);
