// this is the sorting algorithm that will be executed in the
// circuit

#define ARRAY_SIZE 16

void insertion_sort(
    int* start,           // in, 1 bit.
    int arr[ARRAY_SIZE], // inout, 32 bit.
    int *done            // out, 1 bit.
)
{
    *done = 0;
    // those are going to be the registers of the datapath.
    // i and j are actually 5 bits.
    int i, j, elem2insert, elem2compare;

    // wait for the start signal.
    while (!(*start))
        ;

    i = 1;
    while (i < ARRAY_SIZE)
    { // this loop puts i_th element to its correct place
        elem2insert = arr[i];
        j = i-1;
        while (j >= 0)
        { // this loop shifts the elem2insert to left,
          // until it founds the corect place of its.
            elem2compare = arr[j];
            if (elem2insert > elem2compare)
            {
                break; // we found the correct place of elem2insert
            }
            arr[j] = elem2insert;
            arr[j + 1] = elem2compare;
            j--;
        }
        i++;
    }
    *done = 1;
}


// testing the algorithm
#include <stdio.h>
#include <stdlib.h>
#include <time.h>


int compare(const void *a, const void *b)
{
    return (*(int *)a - *(int *)b);
}

int is_array_equal(int arr1[], int arr2[], int size)
{
    for (int i = 0; i < size; i++)
    {
        if (arr1[i] != arr2[i])
        {
            return 0;
        }
    }
    return 1;
}

int main()
{
    int arr[ARRAY_SIZE];
    int arr_copy[ARRAY_SIZE];
    int i;
    int start = 0;
    int done = 0;
    
    // Seed the random number generator
    srand(time(NULL));

    for (int iteration = 0; iteration < 1; iteration++)
    {
        printf("Iteration %d:\n", iteration + 1);
        
        // Populate the array with random numbers
        for (i = 0; i < ARRAY_SIZE; i++)
        {
            arr[i] = rand() % 100;
            arr_copy[i] = arr[i];
        }

        printf("Before sorting:\n");
        for (i = 0; i < ARRAY_SIZE; i++)
        {
            printf("%d ", arr[i]);
        }
        printf("\n");

        // Simulate start signal
        start = 1;

        // Call the insertion sort function
        insertion_sort(&start, arr, &done);

        // Sort the copy using standard library
        qsort(arr_copy, ARRAY_SIZE, sizeof(int), compare);

        printf("After sorting:\n");
        for (i = 0; i < ARRAY_SIZE; i++)
        {
            printf("%d ", arr[i]);
        }
        printf("\n");

        // Check if the two arrays are equal
        if (is_array_equal(arr, arr_copy, ARRAY_SIZE))
        {
            printf("Sorting is correct!\n");
        }
        else
        {
            printf("Sorting is incorrect!\n");
        }
    }

    return 0;
}
