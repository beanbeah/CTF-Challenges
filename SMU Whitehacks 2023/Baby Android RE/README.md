# Baby Android RE

## Learning Objective

This challenge teaches particpants:
- Basic Android RE

## Notes

- This is intended to be an easy challenge

## Public Description

Simple, baby, easy, Android RE for all. 

- If this is your first time, consider using decompilers like [JADX](https://github.com/skylot/jadx)
- The password is the flag. 

## Setup Guide

Release `baby-android-re.apk`

## Flag

`WH2023{b4by_andr0id_r3v3r5ing}`

## Solution

Using JADX or equivalent decompilers,
1) Location login function
`com.example.loginapp1`
2) Reverse password check function to get password (which is the flag)
```java
private Boolean login(String username, String password) {
        if (!username.equals("admin123") || password.length() != 30 || !password.startsWith("WH2023{") || !password.endsWith("}") || password.charAt(7) != "b".charAt(0) || password.charAt(8) != "4".charAt(0) || password.charAt(9) != "b".charAt(0) || password.charAt(10) != "y".charAt(0) || password.charAt(11) != "_".charAt(0) || password.charAt(12) != "a".charAt(0) || password.charAt(13) != "n".charAt(0) || password.charAt(14) != "d".charAt(0) || password.charAt(15) != "r".charAt(0) || password.charAt(16) != "0".charAt(0) || password.charAt(17) != "i".charAt(0) || password.charAt(18) != "d".charAt(0) || password.charAt(19) != "_".charAt(0) || password.charAt(20) != "r".charAt(0) || password.charAt(21) != "3".charAt(0) || password.charAt(22) != "v".charAt(0) || password.charAt(23) != "3".charAt(0) || password.charAt(24) != "r".charAt(0) || password.charAt(25) != "5".charAt(0) || password.charAt(26) != "i".charAt(0) || password.charAt(27) != "n".charAt(0) || password.charAt(28) != "g".charAt(0)) {
            return false;
        }
        return true;
    }
```
## Author
Sean (beanbeah)

