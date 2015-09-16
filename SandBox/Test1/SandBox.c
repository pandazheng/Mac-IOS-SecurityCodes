#include <stdio.h>
#include <sandbox.h>

int main(int argc,char *argv[]) {
	int rv;
	char *errbuff;

	rv = sandbox_init("nointernet",SANDBOX_NAMED,&errbuff);
	if (rv != 0) {
		fprintf(stderr, "sandbox_init failed: %s\n", errbuff);
		sandbox_free_error(errbuff);
	} else {
		putenv("PS1=[SANDBOXED] \\h:\\w \\u\\$ ");
		printf("pid: %d\n",getpid());
		execl("/bin/sh","sh",NULL);
	}

	return 0;
}