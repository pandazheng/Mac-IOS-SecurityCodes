#include <stdio.h>
#include <sandbox.h>

int main(int argc, char *argv[]) {
	int rv;
	char sb[] =
		"(version 1)\n"
		"(allow default)\n"
		"(deny file-read-data\n"
		"	(literal \"/private/var/tmp/ioshh\"))\n";
	char *errbuff;

	rv = sandbox_init(sb, 0, &errbuff);
	if (rv != 0) {
		fprintf(stderr, "sandbox_init failed: %s\n", errbuff);
		sandbox_free_error(errbuff);
	} else {
		putenv("PS1=[SANDBOXED] \\h:\\w \\u\\$ ");
		printf("pid: %d\n", getpid());
		execl("/bin/sh", "sh", NULL);
	}

	return 0;
}