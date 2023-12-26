# DNS

## Learning Objective

This challenge teaches particpants:
- DNS tunnels

## Notes

- This is intended to be a hard challenge

## Public Description

There once was a thing called DNS,
a painful, horrible thing to address.
But in a competition,
filled with lots of ambition,
am I the only one with no progress?

## Setup Guide

Release `capture.pcap`

## Flag

`WH2023{dns_tunnels_arent_really_that_hard_as_they_seem_to_be}`

## Solution

1) Inspect `capture.pcap` and notice a few things:
    - "VACK" in DNS Response (Packet 6)
    - Null type records
2) With google, or otherwise, notice that Iodine DNS Tunnel is used. 
    - [Helpful SANS Whitepaper on DNS Tunneling and detecting them](https://www.sans.org/white-papers/34152/)
3) With a bit more google, participants should be able to find scripts online to decode an Iodine DNS Tunnel.
4) Once decoded, follow HTTP Packets to get Flag. 

The solve script can be located in `Solve/`

## Author
Sean (beanbeah)
Samuel (@sc_zze)
