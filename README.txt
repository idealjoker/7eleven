======================================================================
                    R E A D M E . T X T 
                    doc: Fri May 24 11:26:20 2024
                    dlm: Fri May 24 19:17:36 2024
                    (c) 2024 idealjoker@mailbox.org
                    uE-Info: 82 31 NIL 0 0 72 3 2 4 NIL ofnI
======================================================================

7eleven is a suite of tools for disassembling and compiling code for
Williams System 6 -- 11 pinball games, written in the perl programming
language. The tools are copyrighted

	(c) 2020 by idealjoker@mailbox.org.

----------------------------------------------------------------------

=Compiler=

Usage: C711 
	[system -6/-7 source] [-I)VM <stage>]
	[-1)st pass [-f)ind in range <from-addr,to-addr>]]
	[-2)nd pass [-o)ptimization info <file>]]
	[ROM output -s <suffix>] [create -e)qual-sized (32K) ROM images]
	[m-i)n/m-a)x ROM <hex addr>] [suppress chec-k)sum verification]
	[prepend image with -g)ap of <x> KB of FF bytes]
	[-D)EFINE <symbol>]
	[suppres -w)arnings] [-v)erbose (show warnings)]
	[output code -l)isting] [-x) output D711 .dasm file]
	[-d)ump labels] [dump -J)SR targets] [dump -R)OM before resolving labels]
	[-c)hecksum info] [report free -m)emory blocks]
	[trace -C)onditional assembly]
	[-t)rust_but_verify <ROM_image[,...]> [check already during label -r)esolution]]
	<asm file>

Examples:
	1) Create ROM image from assembler source 
			C711 AlienPoker.s6					creates file AlienPoker_U14.bin
	2) Two-stage compilation with optimization
			C711 -1 AlienPoker.s6				creates file .OPTINFO_AlienPoker.s6
			C711 -2 AlienPoker.s6				creates file AlienPoker_U14.bin

----------------------------------------------------------------------

=Disassembly Library=

D711.pm is a library of disassembly routines. In order to disassemble a
game, a perl program has to be written that includes the library as follows

	use D711 (6);

where (6) indicates that the ROM is a Williams System 6 image. There is
currently no documentation for this library.

----------------------------------------------------------------------

=Utilities=

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
		render_char 3F00	-> 0
		render_char 7708	-> A
