#include <stdlib.h>
#include <assert.h>
#include <string.h>

static void *alloc(int n) {     
  static char *avail, *limit;

  n = (n + sizeof(char *) - 1)&~(sizeof(char *) - 1);
  if (n >= limit - avail) {
          avail = malloc(n + 4*1024);
          assert(avail);  
          limit = avail + n + 4*1024;
  }
  avail += n;
  return avail - n;
}


static char *strsave(const char *str) {
  return strcpy(alloc(strlen(str)+1), str);
}


char *basename(char *name) {
  char *s, *b, *t = 0;
 
  for (b = s = name; *s; s++)
          if (*s == '/' || *s == '\\') {
                  b = s + 1;
                  t = 0;
          }// else if (*s == '.')
          //        t = s;
  s = strsave(b);
  if (t)  
          s[t-b] = 0;
  return s;
}
