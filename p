 Ex 1 - Parent Child Communication using Pipe
#include<stdio.h>
#include<sys/types.h>
#include<unistd.h>
int main()
{
int p[2];
int pid;
char inbuf[10],outbuf[10];
pipe(p); //To send message between parent and child //
pid=fork(); // Fork call to create child process //
if(pid) //// Code of Parent process
{
printf("In parent process\n");
printf("type the data to be sent to child");
scanf("%s",outbuf); // Writing a message into the pipe
write (p[1],outbuf, sizeof(outbuf)); //p[1] indicates write
sleep(2); // To allow the child to run
printf("after sleep in parent process\n");
}
else // Coding of child process //
{
sleep(2);
printf("In child process\n");
read(p[0],inbuf,10); // Read the message written by parent
printf("the data received by the child is %s\n",inbuf);
}
return 0;
}
 
 
Ex 2A - Interprocess Communication using Shared
Memory
#include <iostream>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
using namespace std;
int main()
{ // ftok to generate unique key
key_t key = ftok("shmfile",65);
// shmget creates shared memory and returns an identifier in shmid
int shmid = shmget(key,1024,0666|IPC_CREAT);
// shmat to attach to shared memory
char *str = (char*) shmat(shmid,(void*)0,0);
cout<<"Write Data : ";
gets(str);
printf("Data written in memory: %s\n",str);
//detach from shared memory
shmdt(str);
return 0;
}
shm_client.c
#include <iostream>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
using namespace std;
int main()
{
// ftok to generate same key of the server
key_t key = ftok("shmfile",65);
// shmget returns an identifier in shmid
int shmid = shmget(key,1024,0666|IPC_CREAT);
// shmat to attach to shared memory
char *str = (char*) shmat(shmid,(void*)0,0);
printf("Data read from memory: %s\n",str);
//detach from shared memory
shmdt(str);
// destroy the shared memory
shmctl(shmid,IPC_RMID,NULL);
return 0;
}

