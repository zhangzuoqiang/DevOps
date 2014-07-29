#!/usr/bin/env python
def disk_stat():
    import os
    hd={}
    disk = os.statvfs("/")
    hd['available'] = disk.f_bsize * disk.f_bavail/(1024*1024*1024)
    hd['capacity'] = disk.f_bsize * disk.f_blocks/(1024*1024*1024)
    hd['used'] = disk.f_bsize * disk.f_bfree/(1024*1024*1024)
    return hd

print disk_stat()    