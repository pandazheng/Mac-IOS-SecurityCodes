#include <stdio.h>
#include <unistd.h>

int main(int argc,char* argv[])
{
	char path[0x400];
	confstr(_CS_DARWIN_USER_CACHE_DIR,path,sizeof(path));
	puts(path);

	return 0;
}