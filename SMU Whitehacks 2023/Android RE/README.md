# Android RE

## Learning Objective

This challenge teaches particpants:
- Android RE
- JNI Functions

## Notes

- This is intended to be a medium challenge

## Public Description

Medium Android RE (and some JNI)

- If this is your first time, consider using decompilers like [JADX](https://github.com/skylot/jadx)
- The password is the flag. 

## Setup Guide

Release `android-re.apk`

## Flag

`WH2023{owo_JNI_functions_eec053}`

## Solution

Using JADX or equivalent decompilers,
1) Location login function
`com.example.LoginApp2`
2) Reverse password check function to get password (which is the flag)
```java
 private Boolean login(String username, String password) {
        if (getSHA256(username) == null || !getSHA256(username).equals(this.usernameHash)) {
            return false;
        }
        NativeLib nativeLib = new NativeLib();
        Boolean correct = Boolean.valueOf(nativeLib.checkPassword(password));
        return correct;
    }
```
- Notice that username is compared against SHA256. Using crackstation or otherwise, determine that username is `adminpassword`
- Notice password is checked with a function in `NativeLib` which calls a JNI (Java Native Interface) Function

3) Reversing JNI Function (can be found in `/lib/x86_64/libnativelib.so`)
- Note, APKs can be opened with a zip file manager
- Decompiling with IDA or otherwise, notice function `Java_com_example_nativelib_NativeLib_checkPassword` which was referenced in `NativeLib`
```c
if ( __strlen_chk(v7, -1LL) == 32 )
  {
    sub_20070(v9, v10, 0LL, 6LL);
    v6 = 1;
    v5 = 0;
    if ( (sub_1FFD0(v9, "WH2023") & 1) != 0 )
      v5 = v7[31] == '}';
  }
  if ( (v6 & 1) != 0 )
    std::string::~string(v9);
  if ( v5
    && v7[7] == v7[9]
    && v7[10] == v7[14]
    && v7[14] == v7[24]
    && v7[8] == 'w'
    && v7[7] + v7[8] + v7[9] == 341
    && v7[11] == 'J'
    && v7[12] == 'N'
    && v7[13] == 'I'
    && v7[14] == '_'
    && v7[15] == 'f'
    && v7[16] == 'u'
    && v7[17] == 'n'
    && v7[18] == 'c'
    && v7[19] == 't'
    && v7[20] == 'i'
    && v7[21] == 'o'
    && v7[22] == 'n'
    && v7[23] == 's'
    && v7[25] == v7[26]
    && v7[26] + v7[25] == 202
    && v7[27] == 'c'
    && v7[28] == '0'
    && v7[29] == '5'
    && v7[30] == '3' )
  {
    v8 = 1;
  }
```
- At this point, it should be quite easy for participants to reverse engineer the password. 

## Author
Sean (beanbeah)

