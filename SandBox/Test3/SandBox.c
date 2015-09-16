#include <stdio.h>
#include <sandbox.h>

int main(int argc, char *argv[]) {
	int rv;
	char sb[] =
		"(version 1)\n"
		"(allow default)\n"
		"(deny file-issue-extension*)\n"
		"(deny file-read-data\n"
		"	(regex #\"/private/var/tmp/container/([0-9]+)/.*\"))\n"
		"(allow file-read-data\n"
		"	(require-all\n"
                "           (extension)\n"
                "           (regex #\"/private/var/tmp/container/([0-9]+)/.*\")))\n"
		"(deny file-read-data\n"
		"	(literal \"/private/var/tmp/ioshh\"))\n";
	char *errbuff;

	char *token;
	token = NULL;
	rv = sandbox_issue_extension("/private/var/tmp/container/1337", &token);
	if (rv == 0 && token) {
		printf("Issued extension token for \"/private/var/tmp/container/1337\":\n");
                printf("  %s\n", token);
	} else {
		printf("sandbox_issue_extension failed\n");
	}

	const char *exts[] = { argv[1] };
	printf("Applying sandbox profile:\n");
	printf("%s", sb);
	printf("\n");
	printf("With extensions: { \"%s\" }\n", exts[0]);
	printf("\n");
	
	rv = sandbox_init_with_extensions(sb, 0, exts, &errbuff);
	if (rv != 0) {
		fprintf(stderr, "sandbox_init failed: %s\n", errbuff);
		sandbox_free_error(errbuff);
	} else {
		putenv("PS1=[SANDBOXED] \\h:\\w \\u\\$ ");
		//printf("pid: %d\n", getpid());

		printf("Attempting to issue another extension after applying the sandbox profile...\n");
		char *token2 = NULL;
		rv = sandbox_issue_extension("/private/var/tmp/container/1337", &token2);
		if (rv == 0 && token) {
			printf("Issued extension token for \"/private/var/tmp/container/1337\":\n");
                	printf("  %s\n", token);
		} else {
			printf("sandbox_issue_extension failed\n");
		}

		system("/bin/sh");
		printf("\nConsuming the extension, then starting another shell...\n\n");
		sandbox_consume_extension("/private/var/tmp/container/1337", token);
		system("/bin/sh");
		//execl("/bin/sh", "sh", NULL);
	}

	return 0;
}