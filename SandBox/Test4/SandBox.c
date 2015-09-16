#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
	int rv;
	FILE *f = fopen("/private/var/tmp/can_you_see_me", "r");
	if (f != NULL) {
		char buff[80];
		memset(buff, 0, 80);
		fgets(buff, 80, f); 
		printf("%s", buff);
		fclose(f);
	} else {
		perror("fopen failed");
	}
	return 0;
}