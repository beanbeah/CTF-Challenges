#include <stdio.h>
#include <signal.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#define arr_size 16
#define overflow_size 16
#define long_size 8
#define total (arr_size + long_size + long_size + overflow_size)

/**
 * print_buffer() was adapted from NUS Greyhats Welcome CTF Challenge. https://github.com/NUSGreyhats/welcome-ctf-2021
 * Huge thanks to NUS Greyhats and Enigmatrix for the concept and inspiration for this challenge. 
 */
void print_buffer(char* buffer) {
    printf("\n");
    for (int i = 0; i < total * 3 + 8; i++) printf("-");
    printf("\n");
    printf("%-47s | %-23s | %-23s | %-23s | %-23s \n", "Array Contents", "Random Variable", "CHANGEME", "Saved Base ptr", "Return Address");
    for (int i = 0; i < total * 3 + 8; i++) printf("-");
    printf("\n");
    //print buffer
    for (int i = 0; i < arr_size; i++) {
        printf("%02x ", (buffer[i] & 0xff));
    }
    printf("| ");
    //print randomvariable
    for (int i = arr_size; i < arr_size + 8; i++) {
        printf("%02x ", (buffer[i] & 0xff));
    }
    printf("| ");
    //print CHANGEME
    for (int i = arr_size+8; i < arr_size + 16; i++) {
        printf("%02x ", (buffer[i] & 0xff));
    }
    printf("| ");
    //print Saved Base ptr
    for (int i = arr_size+16; i < arr_size + 24; i++) {
        printf("%02x ", (buffer[i] & 0xff));
    }
    printf("| ");
    //print return address
    for (int i = arr_size+24; i < arr_size + 32; i++) {
        printf("%02x ", (buffer[i] & 0xff));
    }
    printf("\n");
    for (int i = 0; i < total * 3 + 8; i++) printf("-");
    printf("\n");
}

void vuln() {
    char buffer[arr_size];
    long CHANGEME = 0xdeadbeef;
    long randomvariable = 0xcafebeef;
    memset(buffer, 0, arr_size);
    print_buffer(buffer);
    printf("\nWondering why CHANGEME is printed as efbeadde? That's because of Endianness. Endianness is the order in which bytes are stored in memory.\n");
    printf("For most binaries, Little Endian is used, which means the least significant byte is stored first.\n");
    printf("Thus, 0xdeadbeef is stored as efbeadde.\n\n");
    printf("For starters, why not try entering a few characters and see what happens?\n");
    printf("You can also try entering more than 16 characters to see what happens.\n\n");
    

    while(1) {
        printf("Your Input: ");
        fgets(buffer, (total+5), stdin);
        print_buffer(buffer);
        printf("\rRandom Variable\t\t: %p\nCHANGEME\t\t: %p\nsaved base pointer\t: %p\nreturn address\t\t: %p\n", *((long*)(buffer + arr_size )), *((long*)(buffer + arr_size + 8)),*((long*)(buffer + arr_size + 16)),*((long*)(buffer + arr_size + 24)));
        printf("\nRetry? (Y/N) If you have already overwritten CHANGEME, please enter 'N'.\nYour Choice: ");
        //newline handling
        char buf[10];
        fgets(buf, 10, stdin);
        char again;
        sscanf(buf, "%c", &again);
        if (again == 'N')
            break;
    }
    if (CHANGEME == 0xdeadbeef) {
        printf("You didn't overwrite CHANGEME! Try again!\n");
        exit(-1);
    }
    else {
        printf("You overwrote CHANGEME! Here's a shell for you!\n");
        win();
    }
}

void win() {
    system("/bin/sh");
}

void timeout(int signum) {
    printf("Timeout!");
    exit(-1);
}

void setup() {
    setvbuf(stdin, NULL, _IONBF, 0);
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stderr, NULL, _IONBF, 0);
    signal(SIGALRM, timeout);
    alarm(180);
}

int main() { 
    setup();
    printf("=== Buffer Overflow School ===\n");
    printf("Enter your input in, and it'll print it back in hexdump format.\n");
    printf("A buffer overflow is when you write more data than the buffer can hold.\n");
    printf("In such a case, the data will overflow and overwrite other variables in memory\n");
    printf("\nIn this challenge, you will need to overwrite the value of CHANGEME to win the challenge.\n");
    printf("Note, CHANGEME is initialised to 0xdeadbeef, and you will need to overwrite it with a different value.\n");
    vuln();
    return 0;
}