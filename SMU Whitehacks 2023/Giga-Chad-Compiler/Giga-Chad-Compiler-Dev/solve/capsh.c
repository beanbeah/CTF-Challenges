#include <stdio.h>
#include <stdlib.h>
int main() {
   FILE *FileOpen;
   char line[130];                                 
   FileOpen = popen("capsh --print", "r");                                                                            
   while ( fgets( line, sizeof line, FileOpen)) {
   	printf("%s", line);
   }
   pclose(FileOpen);

   return 0;
}
