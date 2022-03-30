#include <iostream>
#include <stdlib.h>
#include <time.h>
using namespace std;
const int n = 8;

//划分
int split(int A[], int low, int high)
{
    int left = 1, i = low, j = high, t;
    while (i != j)
    {
        if (left)
        {
            while (i != j && A[i] <= A[j])
            {
                j--;
            }
            t = A[i];
            A[i] = A[j];
            A[j] = t;
            left = 0;
        } // left
        else
        {
            while (i != j && A[i] <= A[j])
            {
                i++;
            }
            t = A[i];
            A[i] = A[j];
            A[j] = t;
            left = 1;
        } // right
    }     // while
    return i;
}

//快速排序
void quicksort(int A[], int low, int high)
{
    if (low < high) //递归入口
    {
        int mid = split(A, low, high);
        quicksort(A, low, mid - 1);
        quicksort(A, mid + 1, high);
    }
}

//输出数组
void print(int A[], int m)
{
    for (int i = 0; i < m; i++)
    {
        cout << A[i] << ' ';
    }
    cout << endl;
}

int main()
{
    int a[] = {6, 8, 3, 5, 9};
    // cout << split(a, 0, 4) << endl;
    quicksort(a, 0, 4);
    print(a, 5);
    system("pause");
}
// int main()
// {
//     while (1)
//     {
//         srand((unsigned)time(NULL));
//         int A[n];
//         int r;
//         cin >> r;
//         if (!r)
//             break;
//         for (int i = 0; i < n; i++)
//             A[i] = rand();
//         // split(A,0,7);
//         print(A, n);
//         quicksort(A, 0, n - 1);
//         print(A, n);
//         system("pause");
//     }
// }