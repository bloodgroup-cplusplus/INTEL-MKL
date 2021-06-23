#include<cuda_runtime.h>
#include<device_launch_parameters.h>
#include<stdlib.h>
#include<math.h>
#include<assert.h>
#include<iostream>
// cuda kernal for vector addition
__global__  void vectorAdd(int* a, int* b, int* c, int n)
{
	// Calculate global thread ID(tid)
	// one thread per element that gets added.
	//out of all of our thread figure out who am I 
	// blockIdx.x => which block am i 
	//bolckDim.x => block size ( 256)
	// threadIdx.x => which thread am I in the block.
	int tid = (blockIdx.x * blockDim.x) + threadIdx.x;
	// vector boundary guard
	if (tid < n)
	{
		//Each thread adds a single element
		c[tid] = a[tid] + b[tid];
	}
}

// Initialize vector of size n to int between 0-99

void matrix_init(int* a, int n)
{
	for (int i = 0; i < n; ++i)
	{
		a[i] = rand() % 100;
	}
}
//Check vector add result
void error_check(int* a, int* b, int* c, int n)
{
	for (int i = 0; i < n; ++i)
	{
		assert(c[i] == a[i] + b[i]);
	}
}

int main()
{
	// vector size of 2^16 (65536 elements)
	int n = 1 << 16;

	// Host vector pointers

	int* h_a, * h_b, * h_c;
	//Device vector pointers

	int* d_a, * d_b, * d_c;
	//Allocation size for all vectors

	size_t bytes = sizeof(int) * n;

	//Allocate host memory

	h_a = (int*)malloc(bytes);
	h_b = (int*)malloc(bytes);
	h_c = (int*)malloc(bytes);

	//Allocate device memory

	cudaMalloc(&d_a, bytes);
	cudaMalloc(&d_b, bytes);
	cudaMalloc(&d_c, bytes);
	//Initialize vectors a and b with random values between  0 and 99;
	matrix_init(h_a, n);
	matrix_init(h_b, n);

	// Threadblock size

	int NUM_THREADS = 256;

	//Grid size
	int NUM_BLOCKS = (int)ceil(n / NUM_THREADS);

	//Launch kernel on default strream w/o stream

	vectorAdd << < NUM_BLOCKS, NUM_THREADS >> > (d_a, d_b, d_c, n);


	// copy sum vector from device to host

	cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost);


	//check result for errors


	error_check(h_a, h_b, h_c, n);


	std::cout << "COMPLETED SUCCESSUFLLY\n" << std::endl;
	return 0;


}
