#======================================================================
#					 D 7 1 1 . P M 
#					 doc: Fri May 10 17:13:17 2019
#					 dlm: Sat Apr 26 08:37:56 2025
#					 (c) 2019 idealjoker@mailbox.org
#                    uE-Info: 3306 83 NIL 0 0 72 10 2 4 NIL ofnI
#======================================================================

# Williams System 6-11 Disassembler

# HISTORY:
#   May 10, 2019: - created
#   May 11, 2019: - continued
#   May 12, 2019: - massively improved
#   May 14, 2019: - minor improvements
#   May 15, 2019: - split ASM into OP and OPA for output formatting
#                 - major addition of 6800 opcodes
#                 - BUG: all DIR addressing opcodes had wrong length
#   May 16, 2019: - added remaining 6800 opcodes
#                 - added wvm7 labels
#                 - added remaining wvm7 opcodes
#                 - other improvements and fixes
#   ...         : - continued
#   May 19, 2019: - works to disassemble jlord.asm up to init_new_player
#                 - mercurialized
#   May 30, 2019: - continued on flight back from Hamburg:
#                       - debugging
#                       - support for game-specific identifiers
#   Jun  2, 2019: - improved output formatting (added dividers)
#                 - fixed minor bugs
#   Jun  3, 2019: - added thread support
#   Jun  5, 2019: - debugged/improved expression parsing
#   Aug 17, 2019: - renamed to D711 and stated adapting to System 11
#                 - package renamed to D
#                 - added info on Sys7 macros from Scott Charles
#                 - added Sys11 macro "die hooks" from Scott Charles info
#                 - bugfixes
#                 - ordered output of dump_labels by label value
#   Aug 18, 2019: - bugfixes
#                 - added new spawnThread macros
#   Aug 19, 2019: - bugfixes
#   Aug 20, 2019: - bugfixes
#   Aug 21, 2019: - bugfixes
#   Aug 22, 2019: - fixed final(?) major bug: _thread* in WE expr takes
#                   another byte in WVM11
#   Aug 23-31   : - some more bug fixes & improvements
#   Sep  2, 2019: - new automatic labels with addresses
#                 - added $verbose
#   Sep  3, 2019: - replaced print_addr by print_addrs
#   Sep  4 - 16 : - significant debugging
#   Sep 17, 2019: - BUG: CPXA instead of CPX opcode
#                 - made comments use tabstops
#                 - removed label processing from .DB statements
#                 - BUG: first table row distributed over 2 lines
#                 - added @Switch2WVMSubroutines
#   Sep 19, 2019: - added @unstructured
#   Sep 20, 2019: - BUG: rotLeft and Rigth were swapped
#                 - added setLabel to ensure only last define label name is chosen
#                 - removed non-existent opcodes 23 and 27
#   Sep 21, 2019: - BUG: lampOps and indirect ops only took single arguments
#   Sep 23, 2019: - stuff
#   Sep 25, 2019: - added def_string()
#   Sep 27, 2019: - added def_string_table()
#                 - BUG: byteblock() bad format byte 1
#   Sep 28, 2019: - BUG: redefined labels were treated as 0
#                 - BUG: def_ routines overwrote manual labels
#   Sep 19-Oct 4: - improved
#   Oct  5, 2019: - sped up labels 1000%
#   Oct 6-11    : - various improvements
#   Oct 12, 2019: - added code for orphaned labels
#   Jan  5, 2020: - cosmetics
#                 - cleaned up some syntax and renamed a couple of WVM ops
#                 - BUG: unused opcode 0B did not set decoded flag of 2nd argument byte
#                 - turned solenoid numbers into hex
#                 - BUG: number of solenoid tics was wrong
#   Jan  6, 2020: - cosmetics
#   Jan  7, 2020: - removed repeat indication from .DB
#                 - renamed .DB.DW to .DBW; .DW.DB to .DWB
#                 - modified coding of table rows (no .DB.DW.DS strings allowed any more)
#                 - simplyfied wvm_parse_expr() [old infix code left in source]
#                 - BUG: indirect addressing notation was inconsistent
#                 - added .ALIAS to output
#   Jan  8, 2020: - changed or-flag notation for bigroup and lamp ops (LG_all|0x40 instead of 0x40 | LG_all)
#                   to make parsing easier
#                 - BUG: erroneous superfluous code (never executed?) in WVM_lampOp
#                 - changed syntax for playSound with repeat
#   Jan  9, 2020: - changed %greater to %greaterThan
#                 - made ajustment and sound numbers hex
#                 - changed |0x40 to |#$40 (of course)
#                 - BUG: label substitution was not anchored at beginning
#                 - removed def_string and replaced by def_stringX
#                 - removed string length specifier from .DS
#                 - removed .DS.DS
#   Jan 10, 2020: - renamed some .PRAGMAs (new .STR .S7R .DEF)
#                 - added .LBL
#                 - moved all warnings to STDERR
#                 - removed # from table data
#                 - removed "register" from all register ops and replaced "save" by "store"
#                 - BUG: flaggroup table had wrong labels
#   Jan 11, 2020: - BUG: clearSwitches was not recorded in output
#                 - added sleep_subOptimal where long sleep was used instead of short
#   Jan 12, 2020: - added @exception arguments to string table definitions
#                 - WORKS!
#                 - improved structured code parsing
#                 - added def_checksum_byte()
#   Jan 14, 2020: - removed # from label arithmetic
#                 - added conditions to cs_loop analyzers
#   Jan 23, 2023: - expunged address lists in label names
#   Jan 25, 2020: - added undo_code_structure (and -h) to write a file with $unstruturedp[] hints
#                   based on an analysis of labels into indented code produced during output;
#                   the code works, but turns out pointless, because when -l/-i are used, these
#                   structure-breaking labels are caught already in same_block()
#   Jan 26, 2020: - added '!' marker to suppress label sustitution to .DB and .DW ops
#                 - changed def_wordblock_hex() not to substitute labels
#                 - added def_ptrblock_hex() to do the same but substitute labels
#                 - made string identifiers 4-digits long
#                 - renamed def_byte{block,list}_hex_long to def_byte{block,list}_hex_cols
#   Feb  2, 2020: - changed .DEF to .DEFINE & swapped order of arguments
#                 - ensured indent() always adds at least 1 space
#                 - made sure that output lines up with 4-space tab stops
#                 - use tab stops in output
#   Apr 28, 2020: - fixed erroneous _IF macros (IFGT -> IF_GE, IFLT -> IF_LE, IFGE -> IF_GT, IFLE -> IF_LT
#                 - renamed remaining _IF macros
#   May 29, 2021: - added 'no_follow' option ($code_following_enabled)
#                 - BUG: $follow_code was ignored for all JSR
#   May 30, 2021: - BUG: typo
#                 - BUG: special JSR treatment also applies to BSR
#                 - BUG: quite a few WVM ops have changed name...
#                 - BUG: 'store' is missing 2nd argument
#   May 31, 2021: - BUG: def_byteblock_hex_alt() required for C711 -x
#   Jun  8, 2021: - removed 'no_follow' option and $code_following_enabled
#   Jun 16, 2021: - added def_lbl_arith()
#   Jun 19, 2021: - BUG: disassembly of pointers in data did not work
#                 - renamed def_byteblock_hex_alt() to def_byteblock_hex_magic()
#   Oct  9, 2021: - added support for plain M6800 disassembly (leave $WMS_System undefined)
#   Oct 10, 2021: - cleaned up System X support
#   May 12, 2022: - removed die() statement on line 1121
#                 - flaggroup => bitgroup
#                 - sleep_imm => sleepI, WVM_mode => WVM_start
#                 - made sleepI & WVM_start work automatically for Sys11
#                 - added unrealistic_score_limit
#                 - added support for switch names (@Switch)
#                 - BUG: decAndBranchUnless0 reported wrong register
#                 - removed address suffices from switch handler labels
#   May 13, 2022: - made insert_divider overwrite pre-existing divider
#   May 14, 2022: - improved string decoding
#                 - BUG: switchtable decoding did not add labels for switch handlers
#   May 15, 2022: - added grow_strings()
#                 - changed semantics about overwriting labels in setLabel()
#   May 16, 2022: - added trim_overlapping_strings()
#                 - updated (c) year
#                 - added %unfollowed_lbl
#                 - added disassemble_unfollowed_labels()
#                 - added overwriteLabel()
#   May 17, 2022: - BUG: %unfollowed_lbl replaced by @unfollowed_lbl
#                 - BUG: _EXIT_THREAD magic did not work
#   May 18, 2022: - added def_ptr_hex_alt()
#                 - BUG: WVM_start not implemented fully
#                 - imported Sys11 magic from BadCats System11.dasm
#   Oct  3, 2022: - BUG: def_byteblock_hex_cols() had first 2 args swapped
#   Oct  4, 2022: - added OP predefined check to def_byteblock_hex()
#                 - added def_org()
#   Oct  5, 2022: - added support for fill_gaps()
#                 - added debug statement
#                 - BUG: allFlagsSet/Cleared did not support |$C0 arithmetic
#   Oct  7, 2022: - BUG: decode_STR_char() had several bugs
#                 - BUG: CPXA instead of CPX
#                 - BUG: def_switchtable_ptr used switch names as handler routines
#                 - BUG: suppressed definition of no-name labels
#   Oct  8, 2022: - BUG: trim_overlapping_strings had not been adapted to
#                        new string notation with . and \
#                 - renamed grow_strings to grow_1strings
#                 - aded grow_string
#                 - BUG: decode_STR_char decoded everthing below ASCII 48 as space
#                 - turned halt error into warning
#   Oct  9, 2022: - modified one of the debug pointers to not overwrite pointee label
#                 - added already assembled checks to disassemble_wvm()
#   Oct 13, 2022: - BUG: wvm_parse_expr() did not handle simple numbers correctly
#                 - modified wvm_parse_expr() to decode numbers as hex
#   Dec 22, 2023: - added def_bitgroup_table for AP
#                 - added System 6 support
#   Dec 24, 2023: - BUG: load_ROM did not always set MAX_ROM_ADDR correctly
#   Dec 24-31   : - added System 6 support
#   Jan  1, 2024: - made Sys 6 disassembly largely automatic with *.defs
#   Jan 17, 2024: - "modernized" sys 6 labels
#   Feb 18, 2024: - cosmetics
#   May 25, 2024: - BUG: typo: extraneous '
#                 - cosmetics
#                 - BUG: system6 disassembly without switch names produced uncompilable code
#   May 27, 2024: - exported different system disassembly routines
#                 - added define_label
#                 - suppressed output of labels with +1 .. +9
#                 - BUG: copyright message was wrong
#   May 28, 2024: - added return value to def_byte_hex()
#   Jun  7, 2024: - added %systemConstants for System 6 disassembly
#                 - turned formatting constants from my() to our()
#   Jun 16, 2024: - improved error message
#   Jul 16, 2024: - exported [D711.M6800]
#                 - added support for [D711.M6809]
#   Jul 18, 2024: - made it work
#   Jul 19, 2024: - modified load_ROM to allow loading a slice
#                 - BUG: disabled error when using -ac w/o -g and gap is at end
#   Aug  9, 2024: - started adding WPC support
#   Aug 10, 2024: - continued WPC support
#                 - added numberp()
#   Aug 11, 2024: - continued WPC support
#   Aug 12, 2024: - BUG: select_WPC_RPG did not return correct value unless pg was changed
#                 - added support for WPC strings
#   Aug 13, 2024: - added _ROMPG labels to all pages
#                 - BUG: @EXTRA was not swapped out and in
#                 - added range check to setLabel
#                 - BUG: PG 0xFF was not handled correctly
#                 - made @ROM swap in and out (instead of reloading every time)
#   Aug 14, 2024: - exported all WPC stuff to [D711.WPC_DMD]
#                 - made setLabel return true label name
#   Aug 15, 2024: - development
#   Aug 16, 2024: - cosmetics
#   Aug 18, 2024: - added pg as optional argument to setLabel
#   Aug 19, 2024: - added special handling for ! WPC shortcut
#   Aug 20, 2024: - added support for nesteed IFs
#   Aug 21-23:    - heavy debugging of code-structure analysis
#   Aug 24, 2024: - more deebugging (make AP work again)
#                 - added support for <_LOOP and >_EXITLOOP pseusdo labels
#   Aug 25, 2024: - exported [D711.CodeStructureAnalysis]
#			      - BUG: nested ENDIFs used wrong indentation
#	Aug 27, 2024: - suppressed multiple dividers at same address
#	Aug 30, 2024: - adapted overwriteLabel to WCP update
#	Sep  1, 2024: - added support for -Q in import
#	Sep  2, 2024: - BUG: define_label() redefined labels without warning/error
#	Sep  3, 2024: - BUG: Thread# output on WPC was only 2 digits
#	Sep  4, 2024: - added support for DMD# type
#	Sep  8, 2024: - moved gap comment left
#	Sep 15, 2024: - changed ROM page notation for labels
#				  - suppress ROM page notation for labels on current page
#	Sep 18, 2024: - added empty lines after tables
#	Sep 21, 2024: - moved insert_empty_line here
#	Mar 11, 2025: - BUG: $cur_RPG instead of $_cur_RPG in 2 locations
#				  - changed WMS_System ids for WPC
#				  - added support for !override in label_address
# 	Mar 14, 2025: - BUG: WPC_DMD remaining
#				  - improved ROM page handling
#				  - BUG: load_ROM() set wrong start page for FH
#				  - adapted to more general WPC interface
#				  - BUG: same-page labels had page-prefices in output
#	Mar 15, 2025: - improved .ORG handling
#	Mar 16, 2025: - improved auto labels
#				  - added scanCode()
#	Mar 17, 2025: - adapted to unified D711.WPC
#	Mar 19, 2025: - improved output of ANALYSIS_GAPs
#				  - added detection of free space in gaps
#				  - BUG: overwriteLabel no longer worked with WPC labels
#	Mar 21, 2025: - BUG: scanCode did no have PAGEROM label
#	Mar 22, 2025: - modified label handling to croak on trying to re-define label
#				    with different address
#				  - majorly improved scanCode
#	Mar 23, 2025: - modified scanCode to work with .obj files
#				  - made scanCode fuzzy
#	Mar 24, 2025: - BUG: produce_obj() did not handle gaps correctly
#	Mar 26, 2025: - BUG: produce_obj() did not stop at RTS, JMP, LBRA or !exitThread
#				  - BUG: anonymous/auto labels (e.g. RAM_0384) were not handled correclty
#	Apr  3, 2025: - modified scan output
#	Apr  5, 2025: - moved produce_obj and Code Scanner to [D711.WPC]
#	Apr 23, 2025: - modified syntax of repeat bytes in gaps
#	Apr 24, 2025: - removed .ORG gap info (not well formatted, not useful for first .org)
#				  - added support for stray labels in .DB blocks
#				  - added support for stray labels in gaps
#	Apr 25, 2025: - removed dump multiple labels flag from produce_output()
#				  - added -f support to produce_output()
#	Apr 26, 2026: - removed -f (made default)
# END OF HISTORY

# TO-DO:
#   - remove all system specific code from this file
#   - make all def_ routines return values
#   - add more consistency checks like for predefined OP as in def_byteblock_hex()
#	- many, many other things

package D711;

$PATH = $0; $PATH =~ s{/[^/]*$}{};

our $WMS_System;                    # set to 7 or 11 or undef for MC6800 disassembly 
our $verbose = 1;                   # 0: quiet (for automatic scans); 1: error messages (default); 2: debug
our $unclean;                       # used to report unclean disassembly
our @Switch2WVMSubroutines;         # list of addresses of M6800 SBRs returning in WMV mode
our @unstructured;                  # set flag to skip address during code-structure scanning
our @nolabel;                       # set flag to skip address during label substitution
our @no_autolabels;                 # set to true to suppress system 7 auto labels at specific addresses

our @ROM;
our $MIN_ROM_ADDR,$MAX_ROM_ADDR;    # set by load_ROM
our %systemConstants;               # set, e.g., by [D711.system6]

sub BYTE($) { return $ROM[$_[0]]; }
sub WORD($) { return $ROM[$_[0]]<<8|$ROM[$_[0]+1]; }

#----------------------------------------------------------------------
# Output Format Defintion (Tweakables)
#----------------------------------------------------------------------

our($hard_tab)          = 4;                            # length of tab stop
our($code_base_indent)  = 2;                            # base indent (tab stops) for code
our($data_indent)       = 8;                            # indent for data tables (long labels)
our($rem_indent)        = 17;                           # indent for comments
our($def_name_indent)   = 3;                            # indent for .DEFINE .LBL statement args
our($def_val_indent)    = 13;
our(@op_width)          = (undef,2,5,1);                # typical operator width (tab stops) for (nil,6800,WVM7,Data)

our($CodeType_asm)      = 1;                            # different types of code in ROM
our($CodeType_wvm)      = 2;                            # for @TYPE[@addr]
our($CodeType_data)     = 3;                            # also, used as index in @op_width

#----------------------------------------------------------------------
# Tweakables
#----------------------------------------------------------------------

my($unrealistic_score_limit) = 1e6;

#----------------------------------------------------------------------
# Interface
#   use D711 (sys[,opts])
#       sys     = 6, 7, 11, WPC(DMD); to-do: 9, WPC(Alphanumeric,Fliptronics,DCS,Security,95)
#		opts 	expression to eval, e.g. '$opt_Q = 1' to suppress splash
#----------------------------------------------------------------------

sub import($@)
{
	my($pkg,$sys,$opts) = @_;
##	print(STDERR "import($pkg,$sys,$opts)\n");
    
	eval($opts) if defined($opts);

	$WMS_System = $sys;

	unless ($opt_Q) {
		print(STDERR "\nDisassembler for WVM System $WMS_System\n");
		print(STDERR "(c) 2019 idealjoker\@mailbox.org\n");
	}

	require "$PATH/D711.CodeStructureAnalysis";
	if ($WMS_System == 6 || $WMS_System == 7 || $WMS_System == 11) {
		require "$PATH/D711.M6800";
		require "$PATH/D711.System$WMS_System";
	} elsif ($WMS_System =~ m{^WPC\((.*)\)$}) {
		require "$PATH/D711.M6809";
		require "$PATH/D711.WPC";
	} else {
		die("$0: unknown WMS system type $WMS_System\n")
	}
	print(STDERR "\n") unless $opt_Q;
} # import

#----------------------------------------------------------------------
# Utilities
#----------------------------------------------------------------------

sub numberp(@)
{ return  $_[0] =~ /^\d+$/; }

