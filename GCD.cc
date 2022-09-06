int gcd(int a, int b)
{
    int temp;
    while(b != 0)
    {
        temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

int n_gcd(int *a, int size)
{
    int g = a[0];
    for (int i = 1; i < size; i++)
        g = gcd(g, a[i]);
    return g;
}

int main()
{
    int a[6] = {416, 52, 208, 26, 13, 832};
    int g = n_gcd(a, 6);
    return 0;
}