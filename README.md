# Lib-PSP-iplloader-Jump-Slide-POC
This is a proof of concept for the Lib-PSP iplloader arbitrary load address exploit which uses a jump slide to execute code in Lib-PSP iplloader context.

How it works: 

Lib-PSP iplloader does not check the arbitrary load address set in the IPL block header (see here: https://playstationdev.wiki/pspdevwiki/index.php?title=Vulnerabilities#Arbitrary_Load_Address )

Lib-PSP iplloader is composed of 2 parts, a loader, which runs at 0xbfc00000 and copies 0xbfc00280 and onwards to 0x80010000 (0xa0010000 uncached) and a payload which executed from 0x80010000, this happens because 0xbfc00000 (on retail systems) is rom and therefore read only.
 
Because Lib-PSP iplloader does not verify the load address, it is possible to set 0xa0010000 (or 0x80010000) as a load address and have the Lib-PSP iplloader code overwrite itself with the content of the decrypted IPL block. The memcpy function copies one dword at a time.

This Proof Of Concept has been successfully tested to work on the DTP-T1000 using the 3.5.0 version of Lib-PSP iplloader, it works by copying a payload at 0xa0010000, this payload copies 0xbfc00000 to 0xbfe50000, it is followed by a jump register slide, as Lib-PSP iplloader overwrites itself, it will eventually execute the jump register slide, which itself will jump back to 0xa0010000 where the payload is located.

Content: 

payload_0xbfc00000 : contains the payload copied to and executed from 0xa0010000 which copies 0xBFC00000 to 0xBFE50000 (this address is only valid on devkit! Please change it to a valid address if you wish to run this on a retail system)

slide_jr_0xa0010000 : contains a jump register slide that jumps to 0xa0010000; the use of the nop instruction was not necessary, the slide is a repeated 2 dwords. It is possible to optimize it further by reducing it to a single dword using the jump (j) instruction and calculating the relative address to 0xa0010000 (you can't use labels), the jr jump slide however works as is on the 3.5.0 Lib-PSP iplloader on DTP-T1000; The IPL loading code being unchanged across tachyon rom revisions, this should work as is without further optimization.

Result (slide and payload) : Contains a valid sample block both in encrypted and decrypted format that uses both the payload and slide for code execution.
