#include <unistd.h>
#include <stdlib.h>

int main()
{
	setuid(0);
	char command[] = "pacman -Sy >/dev/null && pacman -Qu | wc -l | tail -n1";
	system(command);
}
