[//]: # (======================================================================
                    R E A D M E . S U P P O R T E D _ G A M E S . M D 
                    doc: Wed May 14 08:44:58 2025
                    dlm: Wed May 14 08:44:58 2025
                    (c) 2025 A.M. Thurnherr
                    uE-Info: 1 0 NIL 0 0 72 3 2 4 NIL ofnI
======================================================================)



# Current Game Support

## System 6

### Compiler

All system 6 and 6A games are fully supported.

### Disassembler

The disassemble_s6 script correctly disassembles all system 6 and 6A
games, with no or very few analysis gaps. 

### Game Notes

- Firepower
	- Sys 6
	- C711 requires '-a 6000,6FFF -o <output file>' because of the
	  larger game ROM size of this game
- Algar
	- Sys 6A
	- disassemble_s6 requires -A option
- Alien Poker
	- Sys 6A
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
the mode to assembly can easily be added. Furthermore, the sycall
mechanism from WPC can be ported to Sys 11 to deal with inline
arguments. 

### Disassembler

- at present only the switch table and CPU vectors are disassembled;
disassemble_BadCats has a lot of additional code, including scanning
for Threads

- thread scanning requires the location of some syscalls known for
Pinbot and Bad Cats provided by Pinsider for Radical! (both stock and
prototype code) is not the same for RollerGames (?)

	- need to figure out how fixed routines are
	
	- Radical! has additional WVM-entry routine with 4
	  bytes of in-line arguments; RollerGames has multiple
	  routines with inline arguments

	- WPC syscall mechanism should be generalized
	  (with modes) and ported to Sys 7-11

### Game Notes

- Pin Bot
	- Sys 11A
	- disassemble_s11 produces WARNINGs
	- C711 -f okay
	- single routine switches to WVM mode => PinBot.defs => all okay
- Bad Cats
	- Sys 11B
	- disassemble_s11 okay
	- C711 okay
- Radical!
	- Sys 11C
	- disassemble_s11 produces WARNING, which can be ignored (different way of starting WVM mode!)
	- C711 requires -f because of a mode-switching bug in the original code
- RollerGames
	- Sys 11C
	- disassemble_s11 produces WARNINGs
	- C711 with -f bombs, likely because of confusion related to WARNINGs
	- (at least some) WARNINGs related routines have inline arguments

