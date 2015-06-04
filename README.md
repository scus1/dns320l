# Linux on D-Link DNS-320L

Install cross compiler toolchain
--------------------------------

* [Debian Jessie][deb-cross]
    ```bash
    $ cat - <<EOF | sudo tee /etc/apt/sources.list.d/crosstools.list 
    deb http://emdebian.org/tools/debian/ jessie main
    EOF
    $ curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | sudo apt-key add -
    $ sudo dpkg --add-architecture armel
    $ sudo apt-get update
    $ sudo apt-get install crossbuild-essential-armel
    ```

* Ubuntu 14.04
    ```bash
    $ sudo apt-get install gcc-arm-linux-gnueabi
    ```

[deb-cross]: https://wiki.debian.org/CrossToolchains#Installation

Building the kernel
-------------------

```bash
$ cd kernel/
$ wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.XX.XX.tar.xz
$ tar xzJ linux-3.XX.XX.tar.xz
$ cd linux-3.XX.XX/
$ sh ../configure.sh
$ sh ../build.sh
$ sh ../install.sh
```

MCU
------------
TODO


Tested with
-----------
**Works with**
* **3.16** https://github.com/torvalds/linux/archive/v3.16.tar.gz
**Doesn't work**
* **4.0.**
    ```
     ** MARVELL BOARD: DB-88F6702A-BP LE 
    
    U-Boot 1.1.4 (Apr 19 2012 - 11:21:19) Marvell version: 3.6.0.DNS-320B.01
    
    U-Boot code: 00600000 -> 0067FFF0  BSS: -> 006CFB00
    
    Soc: 88F6702 A1 CPU running @ 1000Mhz L2 running @ 500Mhz
    SysClock = 400Mhz , TClock = 166Mhz 
    
    DRAM (DDR2) CAS Latency = 5 tRP = 5 tRAS = 18 tRCD=6
    DRAM CS[0] base 0x00000000   size 128MB 
    DRAM Total size 128MB  16bit width
    Addresses 8M - 0M are saved for the U-Boot usage.
    Mem malloc Initialization (8M - 7M): Done
    NAND:128 MB
    Flash:  0 kB
    
    CPU : Marvell Feroceon (Rev 1)
    
    Streaming disabled 
    Write allocate disabled
    
    
    USB 0: host mode
    PEX 0: interface detected no Link.
    Net:   egiga0 [PRIME]
    Hit any key to stop autoboot:  1  0 
    Marvell>> run bootusb
    (Re)start USB...
    USB:   scanning bus for devices... 2 USB Device(s) found
    Waiting for storage device(s) to settle before scanning...
    1 Storage Device(s) found
    ....
    .
    ...................
    .........................
    ...................................................
    ...........................................................................................................................................................................
    
    2805702 bytes read
    ## Booting image at 00a00000 ...
       Image Name:   Linux-4.0.4-dns320l
       Created:      2015-06-04  16:29:20 UTC
       Image Type:   ARM Linux Kernel Image (uncompressed)
       Data Size:    2805638 Bytes =  2.7 MB
       Load Address: 00008000
       Entry Point:  00008000
       Verifying Checksum ... OK
    OK
    
    Starting kernel ...
    
    software interrupt
    pc : [<0000cab8>]	   lr : [<0000bd1c>]
    sp : 002b0380  ip : 0029f0e4	 fp : 0029f0b8
    r10: 002b8508  r9 : 007b18d0	 r8 : 00008000
    r7 : 862c0000  r6 : 002a70e8	 r5 : 002a70e8  r4 : 002a70e8
    r3 : edfe0dd0  r2 : d00dfeed	 r1 : 002a70e8  r0 : deadbeef
    Flags: nZCv  IRQs off  FIQs off  Mode SVC_32
    Resetting CPU ...
    ```
* **3.18.14**
    ```
    ** MARVELL BOARD: DB-88F6702A-BP LE 
    
    U-Boot 1.1.4 (Apr 19 2012 - 11:21:19) Marvell version: 3.6.0.DNS-320B.01
    
    U-Boot code: 00600000 -> 0067FFF0  BSS: -> 006CFB00
    
    Soc: 88F6702 A1 CPU running @ 1000Mhz L2 running @ 500Mhz
    SysClock = 400Mhz , TClock = 166Mhz 
    
    DRAM (DDR2) CAS Latency = 5 tRP = 5 tRAS = 18 tRCD=6
    DRAM CS[0] base 0x00000000   size 128MB 
    DRAM Total size 128MB  16bit width
    Addresses 8M - 0M are saved for the U-Boot usage.
    Mem malloc Initialization (8M - 7M): Done
    NAND:128 MB
    Flash:  0 kB
    
    CPU : Marvell Feroceon (Rev 1)
    
    Streaming disabled 
    Write allocate disabled
    
    
    USB 0: host mode
    PEX 0: interface detected no Link.
    Net:   egiga0 [PRIME]
    Hit any key to stop autoboot:  1  0 
    Marvell>> run usbboot
    ## Error: "usbboot" not defined
    Marvell>> bootusbrun 
    Unknown command 'bootusbrun' - try 'help'
    Marvell>> run bootusb
    (Re)start USB...
    USB:   scanning bus for devices... 2 USB Device(s) found
    Waiting for storage device(s) to settle before scanning...
    1 Storage Device(s) found
    ....
    .
    ...................
    .........................
    ...................................................
    .....................................................................................................................................................................
    
    2739446 bytes read
    ## Booting image at 00a00000 ...
    Image Name:   Linux-3.18.14-dns320l
    Created:      2015-06-04  16:42:17 UTC
    Image Type:   ARM Linux Kernel Image (uncompressed)
    Data Size:    2739382 Bytes =  2.6 MB
    Load Address: 00008000
    Entry Point:  00008000
    Verifying Checksum ... OK
    OK
    
    Starting kernel ...
    
    software interrupt
    pc : [<0000ca78>]	   lr : [<0000bcdc>]
    sp : 002b32c8  ip : 0029a02c	 fp : 0029a000
    r10: 002b3450  r9 : 00794b30	 r8 : 00011408
    r7 : 862c0000  r6 : 002a2030	 r5 : 002a2030  r4 : 002a2030
    r3 : edfe0dd0  r2 : d00dfeed	 r1 : 002a2030  r0 : deadbeef
    Flags: nZCv  IRQs off  FIQs off  Mode SVC_32
    Resetting CPU ...
    ```


References
----------
* [Linux on the D-Link DNS-320L][boe]
* [Debian @ Dlink DNS-327L: The guide][nec]
* [Debian Linux on the D-Link DNS-320 & DNS-325 NAS][len]


[nec]: http://ncrmnt.org/wp/2015/02/15/debian-dlink-dns-327l-the-guide/
[boe]: http://www.aboehler.at/doku/doku.php/projects:dns320l
[len]: http://jamie.lentin.co.uk/devices/dlink-dns325/
