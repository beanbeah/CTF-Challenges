# Baby RE

## Learning Objective

This challenge teaches particpants:
- Dart RE
- Dart SMI Representation

## Notes

- This is intended to be a hard challenge

## Public Description

"Pain is just weakness going away" ~ Sun Tzu 

## Setup Guide

Release `distrib.zip`

## Flag

`WH2023{b4by_r3_1s_4w3s0m3_and_1_cant_wait_for_m0r3}`

## Solution

[Note, Dart stores SMI (small integers) in 63 bit form. Thus they appear "doubled"](https://dart.dev/articles/archive/numeric-computation#integers-1)

1) read `redacted-src.dart` to determine 2 for loops encrypting the flag
2) open `src.aot` in IDA or otherwise, find declaration of flag where values are hardcoded and stored in 63 bit form. 
3) reverse for loops and get flag

Soln script in `solve/solve.py`

```
## Author
Sean (beanbeah)

