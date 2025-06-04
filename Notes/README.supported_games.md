<!---======================================================================
                    N O T E S / R E A D M E . S U P P O R T E D _ G A M E S . M D 
                    doc: Wed May 14 08:47:17 2025
                    dlm: Wed Jun  4 14:06:28 2025
                    (c) 2025 idealjoker@mailbox.org
                    uE-Info: 118 46 NIL 0 0 72 3 2 4 NIL ofnI
======================================================================--->

# Current Game Support

## System 6

### Compiler

All system 6 and 6A games are fully supported.

### Disassembler

The disassemble_s6 script correctly disassembles all system 6 and 6A
games, with no or very few analysis gaps. 

### Game Notes

- Firepower
	- System 6
	- C711 requires '-a 6000,6FFF -o <output file>' because of the
	  larger game ROM size of this game
- Algar
	- System 6A
	- disassemble_s6 requires -A option
- Alien Poker
	- System 6A
	- disassemble_s6 requires -A option



## System 7

### Compiler

All system 7 games are fully supported.

### Disassembler

System 7 games are fully supported by the disassembly library
(D7811.pm). There is no functional disassemble_s7 script yet for
automatic disassembly, but all the information is available.


## System 9

### Compiler

Minor changes to the compiler are required to implement system 9 support. 

### Disassembler

There is no support for System 9 games yet. 


## System 11

### Compiler

System 11, 11A, 11B and 11C games are supported. Some games use game
library routines that either change the execution mode or use inline
arguments. Current support for these routines is incomplete with only
routines that change the mode to WVM supported. Routines that change
the mode to assembly can easily be added. Furthermore, the syscall
mechanism from WPC can be ported to Sys 11 to deal with inline
arguments. 

### Disassembler

- at present only the switch table and CPU vectors are disassembled;
disassemble_BadCats has a lot of additional code, including scanning
for Threads

- thread scanning requires the location of some syscalls known for
Pinbot and Bad Cats provided by Pinsider for Radical! (both stock and
prototype code) is not the same for Rollergames (?)

	- need to figure out how fixed routines are
	
	- Radical! has additional WVM-entry routine with 4
	  bytes of in-line arguments; Rollergames has multiple
	  routines with inline arguments

	- WPC syscall mechanism should be generalized
	  (with modes) and ported to Sys 7-11

### Game Notes

- Pin Bot
	- Sys 11A
	- disassemble_s11 produces WARNINGs 
		- warnings due to game routine that switches to WVM mode (-f required)
		- C711 -f option enabled by default
	- C711 okay
- Bad Cats
	- Sys 11B
	- disassemble_s11 okay 
	- C711 okay
- Radical!
	- Sys 11C
	- disassemble_s11 produces WARNING
		- warning can be ignored (no mode conflicts)
		- C711 -f option enabled by default anyway
		- -f option required because of unrelated BUG in stock ROM
	- C711 okay
- RollerGames
	- Sys 11C
	- disassemble_s11 produces WARNINGs
		- (at least some) WARNINGs related routines have inline arguments
		- C711 -f option enabled by default 
	- C711 bombs even with -f
		- likely confusion with inline arguments
		- Sys 11 extensions? [Reg-?] arguments
	


## WPC

WPC support is under development.

### Compiler

There is no compiler support for WPC yet.

### Disassembler

WPC support is under development. There is a disassemble_WPC script that
may work. Best supported game is Terminator 2 (WPC DMD). 
