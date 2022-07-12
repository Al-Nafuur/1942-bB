# 1942-bB
A 1942 port for the 2600 written in Batari Basic

For building the Project [PlusROM functions for bB](http://pluscart.firmaplus.de/pico/?PlusROM#batariBasic) must be installed.

## Using PlusROM functions in batariBasic (experimental)

To build batariBasic with PlusROM functions support just use this fork: https://github.com/Al-Nafuur/batari-Basic

To add PlusROM functions support to your existing batariBasic installation just replace (or add) these files in your bB include folder with the ones from the Github fork above:

    /includes/2600basicfooter.asm
    /includes/banksw.asm
    /includes/score_graphics.asm
    /includes/PlusROM_functions.asm

