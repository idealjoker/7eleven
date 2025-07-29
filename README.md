# 7eleven -- Tools for Disassembling and Compiling Williams Pinball System 6 - 11 and WPC Games

## Overview

7eleven is a suite of tools for disassembling and compiling code for
Williams System 6 -- 11 pinball games, implemented in the perl
programming language. While all games use M6800 assembly language,
beginning with System 7, the games also use a byte code that is
interpreted by the Williams Virtual Machine (WVM). In order to allow
code optimization 7eleven implements a special-purpose programming
language with native support for structured programming and WVM code,
rather than implementing extensions in a macro assembler.

The 7eleven collection of tools includes a compiler (C711), a
disassembly library (D711.pm), and a set of ancillary tools. I created
7eleven to make home ROMs for old pinball games -- Jungle Lord (new
tricks), PEMBOT (no relation), and The Cat's Meow, so far. 


## Copyright And License

***(c) 2019 IDEALJOKER@MAILBOX.ORG***

This software is openly licensed via CC BY-NC-SA 4.0. This license
enables users to distribute, remix, adapt, and build upon the material
in any medium or format for noncommercial purposes only, and only so
long as attribution is given to the creator. If you remix, adapt, or
build upon the material, you must license the modified material under
identical terms. (For details, see
https://creativecommons.org/licenses/by-nc-sa/4.0/). 


## Game Support

All System 6 - 11 games are supported, but at present only System 6
games can be disassembled automatically almost completely. Many System
11 games can also be disassembled, with the output including all
switch-related game code. While the resulting source files can be
compiled to re-create the original or modified ROM images, full
disassembly for system 11 games requires significant effort.

System 7 is supported by the compiler and disassembly library but no
automatic disassembly script has been written yet. System 9 support is
buggy.

## Documentation

Documentation is incomplete but growing, with a few README files in the
subdirectory UserManual, and a fairly complete 7eleven language
reference manual, which include a description of the Williams System
7-11 virtual machine, in the subdirectory LanguageManual. There is also
a [Pinside thread](https://pinside.com/pinball/forum/topic/7eleven-tools-for-disassembling-and-compiling-system-6-11-games)