sub insert_empty_line($)
{
	my($addr) = @_;
	
	push(@{$EXTRA[$addr]},'');
	push(@{$EXTRA_IND[$addr]},$ind);
	$EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 0;
	$EXTRA_AFTER_OP[$addr][$#{$EXTRA[$addr]}] = 1;
}

#----------------------------------------------------------------------
# Load ROM Image
#----------------------------------------------------------------------

#my($start_page);                                                           # 0x20 for 512KB ROMs

sub load_ROM($$@)
{
    my($fn,$saddr,$RPG,$lenK) = @_;
    my($nread,$buf,$eaddr);
#	printf(STDERR "load_ROM($fn,\$%04X,\$%02X,$lenK) [%04X-%04X] <$RPG>\n",$saddr,$RPG,$MIN_ROM_ADDR,$MAX_ROM_ADDR);

    $lenK = 9e99 unless defined($lenK);

    open(RF,$fn) || die("$fn: $!");
    if (defined($RPG)) {
        die("load_ROM($fn,$saddr,$RPG,$lenK)") unless numberp($RPG);
        unless (defined($start_page)) {										# usually defined in [disassemble_WPC] scripts
        	my($nPG) = (sysseek(RF,0,2)) / 16 / 1024;
			$start_page = 64 - $nPG;
		}
        sysseek(RF,($RPG-$start_page)*16*1024,0) || die("sysseek($fn,($RPG-$start_page)*16K): $!");
    }
    for (my($ofs)=0; ($lenK-- > 0) && ($nread = sysread(RF,$buf,1024)) > 0; $ofs+=$nread) {
        @ROM[($saddr+$ofs)..($saddr+$ofs+$nread-1)] = unpack('C*',$buf);
        $eaddr = $saddr + $ofs + $nread - 1;
    }
    close(RF);

    $MIN_ROM_ADDR = $saddr unless defined($MIN_ROM_ADDR);
    $MIN_ROM_ADDR = $saddr if ($saddr < $MIN_ROM_ADDR);
    $MAX_ROM_ADDR = $eaddr if ($eaddr > $MAX_ROM_ADDR);

    &init_system_11() if ($WMS_System==11 && WORD(0xFFFE)>0);               # this should be moved into a future [disassemble_s11]

}

#----------------------------------------------------------------------
# Label Functions
#   - 2 data structures need to be maintained in sync:
#       - %Lbl{label} 	= addr
#		- %LblPg{label} = WPC rom page
#       - @LBL[addr]  	= label
#   - setLabel:
#       - if 3rd argument evaluates to true, allow for duplicate
#         definitions (C711 -x)
#       - {}label is STICKY; address added between braces
#       - first non-automatic label overwrites any previous auto lbl
#       - otherwise, no overwriting
#       - aliased to define_label to allow sharing of API definition
#         with [C711]
#   - label_address:
#       - set @AUTO_LBL[addr] to be used when no label is set during output
#   - substitute_label:
#       - set %Lbl_refs{label} = # of references
#----------------------------------------------------------------------

sub setLabel($$@)
{
    my($lbl,$addr,$pg) = @_;

#   die(sprintf("trying to define empty label [setLabel($lbl,0x%04X,$allow_multiple)]\n",$addr))
#       if (length($lbl) == 0);
    return '' if (length($lbl) == 0);               

    $lbl = sprintf('{%04X}%s',$addr,$')                         # STICKY -> fill address
        if ($lbl =~ /^{}/);

    my($faddr) = $addr;
    if (defined($_cur_RPG) && $addr>=0x4000 && $addr<0x8000) {
        die(sprintf("setLabel($lbl,%04X) [%02X]",$addr,$_cur_RPG))
             unless ($_cur_RPG >= 0 && $_cur_RPG <= 0x3F || $_cur_RPG == 0xFF);
        select_WPC_RPG($pg,11) if defined($pg);             
        unless ($_cur_RPG == 0xFF) {
            $faddr = sprintf("%02X:%04X",$_cur_RPG,$addr);
			$lbl = $' if ($lbl =~ m{^[0-9A-F]{2}:}); 
            $lbl = sprintf("%02X:$lbl",$_cur_RPG);	# unless $lbl =~ m{^\.};
        }
    }
    undef($Lbl{$LBL[$addr]})                                    # overwrite existing auto label with non-auto label
        if (($LBL[$addr] =~ m{_[0-9A-F]{4}$}) &&                #   otherwise, make duplicate
            !($lbl =~ m{_[0-9A-F]{4}$}));
	if (defined($Lbl{$lbl}) && $Lbl{$lbl}!=$addr && $Lbl{$lbl} ne $faddr) {		# trying to re-define label with different address
		if (numberp($Lbl{$lbl})) {
			die(sprintf("setLabel(%s,\$%04X): label already defined at \$%04X\n",$lbl,$addr,$Lbl{$lbl}));
	    } else {
			die(sprintf("setLabel(%s,\$%04X): label already defined at $Lbl{$lbl}\n",$lbl,$addr,$Lbl{$lbl}));
		}
##		my($tl,$pg);											# make unique
#		if ($lbl =~ m{(\[[0-9A-F]{2}\])$}) {
#			$tl = $`;
#			$pg = $1;
#		} else {
#			$tl = $lbl;
#			$pg = '';
#		}
#		my($i) = 0;
#		while (defined($Lbl{$tl.$i.$pg})) { $i++; }
#       $lbl = $tl.$i.$pg;
    }
    $LBL[$addr] = $lbl;                                         # define label
    $Lbl{$lbl} = $faddr;
    $LblPg{$lbl} = $pg;
    return $lbl;
}

*define_label = \&setLabel;                                     # for compatibility with [C711]

sub overwriteLabel($$@)
{
	my($lbl,$addr,$pg) = @_;
##	print(STDERR "overwriteLabel($lbl,$addr,$pg)\n");

	select_WPC_RPG($pg,12) if defined($pg);
	undef($Lbl{$LBL[$addr]});
	$LBL[$addr] = $lbl; 										# define label
	$Lbl{$lbl} = $addr;
    $LblPg{$lbl} = $pg;
	return $lbl;
}

##sub underwriteLabel($$)
##{
##    my($lbl,$addr) = @_;
##
###   print(STDERR "underwriteLabel($lbl) [$LBL[$addr]]\n");
##    return 0 if defined($LBL[$addr]);
##    $LBL[$addr] = $lbl;                 
##    $Lbl{$lbl} = $addr;
##    return 1;
##}

sub label_with_addr($$)                                         # add hex address to end of label for ROM addresses
{																# mark RAM and PIA addresses
	my($lbl,$addr) = @_;

##	die("lbl=$lbl") if ($addr == 0xB1ED);
	if ($addr >= $MIN_ROM_ADDR) {								# ROM address
		$lbl = $' if ($lbl =~ m{^[0-9A-F]{2}:}); 				# remove previous RPG if there is one
		$lbl = $` if ($lbl =~ m{_[0-9A-F]{4}$});				# remove previous address (if there is one)
		my($prefix) = defined($_cur_RPG) ? sprintf('%02X:',$_cur_RPG) : ''
			if ($addr < 0x8000) && $lbl =~ !m{^\.};
		return $prefix . sprintf('%s_%04X',$lbl,$addr);
	}

	if ($WMS_System >= 6 && $WMS_System <= 7 && $addr > 0x7FF) {	# PIA address
		return sprintf('PIA_%04X',$addr);
	}

	if ($addr > 0xFF) { 										# 16-bit RAM address
		return sprintf('RAM_%04X',$addr);
	} else {													# 8-bit
		return sprintf('RAM_%02X',$addr);
	}
}

sub label_address($$@)                                          # save auto lbl for output and return hex address
{
	my($addr,$auto_lbl,$nosuffix) = @_;
##	die("label_address($addr,$auto_lbl,$nosuffix)") if ($addr == 0xB1ED);

	if ($auto_lbl =~ m{^!}) {
		$auto_lbl = $';
    } else {													# force label prefix with !
		if (($AUTO_LBL[$addr] =~ m{_[0-9A-F]{4}$} ||
			 $AUTO_LBL[$addr] =~ m{_[0-9A-F]{4}\[[0-9A-F]{2}\]$})) {
			## when the following if is disabled, local labels will be named after the
			## branch op that calls it first (or last?) 		    
			if ($auto_lbl =~ m{^\.}) {
				$auto_lbl = ($auto_lbl =~ m{BSR}) ? '.subroutine' : '.label';
			} else {
				$auto_lbl = (defined($_cur_RPG) && $addr >= 0x8000)
						  ? 'syscall' : 'library';				# @@@
			}
		} elsif ($auto_lbl =~ m{^\.}) {
			$auto_lbl = ($auto_lbl =~ m{BSR}) ? '.subroutine' : '.label';
	    }
	}

	my($prefix) = defined($_cur_RPG) ? sprintf('%02X:',$_cur_RPG) : ''
		if ($addr < 0x8000) && !$lbl =~ m{^\.};
	$auto_lbl = $` if ($auto_lbl =~ m{\[[0-9A-F]{2}\]$});
##	die("prefix=$prefix auto_lbl=$auto_lbl") if ($addr == 0xB1ED);
	$AUTO_LBL[$addr] = $nosuffix ? $prefix.$auto_lbl : label_with_addr($auto_lbl,$addr);
	return ($addr > 255) ? sprintf('$%04X',$addr)
						 : sprintf('$%02X',$addr);
}

sub substitute_label($$)                                        # replace addresses in a single arg with labels
{
    my($opaddr,$ai) = @_;                                       # argument to process
    my($opa) = $OPA[$opaddr][$ai];
    return $opa if ($nolabel[$opaddr]);

    my($pf,$addr,$mark) = ($opa =~ m{^(\#?\$)([0-9A-Fa-f]+)(!?)$}); # hex number ($ followed by hex digits) => potential address

    unless (defined($addr)) {									# handle XX:label for labels on same page
		if ($opa =~ m{(^[0-9A-F]{2}):} &&  hex($1) == $_cur_RPG) {
			return $';
		} else {
			return $opa;
		}
	}
    
    return $opa unless defined($addr);                          # not an address => nothing to substitute
    return $pf.$addr if ($mark eq '!');                         # address marked with trailing '!' (.DB, .DW) => do not substitute with labels
    $addr = hex($addr);                                         # translate from hex
    my($imm) = (substr($opa,0,1) eq '#')                        # immediate addressing marker
             ? substr($opa,0,1) : '';                           
    return $opa                                                 # don't substitute 8-bit immediate values
        if ($addr == 0 || ($imm && $addr<0x100 && $OP[$opaddr] ne 'LDX'));

    my($opg);													# handle 3-byte WPC references (address word, page byte)
    if (defined($_cur_RPG) &&
		defined($OPA[$opaddr][$ai+1]) &&
	    $_cur_RPG != 0xFF &&
		$addr>=4000 && $addr<0x8000) {
	        my($pga) = $OPA[$opaddr][$ai+1];
    	    $pga = hex($1) if ($pga =~ m{^\$([0-9A-F]{2})$});
#       	print(STDERR "select_WPC_RPG($OPA[$opaddr][$ai+1]=$pga)\n"),
	        $opg = select_WPC_RPG($pga,13),						# change RPG to rom page of reference (opg is original page, the page of the code0
    	        if (numberp($pga) && $pga>=0 && $pga<0x3E);
    }

    my($lbl) = $LBL[$addr];                                     # check if label is defined (in the correct ROM page)
    if (defined($lbl)) {
        $Lbl_refs{$lbl}++;										# update reference count (this is the full label, including ROM page prefix)

		if (defined($_cur_RPG) && $_cur_RPG == $opg) {			# code and label on the same page
			$lbl = $' if ($lbl =~ m{^[0-9A-F]{2}:});
		} else {												# different pages
	        select_WPC_RPG($opg,14) if defined($opg);				# if so, switch back to ROM page of code
	    }
        return $imm.$lbl;
    }

    select_WPC_RPG($opg,15) if defined($opg);

    my($auto_lbl) = $AUTO_LBL[$addr];                           # use auto label if defined
    return $opa unless defined($auto_lbl);
    
    if (defined($Lbl{$auto_lbl})) {                             # auto label already defined
        if (numberp($Lbl{$auto_lbl})) {
            if ($Lbl{$auto_lbl} == $addr) {                     # but it matches
                $Lbl_refs{$auto_lbl}++;
                return $imm.$auto_lbl;
            }
        } else {
            my($pg,$ad) = split(':',$Lbl{$auto_lbl});
            die unless ($pg == $LblPg{$auto_lbl});
            $pg = hex($pg); $ad = hex($ad);
            if (($ad == $addr) && ($pg == $_cur_RPG)) {
                $Lbl_refs{$auto_lbl}++;
                if (defined($_cur_RPG) && $_cur_RPG == $opg) {
                	$auto_lbl = $' if ($auto_lbl =~ m{^[0-9A-F]{2}:});
                } else {
                	select_WPC_RPG($opg,16) if defined($opg);
                }
                return $imm.$auto_lbl;
            }
        }
        my($i);
        for ($i=1; defined($Lbl{"${auto_lbl}$i"}); $i++) {      # otherwise, find unique alternative
            return $imm."${auto_lbl}$i"                         # already defined
                if ($Lbl{"${auto_lbl}$i"} == $addr);
        }
        $auto_lbl = "${auto_lbl}$i";                            # new, unique label
    }
    setLabel($auto_lbl,$addr);                                  # define label
    $Lbl_refs{$auto_lbl}++;
    return $imm.$auto_lbl;
}

sub substitute_labels(@)                                        # replace addresses with labels wherever possible
{
    my($fa,$la) = @_;
    $fa = 0 unless defined($fa);
    $la = $#ROM unless defined($la);

    for (local($addr)=$fa; $addr<=$la; $addr++) {
        for (my($i)=0; $i<@{$OPA[$addr]}; $i++) {
            $OPA[$addr][$i] = substitute_label($addr,$i);
        }
    }
    foreach my $addr (keys(%label_arith_exprs)) {               # substitude expressions defined with def_lbl_arith()
        die unless (@{$OPA[$addr-1]} == 1);
        die if ($WMS_System =~ m{^WPC});
        $OPA[$addr-1][0] = ($OPA[$addr-1][0] =~ /^#/) ? '#' : '';
        $OPA[$addr-1][0] .= $label_arith_exprs{$addr};
    }
    foreach my $addr (keys(%pointer)) {                         # substitude labels defined with def_ptr2lbl()
        die(sprintf("%04X: $OP[$addr] @{$OPA[$addr]}",$addr)) unless (@{$OPA[$addr]} == 1);
        die if ($WMS_System =~ m{^WPC});
        $OPA[$addr][0] = $pointer{$addr};
    }
}

sub disassemble_unfollowed_labels()                             # from begin/end6800 and def_byteblock_code
{
    foreach $Address (@unfollowed_lbl) {
        def_code() unless (defined($OP[$Address]));
    }

    foreach my $l (keys(%Lbl)) {
        next if ($l =~ m/[-+]/);
        $Address = $Lbl{$l};
        def_code() if defined($Address) && !defined($OP[$Address]);
    }
}

#----------------------------------------------------------------------
# Dividers to Visually Structure the Code
#----------------------------------------------------------------------

sub insert_divider($$)                                          # Subroutine, Jump Target, etc.
{
    my($addr,$label) = @_;
#   return if ($DIVIDER[$addr] || !defined($label));
    return unless defined($label);
	return if $DIVIDER[$addr];

	my($hline) = ';----------------------------------------------------------------------';
	$hline = ';======================================================================'
		if ($label =~ m{ROM PAGE});

    $DIVIDER[$addr] = 1;
    push(@{$EXTRA[$addr]},'');
    push(@{$EXTRA_IND[$addr]},0); $EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1; $EXTRA_AFTER_OP[$addr][$#{$EXTRA[$addr]}] = 0;
    push(@{$EXTRA[$addr]},$hline);
    push(@{$EXTRA_IND[$addr]},0); $EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1; $EXTRA_AFTER_OP[$addr][$#{$EXTRA[$addr]}] = 0;
    push(@{$EXTRA[$addr]},"; $label");
    push(@{$EXTRA_IND[$addr]},0); $EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1; $EXTRA_AFTER_OP[$addr][$#{$EXTRA[$addr]}] = 0;
    push(@{$EXTRA[$addr]},$hline);
    push(@{$EXTRA_IND[$addr]},0); $EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1; $EXTRA_AFTER_OP[$addr][$#{$EXTRA[$addr]}] = 0;
    push(@{$EXTRA[$addr]},'');
    push(@{$EXTRA_IND[$addr]},0); $EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1; $EXTRA_AFTER_OP[$addr][$#{$EXTRA[$addr]}] = 0;
}

#----------------------------------------------------------------------
# Disassembler Control
#----------------------------------------------------------------------

sub reset(@)                                                    # to allow restarting it
{
    $Address = $_[0] if (@_);                                   # address is optional argument
    
    $unclean = 0;                                               # set when disassebler encounters errors
    undef(@SCORE);                                              # list of score instruction addresses decoded

    undef(@LBL); undef(@OP); undef(@OPA); undef(@REM);          # label, operator, operands, remarks
    undef(@decoded);                                            # flag set to 1 to mark already decoded code
    undef(@TYPE);                                               # code type (only set for bytes with OPs)
    undef(@EXTRA);                                              # extra lines to add before OP
    undef(@DIVIDER);                                            # code divider to add before everything
    undef(@IND); undef(@EXTRA_IND);                             # indentation
    undef(@N_LABELS);                                           # # of labels pointing to address
}

my($sAddress,$sunclean,@sSCORE,@sLBL,@sOP,@sOPA,@sREM);         # saved state
my(@sdecoded,@sTYPE,@sEXTRA,@sDIVIDER,@sIND,@sEXTRA_IND);
my(@sN_LABELD);

sub save_state()
{
    $sAddress = $Address; $sunclean = $unclean;
    @sSCORE = @SCORE; @sLBL = @LBL; @sOP = @OP;
    @sOPA = @OPA; @sREM = @REM; @sdecoded = @decoded;
    @sTYPE = @TYPE; @sEXTRA = @EXTRA; @sDIVIDER = @DIVIDER;
    @sIND = @IND; @sEXTRA_IND = @EXTRA_IND; @sN_LABELS = @N_LABELS;
}

sub restore_state()
{
    $Address = $sAddress; $unclean = $sunclean;
    @SCORE = @sSCORE; @LBL = @sLBL; @OP = @sOP;
    @OPA = @sOPA; @REM = @sREM; @decoded = @sdecoded;
    @TYPE = @sTYPE; @EXTRA = @sEXTRA; @DIVIDER = @sDIVIDER;
    @IND = @sIND; @EXTRA_IND = @sEXTRA_IND; @N_LABELS = @sN_LABELS;
}

#----------------------------------------------------------------------
# WVM Disassembler
#----------------------------------------------------------------------

sub wvm_bitOp($$$)                                              # operation acting on lamps/flags
{
    my($opc,$ind,$op) = @_;
    return undef unless (BYTE($addr) eq $opc);
    my($base_addr) = $addr;
    
    $OP[$base_addr] = $op; $IND[$base_addr] = $ind;
    $decoded[$addr++] = 1;
    while (BYTE($addr)&0x80) {
        push(@{$OPA[$base_addr]},(BYTE($addr)&0x40) ?
                sprintf('Flag#%02X',BYTE($addr)&~0xC0) :
                sprintf('Lamp#%02X',BYTE($addr)&~0xC0));
        $decoded[$addr++] = 1;
    }
    push(@{$OPA[$base_addr]},(BYTE($addr)&0x40) ?
                sprintf('Flag#%02X',BYTE($addr)&~0xC0) :
                sprintf('Lamp#%02X',BYTE($addr)&~0xC0));
    $decoded[$addr++] = 1;
    return 1;
}

sub wvm_lampOp($$$)                                             # operation acting on lamps with masks
{                                                               # at least in system 11, these take multiple args
    my($opc,$ind,$op) = @_;
    return undef unless (BYTE($addr) eq $opc);
    my($base_addr) = $addr;
    
    $OP[$base_addr] = $op; $IND[$base_addr] = $ind;
    $decoded[$addr++] = 1;
    while (BYTE($addr)&0x80) {
        if (BYTE($addr)&0x40) {
            push(@{$OPA[$base_addr]},sprintf('Lamp#%02X|$40',BYTE($addr)&~0xC0));
        } else {
            push(@{$OPA[$base_addr]},sprintf('Lamp#%02X',BYTE($addr)&~0x80));
        }
        $decoded[$addr++] = 1;
    }
    if (BYTE($addr)&0x40) {
        push(@{$OPA[$base_addr]},sprintf('Lamp#%02X|$40',BYTE($addr)&~0x40));
    } else {
        push(@{$OPA[$base_addr]},sprintf('Lamp#%02X',BYTE($addr)));
    }
    $decoded[$addr++] = 1;
    return 1;
}

sub wvm_indOp($$$)                                              # operation acting on first 15 bytes of memory (registers)
{
    my($opc,$ind,$op) = @_;
    return undef unless (BYTE($addr) eq $opc);
    my($base_addr) = $addr;
    
    $OP[$base_addr] = $op; $IND[$base_addr] = $ind;
    $decoded[$addr++] = 1;
    while (BYTE($addr)&0x80) {                                  # at least in system 11 these take multiple args
        push(@{$OPA[$base_addr]},sprintf('[Reg-%c]',65+BYTE($addr)&~0x80));
        $decoded[$addr++] = 1;
    }
    push(@{$OPA[$base_addr]},sprintf('[Reg-%c]',65+BYTE($addr)));
    $decoded[$addr++] = 1;
    return 1;
}

sub wvm_bitgroupOp($$$)                                         # operation acting on flag/lamp groups
{
    my($opc,$ind,$op) = @_;
    return undef unless (BYTE($addr) eq $opc);
    my($base_addr) = $addr;
    
    $OP[$base_addr] = $op; $IND[$base_addr] = $ind;
    $decoded[$addr++] = 1;
    while (BYTE($addr)&0x80) {
        if (BYTE($addr)&0x40) {
            push(@{$OPA[$base_addr]},sprintf('Bitgroup#%02X|$40',BYTE($addr)&~0xC0));
        } else {
            push(@{$OPA[$base_addr]},sprintf('Bitgroup#%02X',BYTE($addr)&~0x80));
        }
        $decoded[$addr++] = 1;
    }
    if (BYTE($addr)&0x40) {
        push(@{$OPA[$base_addr]},sprintf('Bitgroup#%02X|$40',BYTE($addr)&~0x40));
    } else {
        push(@{$OPA[$base_addr]},sprintf('Bitgroup#%02X',BYTE($addr)));
    }
    $decoded[$addr++] = 1;
#    printf(STDERR "%04X: $OP[$base_addr] @{$OPA[$base_addr]}\n",$base_addr);
    return 1;
}

#----------------------------------------------------------------------
# Recursive Parser for WMS Expressions
#   - prefix notation (old infix code --- with bugs --- commented out above)
#   - argument to parse function determines type of expression result required:
#       - false: logical (logical statements, e.g. _If, %logicOr:, ...)
#       - true : arithmetic (math statements, e.g. %equal:, %bitOr:, ...)
#----------------------------------------------------------------------

sub wvm_parse_expr(@)                                                       # recursive descent parser for WVM7 expressions
{                                                                           # PREFIX NOTATION
    my($arithmetic_result) = @_;
    if (BYTE($addr) < 0xF0) {                                               # flags, lamps, adjustments and registers
        if ((BYTE($addr)&0xF0) == 0xD0) {
            die unless ($arithmetic_result);
            push(@{$OPA[$base_addr]},sprintf('Adj#%02X',BYTE($addr)&~0xF0));
        } elsif ((BYTE($addr)&0xF0) == 0xE0) {
            if ($arithmetic_result) {
                push(@{$OPA[$base_addr]},sprintf('Reg-%c',65+(BYTE($addr)&~0xF0)));
            } else {
                push(@{$OPA[$base_addr]},sprintf('[Reg-%c]',65+(BYTE($addr)&~0xF0)));
            }
        } elsif ((BYTE($addr)&0xC0) == 0x40) {
            if ($arithmetic_result) {
                push(@{$OPA[$base_addr]},sprintf('#$%02X',BYTE($addr)));
            } else {
                push(@{$OPA[$base_addr]},sprintf('Flag#%02X',BYTE($addr)&~0xC0));
            }
        } elsif ((BYTE($addr)&0xC0) == 0x80) {
            if ($arithmetic_result) {
                push(@{$OPA[$base_addr]},sprintf('#$%02X',BYTE($addr)))
            } else {
                push(@{$OPA[$base_addr]},sprintf('Bitgroup#%02X',BYTE($addr)&~0xC0));
            }
        } else {
            if ($arithmetic_result) {
                push(@{$OPA[$base_addr]},sprintf('#$%02X',BYTE($addr)));
            } else {
                push(@{$OPA[$base_addr]},sprintf('Lamp#%02X',BYTE($addr)));
            }
        }
        $decoded[$addr++] = 1;
    } elsif (BYTE($addr) == 0xF0) {                                         # GAME TILTED
        push(@{$OPA[$base_addr]},'%gameTilted');
        $decoded[$addr++] = 1;
    } elsif (BYTE($addr) == 0xF1) {
        push(@{$OPA[$base_addr]},'%gameOver');                              # GAME OVER
        $decoded[$addr++] = 1;
    } elsif (BYTE($addr) == 0xF2) {                                         # Number: prefix required for immediate values >= $F0
        push(@{$OPA[$base_addr]},'%number:');
        push(@{$OPA[$base_addr]},sprintf('#$%02X',BYTE($addr+1)));
        $decoded[$addr++] = $decoded[$addr++] = 1;
    }  elsif (BYTE($addr) == 0xF3) {                                     # LOGICAL NOT
        push(@{$OPA[$base_addr]},'%logicNot:');
        $decoded[$addr++] = 1;
        wvm_parse_expr();
    }  elsif (BYTE($addr) == 0xF4) {                                        # LAMP BLINKING
        push(@{$OPA[$base_addr]},'%lampBlinking:');
        $decoded[$addr++] = 1;
        push(@{$OPA[$base_addr]},(BYTE($addr) >= 0xE0) ?
                                        sprintf('[Reg-%c]',65+(BYTE($addr)&0x0F)) :
                                        sprintf('Lamp#%02X',BYTE($addr)));
        $decoded[$addr++] = 1;
    } elsif (BYTE($addr) == 0xF5) {                                         # BITGROUP ALL OFF
        push(@{$OPA[$base_addr]},'%allFlagsClear:');
        $decoded[$addr++] = 1;
        if (BYTE($addr) >= 0xE0) {                                          # indirect (register)
            push(@{$OPA[$base_addr]},sprintf('[Reg-%c]',65+(BYTE($addr)&0x0F)));
        } else {                                                            # lamp
            if (BYTE($addr) & 0x80) {
                push(@{$OPA[$base_addr]},(BYTE($addr) & 0x40) ?
                                            sprintf('Bitgroup#%02X|$C0',BYTE($addr)&~0xC0) :
                                            sprintf('Bitgroup#%02X',BYTE($addr)));
            } else {
                push(@{$OPA[$base_addr]},(BYTE($addr) & 0x40) ?
                                            sprintf('Bitgroup#%02X|$40',BYTE($addr)&~0x40) :
                                            sprintf('Bitgroup#%02X',BYTE($addr)));
            }
        }
        $decoded[$addr++] = 1;
    } elsif (BYTE($addr) == 0xF6) {                                         # BITGROUP ALL ON
        push(@{$OPA[$base_addr]},'%allFlagsSet:');
        $decoded[$addr++] = 1;
        if (BYTE($addr) >= 0xE0) {                                          # indirect (register)
            push(@{$OPA[$base_addr]},sprintf('[Reg-%c]',65+(BYTE($addr)&0x0F)));
        } else {                                                            # lamp 
            if (BYTE($addr) & 0x80) {
                push(@{$OPA[$base_addr]},(BYTE($addr) & 0x40) ?
                                            sprintf('Bitgroup#%02X|$C0',BYTE($addr)&~0xC0) :
                                            sprintf('Bitgroup#%02X',BYTE($addr)));
            } else {
                push(@{$OPA[$base_addr]},(BYTE($addr) & 0x40) ?
                                            sprintf('Bitgroup#%02X|$40',BYTE($addr)&~0x40) :
                                            sprintf('Bitgroup#%02X',BYTE($addr)));
            }
        }
        $decoded[$addr++] = 1;
    } elsif (BYTE($addr) == 0xF7) {                                         # LAMP OFF
        push(@{$OPA[$base_addr]},'%lampAltbuf:');
        $decoded[$addr++] = 1;
        if (BYTE($addr) >= 0xE0) {                                          # indirect (register)
            push(@{$OPA[$base_addr]},sprintf('[Reg-%c]',65+(BYTE($addr)&0x0F)));
        } else {                                                            # lamp 
            push(@{$OPA[$base_addr]},(BYTE($addr) & 0x40) ?
                                        sprintf('Lamp#%02X|$40',BYTE($addr)&~0x40) :
                                        sprintf('Lamp#%02X',BYTE($addr)));
        }
        $decoded[$addr++] = 1;
    } elsif (BYTE($addr) == 0xF8) {
        push(@{$OPA[$base_addr]},'%switchClosed:');                           # SWITCH
        $decoded[$addr++] = 1;
        push(@{$OPA[$base_addr]},(BYTE($addr) >= 0xE0) ?
                                        sprintf('[Reg-%c]',65+(BYTE($addr)&0x0F)) :
                                        sprintf('Switch#%02X',BYTE($addr)));
        $decoded[$addr++] = 1;
    } elsif (BYTE($addr) == 0xF9) {                                         # bitwise OR
        $decoded[$addr++] = 1;
        push(@{$OPA[$base_addr]},'%bitOr:');
        wvm_parse_expr(1); wvm_parse_expr(1);
    } elsif (BYTE($addr) == 0xFA) {                                         # logical AND
        $decoded[$addr++] = 1;
        push(@{$OPA[$base_addr]},'%logicAnd:');
        wvm_parse_expr(); wvm_parse_expr(); 
    } elsif (BYTE($addr) == 0xFB) {                                         # logical OR
        $decoded[$addr++] = 1;
        push(@{$OPA[$base_addr]},'%logicOr:');
        wvm_parse_expr(); wvm_parse_expr(); 
    } elsif (BYTE($addr) == 0xFC) {                                         # EQUAL
        $decoded[$addr++] = 1;
        push(@{$OPA[$base_addr]},'%equal:');
        wvm_parse_expr(1); wvm_parse_expr(1);
    } elsif (BYTE($addr) == 0xFD) {                                         # GREATER THAN
        $decoded[$addr++] = 1;
        push(@{$OPA[$base_addr]},'%greaterThan:');
        wvm_parse_expr(1); wvm_parse_expr(1);
    } elsif (BYTE($addr) == 0xFE) {                                         # FIND RUNNING THREADS
        $decoded[$addr++] = 1;
        push(@{$OPA[$base_addr]},'%findThread:');
        wvm_parse_expr(1);                                                  # Flags Mask
        if ($WMS_System == 11) {                                            # on sys7 thread id is number; on sys 11 it is expression
            wvm_parse_expr(1);
        } else {                                                            # in system 7, thread id is a constant
            push(@{$OPA[$base_addr]},sprintf('Thread#%02X',BYTE($addr)));
            $decoded[$addr++] = 1;
        }
    } elsif (BYTE($addr) == 0xFF) {                                         # bitwise AND
        $decoded[$addr++] = 1;
        push(@{$OPA[$base_addr]},'%bitAnd:');
        wvm_parse_expr(1); wvm_parse_expr(1);
    } else {
        printf("ABORT: Unknown WVM expression opcode \$%02X at addr \$%04X\n",BYTE($addr),$addr)
            if ($verbose > 0);
        $unclean = 1;
        return;
    }
}

sub wvm_branchOp($$$)
{
    my($opc,$ind,$op) = @_;
    return undef unless (BYTE($addr) eq $opc);
    local($base_addr) = $addr;

    $OP[$base_addr] = $op; $IND[$base_addr] = $ind;
    $decoded[$addr++] = 1;

    wvm_parse_expr();

    my($bra_target) = $addr + 1 + ((BYTE($addr) < 128) ? BYTE($addr) : BYTE($addr)-256);
    push(@{$OPA[$base_addr]},label_address($bra_target,$lbl_root));
    $decoded[$addr++] = 1;

    disassemble_wvm($ind,$bra_target,$lbl_root);
    return 1;
} 

sub wvm_jumpOp($$$)
{
    my($opc,$ind,$op) = @_;
    return undef unless (BYTE($addr) eq $opc);
    local($base_addr) = $addr;

    $OP[$base_addr] = $op; $IND[$base_addr] = $ind;
    $decoded[$addr++] = 1;

    wvm_parse_expr();

    my($bra_target) = WORD($addr);
    push(@{$OPA[$base_addr]},label_address($bra_target,$lbl_root));
    $decoded[$addr++] = $decoded[$addr++] = 1;

    disassemble_wvm($ind,$bra_target,$lbl_root);
    return 1;
} 

sub wvm_nargOp($$$)
{
    my($opc,$ind,$op) = @_;
    return undef unless (BYTE($addr) eq $opc);
    local($base_addr) = $addr;

    $OP[$base_addr] = $op; $IND[$base_addr] = $ind;
    $decoded[$addr++] = 1;
    return 1;
}

sub regVal($)                                                                       # signed single-byte register value
{
    my($usv) = @_;
    return sprintf('#%d',($usv > 127) ? ($usv - 256) : $usv);
}

sub disassemble_wvm(@)
{
    local($ind,$addr,$lbl_root,$divider_label) = @_;                                # local allows wvm_*() to modify $addr

    die("disassemble_wvm() requires defined \$WMS_System\n")
        unless defined($WMS_System);

    unless (defined(BYTE($addr))) {                                                 # outside loaded ROM range
        return if ($WMS_System == 7);                                               # okay for Sys 7
        printf(STDERR "; WARNING: WVM disassembly address %04X outside ROM range\n",$addr)
            if ($verbose > 0);
        $unclean = 1;
        return;
    }
    if ($decoded[$addr] && !defined($OP[$addr])) {                                  # not at start of instruction
        printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code\n",$addr)
            if ($verbose > 0);
        $unclean = 1;
        return;
    }
    insert_divider($addr,$divider_label);
    $N_LABELS[$addr]++;                                                             # we got here somehow, so there's a label

    while (!$decoded[$addr]) {
#       printf("WVM disassembling opcode %02X at %04X\n",BYTE($addr),$addr);

        my($base_addr) = $addr;
        $TYPE[$base_addr] = $CodeType_wvm;

        if (wvm_nargOp(0x00,$ind,'halt')) {                                             # miscellaneous operations
            printf(STDERR "; WARNING: halt WVM instruction at address \$%04X\n",$addr)
                if ($verbose > 0);
            next;
#           $unclean = 1;
#           return;
        }
        next   if wvm_nargOp(0x01,$ind,'noOperation');
        return if wvm_nargOp(0x02,$ind,'return');
        return if wvm_nargOp(0x03,$ind,'exitThread');
        if (wvm_nargOp(0x04,$ind,'M6800_mode')) {
            disassemble_asm($ind,$addr,$lbl_root);
            return;
        }
        next if wvm_nargOp(0x05,$ind,'awardSpecial');
        next if wvm_nargOp(0x06,$ind,'awardExtraball');

        if ($WMS_System == 11) {                                                        # System 11 additional opcodes (info from Scott Charles)
            if (BYTE($addr) == 0x07) {
                if ($decoded[$addr+1] || $decoded[$addr+2] || $decoded[$addr+3]) {
                    printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                        if ($verbose > 0);
                    $unclean = 1;
                    return;
                }
                $OP[$base_addr] = 'spawnThread6800'; $IND[$base_addr] = $ind;
                push(@{$OPA[$base_addr]},sprintf('Thread#%02X',BYTE($addr+1)));
                my($lbl) = label_with_addr($lbl_root,WORD($addr+2));
                push(@{$OPA[$base_addr]},label_address(WORD($addr+2),$lbl));
                $decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = $decoded[$addr+3] = 1;
                disassemble_asm($ind,WORD($addr+2),$lbl);
                $addr += 4;
                next;
            }

            if (BYTE($addr) == 0x08) {                                                  
                if ($decoded[$addr+1] || $decoded[$addr+2]) {
                    printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                        if ($verbose > 0);
                    $unclean = 1;
                    return;
                }
                $OP[$base_addr] = 'spawnThread6800_id06'; $IND[$base_addr] = $ind;
                my($lbl) = label_with_addr($lbl_root,WORD($addr+1));
                push(@{$OPA[$base_addr]},label_address(WORD($addr+1),$lbl));
                $decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = 1;
                disassemble_asm($ind,WORD($addr+1),$lbl);
                $addr += 3;
                next;
            }
            
            if (BYTE($addr) == 0x09) {
                if ($decoded[$addr+1] || $decoded[$addr+2] || $decoded[$addr+3]) {
                    printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                        if ($verbose > 0);
                    $unclean = 1;
                    return;
                }
                $OP[$base_addr] = 'spawnThread'; $IND[$base_addr] = $ind;
                push(@{$OPA[$base_addr]},sprintf('Thread#%02X',BYTE($addr+1)));
                my($lbl) = label_with_addr($lbl_root,WORD($addr+2));
                push(@{$OPA[$base_addr]},label_address(WORD($addr+2),$lbl));
                $decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = $decoded[$addr+3] = 1;
                disassemble_wvm($ind,WORD($addr+2),$lbl);
                $addr += 4;
                next;
            }

            if (BYTE($addr) == 0x0A) {
                if ($decoded[$addr+1] || $decoded[$addr+1]) {
                    printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                        if ($verbose > 0);
                    $unclean = 1;
                    return;
                }
                $OP[$base_addr] = 'spawnThread_id06'; $IND[$base_addr] = $ind;
                my($lbl) = label_with_addr($lbl_root,WORD($addr+1));
                push(@{$OPA[$base_addr]},label_address(WORD($addr+1),$lbl));
                $decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = 1;
                disassemble_wvm($ind,WORD($addr+1),$lbl);
                $addr += 3;
                next;
            }

            if (BYTE($addr) == 0x0B) {
                if ($decoded[$addr+1]) {
                    printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                        if ($verbose > 0);
                    $unclean = 1;
                    return;
                }
                # decrement counter in MSN, branch
                $OP[$base_addr] = 'decAndBranchUnless0'; $IND[$base_addr] = $ind;
                $decoded[$addr++] = 1;
                push(@{$OPA[$base_addr]},sprintf('Reg-%c',65+((BYTE($addr)&0xF0)>>4)));
                my($bra_offset) = WORD($addr) & 0x0FFF;
                my($bra_target) = $base_addr + 3 + (($bra_offset < 2048) ? $bra_offset : $bra_offset-4096);
                push(@{$OPA[$base_addr]},label_address($bra_target,$lbl_root));
                $decoded[$addr++] = $decoded[$addr++] = 1;
                disassemble_wvm($ind,$bra_target,$lbl_root);
                next;            
            }

            if (BYTE($addr) == 0x0C) {
                if ($decoded[$addr+1]) {
                    printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                        if ($verbose > 0);
                    $unclean = 1;
                    return;
                }
                $OP[$base_addr] = 'load'; $IND[$base_addr] = $ind;
                push(@{$OPA[$base_addr]},'Reg-A');
                push(@{$OPA[$base_addr]},sprintf('$%02X',BYTE($addr+1)));
                $decoded[$addr++] = $decoded[$addr++] = 1;
                next;            
            }

            if (BYTE($addr) == 0x0D) {
                if ($decoded[$addr+1]) {
                    printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                        if ($verbose > 0);
                    $unclean = 1;
                    return;
                }
                $OP[$base_addr] = 'store'; $IND[$base_addr] = $ind;
                push(@{$OPA[$base_addr]},'Reg-A');
                push(@{$OPA[$base_addr]},sprintf('$%02X',BYTE($addr+1)));
                $decoded[$addr++] = $decoded[$addr++] = 1;
                next;
            }
                
            if (BYTE($addr) == 0x0E) {
                if ($decoded[$addr+1]) {
                    printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                        if ($verbose > 0);
                    $unclean = 1;
                    return;
                }
                $OP[$base_addr] = 'load'; $IND[$base_addr] = $ind;
                push(@{$OPA[$base_addr]},'Reg-B');
                push(@{$OPA[$base_addr]},sprintf('$%02X',BYTE($addr+1)));
                $decoded[$addr++] = $decoded[$addr++] = 1;
                next;            
            }
                                
            if (BYTE($addr) == 0x0F) {
                if ($decoded[$addr+1]) {
                    printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                        if ($verbose > 0);
                    $unclean = 1;
                    return;
                }
                $OP[$base_addr] = 'store'; $IND[$base_addr] = $ind;
                push(@{$OPA[$base_addr]},'Reg-B');
                push(@{$OPA[$base_addr]},sprintf('$%02X',BYTE($addr+1)));
                $decoded[$addr++] = $decoded[$addr++] = 1;
                next;
            }
        } # if ($WMS_System == 11)

        next if wvm_bitOp(0x10,$ind,'setBits');                                         # flag & lamp operators
        next if wvm_bitOp(0x11,$ind,'clearBits');
        next if wvm_bitOp(0x12,$ind,'toggleBits');
        next if wvm_bitOp(0x13,$ind,'blinkLamps');
        next if wvm_indOp(0x14,$ind,'setBits');        # indirect
        next if wvm_indOp(0x15,$ind,'clearBits');      # indirect
        next if wvm_indOp(0x16,$ind,'toggleBits');     # indirect
        next if wvm_indOp(0x17,$ind,'blinkLamps');     # indirect
        next if wvm_bitgroupOp(0x18,$ind,'setBitgroups');
        next if wvm_bitgroupOp(0x19,$ind,'clearBitgroups');
        next if wvm_bitgroupOp(0x1A,$ind,'fillBitgroups');
        next if wvm_bitgroupOp(0x1B,$ind,'fillWrapBitgroups');
        next if wvm_bitgroupOp(0x1C,$ind,'drainBitgroups');
        next if wvm_bitgroupOp(0x1D,$ind,'rotLeftBitgroups');
        next if wvm_bitgroupOp(0x1E,$ind,'rotRightBitgroups');
        next if wvm_bitgroupOp(0x1F,$ind,'toggleBitgroups');

        next if wvm_lampOp(0x20,$ind,'setAltbuf');                                      # set lamp to alternate buffer
        next if wvm_lampOp(0x21,$ind,'clearAltbuf');                                    # set lamp to primary buffer
        next if wvm_lampOp(0x22,$ind,'toggleAltbuf');                                   # toggle lamp buffer to use
#       next if wvm_lampOp(0x23,$ind,'INVALID');                                        # this opcode does not exist
        next if wvm_indOp(0x24,$ind,'setAltbuf');
        next if wvm_indOp(0x25,$ind,'clearAltbuf');
        next if wvm_indOp(0x26,$ind,'toggleAltbuf');
#       next if wvm_indOp(0x27,$ind,'INVALID');                                        # this opcode does not exist
        next if wvm_bitgroupOp(0x28,$ind,'setBitgroupsAltbuf');
        next if wvm_bitgroupOp(0x29,$ind,'clearBitgroupsAltbuf');
        next if wvm_bitgroupOp(0x2A,$ind,'fillBitgroupsAltbuf');
        next if wvm_bitgroupOp(0x2B,$ind,'fillWrapBitgroupsAltbuf');
        next if wvm_bitgroupOp(0x2C,$ind,'drainBitgroupsAltbuf');
        next if wvm_bitgroupOp(0x2D,$ind,'rotLeftBitgroupsAltbuf');
        next if wvm_bitgroupOp(0x2E,$ind,'rotRightLGroupsAltbuf');
        next if wvm_bitgroupOp(0x2F,$ind,'toggleLGroupsAltbuf');
        
        if ((BYTE($addr)&0xF0) == 0x30) {                                               # solControl ($30-$3F)
            if ($decoded[$addr+1]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'solControl'; $IND[$base_addr] = $ind;
            my($nsol) = BYTE($addr)&0x0F;
            $decoded[$addr++] = 1;
            while ($nsol-- > 0) {
                my($sol)   = BYTE($addr)&0x1F;
                my($flags) = BYTE($addr)&0xE0;
                if    ($flags == 0x00) { $op = 'off'; }
                elsif ($flags == 0x20) { $op = '1-tic'; }
                elsif ($flags == 0x40) { $op = '2-tics'; }
                elsif ($flags == 0x60) { $op = '3-tics'; }
                elsif ($flags == 0x80) { $op = '4-tics'; }
                elsif ($flags == 0xA0) { $op = '5-tics'; }
                elsif ($flags == 0xC0) { $op = '6-tics'; }
                elsif ($flags == 0xE0) { $op = 'on'; }
                else { die(sprintf("solControl flags = \$%02X at addr \$%04X",$flags,$addr)); }
                push(@{$OPA[$base_addr]},sprintf('Sol#%02X:%s',$sol,$op));
                $decoded[$addr++] = 1;
            }
            next;
        }

        if (BYTE($addr) == 0x40) {                                                      # playSound_score
            if ($decoded[$addr+1] || $decoded[$addr+2]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'playSound_score'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = sprintf('Sound#%02X',BYTE($addr+1));
            $OPA[$base_addr][1] = sprintf('%dx%d PTS',(BYTE($addr+2)&0xF8)>>3,10**(BYTE($addr+2)&0x07));
            $decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = 1;
            push(@SCORE,$base_addr);
            if (((BYTE($addr+2)&0xF8)>>3) * (10**(BYTE($addr+2)&0x07)) > $unrealistic_score_limit) {
                printf("ABORT: unrealistic score %d at addr \$%04X\n",
                        ((BYTE($addr+2)&0xF8)>>3) * (10**(BYTE($addr+2)&0x07)),$addr)
                            if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $addr += 3;
            next;
        }
        if (BYTE($addr) == 0x41) {                                                        # queueScore
            if ($decoded[$addr+1]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'queueScore'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = sprintf('%dx%d PTS',(BYTE($addr+1)&0xF8)>>3,10**(BYTE($addr+1)&0x07));
            $decoded[$addr] = $decoded[$addr+1] = 1;
            push(@SCORE,$base_addr);
            if (((BYTE($addr+1)&0xF8)>>3) * (10**(BYTE($addr+1)&0x07)) > $unrealistic_score_limit) {
                printf("ABORT: unrealistic score %d at addr \$%04X\n",
                        ((BYTE($addr+1)&0xF8)>>3) * (10**(BYTE($addr+1)&0x07)),$addr)
                            if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $addr += 2;
            next;
        }
        if (BYTE($addr) == 0x42) {                                                        # score
            if ($decoded[$addr+1]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'score'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = sprintf('%dx%d PTS',(BYTE($addr+1)&0xF8)>>3,10**(BYTE($addr+1)&0x07));
            $decoded[$addr] = $decoded[$addr+1] = 1;
            push(@SCORE,$base_addr);
            if (((BYTE($addr+1)&0xF8)>>3) * (10**(BYTE($addr+1)&0x07)) > $unrealistic_score_limit) {
                printf("ABORT: unrealistic score %d at addr \$%04X\n",
                        ((BYTE($addr+1)&0xF8)>>3) * (10**(BYTE($addr+1)&0x07)),$addr)
                            if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $addr += 2;
            next;
        }
        if (BYTE($addr) == 0x43) {                                                        # score_digitSound
            if ($decoded[$addr+1]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'score_digitSound'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = sprintf('%dx%d PTS',(BYTE($addr+1)&0xF8)>>3,10**(BYTE($addr+1)&0x07));
            $decoded[$addr] = $decoded[$addr+1] = 1;
            push(@SCORE,$base_addr);
            if (((BYTE($addr+1)&0xF8)>>3) * (10**(BYTE($addr+1)&0x07)) > $unrealistic_score_limit) {
                printf("ABORT: unrealistic score %d at addr \$%04X\n",
                        ((BYTE($addr+1)&0xF8)>>3) * (10**(BYTE($addr+1)&0x07)),$addr)
                            if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $addr += 2;
            next;
        }

        if (BYTE($addr)>=0x44 && BYTE($addr)<=0x4F) {                                   # begin6800/end6800
            $OP[$base_addr] = 'begin6800'; $IND[$base_addr] = $ind;
            my($nbytes) = (BYTE($addr)&0x0F) - 2;                                       # max 13 bytes; 3 spare needed at end => 16-byte buffer
            $decoded[$addr++] = 1;
            disassemble_asm_nbytes($ind+1,$addr,$lbl_root,$nbytes,0);                   # $follow_code = 0
            undef($N_LABELS[$addr]);                                                    # ignore default label
            $addr += $nbytes;
            unshift(@{$EXTRA[$addr]},'end6800'); unshift(@{$EXTRA_IND[$addr]},$ind);
            unshift(@{$EXTRA_BEFORE_LABEL[$addr]},1);
            unshift(@{$EXTRA_AFTER_OP[$addr]},0);
            next;
        }

        if  (BYTE($addr) == 0x50) {                                                     # add two registers 
            if ($decoded[$addr+1]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'addTo'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = sprintf('Reg-%c',65+((BYTE($addr+1)&0xF0)>>4));
            $OPA[$base_addr][1] = sprintf('Reg-%c',65+(BYTE($addr+1)&0x0F));
            $decoded[$addr++] = $decoded[$addr++] = 1;
            next;
        }
        if  (BYTE($addr) == 0x51) {                                                     # copy value from one register to other
            if ($decoded[$addr+1]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'copyTo'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = sprintf('Reg-%c',65+((BYTE($addr+1)&0xF0)>>4));
            $OPA[$base_addr][1] = sprintf('Reg-%c',65+(BYTE($addr+1)&0x0F));
            $decoded[$addr++] = $decoded[$addr++] = 1;
            next;
        }

        if  (BYTE($addr) == 0x52) {                                                     # setThreadFlags
            if ($decoded[$addr+1]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'setThreadFlags'; $IND[$base_addr] = $ind;
            push(@{$OPA[$base_addr]},sprintf('Thread#%02X',BYTE($addr+1)));
            $decoded[$addr] = $decoded[$addr+1] = 1; 
            $addr += 2;
            next;
        }
        if (BYTE($addr) == 0x53) {                                                        # sleep / lSleep (the latter is only used when sleep would be better)
            if ($decoded[$addr+1]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = BYTE($addr+1) <= 0x0F ? 'sleep_subOptimal' : 'sleep'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = sprintf('%d',BYTE($addr+1));
            $decoded[$addr] = $decoded[$addr+1] = 1; 
            $addr += 2;
            next;
        }
        if (BYTE($addr) == 0x54) {                                                        # killThread
            if ($decoded[$addr+1] || $decoded[$addr+2] ) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'killThread'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = sprintf('$%02X',BYTE($addr+1));
            $OPA[$base_addr][1] = sprintf('$%02X',BYTE($addr+2));
            $decoded[$addr++] = $decoded[$addr++] = $decoded[$addr++] = 1; 
            next;
        }
        if (BYTE($addr) == 0x55) {                                                        # killThreads
            if ($decoded[$addr+1] || $decoded[$addr+2] ) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'killThreads'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = sprintf('#$%02X',BYTE($addr+1));
            $OPA[$base_addr][2] = sprintf('Thread#%02X',BYTE($addr+2));
            $decoded[$addr++] = $decoded[$addr++] = $decoded[$addr++] = 1; 
            next;
        }
        if (BYTE($addr) == 0x56) {                                                        # jumpSubroutine
            if ($decoded[$addr+1] || $decoded[$addr+2] ) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'jumpSubroutine'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = label_address(WORD($addr+1),$lbl_root);
            $decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = 1; 
            disassemble_wvm($code_base_indent,WORD($addr+1),$lbl_root);
            $addr += 3;
            next;
        }
        if (BYTE($addr) == 0x57) {                                                        # jumpSubroutine6800
            if ($decoded[$addr+1] || $decoded[$addr+2] ) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'jumpSubroutine6800'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = label_address(WORD($addr+1),$lbl_root);
            $decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = 1; 
            disassemble_asm($code_base_indent,WORD($addr+1),$lbl_root);
            $addr += 3;
            next;
        }
        next if wvm_jumpOp(0x58,$ind,'jumpIf');                                           # conditional jumps
        next if wvm_jumpOp(0x59,$ind,'jumpUnless');
        next if wvm_branchOp(0x5A,$ind,'branchIf');                                       # conditional branches
        next if wvm_branchOp(0x5B,$ind,'branchUnless');
        if (BYTE($addr) == 0x5C) {                                                        # jump6800
            if ($decoded[$addr+1] || $decoded[$addr+2] ) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'jump6800'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = label_address(WORD($addr+1),$lbl_root);
            $decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = 1; 
            disassemble_asm($code_base_indent,WORD($addr+1),$lbl_root);
            $addr += 3;
            return;
        }
        if (BYTE($addr) == 0x5D) {                                                        # triggerSwitches
             $OP[$base_addr] = 'triggerSwitches'; $IND[$base_addr] = $ind;
             $decoded[$addr++] = 1;
             while (BYTE($addr)&0x80) {
                if ($decoded[$addr]) {
                    printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                        if ($verbose > 0);
                    $unclean = 1;
                    return;
                }
                push(@{$OPA[$base_addr]},sprintf('Switch#%02X',BYTE($addr)&~0x80));
                $decoded[$addr++] = 1;
            }
            if ($decoded[$addr]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            push(@{$OPA[$base_addr]},sprintf('Switch#%02X',BYTE($addr)));
            $decoded[$addr++] = 1;
            next;
        }
        if (BYTE($addr) == 0x5E) {                                                        # clearSwitches
            $OP[$base_addr] = 'clearSwitches'; $IND[$base_addr] = $ind;
            $decoded[$addr++] = 1;
            while (BYTE($addr)&0x80) {
                if ($decoded[$addr]) {
                    printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                        if ($verbose > 0);
                    $unclean = 1;
                    return;
                }
                push(@{$OPA[$base_addr]},sprintf('Switch#%02X',BYTE($addr)&~0x80));
                $decoded[$addr++] = 1;
            }
            if ($decoded[$addr]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            push(@{$OPA[$base_addr]},sprintf('Switch#%02X',BYTE($addr)));
            $decoded[$addr++] = 1;
            next;
        }
        if (BYTE($addr) == 0x5F) {                                                        # jump
            if ($decoded[$addr+1] || $decoded[$addr+2] ) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'jump'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = label_address(WORD($addr+1),$lbl_root);
            $decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = 1; 
            disassemble_wvm($code_base_indent,WORD($addr+1),$lbl_root);
            $addr += 3;
            return;
        }

        if ((BYTE($addr)&0xF0) == 0x60) {                                               # sleep_indirect
            $OP[$base_addr] = 'sleep'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = sprintf('[Reg-%c]',65+(BYTE($addr)&0x0F));
            $decoded[$addr++] = 1;
            next;
        }

        if ((BYTE($addr)&0xF0) == 0x70) {                                               # sleep
            $OP[$base_addr] = 'sleep'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = sprintf('%d',BYTE($addr)&0x0F);
            $decoded[$addr++] = 1; 
            next;
        }

        if ((BYTE($addr)&0xF0) == 0x80) {                                               # branch
            if ($decoded[$addr+1]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            my($base_addr) = $addr;
            $OP[$base_addr] = 'branch'; $IND[$base_addr] = $ind;
            my($bra_offset) = WORD($base_addr) & 0xFFF;
            my($bra_target) = $base_addr + 2 + (($bra_offset < 2048) ? $bra_offset : $bra_offset-4096);
            $OPA[$base_addr][0] = label_address($bra_target,$lbl_root);
            $decoded[$addr++] = $decoded[$addr++] = 1;
            disassemble_wvm($ind,$bra_target,$lbl_root);
            return;
        }

        if ((BYTE($addr)&0xF0) == 0x90) {                                               # branchSubroutine
            if ($decoded[$addr+1]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            my($base_addr) = $addr;
            $OP[$base_addr] = 'branchSubroutine'; $IND[$base_addr] = $ind;
            my($bra_offset) = WORD($base_addr) & 0x0FFF;
            my($bra_target) = $base_addr + 2 + (($bra_offset < 2048) ? $bra_offset : $bra_offset-4096);
            $OPA[$base_addr][0] = label_address($bra_target,$lbl_root);
            $decoded[$addr++] = $decoded[$addr++] = 1;
            disassemble_wvm($code_base_indent,$bra_target,$lbl_root);
            next;
        }

        if ((BYTE($addr)&0xF0) == 0xA0) {                                               # branchSubroutine6800
            if ($decoded[$addr+1]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            my($base_addr) = $addr;
            $OP[$base_addr] = 'branchSubroutine6800'; $IND[$base_addr] = $ind;
            my($bra_offset) = WORD($base_addr) & 0x0FFF;
            my($bra_target) = $base_addr + 2 + (($bra_offset < 2048) ? $bra_offset : $bra_offset-4096);
            $OPA[$base_addr][0] = label_address($bra_target,$lbl_root);
            $decoded[$addr++] = $decoded[$addr++] = 1;
            disassemble_asm($code_base_indent,$bra_target,$lbl_root);
            next;
        }

        if ((BYTE($addr)&0xF0) == 0xB0) {                                               # add immediate signed byte value to register
            if ($decoded[$addr+1]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'addTo'; $IND[$base_addr] = $ind;
            my($regno) = BYTE($addr)&0x0F;
            $OPA[$base_addr][0] = sprintf('Reg-%c',65+$regno);
            $decoded[$addr++] = 1;
            $OPA[$base_addr][1] = regVal(BYTE($addr));
            $decoded[$addr++] = 1;
            next;
        }

        if ((BYTE($addr)&0xF0) == 0xC0) {                                               # loadRegister
            if ($decoded[$addr+1]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'load'; $IND[$base_addr] = $ind;
            my($regno) = BYTE($addr)&0x0F;
            $OPA[$base_addr][0] = sprintf('Reg-%c',65+$regno);
            $decoded[$addr++] = 1;
            $OPA[$base_addr][1] = regVal(BYTE($addr));
            $decoded[$addr++] = 1;
            next;
        }

        if ((BYTE($addr)&0xF0) == 0xD0) {                                               # playSound n-times
            if ($decoded[$addr+1]) {
                printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
                    if ($verbose > 0);
                $unclean = 1;
                return;
            }
            $OP[$base_addr] = 'playSound'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = sprintf('Sound#%02X:%dx',BYTE($addr+1),BYTE($addr)&0x0F);
            $decoded[$addr++] = $decoded[$addr++] = 1;
            next;
        }

        if ((BYTE($addr)&0xE0) == 0xE0) {                                               # playSound ($E0-$FF)
            $OP[$base_addr] = 'playSound'; $IND[$base_addr] = $ind;
            $OPA[$base_addr][0] = sprintf('Sound#%02X',BYTE($addr)&0x1F);
            $decoded[$addr++] = 1;
            next;
        }

        printf("ABORT: Unknown WVM$WMS_System opcode \$%02X at addr \$%04X\n",BYTE($addr),$addr)
            if ($verbose > 0);
        $unclean = 1;
        return;
    }
}

#----------------------------------------------------------------------
# .ORG
#----------------------------------------------------------------------

sub def_org($)
{
    my($addr) = @_;
    push(@{$EXTRA[$addr]},sprintf('.ORG $%04X',$addr));
    $EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1;
    $EXTRA_AFTER_OP[$addr][$#{$EXTRA[$addr]}] = 0;
}

#----------------------------------------------------------------------
# Label Arithmetic
#   - def_lbl_arith(<expr>) adds the current expression to a table
#   - table is used to add label expressions at the end
#----------------------------------------------------------------------

sub def_lbl_arith($)
{
    my($expr) = @_;
    die unless defined($Address);
    $label_arith_exprs{$Address} = $expr;
    return;
}

#----------------------------------------------------------------------
# Pointers in Data
#----------------------------------------------------------------------

sub def_ptr2lbl($)
{
    my($lbl) = @_;
    die unless defined($Address);
    $pointer{$Address} = $lbl;
    return;
}

#----------------------------------------------------------------------
# Define Values With Labels
#   - define constants (e.g. default number of balls per game)
#   - define pointers to several system tables
#   - define pointers to code sections (recursive disassembly)
#----------------------------------------------------------------------

sub def_word_hex(@)                                                                 # data word (not pointer)
{
    my($lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=2,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    $OP[$Address] = '.DW'; $IND[$Address] = $data_indent; $TYPE[$Address] = $CodeType_data;
    $OPA[$Address][0] = sprintf('$%04X!',WORD($Address));
    $REM[$Address] = $rem unless defined($REM[$Address]);
    insert_divider($Address,$divider_label);
    $decoded[$Address] = $decoded[$Address+1] = 1; $Address += 2;
}

sub def_ptr_hex(@)                                                                  # pointer (not data word)
{
    my($lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=2,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    $OP[$Address] = '.DW'; $IND[$Address] = $data_indent; $TYPE[$Address] = $CodeType_data;
    $OPA[$Address][0] = sprintf('$%04X',WORD($Address));
    $REM[$Address] = $rem unless defined($REM[$Address]);
    insert_divider($Address,$divider_label);
    $decoded[$Address] = $decoded[$Address+1] = 1; $Address += 2;
}

sub def_ptr_hex_alt(@)                                                              # pointer (not data word)
{
    my($lbl,$pointee_lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    die if ($decoded[$Address] || $decoded[$Address+1]);
    setLabel($lbl,$Address);
    $Address+=2,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    setLabel($pointee_lbl,WORD($Address));
    $OP[$Address] = '.DW'; $IND[$Address] = $data_indent; $TYPE[$Address] = $CodeType_data;
    $OPA[$Address][0] = sprintf('$%04X',WORD($Address));
    $REM[$Address] = $rem unless defined($REM[$Address]);
    insert_divider($Address,$divider_label);
    $decoded[$Address] = $decoded[$Address+1] = 1; $Address += 2;
}

sub def_byte_hex(@)
{
    my($lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address++,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    
    $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $OPA[$Address][0] = sprintf('$%02X!',BYTE($Address));
    $REM[$Address] = $rem unless defined($REM[$Address]); 
    insert_divider($Address,$divider_label);
    $decoded[$Address] = 1; $Address++;
    return BYTE($Address-1);
}

sub def_byte_bin(@)
{
    my($lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=1,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $OPA[$Address][0] = sprintf('$%08b',BYTE($Address));
    $REM[$Address] = $rem unless defined($REM[$Address]); 
    insert_divider($Address,$divider_label);
    $decoded[$Address] = 1; $Address++;
}

sub def_byte_dec(@)
{
    my($lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=1,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $OPA[$Address][0] = sprintf('%d',BYTE($Address));
    $REM[$Address] = $rem unless defined($REM[$Address]); 
    insert_divider($Address,$divider_label);
    $decoded[$Address] = 1; $Address++;
}

sub def_byte_LampOrFlag(@)
{
    die unless ($WMS_System == 6);
    my($lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=1,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    die(sprintf("Abort: Illegal System 6 Lamp or Flag byte (\$%02X) at address \$%04X\n",BYTE($Address),$Address))
         if (($WMS_System == 6) && (BYTE($Address) > 0x4F)) ||
            (($WMS_System != 6) && (BYTE($Address) > 0x7F));
    $OPA[$Address][0] = (BYTE($Address) < 0x40) 
                      ? sprintf('Lamp#%02X',BYTE($Address)) 
                      : sprintf('Flag#%02X',BYTE($Address)-0x40);
    $REM[$Address] = $rem unless defined($REM[$Address]); 
    insert_divider($Address,$divider_label);
    $decoded[$Address] = 1; $Address++;
}


sub def_checksum_byte(@)
{
    my($rem) = @_;
    die unless defined($Address);

    $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $OPA[$Address][0] = '@CHECKSUM_BYTE';
    $REM[$Address] = $rem unless defined($REM[$Address]); 
    insert_divider($Address,sprintf("Checksum Byte for Code Block \$%04X",$Address&0xF000));
    $decoded[$Address] = 1; $Address++;
}

#----------------------------------------------------------------------
# Text Strings
#----------------------------------------------------------------------

sub decode_STR_char($)
{
    my($c) = BYTE($_[0]);

    my($suffix) = '';
    if ($c & 0x80) {                                                # period after character
        $suffix = '.';
        $c &= 0x7F;
    }
    if ($c == 32)       { return ' ' . $suffix; }                                               # space
    elsif ($c <= 47)    { return sprintf('\\%02X',$c) . $suffix; }                              # other
    elsif ($c <= 57)    { return sprintf('%c',$c) . $suffix; }                                  # 0-9
    elsif ($c <= 64)    { return ' ' . $suffix; }                                               # space
    elsif ($c <= 90)    { return sprintf('%c',$c) . $suffix; }                                  # A-Z
    elsif ($c == 91)    { return '0' . $suffix; }                                               # fancy
    elsif ($c == 92)    { return '1' . $suffix; }                                               # fancy
    elsif ($c == 93)    { return '2' . $suffix; }                                               # fancy
    elsif ($c == 94)    { return '3' . $suffix; }                                               # fancy
    elsif ($c == 95)    { return '5' . $suffix; }                                               # fancy
    elsif ($c == 96)    { return '6' . $suffix; }                                               # fancy
    elsif ($c == 97)    { return '7' . $suffix; }                                               # fancy
    elsif ($c == 98)    { return '9' . $suffix; }                                               # fancy
    elsif ($c == 99)    { return '\\63' . $suffix; }                                            # all segments lit
    elsif ($c <= 104)   { return sprintf('%c',$c-40) . $suffix; }                               # < = > ? @
    elsif ($c <= 107)   { return sprintf('%c',$c-69) . $suffix; }                               # $ % &
    elsif ($c == 108)   { return ',' . $suffix; }
    elsif ($c == 109)   { return '.' . $suffix; }
    elsif ($c == 110)   { return '+' . $suffix; }
    elsif ($c == 111)   { return '-' . $suffix; }
    elsif ($c == 112)   { return '/' . $suffix; }
    elsif ($c == 113)   { return '\\' . $suffix; }
    elsif ($c <= 116)   { return sprintf('%c',$c-21) . $suffix; }                               # ] ^ _
    elsif ($c == 117)   { return '{' . $suffix; }
    elsif ($c == 118)   { return '*' . $suffix; }
    elsif ($c == 119)   { return '}' . $suffix; }
    elsif ($c == 120)   { return '"' . $suffix; }
    elsif ($c == 121)   { return '[' . $suffix; }
    elsif ($c == 121)   { return '@' . $suffix; }                                               # fancy
    else { return sprintf('\\%02X',$c) . $suffix; }                                             # other
}

sub def_string(@)
{
    my($len,$lbl,$divider_label,$rem) = @_;

    die unless defined($Address);
##  return if ($decoded[$Address]);     # disabled, since there are overlapping strings
    return if defined($OP[$Address]);

    insert_divider($Address,$divider_label);
    setLabel($lbl,$Address);
    $Address+=$len,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    
    $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $REM[$Address] = $rem unless defined($REM[$Address]); 
    $OP[$Address] = '.STR';
    my($o);
    $OPA[$Address][0] = "'";
    for ($o=0; $o<$len; $o++) {
        $OPA[$Address][0] .= decode_STR_char($Address+$o);
        $decoded[$Address+$o] = 1;
    }
    $OPA[$Address][0] .= "'";
#   printf(STDERR "def_string($len,$lbl,$divider_label,$rem) -> $OP[$Address] $OPA[$Address][0]\n");
    $Address += $o;
}   
            
sub def_string_table(@)
{
    my($nstr,$lbl,$divider_label,$rem,$def_len,@exceptions) = @_;

    die unless defined($Address);
    insert_divider($Address,$divider_label);

    my($next_exception,$eLen);                                                  # exception list
    for (my($s)=0; $s<$nstr; $s++) {
        setLabel(sprintf('^%s#%04X',$lbl,$s),$Address);
        $IND[$Address] = $data_indent; $TYPE[$Address] = $CodeType_data;
        $OP[$Address] = '.DW'; $OPA[$Address][0] = sprintf('$%04X',WORD($Address));
        $decoded[$Address] = $decoded[$Address+1] = 1; 
        $REM[$Address] = $rem unless defined($REM[$Address]); undef($rem);

        my($tmp) = $Address;                                                    # define string at pointer address
        $Address = WORD($Address);
        
        unless (defined($next_exception)) {                                     # list with string-length exceptions
            $next_exception = shift(@exceptions);
            if ($next_exception < 0) {
                $eLen = -$next_exception;
                $next_exception = shift(@exceptions);
            }
        }

        if (defined($next_exception) && $s == $next_exception) {                # this string is an exception
            def_string($eLen,sprintf('%s#%04X',$lbl,$s));
            undef($next_exception);
        } else {                                                                # this string is a default string
#           printf(STDERR "def_string($def_len,%s#%04X) @ %04X\n",$lbl,$s,$Address);
            def_string($def_len,sprintf('%s#%04X',$lbl,$s));
        }
        $Address = $tmp + 2;                                                    # continue with next string pointer in table
    }
}

#----------------------------------------------------------------------
# Grow Length-1 Strings
#   - extend 1-long strings to fill short gaps
#   - grows any string extending into a gap
#   - in order to avoid "overgrowing", define a label
#   - this was the first attempt at dealing with string tables with
#     overlapping strings
#   - while it more-or-less works, the problem is that there is a
#     single max_len for all strings, which is typically incorrect
#     as there are 8 and 16-long strings
#   - therefore, I did not use this in either Pinbot or Bad Cats
#----------------------------------------------------------------------

sub grow_1strings($)
{
    my($max_len) = @_;

    for (my($addr)=0; $addr<@ROM-1; $addr++) {
        next unless ($OP[$addr] eq '.STR');                                     # only grow .STR strings
        next if $decoded[$addr+1];                                              # ... that are length 1
        
#       print(STDERR "before: $OPA[$addr][0]\n");
        $OPA[$addr][0] = "'" . decode_STR_char($addr);
        for (my($o)=1; $o<$max_len; $o++) {
            last if defined($OP[$addr+$o]);
            $OPA[$addr][0] .= decode_STR_char($addr+$o);
            $decoded[$addr+$o] = 1;
        }
        $OPA[$addr][0] .= "'";
#       print(STDERR "after: $OPA[$addr][0]\n");
    }
}

#----------------------------------------------------------------------
# String Length
#----------------------------------------------------------------------

sub src_strlen($)                                                                   # true length of string 
{
    my($str) = @_;
    
    my($len) = 0;
    for (my($i)=0; $i<length($str); $i++) {
        my($c) = substr($str,$i,1);
        next if ($c eq '.');
        $i+=2 if ($c eq '\\');
        $len++;
    }
    return $len;
}

#----------------------------------------------------------------------
# Grow strings to fill gaps to next opcode
#----------------------------------------------------------------------

sub grow_strings($)
{
    my($max_len) = @_;

    for (my($addr)=$MIN_ROM_ADDR; $addr<$#ROM; $addr++) {
        next unless ($OP[$addr] eq '.STR');
        my($sl) = src_strlen($OPA[$addr][0]) - 2;
        if (!defined($OP[$addr+$sl])) {
#           printf(STDERR "lenthening length-$sl string $OPA[$addr][0] at address %04X\n",$addr);
            my($oa) = substr($OPA[$addr][0],0,length($OPA[$addr][0])-1);
            while (!defined($OP[$addr+$sl])) {
                $decoded[$addr+$sl] = 1;
                $oa .= decode_STR_char($addr+$sl++);
            }
            $oa .= "'";
            $OPA[$addr][0] = $oa;
        }
    }
}


#----------------------------------------------------------------------
# Trim Overlapping Strings
#   - re-encode all strings at the end when all labels are known
#   - do not lengthen strings
#----------------------------------------------------------------------

sub trim_overlapping_strings()
{
    for (my($addr)=0; $addr<@ROM-1; $addr++) {
        next unless ($OP[$addr] eq '.STR');
        my($ssl) = src_strlen($OPA[$addr][0]) - 2;                                      # current length of source string
        $OPA[$addr][0] = "'" . decode_STR_char($addr);
        for (my($o)=1; $o<$ssl; $o++) {
            last if defined($OP[$addr+$o]);
            $OPA[$addr][0] .= decode_STR_char($addr+$o);
        }
        $OPA[$addr][0] .= "'";
    }
}

#----------------------------------------------------------------------
# Define 7-Segment String
#----------------------------------------------------------------------

sub def_7segment_string(@)
{
    my($len,$lbl,$divider_label,$rem) = @_;

    die unless defined($Address);
    insert_divider($Address,$divider_label);

    setLabel($lbl,$Address);
    $Address+=$len,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $REM[$Address] = $rem unless defined($REM[$Address]); 
    $OP[$Address] = '.S7R';
    my($o);
    $OPA[$Address][0] = "'";
    for ($o=0; $o<$len; $o++) {
        my($c) = BYTE($Address+$o);
        if ($c == 0x3F) { $OPA[$Address][0] .= '0'; }
        elsif ($c == 0x06) { $OPA[$Address][0] .= '1'; }    # also I
        elsif ($c == 0x5B) { $OPA[$Address][0] .= '2'; }    # also Z
        elsif ($c == 0x4F) { $OPA[$Address][0] .= '3'; }
        elsif ($c == 0x66) { $OPA[$Address][0] .= '4'; }
        elsif ($c == 0x6D) { $OPA[$Address][0] .= '5'; }    # also S
        elsif ($c == 0x7D) { $OPA[$Address][0] .= '6'; }
        elsif ($c == 0x07) { $OPA[$Address][0] .= '7'; }
        elsif ($c == 0x7F) { $OPA[$Address][0] .= '8'; }    # also B
        elsif ($c == 0x6F) { $OPA[$Address][0] .= '9'; }
        elsif ($c == 0x77) { $OPA[$Address][0] .= 'A'; }
        elsif ($c == 0x7C) { $OPA[$Address][0] .= 'b'; }
        elsif ($c == 0x39) { $OPA[$Address][0] .= 'C'; }    # also K (in German)
        elsif ($c == 0x58) { $OPA[$Address][0] .= 'c'; }
        elsif ($c == 0x5E) { $OPA[$Address][0] .= 'd'; }
        elsif ($c == 0x79) { $OPA[$Address][0] .= 'E'; }
        elsif ($c == 0x71) { $OPA[$Address][0] .= 'F'; }
        elsif ($c == 0x3D) { $OPA[$Address][0] .= 'G'; } 
        elsif ($c == 0x76) { $OPA[$Address][0] .= 'H'; }
        elsif ($c == 0x74) { $OPA[$Address][0] .= 'h'; }
        elsif ($c == 0x04) { $OPA[$Address][0] .= 'i'; }
        elsif ($c == 0x1E) { $OPA[$Address][0] .= 'J'; }
        elsif ($c == 0x38) { $OPA[$Address][0] .= 'L'; }
        elsif ($c == 0x37) { $OPA[$Address][0] .= 'N'; }
        elsif ($c == 0x54) { $OPA[$Address][0] .= 'n'; }
        elsif ($c == 0x5C) { $OPA[$Address][0] .= 'o'; }
        elsif ($c == 0x73) { $OPA[$Address][0] .= 'P'; }
        elsif ($c == 0x67) { $OPA[$Address][0] .= 'q'; }    # maybe also g?
        elsif ($c == 0x31) { $OPA[$Address][0] .= 'R'; }    # F without middle line
        elsif ($c == 0x50) { $OPA[$Address][0] .= 'r'; }
        elsif ($c == 0x78) { $OPA[$Address][0] .= 't'; }    
        elsif ($c == 0x3E) { $OPA[$Address][0] .= 'U'; }    # also V
        elsif ($c == 0x1C) { $OPA[$Address][0] .= 'u'; }
        elsif ($c == 0x6E) { $OPA[$Address][0] .= 'Y'; }
        elsif ($c == 0x00) { $OPA[$Address][0] .= ' '; }
        elsif ($c == 0x40) { $OPA[$Address][0] .= '-'; }
        elsif ($c == 0x08) { $OPA[$Address][0] .= '_'; }
        elsif ($c == 0x0F) { $OPA[$Address][0] .= ']'; }
        elsif ($c == 0x01) { $OPA[$Address][0] .= '~'; }
        elsif ($c == 0x48) { $OPA[$Address][0] .= '='; }
        elsif ($c == 0x22) { $OPA[$Address][0] .= '"'; }
        elsif ($c == 0x02) { $OPA[$Address][0] .= '`'; }
        elsif ($c == 0x20) { $OPA[$Address][0] .= "'"; }
        elsif ($c == 0x64) { $OPA[$Address][0] .= '\\'; }
        elsif ($c == 0x52) { $OPA[$Address][0] .= '/'; }
        elsif ($c == 0x30) { $OPA[$Address][0] .= '|'; }
        elsif ($c == 0x43) { $OPA[$Address][0] .= ')'; }
        elsif ($c == 0x61) { $OPA[$Address][0] .= '('; }
        elsif ($c == 0x63) { $OPA[$Address][0] .= '*'; }
        elsif ($c == 0x5F) { $OPA[$Address][0] .= '&'; }
        elsif ($c == 0x21) { $OPA[$Address][0] .= '^'; }
        elsif ($c == 0x3D) { $OPA[$Address][0] .= '%'; }
        elsif ($c == 0x46) { $OPA[$Address][0] .= '}'; }
        elsif ($c == 0x3D) { $OPA[$Address][0] .= '{'; }
        elsif ($c == 0x4B) { $OPA[$Address][0] .= '?'; }
        elsif ($c == 0x18) { $OPA[$Address][0] .= '<'; }
        elsif ($c == 0x0C) { $OPA[$Address][0] .= '>'; }
        else { $OPA[$Address][0] .= sprintf('\%02X',$c); }
        $decoded[$Address+$o] = 1;
    }
    $OPA[$Address][0] .= "'";
    $Address += $o;
}   
            
sub def_7segment_table(@)
{
    my($nstr,$lbl,$divider_label,$rem,$def_len,@exceptions) = @_;

    die unless defined($Address);
    insert_divider($Address,$divider_label);

    my($next_exception,$eLen);                                                  # exception list
    for (my($s)=0; $s<$nstr; $s++) {
        setLabel(sprintf('%s#%04X_',$lbl,$s),$Address);
        $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
        $OP[$Address] = '.DW'; $OPA[$Address][0] = sprintf('$%04X',WORD($Address));
        $decoded[$Address] = $decoded[$Address+1] = 1; 
        $REM[$Address] = $rem unless defined($REM[$Address]); undef($rem);
        
        my($tmp) = $Address;
        $Address = WORD($Address);
        
        unless (defined($next_exception)) {
            $next_exception = shift(@exceptions);
            if ($next_exception < 0) {
                $eLen = -$next_exception;
                $next_exception = shift(@exceptions);
            }
        }

        if (defined($next_exception) && $s == $next_exception) {                # this string is an exception
            def_7segment_string($eLen,sprintf('%s#%04X',$lbl,$s));
            undef($next_exception);
        } else {                                                                # this string is a default string
            def_7segment_string(7,sprintf('%s#%04X',$lbl,$s));
        }
        $Address = $tmp + 2;
    }
}


#----------------------------------------------------------------------
# Flag Group Table Pointer
#   length is 15 for JL and 14 for PB => needs to be supplied (manually?)
#----------------------------------------------------------------------

sub def_bitgrouptable_ptr(@)
{
    my($nentries,$lbl,$bgt_lbl,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=2,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    $OP[$Address] = '.DW'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $OPA[$Address][0] = $bgt_lbl; $REM[$Address] = $rem unless defined($REM[$Address]); 
    $decoded[$Address] = $decoded[$Address+1] = 1; 
    
    my($saved_addr) = $Address;
    $Address = WORD($Address);
    def_bitgrouptable($nentries,$bgt_lbl);
    $Address = $saved_addr + 2;
}

my($bitgrouptable_lbl);                             
sub def_bitgrouptable(@)
{
    my($nentries,$lbl,$rem) = @_;
    die unless defined($Address);

    $bitgrouptable_lbl = $lbl;
    insert_divider($Address,'Bit Group Table');
    setLabel($lbl,$Address);
    $Address+=$nentries*2,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    for (my($bg)=0; $bg<$nentries; $bg++) {
        $OP[$Address+2*$bg] = '.DB'; $IND[$Address+2*$bg] = $data_indent; $TYPE[$Address+2*$bg] =  $CodeType_data;
        if (BYTE($Address+2*$bg) < 0x40) {
            $OPA[$Address+2*$bg][0] = sprintf('Lamp#%02X',BYTE($Address+2*$bg));
            $OPA[$Address+2*$bg][1] = sprintf('Lamp#%02X',BYTE($Address+2*$bg+1));
        } else {
            $OPA[$Address+2*$bg][0] = sprintf('Flag#%02X',BYTE($Address+2*$bg) & 0x3F);
            $OPA[$Address+2*$bg][1] = sprintf('Flag#%02X',BYTE($Address+2*$bg+1) & 0x3F);
        }
        $decoded[$Address+2*$bg] = $decoded[$Address+2*$bg+1] = 1;
    }
    $Address += $nentries * 2;
}


#----------------------------------------------------------------------
# Switch Table Pointer
#----------------------------------------------------------------------

my($switchtable_lbl);

sub def_switchtable_ptr(@)
{
    my($nentries,$lbl,$swtbl_lbl,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=2,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    $OP[$Address] = '.DW'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $OPA[$Address][0] = $swtbl_lbl; $REM[$Address] = $rem unless defined($REM[$Address]); 
    $decoded[$Address] = $decoded[$Address+1] = 1; 
    $switchtable_lbl = $swtbl_lbl;

    my($svAddress) = $Address;
    $Address = WORD($Address);
    setLabel($swtbl_lbl,$Address);
    insert_divider($Address,'Switch Table');
    for (my($sw)=0; $sw<$nentries; $sw++) {
        $REM[$Address] = defined($Switch[$sw]) ? sprintf("switch # %d ($Switch[$sw])",$sw+1)
                                               : sprintf('switch # %d',$sw+1);
        $OP[$Address] = '.DBW'; $IND[$Address] = $data_indent; $TYPE[$Address] = $CodeType_data;
        $OPA[$Address][0] = sprintf('%%%08b',BYTE($Address));
        $decoded[$Address] = $decoded[$Address+1] = $decoded[$Address+2] = 1;
        my($swn) = defined($Switch[$sw]) ? $Switch[$sw] : sprintf('sw_%02X',$sw);
        if (WORD($Address+1) > 0) {
            $OPA[$Address][1] = label_address(WORD($Address+1),$swn.'_handler',1);      # suppress address suffix in label
            setLabel($swn.'_handler',WORD($Address+1));
            disassemble_wvm($code_base_indent,WORD($Address+1),$swn.'_handler',"Switch Handler ($swn)"); 
        } else {
            $OPA[$Address][1] = 'NULL';
        }
        $Address += 3;
    }
    $Address = $svAddress + 2;
}


#----------------------------------------------------------------------
# Sound Table Pointer
#----------------------------------------------------------------------

my($soundtable_lbl);

sub parse_complex_sound($$)
{
    my($addr,$lbl) = @_;

    setLabel($lbl,$addr);
    $OP[$addr]   = '.DB';
    $IND[$addr]  = $data_indent;
    $TYPE[$addr] = $CodeType_data;

    for (my($nbytes)=1,my($col)=0,my($full)=0; ; $nbytes++,$col++) {
        if ($col > 7) {                                             # new line every 8th byte
            $full++;
            $OP[$addr+8*$full] = '.DB';
            $IND[$addr+8*$full] = $data_indent;
            $TYPE[$addr+8*$full] = $CodeType_data;
            $col = 0;
        }

        if (BYTE($addr+$nbytes-1) == 0xF9) {                            # quote
            push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
            $decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
        } elsif (BYTE($addr+$nbytes-1) == 0xFA) {                       # jump (parser does not follow!!!)
            push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
            $decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
            push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
            $decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
            push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
            $decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
            last;
        } elsif (BYTE($addr+$nbytes-1) == 0xFC) {                       # gobble next 2 bytes
            push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
            $decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
            push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
            $decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
        } elsif (BYTE($addr+$nbytes-1) == 0xFD) {                       # gobble next byte
            push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
            $decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
        } elsif (BYTE($addr+$nbytes-1) == 0xFE) {                       # gobble next byte
            push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
            $decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
        } elsif (BYTE($addr+$nbytes-1) == 0xFF) {                       # end of list
            push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
            $decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
            last;
        }
        push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
        $decoded[$addr+$nbytes-1] = 1;
    }       
}

sub def_soundtable_ptr(@)
{
    my($nentries,$lbl,$sndtbl_lbl,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=2,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    $OP[$Address] = '.DW'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $OPA[$Address][0] = $sndtbl_lbl; $REM[$Address] = $rem unless defined($REM[$Address]); 
    $decoded[$Address] = $decoded[$Address+1] = 1; 
    $soundtable_lbl = $sndtbl_lbl;

    my($saved_addr) = $Address;
    $Address = WORD($Address);
    insert_divider($Address,'Sound Table');
    my($csound);
    for (my($snd)=0; $snd<$nentries; $snd++) {
        setLabel($sndtbl_lbl,$Address) if ($snd == 0);
        $IND[$Address] = $data_indent; $TYPE[$Address] = $CodeType_data;
        if (BYTE($Address+2) == 0xFF) {
            $OP[$Address] = '.DWB';
            push(@{$OPA[$Address]},sprintf('$%04X',WORD($Address)));
            push(@{$OPA[$Address]},sprintf('$%02X!',BYTE($Address+2)));
            parse_complex_sound(WORD($Address),
                                sprintf("${sndtbl_lbl}_csound#%d",++$csound));
        } else {
            $OP[$Address] = '.DB';
            push(@{$OPA[$Address]},sprintf('$%02X!',BYTE($Address)));
            push(@{$OPA[$Address]},sprintf('$%02X!',BYTE($Address+1)));
            push(@{$OPA[$Address]},sprintf('$%02X!',BYTE($Address+2)));
        }
        $decoded[$Address] = $decoded[$Address+1] = $decoded[$Address+2] = 1; 
        $Address += 3;
    }
    $Address = $saved_addr + 2;     
}

#----------------------------------------------------------------------
# Code Pointers
#----------------------------------------------------------------------

sub def_code_ptr(@)
{
    my($lbl,$code_lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=2,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);

    my($code_addr) = WORD($Address);
    my($usr_lbl) = $LBL[$code_addr];
    $code_lbl = $usr_lbl if defined($usr_lbl);
    setLabel($code_lbl,$code_addr);

    $OP[$Address] = '.DW'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $OPA[$Address][0] = $code_lbl; $REM[$Address] = $rem unless defined($REM[$Address]); 
    $decoded[$Address] = $decoded[$Address+1] = 1;

    disassemble_asm($code_base_indent,$code_addr,$code_lbl,$divider_label);
    $Address += 2;
}


sub def_wvm_code_ptr(@)
{
    my($lbl,$code_lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=2,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);

    my($code_addr) = WORD($Address);
    my($usr_lbl) = $LBL[$code_addr];
    $code_lbl = $usr_lbl if defined($usr_lbl);
    setLabel($code_lbl,$code_addr);

    $OP[$Address] = '.DW'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $OPA[$Address][0] = $code_lbl; $REM[$Address] = $rem unless defined($REM[$Address]); 
    $decoded[$Address] = $decoded[$Address+1] = 1;

    disassemble_wvm($code_base_indent,$code_addr,$code_lbl,$divider_label);
    $Address += 2;
}

sub def_code(@)                                      # does not update $Address
{
    my($lbl,$divider_label) = @_;
    die("$lbl,$divider_label") unless defined($Address);

    my($usr_lbl) = $LBL[$Address];
    $lbl = $usr_lbl if defined($usr_lbl);
    setLabel($lbl,$Address);
    return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);

    disassemble_asm($code_base_indent,$Address,$lbl,$divider_label);
}


sub def_wvm_code(@)                              # does not update $Address
{
    my($lbl,$divider_label) = @_;
    die unless defined($Address);

    my($usr_lbl) = $LBL[$Address];
    $lbl = $usr_lbl if defined($usr_lbl);
    setLabel($lbl,$Address);
    return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);

    disassemble_wvm($code_base_indent,$Address,$lbl,$divider_label);
}

sub def_byteblock_bin(@)
{
    my($nbytes,$lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=$nbytes,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    insert_divider($Address,$divider_label) if defined($divider_label);

	my($bAddress) = $Address;
    $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $OPA[$Address][0] = sprintf('%%%08b',BYTE($Address)); $REM[$Address] = $rem unless defined($REM[$Address]);
    $decoded[$Address++] = 1;

    for (my($i)=1; $i<$nbytes; $i++) {
        $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
        $OPA[$Address][0] = sprintf('%%%08b',BYTE($Address));
        $decoded[$Address++] = 1;
    }
    insert_empty_line($bAddress);
}


sub def_byteblock_hex(@)
{
    my($nbytes,$lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=$nbytes,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    insert_divider($Address,$divider_label) if defined($divider_label);

	my($bAddress);
    do {
        printf(STDERR "def_byteblock_hex(@_) operator already defined ($OP[$Address],$decoded[$Address]) at \$%04X\n",$Address)
            if (defined($OP[$Address]));
        $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
        $REM[$Address]=$rem,undef($rem) unless defined($REM[$Address]);
        $bAddress = $Address;
#       die if (@{$OPA[$bAddress]});
        for (my($col)=0; $nbytes>0 && $col<8; $col++,$nbytes--) {
            push(@{$OPA[$bAddress]},sprintf('$%02X!',BYTE($Address)));
            $decoded[$Address++] = 1;
        }
    } while ($nbytes > 0);
    insert_empty_line($bAddress);
}


#----------------------------------------------------------------------
# Similar to def_byteblock_hex, except that
#   1) already decoded bytes are silently ignored. This is necessary
#      for dasm files generated with C711 -x where checksum bytes are
#      defined before regular disassembly. Special treatment is needed,
#      because there may be a checksum byte following # a data table.
#   2) pointers in data tables are handled correctly
#----------------------------------------------------------------------

sub def_byteblock_hex_magic(@)
{
    my($nbytes,$lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=$nbytes,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    insert_divider($Address,$divider_label) if defined($divider_label);

DB_STATEMENT:
    while ($nbytes > 0) {
        $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
        $REM[$Address]=$rem,undef($rem) unless defined($REM[$Address]);
        my($bAddress) = $Address;
        for (my($col)=0; $nbytes>0 && $col<8; $col++,$nbytes--) {
            if (defined($pointer{$Address})) {
                die unless ($nbytes >= 2);
                $OP[$Address] = '.DW'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
                $OPA[$Address][0] = $pointer{$Address};
                $decoded[$Address++] = $decoded[$Address++] = 1;
                $nbytes -= 2;
                next DB_STATEMENT;
            } 
            push(@{$OPA[$bAddress]},sprintf('$%02X!',BYTE($Address)))
                unless ($decoded[$Address]);
            $decoded[$Address++] = 1;
        }
    }
}


sub def_byteblock_hex_cols(@)
{
    my($nbytes,$ncols,$lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=$nbytes,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    insert_divider($Address,$divider_label) if defined($divider_label);

    my($n) = 0;
    for (my($i)=0; $i<$nbytes; $i++,$n++) {
        $decoded[$Address+$n] = 1;
        if ($n == $ncols) {
            $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
            for (my($j)=0; $j<$n; $j++) { push(@{$OPA[$Address]},sprintf('$%02X!',BYTE($Address+$j))); }
            $Address += $n; $n = 0;
        }
    }
    $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    for (my($j)=0; $j<$n; $j++) { push(@{$OPA[$Address]},sprintf('$%02X!',BYTE($Address+$j))); }
    $Address += $n;
    insert_empty_line($Address-$n);
}


sub def_bytelist_hex(@)                                                         # value-terminated list
{
    my($EOL,$lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    insert_divider($Address,$divider_label) if defined($divider_label);

    do {
        $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
        $REM[$Address]=$rem,undef($rem) unless defined($REM[$Address]);
        my($bAddress) = $Address;
        for (my($col)=0; BYTE($Address)!=$EOL && $col<8; $col++) {
            push(@{$OPA[$bAddress]},sprintf('$%02X!',BYTE($Address)));
            $decoded[$Address++] = 1;
        }
    } while (BYTE($Address)!=$EOL);
    $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    push(@{$OPA[$Address]},sprintf('$%02X!',BYTE($Address)));
    $decoded[$Address++] = 1;
    insert_empty_line($Address-1);
}

sub def_bytelist_hex_cols(@)                                                    # value-terminated list
{
    my($bytes_in_block,$EOL,$lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    insert_divider($Address,$divider_label) if defined($divider_label);

    my($n) = 0;
    for (my($i)=0; BYTE($Address+$n-1)!=$EOL; $i++,$n++) {
        $decoded[$Address+$n] = 1;
        if ($n == $bytes_in_block) {
            $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
            for (my($j)=0; $j<$n; $j++) { push(@{$OPA[$Address]},sprintf('$%02X!',BYTE($Address+$j))); }
            $Address += $n; $n = 0;
        }
    }
    $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    for (my($j)=0; $j<$n; $j++) { push(@{$OPA[$Address]},sprintf('$%02X!',BYTE($Address+$j))); }
    $Address += $n;
}


sub def_byteblock_code(@)
{
    my($nbytes,$lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=$nbytes,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);

    disassemble_asm_nbytes($code_base_indent,$Lbl{$lbl},$lbl,$nbytes,0,$divider_label); # follow_code = 0
    my($ngap) = 0;
    for (my($a)=$Address+$nbytes-1; !$decoded[$a]; $a--) {
        $ngap++;
        $decoded[$a] = 1;
    }
    $Address += $nbytes - $ngap;
    if ($ngap > 0) {
        $OP[$Address] = '.DB';
        $IND[$Address] = $data_indent;
        $TYPE[$Address] = $CodeType_data;
        for (my($i)=0; $i<$ngap; $i++) {
            push(@{$OPA[$Address]},sprintf('$%02X!',BYTE($Address+$i)));
        }
        $Address += $ngap;
    }
}


sub def_wordblock_hex(@)                                                        # data words (not pointers)
{
    my($nbytes,$lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=$nbytes,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    insert_divider($Address,$divider_label) if defined($divider_label);

    $OP[$Address] = '.DW'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $OPA[$Address][0] = sprintf('$%04X!',WORD($Address)); $REM[$Address] = $rem unless defined($REM[$Address]);
    $decoded[$Address++] = $decoded[$Address++] = 1;

    for (my($i)=2; $i<$nbytes; $i+=2) {
        $OP[$Address] = '.DW'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
        $OPA[$Address][0] = sprintf('$%04X!',WORD($Address));
        $decoded[$Address++] = $decoded[$Address++] = 1;
    }
    insert_empty_line($Address-2);
}

sub def_ptrblock_hex(@)                                                         # block with pointers (not regular data words)
{
    my($nbytes,$lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=$nbytes,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    insert_divider($Address,$divider_label) if defined($divider_label);

    $OP[$Address] = '.DW'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $OPA[$Address][0] = sprintf('$%04X',WORD($Address)); $REM[$Address] = $rem unless defined($REM[$Address]);
    $decoded[$Address++] = $decoded[$Address++] = 1;

    for (my($i)=2; $i<$nbytes; $i+=2) {
        $OP[$Address] = '.DW'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
        $OPA[$Address][0] = sprintf('$%04X',WORD($Address));
        $decoded[$Address++] = $decoded[$Address++] = 1;
    }
    insert_empty_line($Address-2);
}


sub def_bytebyteblock_hex(@)
{
    my($nbytes,$lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=$nbytes,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    insert_divider($Address,$divider_label) if defined($divider_label);

    $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data; $REM[$Address] = $rem unless defined($REM[$Address]);
    $OP[$Address] = '.DB'; 
    $OPA[$Address][0] = sprintf('$%02X!',BYTE($Address)); $OPA[$Address][1] = sprintf('$%02X!',BYTE($Address+1));
    $decoded[$Address++] = $decoded[$Address++] = 1;

    for (my($i)=2; $i<$nbytes; $i+=2) {
        $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
        $OP[$Address] = '.DB'; 
        $OPA[$Address][0] = sprintf('$%02X!',BYTE($Address)); $OPA[$Address][1] = sprintf('$%02X!',BYTE($Address+1));
        $decoded[$Address++] = $decoded[$Address++] = 1;
    }
    insert_empty_line($Address-2);
}

sub def_wordbyteblock_hex(@)
{
    my($nbytes,$lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    $Address+=$nbytes,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    insert_divider($Address,$divider_label) if defined($divider_label);

    $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data; $REM[$Address] = $rem unless defined($REM[$Address]);
    $OP[$Address] = '.DWB'; 
    $OPA[$Address][0] = sprintf('$%04X',WORD($Address)); $OPA[$Address][1] = sprintf('$%02X!',BYTE($Address+2));
    $decoded[$Address++] = $decoded[$Address++] = $decoded[$Address++] = 1;

    for (my($i)=3; $i<$nbytes; $i+=3) {
        $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
        $OP[$Address] = '.DWB'; 
        $OPA[$Address][0] = sprintf('$%04X',WORD($Address)); $OPA[$Address][1] = sprintf('$%02X!',BYTE($Address+2));
        $decoded[$Address++] = $decoded[$Address++] = $decoded[$Address++] = 1;
    }
    insert_empty_line($Address-3);
}

sub def_bytebytelist_hex(@)                                                         # value-terminated list (end of list can be specific high- or low-byte value)
{
    my($EOLhb,$EOLlb,$lbl,$divider_label,$rem) = @_;
    die unless defined($Address);
    setLabel($lbl,$Address);
    return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
    insert_divider($Address,$divider_label) if defined($divider_label);

    $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $OPA[$Address][0] = sprintf('$%02X!',BYTE($Address));
    $OPA[$Address][1] = sprintf('$%02X!',BYTE($Address+1));
    $REM[$Address] = $rem unless defined($REM[$Address]);
    $decoded[$Address++] = $decoded[$Address++] = 1;
    
    return if (BYTE($Address-2)==$EOLhb || BYTE($Address-1)==$EOLlb);

    for (my($i)=2; BYTE($Address)!=$EOLhb && BYTE($Address+1)!=$EOLlb; $i++) {
        $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
        $OPA[$Address][0] = sprintf('$%02X!',BYTE($Address));
        $OPA[$Address][1] = sprintf('$%02X!',BYTE($Address+1));
        $decoded[$Address++] = $decoded[$Address++] = 1;
    }
    if (BYTE($Address+1)==$EOLhb) {
        $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
        $OPA[$Address][0] = sprintf('$%02X!',BYTE($Address));
        $OPA[$Address][1] = sprintf('$%02X!',BYTE($Address+1));
        $decoded[$Address++] = $decoded[$Address++] = 1;
		die if ($Address-2 == 0x44B1 && $_cur_RPG == 0x31);
    } else {
        $OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
        $OPA[$Address][0] = sprintf('$%02X!',BYTE($Address));
        $decoded[$Address++] = 1;
	    insert_empty_line($Address-1);
    }
}

sub tablerow_newline($$)
{
    my($addr,$op) = @_;

    $OP[$addr]      = $op;
    $IND[$addr]     = $data_indent;
    $TYPE[$addr]    = $CodeType_data;
    $REM[$addr]     = $rem unless defined($REM[$addr]);
}

sub def_tablerow(@)                                                 # format chars: h)ex no label, H)ex w/label, $ ptr to M6800 code, ^ ptr (returned)
{
    my($fmt,$lbl,$divider_label,$rem) = @_;
    die unless defined($Address);

    setLabel($lbl,$Address) if defined($lbl);
    insert_divider($Address,$divider_label) if defined($divider_label);


    $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
    $REM[$Address] = $rem unless defined($REM[$Address]);

    my($retval);
    my($base_addr) = $Address;
    my($prev_fmt,$bytes_consumed,$prev_pragma);
    for (my($i)=0; $i<length($fmt); $i++) {
        my($f) = substr($fmt,$i,1);

        if ($f ne $prev_fmt) {                                      # same format, same line
            tablerow_newline($base_addr,$prev_pragma);              # different format new line
            $base_addr += $bytes_consumed;
            $bytes_consumed = 0;
        }

        if ($f eq 'h') {                                            # hex bytes without label substitution
            $prev_pragma = '.DB';
            push(@{$OPA[$base_addr]},sprintf('$%02X!',BYTE($Address)));
            $bytes_consumed++;
            $decoded[$Address++] = 1;
        } elsif ($f eq 'H') {                                      # hex bytes with label substitution
            $prev_pragma = '.DB';
            push(@{$OPA[$base_addr]},sprintf('$%02X',BYTE($Address)));
            $bytes_consumed++;
            $decoded[$Address++] = 1;
        } elsif ($f eq 's') {                                      # string (length taken from argument)
            $prev_pragma = '.STR';
            my($len) = '';
            while ($i+1<length($fmt) && ord(substr($fmt,$i+1,1))>=48 &&
                                        ord(substr($fmt,$i+1,1))<=57) {
                                                $len .= substr($fmt,++$i,1);
                                        }
            push(@{$OPA[$base_addr]},"'");
            for (my($i)=0; $i<$len; $i++) {
                $OPA[$base_addr][$#{$OPA[$base_addr]}] .= sprintf('%c',BYTE($Address));
                $decoded[$Address++] = 1;
            }
            $OPA[$base_addr][$#{$OPA[$base_addr]}] .= "'";
            $bytes_consumed += $len;
            $f = '';                                                # suppress combination of multiple strings on same line
        } elsif ($f eq '^') {                                       # pointer (value of last pointer in format is returned by def_tablerow)
            $prev_pragma = '.DW';
            my($target) = WORD($Address);
            push(@{$OPA[$base_addr]},label_address(WORD($Address),$lbl));
            $decoded[$Address++] = $decoded[$Address++] = 1;
            $retval = $target;
            $bytes_consumed += 2;
        } elsif ($f eq '$') {                                       # pointer to M6800 code
            $prev_pragma = '.DW';
            my($target) = WORD($Address);
            push(@{$OPA[$base_addr]},label_address(WORD($Address),"${lbl}_code"));
            disassemble_asm($code_base_indent,$target,"${lbl}_code");
            $decoded[$Address++] = $decoded[$Address++] = 1;
            $retval = $target;
            $bytes_consumed += 2;
        } else {
            die("def_tablerow: unknown format character $f\n");
        }
        $prev_fmt = $f; 
    }

    tablerow_newline($base_addr,$prev_pragma);

    return $retval;
}

#----------------------------------------------------------------------
# Code Exploration (Scanning)
#----------------------------------------------------------------------

sub isMember($@)
{
    my($target,@list) = @_;

    foreach my $le (@list) {
        return 1 if ($le eq $target);
    }
    return 0;
}

sub find_pointers_to_score_routines($$)
{
    my($code_begin,$code_end) = @_;

    for (my($addr)=$code_begin; $addr<$code_end; $addr++) {
        next unless (WORD($addr) >= $code_begin &&
                     WORD($addr) <= $code_end);
        reset($addr);
        printf("Scanning %04X\n",$Address);
        def_wvm_code_ptr('wvm_code_ptr','wvm_code');
        if (!$unclean && @SCORE) {
            printf("# ptr_to_scoring_routine %04X at %04X preceded by opcode %02X\n",WORD($addr),$addr,BYTE($addr-1));
        }
    }
}

sub find_WVM_code_table($$$$)
{
    my($code_begin,$code_end,$min_len,$pad_bytes) = @_;

    $code_end-- if ($code_end == 0xFFFF);
    my($save_verbose) = $verbose; $verbose = 0;

    my(%in_table) = ();
START_ADDR:
    for (my($start_addr)=$code_begin; $start_addr<$code_end; $start_addr++) {
        my($len); $len = 0;
        my($addr) = $start_addr;

        next if ($in_table{$start_addr+$pad_bytes});

        while (WORD($addr+$pad_bytes) >= $code_begin &&
               WORD($addr+$pad_bytes) <= $code_end) {
                    $len++; $addr += 2 + $pad_bytes;
        }
        if ($len >= $min_len) {
            printf("# possible WVM code table (%d entries) at \$%04X\n",$len,$start_addr);
            my($ptr);
            $unclean = 0;
            for ($ptr=0; $ptr<$len && !$unclean; $ptr++) {
                my($ptr_addr) = $Address = $start_addr + $ptr*(2 + $pad_bytes) + $pad_bytes;
                reset();
                def_wvm_code_ptr("ptr$ptr","ptr$ptr_");
                if ($unclean) {
                    printf("unclean ptr$ptr at \$%04X\n",$ptr_addr);
                    next START_ADDR;
                } else {
                    printf("clean ptr$ptr pointer at \$%04X -> \$%04X\n",$ptr_addr,WORD($ptr_addr));
                    $in_table{$ptr_addr} = 1;
                }
            }
            printf("CLEAN length $len at \$%04X!\n",$start_addr) if !$unclean;
            $start_addr += $ptr*(2 + $pad_bytes);
        }
    }
    reset();
    $verbose = $save_verbose;
}

# find next 16 bits in code that look like a pointer and start disassembly
# there

sub scan_next_6800_pointer($$)
{
    my($code_begin,$code_end) = @_;

    while ($Address < $code_end &&
            (WORD($Address) == 0xFFFF ||
             WORD($Address)<$code_begin ||
             WORD($Address)>$code_end)) { $Address++; }
             
    def_code_ptr('code_ptr','system_hook','System Hook');
}
    
#----------------------------------------------------------------------
# Game Specific Identifiers
#----------------------------------------------------------------------

sub substitute_identifiers(@)                                                               # substitute game-specific identifiers
{
    my($fa,$la) = @_;
    $fa = 0 unless defined($fa);
    $la = $#ROM unless defined($la);

    for (my($addr)=$fa; $addr<=$la; $addr++) {
        next unless defined($OP[$addr]);
        for (my($i)=0; $i<@{$OPA[$addr]}; $i++) {
            if ($OPA[$addr][$i] =~ m{^Adj#([0-9A-Fa-f]{2,4})}) {                            # adjustments
                $OPA[$addr][$i] = $Adj[hex($1)] . $' if defined($Adj[hex($1)]);
            } elsif ($OPA[$addr][$i] =~ m{^Sol#}) {                                         # solenoids
                my($num,$len) = ($' =~ m{([0-9A-Fa-f]+)(.*)});
                $OPA[$addr][$i] = $Sol[hex($num)] . $len if defined($Sol[hex($num)]);
            } elsif ($OPA[$addr][$i] =~ m{^Lamp#([0-9A-Fa-f]{1,3})}) {                      # lamps
            	if (defined($_cur_RPG)) {
            		die(sprintf("%04X: $OP[$addr] @{$OPA[$addr]}",$addr)) unless numberp($1);
	                $OPA[$addr][$i] = $Lamp[$1] . $' if defined($Lamp[$1]);
            	} else {
            		die(sprintf("%04X: $OP[$addr] @{$OPA[$addr]}",$addr))
						unless length($1) == 2;
	                $OPA[$addr][$i] = $Lamp[hex($1)] . $' if defined($Lamp[hex($1)]);
	            }
            } elsif ($OPA[$addr][$i] =~ m{^Flag#([0-9A-F]{2})}) { 							# flags
                $OPA[$addr][$i] = $Flag[hex($1)] . $' if defined($Flag[hex($1)]);
            } elsif ($OPA[$addr][$i] =~ m{^Bitgroup#([0-9A-Fa-f]{2,4})}) {                  # bitgroups
                $OPA[$addr][$i] = $BitGroup[hex($1)] . $' if defined($BitGroup[hex($1)]);
            } elsif ($OPA[$addr][$i] =~ m{^Sound#([0-9A-Fa-f]{2,4})}) {                     # sounds
                $OPA[$addr][$i] = $Sound[hex($1)] . $' if defined($Sound[hex($1)]);
            } elsif ($OPA[$addr][$i] =~ m{^Switch#([0-9A-F]{2})}) { 						# switches
                $OPA[$addr][$i] = $Switch[hex($1)] . $' if defined($Switch[hex($1)]);
            } elsif ($OPA[$addr][$i] =~ m{^Thread#([0-9A-F]{2,4})$}) {						# threads
                $OPA[$addr][$i] = $Thread[hex($1)] . $' if defined($Thread[hex($1)]);
            } elsif ($OPA[$addr][$i] =~ m{^Error#([0-9A-F]{2})}) {                       	# errors (WPC)
                $OPA[$addr][$i] = $Error[hex($1)] . $' if defined($Error[hex($1)]);
            } elsif ($OPA[$addr][$i] =~ m{^Audit#([0-9A-F]{4})}) {                       	# audits (WPC)
                $OPA[$addr][$i] = $Audit[hex($1)] . $' if defined($Audit[hex($1)]);
            } elsif ($OPA[$addr][$i] =~ m{^DMD#([0-9A-F]{2})}) {                          	# DMD animations (WPC)
                $OPA[$addr][$i] = $DMD[hex($1)] . $' if defined($DMD[hex($1)]);
            } 
        }
    }
}

#----------------------------------------------------------------------
# Produce Output
#   - also deals with gaps & .ORGs
#----------------------------------------------------------------------

sub strlen($)
{
    my($s) = @_;

    my($len) = 0;
    for (my($i)=0; $i<length($s); $i++) {
        if (substr($s,$i,1) eq "\t") {
            $len = (int($len / $hard_tab) + 1) * $hard_tab;
        } else {
            $len++;
        }
    }
    return $len;
}

sub indent($$)
{
    my($line,$col) = @_;
    my($ind) = '';
    $ind .= "\t" while (strlen($line.$ind) < $col);
    $ind = ' ' if (length($ind)==0 && length($line)>0 && !($line =~ m{\s$}));
    return $ind;
}

sub output_aliases($$@)
{
    my($title,$fmt,@aliases) = @_;
    return unless (@aliases);

    print(";----------------------------------------------------------------------\n");
    print("; $title\n");
    print(";----------------------------------------------------------------------\n\n");

    for (my($i)=0; $i<@aliases; $i++) {
        next unless defined($aliases[$i]);
        $line = '.DEFINE';
        $line .= indent($line,$hard_tab*$def_name_indent);
        $line .= $aliases[$i];
        $line .= indent($line,$hard_tab*$def_val_indent) . sprintf($fmt,$i);
        print("$line\n");
    }
    print("\n");
}

sub output_keyValue_aliases($@)
{
    my($title,%kv) = @_;
    return unless (%kv);

    print(";----------------------------------------------------------------------\n");
    print("; $title\n");
    print(";----------------------------------------------------------------------\n\n");

    foreach my $key (sort { $kv{$a} <=> $kv{$b} } keys(%kv)) {
        next unless defined($kv{$key});
        $line = '.DEFINE';
        $line .= indent($line,$hard_tab*$def_name_indent);
        $line .= $key;
        $line .= indent($line,$hard_tab*$def_val_indent) . sprintf('$%02X',$kv{$key});
        print("$line\n");
    }
    print("\n");
}

sub byHexValue {
    (numberp($Lbl{$a}) ? sprintf('  :%04X',$Lbl{$a}) : $Lbl{$a}) cmp (numberp($Lbl{$b}) ? sprintf('  :%04X',$Lbl{$b}) : $Lbl{$b});
}

sub output_labels($)
{
    my($title) = @_;

    print(";----------------------------------------------------------------------\n");
    print("; $title\n");
    print(";----------------------------------------------------------------------\n\n");

    foreach my $lbl (sort byHexValue keys %Lbl) {
        next if ($lbl =~ m{(.*)\+[1-9]$} && defined($Lbl{$1}));             # e.g. =Lamps+2
        my($lv) = $Lbl{$lbl};
        next unless defined($lv);                                           # undefined label?

        if (numberp($lv)) {
            next if defined($ROM[$lv]);                                     # not an external label
            $line = '.LBL'; 
            $line .= indent($line,$hard_tab*$def_name_indent) . $lbl;
            $line .= indent($line,$hard_tab*$def_val_indent) .
                        sprintf(($lv > 0xFF)?"\$%04X\n":"\$%02X\n",$Lbl{$lbl});
        } else {
            my($pg,$addr) = split(':',$lv);
            next if $decodedPG[hex($pg)][hex($addr)-0x4000];                # not an external label
            $line = '.LBL'; 
            $line .= indent($line,$hard_tab*$def_name_indent) . $lbl;
            $line .= indent($line,$hard_tab*$def_val_indent) . $lv . "\n";
        }
        print($line);
    }
    print("\n");
}

sub print_addr($)
{
	my($addr) = @_;

	if (defined($_cur_RPG) && $addr<0x8000) {
		printf("<%02X:%04X>\t",$_cur_RPG,$addr);
	} elsif (defined($_cur_RPG)) {
	   printf("<FF:%04X>\t",$addr);
	} else {
		printf("<%04X>\t",$addr);
	}
}


sub produce_output(@)                                               
{                                                                   
    my($fa,$la,$hdr) = @_;
    $fa = 0 unless defined($fa);
    $la = $#ROM unless defined($la);
    $hdr = 1 unless defined($hdr);

    my($org,$line);
    my($decoded) = my($ROMbytes) = 0;

    if ($hdr) {
        output_aliases('Solenoid Aliases','Sol#%02X',@Sol);
        output_aliases('Lamp Aliases','Lamp#%02X',@Lamp);
        output_aliases('Flag Aliases','Flag#%02X',@Flag);
        output_aliases('Bitgroup Aliases','Bitgroup#%02X',@BitGroup);
        output_aliases('Switch Aliases','Switch#%02X',@Switch);
        output_aliases('Sound Aliases','Sound#%02X',@Sound);
        if (defined($_cur_RPG)) {
	        output_aliases('Thread Aliases','Thread#%04X',@Thread);
        } else {
	        output_aliases('Thread Aliases','Thread#%02X',@Thread);
	    }
        output_keyValue_aliases('System Constants',%systemConstants);
        output_aliases('Game Adjustment Aliases','Adj#%02X',@Adj);   
        output_aliases('Audit Aliases','Audit#%04X',@Audit);  		
##      output_aliases('Error Aliases','Error#%02X',@Error);				# clutter
        output_labels("System$WMS_System API (external labels)");           # manually defined labels outside ROM
    }

    my($gapLen,$codeStarted);
    for (my($addr)=$fa; $addr<=$la; $addr++) {                              # loop through addresses
        $decoded++ if $decoded[$addr];
        $ROMbytes++ if defined(BYTE($addr));
        if (defined($OP[$addr])) {                                          # there is code at this address

			#------------------------------------------------------------------------------------------
			# Pre-Label Pseudo Ops
			#------------------------------------------------------------------------------------------

			for (my($i)=0; $i<@{$EXTRA[$addr]}; $i++) { 					# first, print the pre-label constructs (ENDIF, ...)
				next unless ($EXTRA_BEFORE_LABEL[$addr][$i]);
				$line .= indent($line,$hard_tab*$EXTRA_IND[$addr][$i]) . $EXTRA[$addr][$i];
				print_addr($addr) if ($print_addrs);
				printf('			')	   if ($print_code);
				print("$line\n"); undef($line);
			}

			#------------------------------------------------------------------------------------------
			# .ORG
			#------------------------------------------------------------------------------------------

            unless (defined($org)) {                                        # new .ORG after a gap
				if ($code_started) {
					print("\n");
				} elsif (!($WMS_System =~ m{^WPC})) {
					print_addr($addr) if ($print_addrs);
					printf('			')	if ($print_code);
					print(";----------------------------------------------------------------------\n");
					print_addr($addr) if ($print_addrs);
					printf('			')	if ($print_code);
					print("; GAME ROM START\n");
					print_addr($addr) if ($print_addrs);
					printf('			')	if ($print_code);
					print(";----------------------------------------------------------------------\n");
					print_addr($addr) if ($print_addrs);
					print("\n");
					$code_started = 1;
                }
                print_addr($addr) if ($print_addrs);
                printf('            ')  if ($print_code);
                $line = indent('',$hard_tab*$IND[$addr]) . '.ORG';
                $line .= indent($line,$hard_tab*($IND[$addr]+$op_width[3]));
                $org = $addr;
                if ($WMS_System =~ m{^WPC} && $org < 0x8000) {
                    $line .= sprintf("\$%02X:%04X",$_cur_RPG,$org);
                } else {
                    $line .= sprintf('$%04X',$org);
                }
##              $line .= sprintf("\t\t; %d-byte gap",$gapLen)
##                  if ($gapLen > 0);
                $line .= "\n";                  
                print($line); $line = '';
                $gapLen = 0;
            }

			#------------------------------------------------------------------------------------------
			# Labels
			#------------------------------------------------------------------------------------------

            my($lbl) = $LBL[$addr];                                                 # then, any labels (NB: multiple possible, required for auto disassembly)
            if (defined($lbl)) {
	            $lbl = $' if ($lbl =~ m{^[0-9A-F]{2}:}); 							# strip WPC page prefix
                $line = "$lbl:";
                my($ind) = ($EXTRA_IND[$addr][$#{$EXTRA_IND[$addr]}] > 0)           # indent to use
                          ? $EXTRA_IND[$addr][$#{$EXTRA_IND[$addr]}] : $IND[$addr];
				if (length($line) >= $hard_tab*$ind) {								# long label => separate line
					$line .= indent($line,$hard_tab*$rem_indent)."\t; ".$REM[$addr],undef($REM[$addr])
						if defined($REM[$addr]);									# comment
					print_addr($addr) if ($print_addrs);							# output the line
					printf('			')	if ($print_code);
					print("$line\n"),undef($line)							   
				}
			}

			#------------------------------------------------------------------------------------------
			# Post-Label Pseudo Ops
			#------------------------------------------------------------------------------------------

			for (my($i)=0; $i<@{$EXTRA[$addr]}; $i++) { 							# then, "extra" OPs (always pseudo ops)
				next if ($EXTRA_BEFORE_LABEL[$addr][$i] || $EXTRA_AFTER_OP[$addr][$i]);
				$line .= indent($line,$hard_tab*$EXTRA_IND[$addr][$i]) . $EXTRA[$addr][$i];
				print_addr($addr) if ($print_addrs);
				printf('			')	   if ($print_code);
				print("$line\n"); undef($line);
			}
			 
			#------------------------------------------------------------------------------------------
			# Statements (Operators and Op Args)
			#------------------------------------------------------------------------------------------

			$line .= indent($line,$hard_tab*$IND[$addr]) . $OP[$addr];				# then, the operator
			$line .= indent($line,$hard_tab*($IND[$addr]+$op_width[$TYPE[$addr]]))	# and any operands
				unless ($OP[$addr] eq '!');											# don't add whitespace after ! op
##			foreach my $opa (@{$OPA[$addr]}) {
##				$opa = $1.$' if ($opa =~ m{^(#)?([0-9A-F]{2}):}) && (hex($2)==$_cur_RPG);	# remove PG prefix of same-page labels 
##				$line .= $opa . ' ';
##			}
			for (my($i)=0; $i<@{$OPA[$addr]}; $i++) {
				if ($i>0 && $TYPE[$addr]==$CodeType_data && defined($LBL[$addr+$i])) {			# label inside data block
					die("stray label <$LBL[$addr+$i]> disallowed outside .DB block (implementation restricton)\n")
						unless ($OP[$addr] eq '.DB');
					$OP[$addr+$i] = '.DB'; $IND[$addr+$i] = $data_indent; $TYPE[$addr+$i] =  $CodeType_data;
					@{$OPA[$addr+$i]} = @{$OPA[$addr]}[$i..$#{$OPA[$addr]}];
					last;
				}
				my($opa) = $OPA[$addr][$i];
				$opa = $1.$' if ($opa =~ m{^(#)?([0-9A-F]{2}):}) && (hex($2)==$_cur_RPG);	# remove PG prefix of same-page labels 
				$line .= $opa . ' ';
			}

			#------------------------------------------------------------------------------------------
			# Comments
			#------------------------------------------------------------------------------------------

			$line .= indent($line,$hard_tab*$rem_indent)."\t; ".$REM[$addr],undef($REM[$addr])
				if defined($REM[$addr]);

			#------------------------------------------------------------------------------------------
			# Address (optional), Code (optional) and Source (mandatory) Output
			#------------------------------------------------------------------------------------------

			print_addr($addr) if ($print_addrs);
			if ($print_code) {
				printf('%02X ',BYTE($addr));
				my($i);
				for ($i=1; $decoded[$addr+$i] && !defined($OP[$addr+$i]); $i++) {
					printf('%02X ',BYTE($addr+$i));
				}
				while ($i < 4) {
					print('   ');
					$i++;
				}
			}

			print("$line\n"); undef($line);

			#------------------------------------------------------------------------------------------
			# Post-Operation Pseudo Ops
			#------------------------------------------------------------------------------------------

			for (my($i)=0; $i<@{$EXTRA[$addr]}; $i++) { 							# then, "extra" OPs (always pseudo ops)
				next unless ($EXTRA_AFTER_OP[$addr][$i]);
				$line .= indent($line,$hard_tab*$EXTRA_IND[$addr][$i]) . $EXTRA[$addr][$i];
				print_addr($addr) if ($print_addrs);
				printf('			')	   if ($print_code);
				print("$line\n"); undef($line);										
			}
			 
		} elsif (!$decoded[$addr]) {												# this address was not decoded -> gap

			#------------------------------------------------------------------------------------------
			# Analysis Gap
			#------------------------------------------------------------------------------------------

			if ($fill_gaps && defined($org)) {										# output gaps as byte blocks
				if ($print_code) {
					for (my($a)=$addr+1; $a<=$MAX_ROM_ADDR; $a++) {
						die(sprintf("$0: cannot print code at address %04X with gap auto filling enabled (implementation restriction)\n",$addr))
							if ($decoded[$a]);
                    }
					last;															# gap extends to end of ROM
                }
				my($n) = 1;															# count repeat bytes
				my($GB) = BYTE($addr);
				while ($addr+$n<=$la && !$decoded[$addr+$n] && BYTE($addr+$n)==$GB) { $n++; }
				
				#------------------------------------------------------------------------------------------
				# Free Space
				#------------------------------------------------------------------------------------------

	FREE_GAP_SPACE:
				if ($GB==0xFF && $n>20) {											# FREE SPACE
					$freeBytes += $n;
					print_addr($addr) if ($print_addrs);
					print("\n"); print_addr($addr) if ($print_addrs);
					print(";----------------------------------------------------------------------\n");
					print_addr($addr) if ($print_addrs);
					printf("; FREE SPACE (%.1f KB)\n",$n/1024);
					print_addr($addr) if ($print_addrs);
					print(";----------------------------------------------------------------------\n");
					print_addr($addr) if ($print_addrs);
					print("\n"); print_addr($addr) if ($print_addrs);
					undef($org);
					$addr --;

#					FOLLOWING CODE INSTEAD OF undef($org) FILLS EMPTY SPACE WITH FF
#					$LBL[$addr] = 'FREE_SPACE' unless defined($LBL[$addr]);
#					print("$LBL[$addr]:");
#					printf("%s.DB \$%02X[${n}x]",indent("$LBL[$addr]:",$hard_tab*$data_indent),BYTE($addr));
#					$addr += $n;
#					if (defined($_cur_RPG) && $_cur_RPG<=0x3D && $addr>=0x8000) {	# free space extends exactly to end of ROM page
#						die(sprintf("%02X,%04X",$_cur_RPG,$addr)) if ($addr > 0x8000);
#						print("\n");
#					} elsif ($_cur_RPG == 0xFF) {									# free space in system ROM
#						die(sprintf("%02X,%04X",$_cur_RPG,$addr)) if ($addr < 0x8000);
#						print("\n");
#					} else {
#						print("\n"); print_addr($addr) if ($print_addrs);
#						print("\n");
#                   }

					next;
				}
            
				#------------------------------------------------------------------------------------------
				# Not Free Space
				#------------------------------------------------------------------------------------------

				print_addr($addr) if ($print_addrs);
				print("\n"); print_addr($addr) if ($print_addrs);					# new gap
				print(";----------------------------------------------------------------------\n");
				print_addr($addr) if ($print_addrs);
				print("; ANALYSIS GAP\n");
				print_addr($addr) if ($print_addrs);
				print(";----------------------------------------------------------------------\n");
				print_addr($addr) if ($print_addrs);
				print("\n"); print_addr($addr) if ($print_addrs);
				$LBL[$addr] = 'ANALYSIS_GAP' unless defined($LBL[$addr]);
				printf("$LBL[$addr]:");
				printf("%s.DB \$%02X",indent("$LBL[$addr]:",$hard_tab*$data_indent),BYTE($addr));
				print("[${n}x]") if ($n > 1);
				my($col) = 1;
                $addr += $n;

				while ($addr<=$MAX_ROM_ADDR && !$decoded[$addr]) {					# continue ANALYSIS_GAP
					$n = 1;															# count repeat bytes
					$GB = BYTE($addr);
					while ($addr+$n<=$la && !$decoded[$addr+$n] && BYTE($addr+$n)==$GB) { $n++; }
					print("\n"),goto FREE_GAP_SPACE if ($GB==0xFF && $n>20);
					
					if (defined($LBL[$addr])) {										# pre-existing label in gap
						printf("\n");
						print_addr($addr) if ($print_addrs);
						printf("$LBL[$addr]:%s.DB  \$%02X",indent("$LBL[$addr]:",$hard_tab*$data_indent),$GB);
						print("[${n}x]") if ($n > 1);
						$col = 1;
					} elsif ($col >= 8) {											# continue gap on new line
						printf("\n");
						print_addr($addr) if ($print_addrs);
						printf("ANALYSIS_GAP:");
						printf("%s.DB \$%02X",indent("ANALYSIS_GAP:",$hard_tab*$data_indent),$GB);
						print("[${n}x]") if ($n > 1);
						$col = 1;
					} else {														# continue gap on current line
						printf(" \$%02X",$GB);
						print("[${n}x]"),$col++ if ($n > 1);
						$col++;
					}
					$addr += $n;
				}
				$addr--;
				print("\n");
				if (defined($_cur_RPG) && $addr> 0x8000) {							# this looks wrong, why only for WPC?
					print_addr($addr) if ($print_addrs);
					printf("\n");
				}
##			} elsif ($print_code && defined($org)) {								# print code in gaps
##				print_addr($addr) if ($print_addrs);								# code disabled 07/20 to avoid zillions of single-byte no-code lines
##				printf("%02X		  $LBL[$addr]:\n",BYTE($addr));
			} else {
				undef($org);
				$gapLen++;
			}
		}
	}
#	print(STDERR "decoded/ROMbytes = $decoded/$ROMbytes\n");
	return $decoded;
}

#----------------------------------------------------------------------
# Output Routines
#----------------------------------------------------------------------

sub dump_labels($)
{
	my($fmt) = @_;

	if ($fmt == 1) {																# label code
		foreach my $lbl (sort { $Lbl{$a} <=> $Lbl{$b} } keys(%Lbl)) {
			next unless defined($Lbl{$lbl});
			my($laddr) = $Lbl{$lbl};
			if (numberp($laddr)) {
				printf("D711::overwriteLabel('$lbl',0x%04X,0x%02X);\n",$Lbl{$lbl},$LblPg{$lbl});
			} else {
				my($pg);
				($pg,$laddr) = split(':',$laddr);
				$pg = hex($pg); $laddr = hex($laddr);
				printf("D711::overwriteLabel('$lbl',0x%04X,0x%02X);\n",$laddr,$pg);
			}
		}	
	} else {																		# human readable
		print("Labels:\n");
		foreach my $lbl (sort byHexValue keys %Lbl) {
			next unless defined($Lbl{$lbl});
			my($laddr) = $Lbl{$lbl};
			my($defd);
			if (numberp($laddr)) {
				$defd = defined($LBL[$laddr]);
			} else {
				my($pg);
				($pg,$laddr) = split(':',$laddr);
				$pg = hex($pg); $laddr = hex($laddr);
				$defd = defined($LBLPG[$pg][$laddr-0x4000]);
			}
			print("\t");
			print($decoded[$laddr]	? ' ' : 'D');							# D)ecoded
			print(($Lbl_refs{$lbl} > 0) ? ' ' : 'O');						# O)rphaned (unreferenced)
			print($defd ? ' ' : '!');										# ! inconsistent (not in @LBL)

			if (numberp($Lbl{$lbl})) {
				printf("\t0x%04X $lbl\n",$Lbl{$lbl});
			} else {
				printf("\t$Lbl{$lbl} $lbl\n");
			}
	    }
	}
#	print("Label Refs:\n");
#	foreach my $lbl (keys(%Lbl)) {
#		printf("\t%3d\t$lbl\n",$Lbl_refs{$lbl});
#	}
}
		    
1;
