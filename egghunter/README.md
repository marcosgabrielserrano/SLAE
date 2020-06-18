

Run make from this directory.

The binary will be "bin/egghunter"

TO CHANGE THE SHELLCODE:

change TEST_IN := src/print.nasm
to TEST_IN := <shellcode_you_desire>

HOWEVER: shellcode assembly must be prepended with the egg "AAAAAAAA"
This can be prepended to your shellcode by adding

EGG db "AAAAAAAA"

before the any other instruction in your shellcode
