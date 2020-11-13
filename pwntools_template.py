#!/usr/bin/env python3
from pwn import *

# https://fascinating-confusion.io/posts/2020/11/csr20-howtoheap-writeup/

#convenience Functions
convert = lambda x                  :x if type(x)==bytes else str(x).encode()
s       = lambda data               :io.send(convert(data))
sl      = lambda data               :io.sendline(convert(data))
sla     = lambda delim,data         :io.sendlineafter(convert(delim), convert(data), timeout=context.timeout)
ru      = lambda delims, drop=True  :io.recvuntil(delims, drop, timeout=context.timeout)
uu32    = lambda data               :u32(data.ljust(4, b'\x00'))
uu64    = lambda data               :u64(data.ljust(8, b'\x00'))

# Exploit configs
binary = ELF('howtoheap')
host = 'chal.cybersecurityrumble.de'
port = 8263
local_libc = ELF('/usr/lib/x86_64-linux-gnu/libc-2.31.so', checksec=False)
remote_libc = ELF('./libc-2.32.so', checksec=False)
ld = ELF('./ld-2.32.so', checksec=False)

def launch_gdb(breakpoints=[], cmds=[]):
    if args.NOPTRACE:
        return
    info("Attaching Debugger")
    cmds.append('handle SIGALRM ignore')
    for b in breakpoints:
        cmds.insert(0,'b *' + str(binary.address + b))
    gdb.attach(io, gdbscript='\n'.join(cmds))

def add(idx, size):
    sl(1)
    sla(': ', idx)
    sla(': ', size)
    return ru('>')

def remove(idx):
    sl(2)
    sla(': ', idx)
    return ru('>')

def show(idx,size):
    sl(3)
    sla(': ', idx)
    sla(': ', size)
    return ru('>')

def write(idx, size, data):
    sl(4)
    sla(': ', idx)
    sla(': ', size)
    s(data)
    return ru('>')

if __name__ == '__main__':
    # call with DEBUG to change log level
    # call with NOPTRACE to skip gdb attach
    # call with REMOTE to run against live target
    one_gadget = [0xcda5a, 0xcda5d, 0xcda60]
    if args.REMOTE:
        args.NOPTRACE = True # disable gdb when working remote
        io = remote(host, port)
        libc = remote_libc
    else:
        io = process([ld.path, binary.path], env={'LD_PRELOAD': remote_libc.path})
        libc = remote_libc
    if not args.REMOTE:
        for mmap in open('/proc/{}/maps'.format(io.pid),"rb").readlines():
            mmap = mmap.decode()
            if binary.path.split('/')[-1] == mmap.split('/')[-1][:-1]:
                binary.address = int(mmap.split('-')[0],16)
                break

    io.interactive()