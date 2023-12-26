#!/bin/sh

#check gcc exists, if not print error message and exit
if ! [ -x "$(command -v gcc)" ]; then
  echo 'Error: gcc is not installed.' >&2
  exit 1
fi

#get STDIN until EOF and store in variable
input=$(cat)

#write the input to a file
echo "$input" > /tmp/input.c

#compile code, have a timeout of 30 seconds, and store the output in a variable
output=$(timeout 30s sh -c "gcc /tmp/input.c -o /tmp/a.out 2>&1")

#check if the program timed out, if so print error message and exit
if [ $? -eq 124 ]; then
  echo 'Error: program timed out.' >&2
  exit 1
fi

#print the output if not empty
if [ -n "$output" ]; then
  echo "Output from GCC: $output"
fi

#check if the program exists, if not print error message and exit
if ! [ -x "/tmp/a.out" ]; then
  echo 'Error: program did not compile.' >&2
  exit 1
fi

#run the program, have a timeout of 30 seconds, and store the output in a variable
output=$(timeout 30s /tmp/a.out 2>&1)

#check if the program timed out, if so print error message and exit
if [ $? -eq 124 ]; then
  echo 'Error: program timed out.' >&2
  exit 1
fi

#print the output
echo "Output from program: $output"