Ex 2B - Interprocess Communication using Message
Queue
// Program for Message Queue (Sender Process)
#include <stdio.h>
#include <sys/ipc.h>
#include <sys/msg.h>
// structure for message queue
struct msg_queue
{
long mesg_type;
char mesg_text[100];
} message;
int main()
{
key_t key;
int msgid;
// ftok to generate unique key
key = ftok("progfile", 65);

// msgget creates a message queue and returns identifier
msgid = msgget(key, 0666 | IPC_CREAT);
printf(“Enter the message type:”);
scanf(“%d”,&message.mesg_type);
printf(“Enter the message:”);
gets(message.mesg_text);
// msgsnd to send message
msgsnd(msgid, &message, sizeof(message), 0);
printf("Data sent successfully”);
return 0;
}
//Sample message and type: Nokia 1
// Program for Message Queue (Receiver Process)
#include <stdio.h>
#include <sys/ipc.h>
#include <sys/msg.h>
struct msg_queue
{
long type;
char mesg_text[100];
}message;
long int x;
int i=1;
int main()
{
key_t key;
int msgid;
// ftok to generate the same key as the sender
key = ftok("progfile", 65);
msgid = msgget(key, 0666 | IPC_CREAT);
printf("Enter the type:");
scanf("%ld",&buf.type);
msgrcv(msgqid, &message, sizeof(message.mesg_text),message.type, 0);
printf("Message associated with type %d is %s",buf.type, message.mesg_text);
}
 
--------------------------------------------------------------------------------------------------------------------
EXP-11(A)(PAGE REPLACEMENT):
#include <stdio.h>
 
void FIFO(int pages[], int n, int no_of_frames) {
   int frames[no_of_frames], page_faults = 0, index = 0;
   printf("\nFIFO Page Replacement\n");
 
   for (int i = 0; i < no_of_frames; i++) frames[i] = -1;  // Initialize frames
 
   for (int i = 0; i < n; i++) {
       int flag = 0;
 
       // Check if page is already in frame
       for (int j = 0; j < no_of_frames; j++) {
           if (frames[j] == pages[i]) {
               flag = 1;  // Page hit
               break;
           }
       }
 
       if (!flag) {  // Page fault
           frames[index] = pages[i];
           index = (index + 1) % no_of_frames;  // Circular queue
           page_faults++;
           printf("Page %d caused a page fault.\n", pages[i]);
       }
   }
 
   printf("Total Page Faults: %d\n", page_faults);
}
 
void LRU(int pages[], int n, int no_of_frames) {
   int frames[no_of_frames], time[no_of_frames], page_faults = 0;
 
   printf("\nLRU Page Replacement\n");
   for (int i = 0; i < no_of_frames; i++) {
       frames[i] = -1;  // Initialize frames
       time[i] = -1;    // Time tracking for LRU
   }
 
   for (int i = 0; i < n; i++) {
       int flag = 0, least_recent = 0;
 
       // Check if page is already in frame
       for (int j = 0; j < no_of_frames; j++) {
           if (frames[j] == pages[i]) {
               flag = 1;
               time[j] = i;  // Update time for the page hit
               break;
           }
       }
 
       if (!flag) {  // Page fault
           // Find the least recently used page
           for (int j = 0; j < no_of_frames; j++) {
               if (time[j] < time[least_recent]) least_recent = j;
           }
 
           frames[least_recent] = pages[i];  // Replace page
           time[least_recent] = i;  // Update time of replacement
           page_faults++;
           printf("Page %d caused a page fault.\n", pages[i]);
       }
   }
 
   printf("Total Page Faults: %d\n", page_faults);
}
 
void Optimal(int pages[], int n, int no_of_frames) {
   int frames[no_of_frames], page_faults = 0;
 
   printf("\nOptimal Page Replacement\n");
   for (int i = 0; i < no_of_frames; i++) frames[i] = -1;  // Initialize frames
 
   for (int i = 0; i < n; i++) {
       int flag = 0;
 
       // Check if page is already in frame
       for (int j = 0; j < no_of_frames; j++) {
           if (frames[j] == pages[i]) {
               flag = 1;  // Page hit
               break;
           }
       }
 
       if (!flag) {  // Page fault
           int replace_index = -1, farthest = i + 1;
 
           // Find the page that won't be used for the longest time in future
           for (int j = 0; j < no_of_frames; j++) {
               int k;
               for (k = i + 1; k < n; k++) {
                   if (frames[j] == pages[k]) {
                       if (k > farthest) {
                           farthest = k;
                           replace_index = j;
                       }
                       break;
                   }
               }
 
               // If page is not found in future, replace it
               if (k == n) {
                   replace_index = j;
                   break;
               }
           }
 
           if (replace_index == -1) {
               for (int j = 0; j < no_of_frames; j++) {
                   if (frames[j] == -1) {
                       replace_index = j;
                       break;
                   }
               }
           }
 
           frames[replace_index] = pages[i];  // Replace page
           page_faults++;
           printf("Page %d caused a page fault.\n", pages[i]);
       }
   }
 
   printf("Total Page Faults: %d\n", page_faults);
}
 
int main() {
   int no_of_frames = 3;  // You can change the number of frames as needed
   int pages[] = {2, -1, -1, 2, 3, -1, 2, 3, -1, 2, 3, 1, 5, 3, 1, 3, 2, 4, 3, 2, 4, 3, 5, 4, 3, 5, 2};
   int no_of_pages = sizeof(pages) / sizeof(pages[0]);
 
   printf("Number of frames: %d\n", no_of_frames);
   printf("Page sequence: ");
   for (int i = 0; i < no_of_pages; i++) {
       if (pages[i] != -1) {
           printf("%d ", pages[i]);
       }
   }
   printf("\n");
 
   FIFO(pages, no_of_pages, no_of_frames);
   LRU(pages, no_of_pages, no_of_frames);
   Optimal(pages, no_of_pages, no_of_frames);
 
   return 0;
}
--------------------------------------------------------------------------------------------------
//parent and child using shared memory
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>    // For fork() and sleep()
#include <sys/ipc.h>   // For IPC_CREAT
#include <sys/shm.h>   // For shmget, shmat, shmdt, shmctl
#include <string.h>    // For strcpy and strlen
#include <sys/wait.h>  // For wait()

int main() {
    // Generate a unique key for the shared memory segment
    key_t key = ftok("shmfile", 65);

    // Create a shared memory segment
    int shmid = shmget(key, 1024, 0666 | IPC_CREAT);

    // Fork the process to create parent and child
    pid_t pid = fork();

    if (pid < 0) {
        // Fork failed
        perror("fork failed");
        return 1;
    } else if (pid > 0) {
        // Parent process
       char *str = (char *)shmat(shmid, NULL, 0);
       printf("Parent: Write Data: ");
        scanf("%s",&str);
        // Detach from shared memory
        shmdt(str);

        // Wait for the child to complete
        wait(NULL);

        // Destroy the shared memory after child has finished reading
        shmctl(shmid, IPC_RMID, NULL);
    } else {
        // Child process
        sleep(3); // Sleep to ensure parent writes first

        char *str = (char *)shmat(shmid, NULL, 0);
        printf("Child: Data read from memory: %s\n", str);

        // Detach from shared memory
        shmdt(str);
    }

    return 0;
}
-------------------------------------------------------------------------------------------------
//bidirectional pipe
#include<stdio.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/wait.h>
#include<string.h>
int main()
{
    int fd1[2],fd2[2];
    pid_t p1;
    pipe(fd1);
    pipe(fd2);
    p1=fork();
    char a[10],b[10];
    if(p1==0)
    {
       read(fd1[0],a,strlen(a)+1);
        close(fd1[0]);
        printf("Data read from parent: %s\n", a);
        
        
        printf("enter string in child:");
        scanf("%s",b);
        
        write(fd2[1],b,strlen(b)+1);
        close(fd2[1]);
    }
    else
    {
        printf("enter string in parent :");
        scanf("%s",a);
        write(fd1[1],a,strlen(a)+1);
        close(fd1[1]);
        wait(NULL);
        read(fd2[0],b,strlen(b)+1);
        printf("Data read from child: %s\n", b);
    }
}

