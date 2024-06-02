======================================================================
		    R E A D M E . T X T 
		    doc: Fri May 24 11:26:20 2024
		    dlm: Sat May 25 11:00:08 2024
		    (c) 2024 idealjoker@mailbox.org
		    uE-Info: 62 25 NIL 0 0 72 3 2 8 NIL ofnI
======================================================================

COPYRIGHT AND LICENSE

		    (c) 2019 IDEALJOKER@MAILBOX.ORG

This software is openly licensed via CC BY-NC-SA 4.0. This license
enables users to distribute, remix, adapt, and build upon the
material in any medium or format for noncommercial purposes only, and
only so long as attribution is given to the creator. If you remix,
adapt, or build upon the material, you must license the modified
material under identical terms. (For details, see
https://creativecommons.org/licenses/by-nc-sa/4.0/). 

======================================================================

CHANGE LOG
    May 10, 2019: - disassembler library created
    Jan  4, 2020: - compiler created
    May 24, 2024: - initial GitHub release

======================================================================

PROGRAMMING LANGUAGE

7eleven is a suite of tools for disassembling and compiling code for
Williams System 6 -- 11 pinball games, implemented in the perl
programming language. While all games use M6800 assembly language,
beginning with System 7, the games also use a byte code that is
interpreted by the Williams Virtual Machine (WVM). In order to allow
code optimization 7eleven implements a special-purpose programming
language with native support for structured programming and WVM code,
rather than implementing extensions in a macro assembler.

The 7eleven programming language includes four different types of
statements: 

1) M6800 assembly statements (upper case, e.g. LDAA #$01), including
conditional assembly (. prefix, e.g. .IFDEF .. .ENDIF)

2) M6800 extensions (upper case, _ prefix) for structured programming
(e.g. _IF .. _ENDIF) and other purposed (e.g. _WVM_MODE, _TESTFLAG[A])

3) WVM statements (mixed case, e.g. killThreads #$FF Thread#22)

4) WVM extensions (mixed case, _ prefix) for structured programming
(e.g. _Loop .. _While)

The 7eleven programming language also supports a set of native WVM
byte-sized data types, including Switches, Lamps, Flags, Adjustments,
Solenoids, Threads, and Bit Groups. Since pinball programming uses a
lot of byte-code interpreters the 7eleven programming language can be
extended with encoding plugins for labels, which allows constructs like
LDAA #100K{ScoreByte}. In addition to ScoreByte, other standard plugins
include SolCmd, InvertByte, LSB and MSB. Multi-byte data types include
fixed and variable-length character strings for 7- and 16-segment
displays. 

----------------------------------------------------------------------

COMPILER

Usage: C711 
    [system -6/-7 source] [-I)VM <stage>]
    [-1)st pass [-f)ind in range <from-addr,to-addr>]]
    [-2)nd pass [-o)ptimization info <file>]]
    [ROM output -s <suffix>] [create -e)qual-sized (32K) ROM images]
    [m-i)n/m-a)x ROM <hex addr>] [suppress chec-k)sum verification]
    [prepend image with -g)ap of <x> KB of FF bytes]
    [-D)EFINE <symbol>]
    [suppress -w)arnings] [-v)erbose (show warnings)]
    [output code -l)isting] [-x) output D711 .dasm file]
    [-d)ump labels] [dump -J)SR targets] [dump -R)OM before resolving labels]
    [-c)hecksum info] [report free -m)emory blocks]
    [trace -C)onditional assembly]
    [-t)rust_but_verify <ROM_image[,...]> [check already during label -r)esolution]]
    <asm file>

Examples:
    1) Create ROM image from assembler source 
	    C711 AlienPoker.s6			creates file AlienPoker_U14.bin
    2) Two-stage compilation with optimization
	    C711 -1 AlienPoker.s6		creates file .OPTINFO_AlienPoker.s6
	    C711 -2 AlienPoker.s6		creates file AlienPoker_U14.bin

----------------------------------------------------------------------

DISASSEMBLY LIBRARY

D711.pm is a library of disassembly routines. In order to disassemble a
game, a perl program has to be written that includes the library as follows

    use D711 (6);

where (6) indicates that the ROM is a Williams System 6 image. There is
currently no documentation for this library.

----------------------------------------------------------------------

UTILITIES

annotate_PinMAME_trace
     Annotate PinMAME TRACE output to help debugging
     NOTES:
	   - input from "TRACE <FILE> A B X" output
	   - also removes all backend calls (ISR) from output
	   - annotations:
		   - thread switching
		   - thread parking
		   - WVM/IVM operations (interpreter)

cpx
    Translate cmp -l output to hex
    EXAMPLE
	cmp -l image1.bin image2.bin | cpx

mkIndex
    Create "table of contents" from full-line comments in 7eleven source files
    EXAMPLE
	mkIndex AlienPoker.s6 > AlienPoker.index
    
render_char
    Render 16-bit hex code as done by Sys 11 alphanumeric displays
    EXAMPLES:
	render_char 3F00    -> 0
	render_char 7708    -> A
