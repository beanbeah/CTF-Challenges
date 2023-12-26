'''
flag	.text	0000000000067378	00000251	00000008
void __cdecl flag()
{
  __int64 v0; // r14
  __int64 ArrayStub; // rax
  __int64 v2; // rax
  __int64 savedregs; // [rsp+0h] [rbp+0h] BYREF

  if ( (unsigned __int64)&savedregs <= *(_QWORD *)(v0 + 64) )
    (*(void (**)(void))(v0 + 568))();
  ArrayStub = Precompiled_Stub__iso_stub_AllocateArrayStub();
  *(_QWORD *)(ArrayStub + 23) = 62LL;
  *(_QWORD *)(ArrayStub + 31) = 246LL;
  *(_QWORD *)(ArrayStub + 39) = 0LL;
  *(_QWORD *)(ArrayStub + 47) = 2LL;
  *(_QWORD *)(ArrayStub + 55) = 10LL;
  *(_QWORD *)(ArrayStub + 63) = 154LL;
  *(_QWORD *)(ArrayStub + 71) = 62LL;
  *(_QWORD *)(ArrayStub + 79) = 162LL;
  *(_QWORD *)(ArrayStub + 87) = 188LL;
  *(_QWORD *)(ArrayStub + 95) = 36LL;
  *(_QWORD *)(ArrayStub + 103) = 88LL;
  *(_QWORD *)(ArrayStub + 111) = 76LL;
  *(_QWORD *)(ArrayStub + 119) = 154LL;
  *(_QWORD *)(ArrayStub + 127) = 194LL;
  *(_QWORD *)(ArrayStub + 135) = 192LL;
  *(_QWORD *)(ArrayStub + 143) = 154LL;
  *(_QWORD *)(ArrayStub + 151) = 120LL;
  *(_QWORD *)(ArrayStub + 159) = 244LL;
  *(_QWORD *)(ArrayStub + 167) = 162LL;
  *(_QWORD *)(ArrayStub + 175) = 174LL;
  *(_QWORD *)(ArrayStub + 183) = 168LL;
  *(_QWORD *)(ArrayStub + 191) = 172LL;
  *(_QWORD *)(ArrayStub + 199) = 150LL;
  *(_QWORD *)(ArrayStub + 207) = 146LL;
  *(_QWORD *)(ArrayStub + 215) = 232LL;
  *(_QWORD *)(ArrayStub + 223) = 78LL;
  *(_QWORD *)(ArrayStub + 231) = 42LL;
  *(_QWORD *)(ArrayStub + 239) = 34LL;
  *(_QWORD *)(ArrayStub + 247) = 78LL;
  *(_QWORD *)(ArrayStub + 255) = 230LL;
  *(_QWORD *)(ArrayStub + 263) = 224LL;
  *(_QWORD *)(ArrayStub + 271) = 70LL;
  *(_QWORD *)(ArrayStub + 279) = 68LL;
  *(_QWORD *)(ArrayStub + 287) = 92LL;
  *(_QWORD *)(ArrayStub + 295) = 112LL;
  *(_QWORD *)(ArrayStub + 303) = 16LL;
  *(_QWORD *)(ArrayStub + 311) = 24LL;
  *(_QWORD *)(ArrayStub + 319) = 102LL;
  *(_QWORD *)(ArrayStub + 327) = 92LL;
  *(_QWORD *)(ArrayStub + 335) = 116LL;
  *(_QWORD *)(ArrayStub + 343) = 6LL;
  *(_QWORD *)(ArrayStub + 351) = 32LL;
  *(_QWORD *)(ArrayStub + 359) = 70LL;
  *(_QWORD *)(ArrayStub + 367) = 108LL;
  *(_QWORD *)(ArrayStub + 375) = 2LL;
  *(_QWORD *)(ArrayStub + 383) = 62LL;
  *(_QWORD *)(ArrayStub + 391) = 230LL;
  *(_QWORD *)(ArrayStub + 399) = 218LL;
  *(_QWORD *)(ArrayStub + 407) = 226LL;
  *(_QWORD *)(ArrayStub + 415) = 254LL;
  *(_QWORD *)(ArrayStub + 423) = 48LL;
  new__GrowableList__withData();
  *(_QWORD *)(v2 + 15) = 102LL;
}
'''

#Note that the above array stores integers as SMI, that is 63-bit integers

original = [62, 246, 0, 2, 10, 154, 62, 162, 188, 36, 88, 76, 154, 194, 192, 154, 120, 244, 162, 174, 168, 172, 150, 146, 232, 78, 42, 34, 78, 230, 224, 70, 68, 92, 112, 16, 24, 102, 92, 116, 6, 32, 70, 108, 2, 62, 230, 218, 226, 254, 48]
converted = [(i//2) for i in original]

'''
for (int i = 0; i < output.length; i++) {
    output[i] = output[i] ^ i;
  }
'''
tmp = []
for i in range(len(converted)):
    tmp.append(converted[i] ^ i)

'''
for (int i = 0; i < input.length; i++) {
    output.add(input[i] ^ input[(i + 1) % input.length]);
  }
'''
flag = []
for i in range(len(tmp)-1, -1, -1):
    if i == len(tmp)-1:
        flag.append(125)
    else:
        flag.append(tmp[i] ^ flag[-1])

flag = flag[::-1]
flag = [chr(i) for i in flag]
print(''.join(flag))
