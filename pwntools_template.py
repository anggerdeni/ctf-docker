from pwn import *
from sys import argv
context.update(arch='amd64', os='linux', terminal=['tmux','splitw','-h'])

convert = lambda x                  :x if type(x)==bytes else str(x).encode()
s       = lambda data               :io.send(convert(data))
sl      = lambda data               :io.sendline(convert(data))
sla     = lambda delim,data         :io.sendlineafter(convert(delim), convert(data), timeout=context.timeout)
ru      = lambda delims, drop=True  :io.recvuntil(delims, drop, timeout=context.timeout)
uu32    = lambda data               :u32(data.ljust(4, b'\x00'))
uu64    = lambda data               :u64(data.ljust(8, b'\x00'))

CHAL_PATH=''
BINARY=ELF(CHAL_PATH)
REMOTE_IP=''
PORT=22223
LD_PRELOAD=null
LD=null
GDB_CMD=['handle SIGALRM ignore']

breakpoints = []

for i in breakpoints:
    GDB_CMD.insert(0, 'b *'.format(i))

def __main__():
    if('local' in argv):
        if(LD_PRELOAD && ld):
            p = process([LD.path, BINARY.path], env={"LD_PRELOAD":"../libc-2.27.so"})
        elif(LD_PRELOAD):
            p = process(BINARY.path, env={"LD_PRELOAD":"../libc-2.27.so"})

        if('gdb' in argv):
            gdb.attach(p, '\n'.join(GDB_CMD))

        if('showmem' in argv):
            for mmap in open('/proc/{}/maps'.format(p.pid),"rb").readlines():
                mmap = mmap.decode()
                if binary.path.split('/')[-1] == mmap.split('/')[-1][:-1]:
                    binary.address = int(mmap.split('-')[0],16)
                    break
    else:
        p = remote(REMOTE_IP, PORT)

    # YOUR CODE HERE


    # SHELL
    p.interactive()

__main__()