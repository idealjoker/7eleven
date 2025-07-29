# 7eleven Utilities 

## cpx

Hexadecimalize output from cmp -l. 

Usage example: `cmp -l T2_U6.bin HomeROM_U6.bin | cpx`


## mkTOC \<7eleven source file>

Create Table-of-Contents from full-line comments in source file. 

Usage example: `mkTOC T2.WPC > T2.TOC`


## render_sys11_alpha_char \<16-segment hex word>

Display 16-segment rendering of single alphanumeric symbol. 

Usage example: `render_sys11_alpha_char 0944`


## recreate_patched_src \<patched source file> \<original source file>

Use updated original source file (disassembly output) to recreate
patched source file based on an earlier version of the original source
file. 

Usage example: `recreate_patched_src HomeROM_orig.WPC T2.WPC > HomeROM_updated.WPC`

