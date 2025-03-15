#include<iostream>
#include<math.h>

__global__
void add(int n,float *x,float *y)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    for (int i = index; i < n; i += stride)
      y[i] = x[i] + y[i];
    //printf("blockIdx.x: %d, threadIdx.x: %d  blockDim.x=%d gridStride: %d \n", blockId, index,blockDim.x,gridStride);
}


int main()
{
    int N = 1<<20;
    float *x,*y;

    printf("N=%d\n",N);
    cudaMallocManaged(&x,N*sizeof(float));
    cudaMallocManaged(&y,N*sizeof(float)); 

    for(int i=0;i<N;i++)
    {
        x[i] = 1.0f;
        y[i] = 2.0f;
    }   
    int threadsPerBlock = 256;
    int blocksPerGrid =(N + threadsPerBlock - 1) / threadsPerBlock;
    add<<<blocksPerGrid,threadsPerBlock>>>(N,x,y);
    cudaDeviceSynchronize();

    // Free memory
    cudaFree(x);
    cudaFree(y);
    
    return 0;
}