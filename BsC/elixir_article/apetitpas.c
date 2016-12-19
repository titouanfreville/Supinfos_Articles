int Puissance(int a, int b)  {
  int res=1;
  int i;
  for (i=1; i<b;i++) {
    res=res*b;
  }
  return res;
}

int Factorielle(int a)  {
  int res=1;
  int i;
  for (i=0; i<a;i++) {
    res=res*i;
  }
  return res;
}

int main() {
  return 0;
}
