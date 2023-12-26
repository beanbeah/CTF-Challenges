# Giga-Chad-Compiler

## Learning Objective

This challenge teaches particpants:

## Notes

- This is intended to be a hard challenge

## Public Description

Recently, I came across this bot called "Compiler" on Discord that can compile any source code you send it.
But honestly, kids these days have it too easy. So I made Giga-Chad-Compiler (GCC) where only C is allowed. 
Let's be honest, who needs Rust when you have C. 

Btw, to keep Giga-Chad-Compiler secure, all user code submissions are run in a docker container with NO Internet access.
The flag is stored at `/root/flag.txt`

PS, the bot only responds in DMs with slash commands (`/compile`)

## Setup Guide

Run EC2 with following configuration:

Ubuntu 18.04 LTS
Instance type: t2.micro
Network settings: Default
Storage: 30GB

Copy `setup.sh` and `main.py` to `/home/ubuntu`

Then run the following commands in EC2:
`cd /home/ubuntu`
`chmod +x ./setup.sh`
`sudo setup.sh`

When running `setup.sh`, it may prompt for input. Press `y` to proceed.
After setup is successful, the line `Setup complete!` should be printed.

Bot invite: <https://discord.com/api/oauth2/authorize?client_id=1082616098366701658&permissions=0&scope=bot>

To restart the service (make sure `/home/ubuntu/main.py` is recreated first):
`sudo systemctl stop main.service && /home/ubuntu/setup.sh`

## Flag

`WH2023{g1gaChAds_wr1t3_c0d3_1n_ASM_n0t_C}`

## Solution

Using `/compile`, send code to 
1. Check for permissions with capsh
2. check for mounts 
3. run `shocker.c` and edit it to retrieve `/root/flag.txt`

## Author
Sean (beanbeah)
samuzora
