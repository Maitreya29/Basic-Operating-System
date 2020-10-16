global entry

MAGIC equ 0x1BADB002 
FLAGS equ 0
SUM equ -MAGIC


SYS_WRITE equ 4
SYS_READ  equ 3
STDOUT    equ 1
STDIN     equ 2
SYS_EXIT  equ 1
WRITESTART equ 0xB8000
 
section .data
         msg dd "                              BASIC OS 0.0.1                              " ; Title message
  len equ $ - msg ; Get length
  msg2 dd "BASIC OS is, as the name suggests, a very basic operating system currently under development. :)" ; Line 1
  len2 equ $ - msg2 ; Get length
  msg3 dd 'https://github.com/Maitreya29/' ; Line 2
  len3 equ $ - msg3 ; Get Length
  position dd 0 ; Required
  temp dd 0 ; Required
  templen dd 0 ; Required
  line dd 0 ; Required 

%macro printchar 2 ; The macro printchar will take 2 arguments
    mov eax, WRITESTART ; Set eax to the memory position of the start of text output
    mov ebx, [position] ; Now, we take the value of position and put it into ebx.
    add eax, ebx ; Now, we add ebx to eax to get the current memory position.
    mov ebx, %1 ; Now, we set ebx to the character we are printing.
    mov [eax], ebx ; And we set the given memory position to ebx to print the character.
    mov ecx, eax ; Now, we move eax to ecx for some more memory manipulation to set the color
    add ecx, 1 ; We increase ecx by 1 since we need to go to the next byte for the color data.
    mov edx, %2 ; Here, we set edx to the color we want.
    mov [ecx], edx ; And here we set the given memory position to edx to set the color.
    mov eax, [position] ; Lastly, these last 3 lines of the macro add 2 to the position variable.
    add eax, 2
    mov [position], eax
%endmacro

%macro clearscreen 1 ; The clearscreen macro takes 1 argument: the number of characters to clear.
    mov eax, %1 ; We move the number of characters to eax...
    mov [templen], eax ; ... and we use that to set templen.
    %%clearscreen: ; This label will be used for a loop.
    printchar ' ', 0 ; For each iteration of the loop, we print a space character with the default color, 0, to clear that character's position on the screen
    mov esi, [templen] ; Now, we need to move templen to esi...
    sub esi, 1 ; ..and subtract 1...
    mov [templen], esi ; ... and move that back to templen so we can decrement the variable.
    mov al, [templen] ; And now, we need to move templen to al so we can compare it.
    cmp al, 0 ; This checks if al (from templen) is 0.
    jne %%clearscreen ; If it is not 0, it iterates through the loop again. If it is 0, the macro ends.
%endmacro

%macro clearall 0
   clearscreen 4000
   clearscreen 4000
   clearscreen 4000
   clearscreen 4000
   clearscreen 4000
   clearscreen 4000
   clearscreen 4000
   clearscreen 4000
   clearscreen 4000
   clearscreen 4000
   clearscreen 4000
   clearscreen 4000
   clearscreen 4000
   clearscreen 4000
   clearscreen 4000
   clearscreen 4000
%endmacro

%macro printstr 3 ; This takes 3 arguments, the string, the length, and the color.
    mov eax, %1 ; These two lines move the string to temp.
    mov [temp], eax
    mov eax, %2 ; And these move the length to templen.
    mov [templen], eax
    %%printstart: ; This is the start of a loop.
    mov esi, [temp] ; Here, we get the current character...
    mov esi, [esi]
    printchar esi, %3 ; ... and print it with the given color.
    mov esi, [temp] ; Now, we increment temp so we can get to the next character
    add esi, 1
    mov [temp], esi
    mov esi, [templen] ; And we decrement templen...
    sub esi, 1
    mov [templen], esi
    mov al, [templen] ; ... and compare it to 0 to see if we need to go through another iteration of the loop.
    cmp al, 0
    jne %%printstart
%endmacro

%macro gotoline 1
    mov eax, %1 ; Move the line number to eax ...
    imul eax, 160 ; ... and multiply by 160 (characters per line) ... 
    mov [position], eax ; ... and set the position to that.
%endmacro


section .text:
align 4 
        dd MAGIC
        dd FLAGS
        dd SUM
entry:
   clearall ; Clear the screen
   mov eax, 0 ; Now, we need to reset the character position.
   mov [position], eax
   printstr msg, len, 0b00011010 ; Blue background, green text.
   gotoline 4 ; Go to line 4
   printstr msg2, len2, 10 ; Green text
   gotoline 6 ; Go to line 6
   printstr msg3, len3, 10 ; Green text
loop:
jmp loop ; For now we won't do anything but loop forever.