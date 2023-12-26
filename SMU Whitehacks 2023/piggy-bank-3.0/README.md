# Piggy Bank 3.0

## Learning Objective

This challenge teaches particpants:
- Src Code Review
- Haskell Logic Bugs

## Notes
- This is intended to be a medium/hard challenge
- Source Code should be released 
- Participants may find it easier to solve this by using a debugger like GDB to debug the binary. They would then notice functions like `strlen` perform similar to their respective C functions. 

## Public Description

We're back with a new and updated Piggy Bank from Whitehacks 2021. This time, I'm literally using haskell, which chatGPT tells me is a "memory safe" language. So anyways, that means I'm super secure right...

## Setup Guide
```
docker build -t haskell .
docker run -p 8003:8003 haskell
```

Note, the challenge has been containerised using Xinetd. 
Only distribute `distrib.zip`

## Flag

`WH2023{Ungu3ssable_Str1ng}`

## Solution
1) notice strlen is insecure and reads up till a null byte
    - As such, we can send `"-9" + "\x00" + "99999"` to trick the program into reading `-999999`
2) notice that negative numbers are not checked

General Exploit Idea
1) Deposit a negative amount of money
2) Buy Flag

Full Solution is in `xpl.py`

## Author
Sean (beanbeah)