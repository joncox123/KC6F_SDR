# KC6F_SDR
Software Defined Radio (SDR) software written in Matlab. Currently supports Softrock Si570 radios, including the RXTX.

The goal of KC6F SDR is to provide a Software Defined Radio package, intended for radio amateurs (hams), that is cross-platform, easy to use, readily customizable and supports a wide range of modulation/demodulation modes. Initially, I am targeting the Softrock Ensemble kit radios (http://fivedash.com/), but others will hopefully be added later. 

KC6F SDR is written in Matlab, and can run on Mac, Linux and Windows. With the Matlab Compiler, it can also be packaged to run as an app that doesn't require a Matlab license or installation. 

System Requirements:
Softrock Ensemble receiver or transceiver (RXTX)
64-bit Windows
Two sound cards, one of which must support 192 kHz sampling rate

Todo:
1. Compile with Matlab Compiler for wider distribution
2. Add support for Linux and Mac (needs support for Softrock USB interface)
3. Add TX support
4. Add AM and CW analog modes
5. Add PSK
6. Add automatic CW transmitter and decoder
7. Add support for adaptive filtering with second receiver and antenna

![Screen shot of KC6F SDR on Windows](screenShot.jpg?raw=true "Screen Shot")
