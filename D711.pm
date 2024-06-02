#======================================================================
#					 . . / . . / B I N / D 7 1 1 . P M 
#					 doc: Fri May 10 17:13:17 2019
#					 dlm: Sun Feb 18 17:37:00 2024
#					 (c) 2019 idealjoker@mailbox.org
#					 uE-Info: 186 29 NIL 0 0 72 0 2 4 NIL ofnI
#======================================================================

# Williams System 6-11 Disassembler

# HISTORY:
#	May 10, 2019: - created
#	May 11, 2019: - continued
#	May 12, 2019: - massively improved
#	May 14, 2019: - minor improvements
#	May 15, 2019: - split ASM into OP and OPA for output formatting
#				  - major addition of 6800 opcodes
#				  - BUG: all DIR addressing opcodes had wrong length
#	May 16, 2019: - added remaining 6800 opcodes
#				  - added wvm7 labels
#				  - added remaining wvm7 opcodes
#				  - other improvements and fixes
#	...			: - continued
#	May 19, 2019: - works to disassemble jlord.asm up to init_new_player
#				  - mercurialized
#	May 30, 2019: - continued on flight back from Hamburg:
#						- debugging
#						- support for game-specific identifiers
#	Jun  2, 2019: - improved output formatting (added dividers)
#				  - fixed minor bugs
#	Jun  3, 2019: - added thread support
#	Jun  5, 2019: - debugged/improved expression parsing
#	Aug 17, 2019: - renamed to D711 and stated adapting to System 11
#				  - package renamed to D
#				  - added info on Sys7 macros from Scott Charles
#				  - added Sys11 macro "die hooks" from Scott Charles info
#				  - bugfixes
#				  - ordered output of dump_labels by label value
#	Aug 18, 2019: - bugfixes
#				  - added new spawnThread macros
#	Aug 19, 2019: - bugfixes
#	Aug 20, 2019: - bugfixes
#	Aug 21, 2019: - bugfixes
#	Aug 22, 2019: - fixed final(?) major bug: _thread* in WE expr takes
#					another byte in WVM11
#	Aug 23-31	: - some more bug fixes & improvements
#	Sep  2, 2019: - new automatic labels with addresses
#				  - added $verbose
#	Sep  3, 2019: - replaced print_addr by print_addrs
#	Sep  4 - 16 : - significant debugging
#	Sep 17, 2019: - BUG: CPXA instead of CPX opcode
#				  - made comments use tabstops
#				  - removed label processing from .DB statements
#				  - BUG: first table row distributed over 2 lines
#				  - added @Switch2WVMSubroutines
#	Sep 19, 2019: - added @unstructured
#	Sep 20, 2019: - BUG: rotLeft and Rigth were swapped
#				  - added setLabel to ensure only last define label name is chosen
#				  - removed non-existent opcodes 23 and 27
#	Sep 21, 2019: - BUG: lampOps and indirect ops only took single arguments
#	Sep 23, 2019: - stuff
#	Sep 25, 2019: - added def_string()
#	Sep 27, 2019: - added def_string_table()
#				  - BUG: byteblock() bad format byte 1
#	Sep 28, 2019: - BUG: redefined labels were treated as 0
#				  - BUG: def_ routines overwrote manual labels
#	Sep 19-Oct 4: - improved
#	Oct  5, 2019: - sped up labels 1000%
#	Oct 6-11	: - various improvements
#	Oct 12, 2019: - added code for orphaned labels
#	Jan  5, 2020: - cosmetics
#				  - cleaned up some syntax and renamed a couple of WVM ops
#				  - BUG: unused opcode 0B did not set decoded flag of 2nd argument byte
#				  - turned solenoid numbers into hex
#				  - BUG: number of solenoid tics was wrong
#	Jan  6, 2020: - cosmetics
#	Jan  7, 2020: - removed repeat indication from .DB
#				  - renamed .DB.DW to .DBW; .DW.DB to .DWB
#				  - modified coding of table rows (no .DB.DW.DS strings allowed any more)
#				  - simplyfied wvm_parse_expr() [old infix code left in source]
#				  - BUG: indirect addressing notation was inconsistent
#				  - added .ALIAS to output
#	Jan  8, 2020: - changed or-flag notation for bigroup and lamp ops (LG_all|0x40 instead of 0x40 | LG_all)
#					to make parsing easier
#				  - BUG: erroneous superfluous code (never executed?) in WVM_lampOp
#				  - changed syntax for playSound with repeat
#	Jan  9, 2020: - changed %greater to %greaterThan
#				  - made ajustment and sound numbers hex
#				  - changed |0x40 to |#$40 (of course)
#				  - BUG: label substitution was not anchored at beginning
#				  - removed def_string and replaced by def_stringX
#				  - removed string length specifier from .DS
#				  - removed .DS.DS
#	Jan 10, 2020: - renamed some .PRAGMAs (new .STR .S7R .DEF)
#				  - added .LBL
#				  - moved all warnings to STDERR
#				  - removed # from table data
#				  - removed "register" from all register ops and replaced "save" by "store"
#				  - BUG: flaggroup table had wrong labels
#	Jan 11, 2020: - BUG: clearSwitches was not recorded in output
#				  - added sleep_subOptimal where long sleep was used instead of short
#	Jan 12, 2020: - added @exception arguments to string table definitions
#				  - WORKS!
#				  - improved structured code parsing
#				  - added def_checksum_byte()
#	Jan 14, 2020: - removed # from label arithmetic
#				  - added conditions to cs_loop analyzers
#	Jan 23, 2023: - expunged address lists in label names
#	Jan 25, 2020: - added undo_code_structure (and -h) to write a file with $unstruturedp[] hints
#					based on an analysis of labels into indented code produced during output;
#				    the code works, but turns out pointless, because when -l/-i are used, these
#					structure-breaking labels are caught already in same_block()
#	Jan 26, 2020: - added '!' marker to suppress label sustitution to .DB and .DW ops
#				  - changed def_wordblock_hex() not to substitute labels
#				  - added def_ptrblock_hex() to do the same but substitute labels
#				  - made string identifiers 4-digits long
#				  - renamed def_byte{block,list}_hex_long to def_byte{block,list}_hex_cols
#	Feb  2, 2020: - changed .DEF to .DEFINE & swapped order of arguments
#				  - ensured indent() always adds at least 1 space
#				  - made sure that output lines up with 4-space tab stops
#				  - use tab stops in output
#	Apr 28, 2020: - fixed erroneous _IF macros (IFGT -> IF_GE, IFLT -> IF_LE, IFGE -> IF_GT, IFLE -> IF_LT
#				  - renamed remaining _IF macros
#	May 29, 2021: - added 'no_follow' option ($code_following_enabled)
#				  - BUG: $follow_code was ignored for all JSR
#	May 30, 2021: - BUG: typo
#				  - BUG: special JSR treatment also applies to BSR
#				  - BUG: quite a few WVM ops have changed name...
#			 	  - BUG: 'store' is missing 2nd argument
#	May 31, 2021: - BUG: def_byteblock_hex_alt() required for C711 -x
#	Jun  8, 2021: - removed 'no_follow' option and $code_following_enabled
#	Jun 16, 2021: - added def_lbl_arith()
#  	Jun 19, 2021: - BUG: disassembly of pointers in data did not work
#				  - renamed def_byteblock_hex_alt() to def_byteblock_hex_magic()
#	Oct  9, 2021: - added support for plain M6800 disassembly (leave $WMS_System undefined)
#	Oct 10, 2021: - cleaned up System X support
#	May 12, 2022: - removed die() statement on line 1121
#				  - flaggroup => bitgroup
#				  - sleep_imm => sleepI, WVM_mode => WVM_start
#				  - made sleepI & WVM_start work automatically for Sys11
#				  - added unrealistic_score_limit
#				  - added support for switch names (@Switch)
#				  - BUG: decAndBranchUnless0 reported wrong register
#				  - removed address suffices from switch handler labels
#	May 13, 2022: - made insert_divider overwrite pre-existing divider
#	May 14, 2022: - improved string decoding
#				  - BUG: switchtable decoding did not add labels for switch handlers
#	May 15, 2022: - added grow_strings()
#				  - changed semantics about overwriting labels in setLabel()
#	May 16, 2022: - added trim_overlapping_strings()
#				  - updated (c) year
#				  - added %unfollowed_lbl
#				  - added disassemble_unfollowed_labels()
#				  - added overwriteLabel()
#	May 17, 2022: - BUG: %unfollowed_lbl replaced by @unfollowed_lbl
#				  - BUG: _EXIT_THREAD magic did not work
#	May 18, 2022: - added def_ptr_hex_alt()
#				  - BUG: WVM_start not implemented fully
#				  - imported Sys11 magic from BadCats System11.dasm
#	Oct  3, 2022: - BUG: def_byteblock_hex_cols() had first 2 args swapped
#	Oct  4, 2022: - added OP predefined check to def_byteblock_hex()
#				  - added def_org()
#	Oct  5, 2022: - added support for fill_gaps()
#				  - added debug statement
#				  - BUG: allFlagsSet/Cleared did not support |$C0 arithmetic
#	Oct  7, 2022: - BUG: decode_STR_char() had several bugs
#				  - BUG: CPXA instead of CPX
#				  - BUG: def_switchtable_ptr used switch names as handler routines
#				  - BUG: suppressed definition of no-name labels
#	Oct  8, 2022: - BUG: trim_overlapping_strings had not been adapted to
#						 new string notation with . and \
#				  - renamed grow_strings to grow_1strings
#				  - aded grow_string
#				  - BUG: decode_STR_char decoded everthing below ASCII 48 as space
#				  - turned halt error into warning
#	Oct  9, 2022: - modified one of the debug pointers to not overwrite pointee label
#				  - added already assembled checks to disassemble_wvm()
#	Oct 13, 2022: - BUG: wvm_parse_expr() did not handle simple numbers correctly
#				  - modified wvm_parse_expr() to decode numbers as hex
#	Dec 22, 2023: - added def_bitgroup_table for AP
#				  - added System 6 support
#	Dec 24, 2023: - BUG: load_ROM did not always set MAX_ROM_ADDR correctly
#	Dec 24-31   : - added System 6 support
#	Jan  1, 2024: - made Sys 6 disassembly largely automatic with *.defs
#	Jan 17, 2024: - "modernized" sys 6 labels
#	Feb 18, 2024: - cosmetics
# END OF HISTORY

# TO-DO:
#	- make work with system 7 code (see setLabel below)
#	- add more consisency checks like for predefined OP as in def_byteblock_hex()

package D711;

our $WMS_System;					# set to 7 or 11 or undef for MC6800 disassembly 
our $verbose = 1;					# 0: quiet (for automatic scans); 1: error messages (default); 2: debug
our $unclean;						# used to report unclean disassembly
our @Switch2WVMSubroutines;			# list of addresses of M6800 SBRs returning in WMV mode
our	@unstructured;					# set flag to skip address during code-structure scanning
our	@nolabel;						# set flag to skip address during label substitution
our @no_autolabels;					# set to true to suppress system 7 auto labels

our @ROM;
our $MIN_ROM_ADDR,$MAX_ROM_ADDR;	# set by load_ROM

sub BYTE($) { return $ROM[$_[0]]; }
sub WORD($) { return $ROM[$_[0]]<<8|$ROM[$_[0]+1]; }

#----------------------------------------------------------------------
# Output Format Defintion (Tweakables)
#----------------------------------------------------------------------

my($hard_tab)			= 4;							# length of tab stop
my($code_base_indent)	= 2;							# base indent (tab stops) for code
my($data_indent)		= 8;							# indent for data tables (long labels)
my($rem_indent) 		= 17;							# indent for comments
my($def_name_indent)	= 3;							# indent for .DEFINE .LBL statement args
my($def_val_indent)		= 13;
my(@op_width)			= (undef,2,5,1);				# typical operator width (tab stops) for (nil,6800,WVM7,Data)

my($CodeType_6800)		= 1;							# different types of code in ROM
my($CodeType_wvm)		= 2;							# for @TYPE[@addr]
my($CodeType_data)		= 3;							# also, used as index in @op_width

#----------------------------------------------------------------------
# Tweakables
#----------------------------------------------------------------------

my($unrealistic_score_limit) = 1e6;

#----------------------------------------------------------------------
# WVM7 Interface
#	use D711 (sys[,opts])
#		sys		= 7 or 11
#----------------------------------------------------------------------

sub import($@)
{
	my($pkg,$sys,$opts) = @_;
	
	$WMS_System = $sys;

	print(STDERR "Disassembler for WVM System $WMS_System\n");
	print(STDERR "(c) 2020 A.M. Thurnherr\n");

	if ($WMS_System == 6) {
		setLabel('=display_p1', 						0x00);		# 3-byte data
		setLabel('=display_p1+1', 						0x01);
		setLabel('=display_p1+2', 						0x02);
		setLabel('_display_bip',						0x03);
		setLabel('=display_p2', 						0x04);		# 3-byte data
		setLabel('=display_p2+1', 						0x05);
		setLabel('=display_p2+2', 						0x06);
		setLabel('_display_credits',					0x07);
		setLabel('=display_p3', 						0x08);		# 3-byte data
		setLabel('=display_p3+1', 						0x09);		
		setLabel('=display_p3+2', 						0x0A);		
		setLabel('=display_p4', 						0x0C);		# 3-byte data
		setLabel('=display_p4+1', 						0x0D);		
		setLabel('=display_p4+2', 						0x0E);		
		setLabel('=Lamps',								0x10);		# 8 bytes
		setLabel('=Lamps+1',							0x11);
		setLabel('=Lamps+2',							0x12);
		setLabel('=Lamps+3',							0x13);
		setLabel('=Lamps+4',							0x14);
		setLabel('=Lamps+5',							0x15);
		setLabel('=Lamps+6',							0x16);
		setLabel('=Lamps+7',							0x17);
		setLabel('=Flags',								0x18);		# 2 bytes
		setLabel('=Flags+1',							0x19);		
		setLabel('=BlinkBuf',							0x1A);		# 8 bytes
		setLabel('=BlinkBuf+1',							0x1B);
		setLabel('=BlinkBuf+2',							0x1C);
		setLabel('=BlinkBuf+3',							0x1D);
		setLabel('=BlinkBuf+4',							0x1E);
		setLabel('=BlinkBuf+5',							0x1F);
		setLabel('=BlinkBuf+6',							0x20);
		setLabel('=BlinkBuf+7',							0x21);
		setLabel('=dontUse',							0x22);		# 2 bytes
		setLabel('=dontUse+1',							0x23);
		setLabel('=SwitchBuf',							0x24);	  	# 8 bytes; reverse column order
		setLabel('=SwitchBuf+1',						0x25);
		setLabel('=SwitchBuf+2',						0x26);
		setLabel('=SwitchBuf+3',						0x27);
		setLabel('=SwitchBuf+4',						0x28);
		setLabel('=SwitchBuf+5',						0x29);
		setLabel('=SwitchBuf+6',						0x2A);
		setLabel('=SwitchBuf+7',						0x2B);
		setLabel('=SwitchStuckBuf', 		  			0x2C);	  	# 8 bytes; reverse column order
		setLabel('=SwitchStuckBuf+1', 		  			0x2D);
		setLabel('=SwitchStuckBuf+2', 		  			0x2E);
		setLabel('=SwitchStuckBuf+3', 		  			0x2F);
		setLabel('=SwitchStuckBuf+4', 		  			0x30);
		setLabel('=SwitchStuckBuf+5', 		  			0x31);
		setLabel('=SwitchStuckBuf+6', 		  			0x32);
		setLabel('=SwitchStuckBuf+7', 		  			0x33);
		setLabel('=SwitchQueue',						0x34);		# 3 bytes
		setLabel('=SwitchQueue+1',						0x35);		
		setLabel('=SwitchQueue+2',						0x36);
		setLabel('_tiltWarnings',						0x37);
		setLabel('_solenoids_timer',					0x38);
		setLabel('_last_solNo',							0x39);

		setLabel('_soundAndDelay_timer',				0x3A);		# 3 bytes
		setLabel('_soundAndDelay_timer_handler',		0x3B);		
		setLabel('_soundAndDelay_timer_handler+1',		0x3C);		
		setLabel('_solenoid_timer', 					0x3D);		# 3 bytes
		setLabel('_solenoid_timer_handler',				0x3E);		
		setLabel('_solenoid_timer_handler+1',			0x3F);		
		setLabel('_script_timer1',	 					0x40);		# 3 bytes
		setLabel('__script_timer1_handler',				0x41);
		setLabel('__script_timer1_handler+1',			0x42);
		setLabel('_script_timer2',	 					0x43);		# 3 bytes
		setLabel('__script_timer2_handler',				0x44);
		setLabel('__script_timer2_handler1',			0x45);
		setLabel('_match',								0x46);
		setLabel('_bonusX', 							0x47);
		
		setLabel('=cycleCounter',						0x50);		# 4 bytes
		setLabel('=cycleCounter+1',						0x51);		
		setLabel('=cycleCounter+2',						0x52);		
		setLabel('=cycleCounter+3',						0x53);
		setLabel('_blink_counter',						0x54);
		setLabel('_playerUp',							0x55);
		setLabel('_maxPlayerInGame',					0x56);
		setLabel('_sound_repeatCount',					0x57);
		setLabel('_sound_id',							0x58);
		setLabel('_sound_pinOp',						0x59);
		setLabel('_sound_duration',						0x5A);
		setLabel('_EB_pending',							0x5B);
		setLabel('_bonusCountdown_score',				0x5C);
		setLabel('=scoreQueue',							0x5D);		# 5 bytes
		setLabel('=scoreQueue+1',						0x5E);
		setLabel('=scoreQueue+2',						0x5F);

		setLabel('=scoreQueue+3',						0x60);
		setLabel('=scoreQueue+4',						0x61);
		setLabel('=solQueue',							0x62);		# length
		setLabel('=solQueue+1',							0x63);		# 1st elt
		setLabel('=solQueue+2',							0x64);
		setLabel('=solQueue+3',							0x65);
		setLabel('_switchSolCmd',						0x66);
		setLabel('_tmp1',								0x67);
		setLabel('_tmp2',								0x68);
		setLabel('_tmp3',								0x69);
		setLabel('_tmp4',								0x6A);
		setLabel('_tmp5',								0x6B);
		setLabel('_tmp6',								0x6C);
		setLabel('_tmp7',								0x6D);
		setLabel('_switchScript_flags',					0x6E);
		
		setLabel('_nextDT_p1',							0x70);	    
		setLabel('_nextDT_p2',							0x71);	    
		setLabel('_nextDT_p3',							0x72);	    
		setLabel('_nextDT_p4',							0x73);	    
		setLabel('_ballTime',							0x74);	    
		setLabel('_gameStatusFlags',					0x78);	   # 01: gameOver 02:gameTilted  04:EBpending 08: EBearned 10:balltimeOverflow(1min passed) 80:playfield qualified
		setLabel('=switchScanKillTimer',				0x7A);	    
		setLabel('=timerHandler',						0x7E);	    
		setLabel('=timerHandler+1',						0x7F);	    
		
		setLabel('__score_tmpX',						0x80);
		setLabel('__score_tmpX+1',						0x81);
		setLabel('__tmp1_X',							0x82);	    
		setLabel('__tmp1_X+1',							0x83);
		setLabel('__RAM[X+B]_tmpX',						0x86);
		setLabel('__RAM[X+B]_tmpX+1',					0x87);
		setLabel('__lampMask[A]_Xin',					0x88);
		setLabel('__lampMask[A]_Xin+1',					0x89);
		setLabel('__tmp2_X',							0x8A);
		setLabel('__tmp2_X+1',							0x8B);
		setLabel('__switch_params',						0x8C);	    
		setLabel('__switch_params+1',					0x8D);	    
		
		setLabel('__copyRAM_tmpX',						0x90);	    
		setLabel('__Xstore',							0x92);
		setLabel('=data_p1',							0x94);		# 18 bytes
		setLabel('=data_p2',							0xA6);		# 18 bytes
		setLabel('=data_p3',							0xB8);		# 18 bytes
		setLabel('=data_p4',							0xCA);		# 18 bytes
		
		setLabel('_GameVarE0',							0xE0);		# 3 used in Alien Poker, more very likely possible (c.f. Sys 7); competes with stack
		setLabel('_GameVarE1',							0xE1);
		setLabel('_GameVarE2',							0xE2);
		setLabel('TOP_OF_STACK',						0xFF);
		
		setLabel('=BB_RAM_START',						0x0100);						# Battery Backed RAM
		setLabel('_BB_unused?_0101',					0x0101);
		setLabel('_BB_unused_0102', 					0x0102);
		setLabel('_BB_unused_0103', 					0x0103);
		setLabel('_BB_unused_0104', 					0x0104);
		setLabel('_BB_unused_0105', 					0x0105);
		setLabel('_BB_unused_0106', 					0x0106);
		setLabel('_BB_unused_0107', 					0x0107);
		setLabel('_BB_unused_0108', 					0x0108);
		setLabel('_BB_unused_0109', 					0x0109);
		setLabel('=BB_AUDIT_START',						0x010A);
		setLabel('=BB_AU01_leftCoins',					0x010A);	
		setLabel('=BB_AU02_centerCoins',				0x0110);	
		setLabel('=BB_AU03_rightCoins',					0x0116);	
		setLabel('=BB_AU04_paidCredits',				0x011C);	
		setLabel('=BB_AU05_Specials',					0x0122);	
		setLabel('=BB_AU06_replayAwards',				0x0128);	
		setLabel('=BB_AU07_match_HSTD_cred',			0x012E);	
		setLabel('=BB_AU08_totalCredits',				0x0134);	
		setLabel('=BB_AU09_extraballs',					0x013A);	
		setLabel('=BB_AU10_ballTime',					0x0140);	
		setLabel('=BB_AU11_ballsPlayed',				0x0146);	
		setLabel('=BB_HSTD',							0x0148);
		setLabel('=BB_HSTD+2',							0x014A);
		setLabel('=BB_HSTD+4',							0x014C);
		
		setLabel('_BB_Credits',							0x0152);

		setLabel('_BB_AU12_HSTD',						0x017F);	
		setLabel('_BB_AU12_HSTD+1',						0x0180);	
		setLabel('_BB_AD13_BUHSTD',						0x0181);	
		setLabel('_BB_AD13_BUHSTD+1',					0x0182);	
		setLabel('_BB_AD14_replay1',					0x0183);	
		setLabel('_BB_AD14_replay+1',					0x0184);	
		setLabel('_BB_AD15_replay2',					0x0185);	
		setLabel('_BB_AD15_replay2+1',					0x0186);	
		setLabel('_BB_AD16_replay3',					0x0187);	
		setLabel('_BB_AD16_replay3+1',					0x0188);	
		setLabel('_BB_AD17_replay4',					0x0189);	
		setLabel('_BB_AD17_replay4+1',					0x018A);	
		setLabel('_BB_AD18_maxCredits',					0x018B);	
		setLabel('_BB_AD18_maxCredits+1',				0x018C);	
		setLabel('_BB_AD19_priceControl',				0x018D);	
		setLabel('_BB_AD19_priceControl+1',				0x018E);	
		setLabel('_BB_AD20_lCoinMult',					0x018F);	
		setLabel('_BB_AD20_lCoinMult+1',				0x0190);	

		setLabel('_BB_AD21_cCoinMult',					0x0191);	
		setLabel('_BB_AD21_cCoinMult+1',				0x0192);	
		setLabel('_BB_AD22_rCoinMult',					0x0193);	
		setLabel('_BB_AD22_rCoinJult+1'	,				0x0194);	
		setLabel('_BB_AD23_coins4credit',				0x0195);	
		setLabel('_BB_AD23_coins4credit+1',				0x0196);	
		setLabel('_BB_AD24_coinsBonus',					0x0197);	
		setLabel('_BB_AD24_coinsBonus+1',				0x0198);	
		setLabel('_BB_AD25_HScredits',					0x0199);	
		setLabel('_BB_AD25_HScredits+1',				0x019A);	
		setLabel('_BB_AD26_match_multipleEB',			0x019B);	
		setLabel('_BB_AD26_match_multipleEB+1',			0x019C);	
		setLabel('_BB_AD27_SpecialAward',				0x019D);	
		setLabel('_BB_AD27_SpecialAward+1',				0x019E);	
		setLabel('_BB_AD28_ScoringAward',				0x019F);	
		setLabel('_BB_AD28_ScoringAward+1',				0x01A0);	
		setLabel('_BB_AD29_tiltWarnings',				0x01A1);	
		setLabel('_BB_AD29_tiltWarnings+1',				0x01A2);	
		setLabel('_BB_AD30_ballsPerGame',				0x01A3);	
		setLabel('_BB_AD30_ballsPerGame+1',				0x01A4);	
		setLabel('_BB_AD31',							0x01A5);	
		setLabel('_BB_AD31+1',							0x01A6);	
		setLabel('_BB_AD32',							0x01A7);	
		setLabel('_BB_AD32+1',							0x01A8);	
		setLabel('_BB_AD33',							0x01A9);	
		setLabel('_BB_AD33+1',							0x01AA);	
		setLabel('_BB_AD34',							0x01AB);	
		setLabel('_BB_AD34+1',							0x01AC);	
		setLabel('_BB_AD35',							0x01AD);	
		setLabel('_BB_AD35+1',							0x01AE);	

		setLabel('PIA_2200_sol1-8(data)',				0x2200);					# Solenoids
		setLabel('PIA_2200_sol1-8(ctrl)',				0x2201);
		setLabel('PIA_2202_sol9-16(data)',				0x2202);
		setLabel('PIA_2202_sol9-16(ctrl)',				0x2203);
		setLabel('PIA_2202_sol17-24(data)',				0x2204);
		setLabel('PIA_2202_sol17-24(ctrl)',				0x2205);
		setLabel('PIA_2400_lampRow_input(data)',		0x2400);
		setLabel('PIA_2400_lampRow_input(ctrl)',		0x2401);
		setLabel('PIA_2402_lampCol_strobe(data)',		0x2402);
		setLabel('PIA_2402_lampCol_strobe(ctrl)',		0x2403);
		setLabel('PIA_2800_display_strobe(data)',		0x2800);
		setLabel('PIA_2800_display_strobe(ctrl)',		0x2801);
		setLabel('PIA_2802_display_digit(data)',		0x2802);
		setLabel('PIA_2802_display_digit(ctrl)',		0x2803);
		setLabel('PIA_3000_switchRow_input(data)',		0x3000);
		setLabel('PIA_3000_switchRow_input(ctrl)',		0x3001);
		setLabel('PIA_3002_switchCol_strobe(data)',		0x3002);
		setLabel('PIA_3002_switchCol_strobe(ctrl)',		0x3003);
		
		sub disassemble_System6()
		{
			$Address = 0x6000;
			def_byte_hex('GAMEROM_CHECKSUM');
			def_word_hex('GAME_NUMBER');
			def_byte_hex('GAMEROM_VERSION');
			def_byte_hex('CMOS_CHECKBYTE');
	
			def_byte_hex('DEFAULT_HIGHSCORE');
			def_byte_hex('DEFAULT_REPLAYLVL_1');
			def_byte_hex('DEFAULT_REPLAYLVL_2');
			def_byte_hex('DEFAULT_REPLAYLVL_3');
			def_byte_hex('DEFAULT_REPLAYLVL_4');
			def_byte_hex('DEFAULT_MAXCREDITS');
			def_byte_hex('DEFAULT_COINSELECT');
			def_byte_hex('DEFAULT_COINSLOT_1');
			def_byte_hex('DEFAULT_COINSLOT_2');
			def_byte_hex('DEFAULT_COINSLOT_3');
			def_byte_hex('DEFAULT_COINS4CREDIT');
			def_byte_hex('DEFAULT_COINS4BONUSCREDIT');
			def_byte_hex('DEFAULT_HIGHSCORE_CREDITS');
			def_byte_hex('DEFAULT_MATCHAWARDS');
			def_byte_hex('DEFAULT_SPECIALAWARD');
			def_byte_hex('DEFAULT_REPLAYAWARD');
			def_byte_hex('DEFAULT_TILTWARNINGS');
			def_byte_hex('DEFAULT_BALLS_PER_GAME');
			def_byte_hex('DEFAULT_AD31');
			def_byte_hex('DEFAULT_AD32');
			def_byte_hex('DEFAULT_AD33');
			def_byte_hex('DEFAULT_AD34');
			def_byte_hex('DEFAULT_AD35');
			def_byteblock_hex(40,'DEFAULT_COIN_TABLE');
			def_byte_hex('MAX_SWITCH');
			def_byte_hex('BALLSERVE_SOLCMD_AND_1EB_FLAG');
			def_byte_LampOrFlag('EXTRABALL_LAMP');
			def_byte_hex('MAX_PLAYER');
			def_byte_hex('CYCLECOUNTER_1');
			def_byte_hex('CYCLECOUNTER_2');
			def_byte_hex('CYCLECOUNTER_3');
			def_byte_hex('CYCLECOUNTER_4');
			def_byte_hex('BLINK_DELAY');
			def_byte_hex('CYCLECOUNTER_PINOPP_1');
			def_byte_hex('CYCLECOUNTER_PINOPP_2');
			def_byte_hex('CYCLECOUNTER_PINOPP_3');
			def_byte_hex('CYCLECOUNTER_PINOPP_4');
#			def_byteblock_hex(8,'SCRIPT_LAMPS');
			def_byte_LampOrFlag('SCRIPT_LAMPS');
				def_byte_LampOrFlag('');
				def_byte_LampOrFlag('');
				def_byte_LampOrFlag('');
				def_byte_LampOrFlag('');
				def_byte_LampOrFlag('');
				def_byte_LampOrFlag('');
				def_byte_LampOrFlag('');
			def_bitgrouptable(8,'BITGROUP_TABLE');
			def_byteblock_hex(8,'LAMPS_INITDATA');
			def_byteblock_hex(2,'FLAGS_INITDATA');
			def_byteblock_hex(8,'BLINK_INITDATA');
			def_byteblock_hex(8,'LAMPS_MEMDATA');
			def_byteblock_hex(2,'FLAGS_MEMDATA');
			def_byteblock_hex(8,'BLINK_MEMDATA');
			def_wordblock_hex(32,'SOUND_TABLE');
			def_byteblock_hex(8,'PBPINOPP_SOLCMD_TABLE_1');
			def_byteblock_hex(8,'PBPINOPP_SOLCMD_TABLE_2');
			def_byte_hex('BONUSCOUNT_BONUSX_DELAY');
			def_byte_hex('BONUSCOUNT_SOUND');
			def_byte_hex('BONUSCOUNT_DELAY');
#			def_byteblock_hex(4,'BONUSLAMPS_TABLE');
			def_byte_LampOrFlag('BONUSLAMPS_TABLE');
				def_byte_LampOrFlag('');
				def_byte_LampOrFlag('');
				def_byte_LampOrFlag('');
#			def_byteblock_hex(4,'BONUSX_LAMPS_TABLE');
			def_byte_LampOrFlag('BONUSX_LAMPS_TABLE');
				def_byte_LampOrFlag('');
				def_byte_LampOrFlag('');
				def_byte_LampOrFlag('');
			def_byteblock_hex(4,'BONUSX_VALUE_TABLE');
			def_byte_hex('SPECIAL_SCORE');
			def_byte_hex('SND_CREDIT');
			def_byte_hex('SND_CREDIT_DELAY');
			def_byte_hex('SND_TILT');
			def_ptr_hex('STATUSUPDATE_TABLE');
			def_ptr_hex('STATUSUPDATE_TABLE_END');
			def_ptr_hex('GAMEEVENTS_HANDLER_TABLE');
			def_ptr_hex('GAMEEVENTS_HANDLER_TABLE_END');
			def_code_ptr('GAME_BACKGROUND_HANDLER','game_background_handler','Game Background Event Handler');
			def_code_ptr('BALLSTART_EVENT','ballstart_event_handler','Ball Start Event Handler');
			def_code_ptr('BONUSX_COUNTDOWN_EVENT','bonusX_countdown_event_handler','BonusX Countdown Event Handler');
			def_code_ptr('BALLDRAIN_EVENT','balldrain_event_handler','End of Ball Event Handler');
			def_ptr_hex('SOUNDSCRIPT_P1');
			def_ptr_hex('SOUNDSCRIPT_P2');
			def_ptr_hex('SOUNDSCRIPT_P3');
			def_ptr_hex('SOUNDSCRIPT_P4');
			def_ptr_hex('SOUNDSCRIPT_MATCH');
			def_ptr_hex('SOUNDSCRIPT_HIGHSCORE');
			def_ptr_hex('SOUNDSCRIPT_GAMEOVER');
			def_byteblock_code(3,'IRQ_HANDLER');
			def_byte_hex('ATTRACT_DELAY');
			def_byte_hex('ATTRACT_SEQ_MAX');
	        def_ptr_hex('ATTRACT_DATA');

	        $Address = 0x60F5;																				# Switch Table
	        insert_divider($Address,'Switch Table');
			my($n) = BYTE(0x6044);
	        for (my($i)=0; $i<$n; $i++) {
				my($sn) = defined($Switch[$i]) ? $Switch[$i] : sprintf('Switch#%02X',$i);
	        	def_code_ptr($sn,$sn . '_handler','Switch Handler');
	        	if (WORD($Address-2) == 0x7230) {
	        		def_ptr_hex($sn . '_scriptPtr');
	        	} else {
	        		def_byteblock_hex(2,$sn . '_params');
	        	}
	        }

			$Address = WORD(0x60D0);															# Status Update Table
			my($n) = (WORD(0x60D2) - $Address) / 9;
			if ($n > 0) {
				die unless ($n==int($n));
				insert_divider($Address,'Status Update Table');
				def_byteblock_hex_cols(9,9,'statusUpdate_1');            
				for (my($i)=2; $i<=$n; $i++) {
					def_byteblock_hex_cols(9,9,"statusUpdate_$i");
				}
			}
	        
			$Address = WORD(0x60D4);															# Game Event Table
			my($n) = (WORD(0x60D6) - $Address) / 4;
			if ($n > 0) {
				die("$n") unless ($n==int($n));
				insert_divider($Address,'Game Event Table');
                def_byte_LampOrFlag('gameEvent_table');
				def_byte_dec('');
				def_code_ptr('',$Gameevent[0] ? "${Gameevent[0]}_handler" : "gameEvent_1_handler");
                for (my($i)=2; $i<=$n; $i++) {
                        def_byte_LampOrFlag('');
						def_byte_dec('');
                        def_code_ptr('',$Gameevent[$i-1] ? "${Gameevent[$i-1]}_handler" : "gameEvent_${i}_handler");
                }
			}
	        
			my($len);
			for (my($p)=0; $p<4; $p++) {
				$Address = WORD(0x60E0+2*$p);													# Sound Scripts
				next if $decoded[$Address];
				def_byte_hex(sprintf('p%dStart_sndList',$p+1));
				def_bytelist_hex(0,'');
            }
			$Address = WORD(0x60E8); 
			unless ($decoded[$Address]) {
				def_byte_hex('match_sndList');
				def_bytelist_hex(0,'');
            }
			$Address = WORD(0x60EA); 
			unless ($decoded[$Address]) {
				def_byte_hex('highScore_sndList');
				def_bytelist_hex(0,'');
            }
			$Address = WORD(0x60EC); 
			unless ($decoded[$Address]) {
				def_byte_hex('gameOver_sndList');
				def_bytelist_hex(0,'');
            }

			$Address = WORD(0x60F3);															# Attract Mode Data
			insert_divider($Address,'Attract Mode Lamp Data');
			my($n) = BYTE(0x60F2) + 1;
			def_byteblock_hex(6,'attract_mode_data');
            for (my($i)=2; $i<=$n; $i++) {
				def_byteblock_hex(6,'');
            }

			$Address = 0x7000; def_code('sys_reset_game');							# System Calls
			$Address = 0x7045; def_code('sys_gameOver');
			$Address = 0x7062; def_code('sys_background_loop');
			$Address = 0x719A; def_code('sys_enter_audits_and_adjustments');
			$Address = 0x71CB; def_code('sys_solCmdOrPlaySound[A]');
			$Address = 0x71EC; def_code('sys_solCmd[A]');
			$Address = 0x71C9; def_code('sys_exec_switchSolCmd');
			$Address = 0x721F; def_code('sys_B=RAM[X+B]');
			$Address = 0x72A8; def_code('sys_award_SPECIAL');
			$Address = 0x7230; def_code('sys_switch_script');
			$Address = 0x7300; def_code('sys_lampStatusUpdate_then_run_timedScripts');
			$Address = 0x7306; def_code('sys_clearScoreQueue_outhole_handler');
			$Address = 0x730D; def_code('sys_outhole_handler');
			$Address = 0x73E9; def_code('sys_start_ball');
			$Address = 0x740A; def_code('sys_ball_kickout');
			$Address = 0x7426; def_code('sys_end_of_game');
			$Address = 0x7457; def_code('sys_match_handler');
			$Address = 0x746B; def_code('sys_endOfGame_noMatch');
			$Address = 0x7520; def_code('sys_load_playerData');
			$Address = 0x7562; def_code('sys_X=playerData');
			$Address = 0x7571; def_code('sys_creditButton_handler');
			$Address = 0x75C2; def_code('sys_add_player_to_game');
			$Address = 0x75D8; def_code('sys_init_game');
			$Address = 0x75F0; def_code('sys_clear_scoreQueue');
			$Address = 0x75FE; def_code('sys_coinLeft_handler');
			$Address = 0x7602; def_code('sys_coinCenter_handler');
			$Address = 0x7606; def_code('sys_coinRight_handler');
			$Address = 0x766C; def_code('sys_award_freeGame');
			$Address = 0x76CC; def_code('sys_delay[B]');
			$Address = 0x76D9; def_code('sys_delay[AB]');
			$Address = 0x76DD; def_code('sys_copyRAM');
			$Address = 0x76F1; def_code('sys_lampStatusUpdate');
			$Address = 0x7832; def_code('sys_pinOp_solCmd');
			$Address = 0x79BF; def_code('sys_exitOnGameOverOrTilt');
			$Address = 0x79C6; def_code('sys_exit');
			$Address = 0x79CB; def_code('sys_play_soundScript');
			$Address = 0x7744; def_code('sys_execStatusupdate[X]');
			$Address = 0x777C; def_code('sys_testBit');
			$Address = 0x77A8; def_code('sys_run_timedScripts');
			$Address = 0x77F0; def_code('sys_play_sound');
			$Address = 0x7925; def_code('sys_light_EBlamp');
			$Address = 0x7897; def_code('sys_setBitgroup');
			$Address = 0x780E; def_code('sys_pinOp[A]');
			$Address = 0x78A8; def_code('sys_bitgroupOp[A]_until[B]');
			$Address = 0x7980; def_code('sys_checkAdjustment');
			$Address = 0x792C; def_code('sys_setBit');
			$Address = 0x793D; def_code('sys_clearBit');
			$Address = 0x794A; def_code('sys_blinkLamps');
			$Address = 0x7953; def_code('sys_BX=lampMask[A]');
			$Address = 0x7993; def_code('sys_bobTilt_handler');
			$Address = 0x79A3; def_code('sys_ballTilt_handler');
			$Address = 0x79B6; def_code('sys_tilt_sound');
			$Address = 0x79E4; def_code('sys_score[A]');
			$Address = 0x7A00; def_code('sys_score[A]_now');
			$Address = 0x7AD6; def_code('sys_clear_displays');
			$Address = 0x7AD8; def_code('sys_fill_displays');
			$Address = 0x7AE3; def_code('sys_clear_BB_RAM');
			$Address = 0x7B09; def_code('sys_bookkeeping_menu');
			$Address = 0x7C8F; def_code('sys_start_game');
			$Address = 0x7DF8; def_code('sys_mergeCopy_[X]_to_[Xptr]');
			$Address = 0x7E0B; def_code('sys_splitCopy_[X]_to_[Xptr]');
			$Address = 0x7E1E; def_code('sys_B=shiftLeft4[X,X+1]');
			$Address = 0x7E2D; def_code('sys_splitStore[B]');
			$Address = 0x7E36; def_code('sys_HSreset_handler');
			$Address = 0x7E4C; def_code('sys_IRQ_handler');
			$Address = 0x7E9D; def_code('sys_IRQ_handler_display[A]');

			$Address = 0x7FDC;
			insert_divider($Address,'System Data');
			setLabel('system_data-1',$Address-1);
			def_byteblock_hex(16,'system_data');
			def_ptrblock_hex(12,'PIA_list');

			$Address = 0x7FF8;
			insert_divider($Address,'CPU Vectors');
			def_code_ptr('IRQ_vector','IRQ_handler','CPU Vector Handler');
			def_code_ptr('SWI_vector','SWI_handler','CPU Vector Handler');
			def_code_ptr('NMI_vector','NMI_handler','CPU Vector Handler');
			def_code_ptr('RST_vector','RST_handler','CPU Vector Handler');

		}

    } elsif ($WMS_System == 7) {
		setLabel('WVM_start' ,0xF3AB);
		setLabel('WVM_sleepI',0xEA2F);

		if (0) {
		die("code adaptation incomplete (setLabel required)");	# I *think* this means that the following
																# assignments need to be reformatted using
																# setLabel()

		$Lbl{'Reg-A'} = 0x00;								# Data Labels
		$Lbl{'Reg-B'} = 0x01;
	    
		$Lbl{'Comma_Flags'} = 0x60;
	    
		$Lbl{'Spare_Ram_0'} = 0xE0; 					   # extra RAM, not accessible in WVM
		$Lbl{'Spare_Ram_1'} = 0xE1;
		$Lbl{'Spare_Ram_2'} = 0xE2;
		$Lbl{'Spare_Ram_3'} = 0xE3;
		$Lbl{'Spare_Ram_4'} = 0xE4;
		$Lbl{'Spare_Ram_5'} = 0xE5;
		$Lbl{'Spare_Ram_6'} = 0xE6; 					   # last used on JL
		$Lbl{'Spare_Ram_7'} = 0xE7;
		$Lbl{'Spare_Ram_8'} = 0xE8;
		$Lbl{'Spare_Ram_9'} = 0xE9;
		$Lbl{'Spare_Ram_10'} = 0xEA;
		$Lbl{'Spare_Ram_11'} = 0xEB;
		$Lbl{'Spare_Ram_12'} = 0xEC;
		$Lbl{'Spare_Ram_13'} = 0xED;
		$Lbl{'Spare_Ram_14'} = 0xEE;
		$Lbl{'Spare_Ram_15'} = 0xEF;
	    
		$Lbl{'WVM_sleep'}				= 0xEA2F;		  # used internally
		
		$Lbl{'add_points'}					= 0xEC96; $Lbl{'a_cmosinc'} 			  = 0xEFAF;
		$Lbl{'abx_ret'} 				  = 0xF213; $Lbl{'award_special'}			= 0xF6A5;
		$Lbl{'award_replay'}			  = 0xF6BF; $Lbl{'addcredits'}				= 0xF6FE;
		$Lbl{'addcredit2'}				  = 0xF701; $Lbl{'add_player'}				= 0xF858;
		$Lbl{'adjust_func'} 			  = 0xFD0B; $Lbl{'adjust_a'}				= 0xFFF2;
		$Lbl{'b_plus10'}				  = 0xECEE; $Lbl{'b_cmosinc'}				= 0xEF69;
		$Lbl{'bit_switch'}				  = 0xF2EA; $Lbl{'bit_lamp_flash'}			= 0xF2EF;
		$Lbl{'bit_lamp_buf_1'}			  = 0xF2F4; $Lbl{'bit_lamp_buf_0'}			= 0xF2F9;
		$Lbl{'bit_main'}				  = 0xF2FC; $Lbl{'branch_lookup'}			= 0xF38B;
		$Lbl{'breg_sto'}				  = 0xF3CF; $Lbl{'branchdata'}				= 0xF5F8;
		$Lbl{'branch_toggle'}			  = 0xF636; $Lbl{'branch_lamp_on'}			= 0xF63B;
		$Lbl{'branch_lamprangeoff'} 	  = 0xF647; $Lbl{'lamprangeon'} 			= 0xF64E;
		$Lbl{'branch_tilt'} 			  = 0xF653; $Lbl{'branch_gameover'} 		= 0xF65A;
		$Lbl{'branch_lampbuf1'} 		  = 0xF661; $Lbl{'branch_switch'}			= 0xF666;
		$Lbl{'branch_and'}				  = 0xF66B; $Lbl{'branch_add'}				= 0xF670;
		$Lbl{'branch_or'}				  = 0xF672; $Lbl{'branch_equal'}			= 0xF677;
		$Lbl{'branch_ge'}				  = 0xF67C; $Lbl{'branch_threadpri'}		= 0xF67F;
		$Lbl{'branch_bitwise'}			  = 0xF686; $Lbl{'balladjust'}				= 0xF9E6;
		$Lbl{'block_copy'}				  = 0xFFD1; $Lbl{'csum1'}					= 0xE83F;
		$Lbl{'clear_all'}				  = 0xE86C; $Lbl{'checkswitch'} 			= 0xE8D4;
		$Lbl{'check_threads'}			  = 0xE9FC; $Lbl{'check_threadid'}			= 0xEB00;
		$Lbl{'comma_million'}			  = 0xEB99; $Lbl{'comma_thousand'}			= 0xEB9D;
		$Lbl{'checkreplay'} 			  = 0xECAC; $Lbl{'check_sw_mask'}			= 0xEDE7;
		$Lbl{'check_sw_close'}			  = 0xEE61; $Lbl{'check_sw_open'}			= 0xEEBB;
		$Lbl{'copy_word'}				  = 0xEF0F; $Lbl{'cmosinc_a'}				= 0xEF53;
		$Lbl{'cmosinc_b'}				  = 0xEF63; $Lbl{'clr_ram_100'} 			= 0xEF74;
		$Lbl{'clr_ram'} 				  = 0xEF77; $Lbl{'copyblock'}				= 0xEFBC;
		$Lbl{'copyblock2'}				  = 0xEFE4; $Lbl{'csum2'}					= 0xF318;
		$Lbl{'complexbranch'}			  = 0xF615; $Lbl{'credit_special'}			= 0xF6B8;
		$Lbl{'coinlockout'} 			  = 0xF72C; $Lbl{'checkmaxcredits'} 		= 0xF749;
		$Lbl{'creditq'} 				  = 0xF75F; $Lbl{'coin_accepted'}			= 0xF7A2;
		$Lbl{'cmos_a_plus_b_cmos'}		  = 0xF80F; $Lbl{'clear_bonus_coins'}		= 0xF829;
		$Lbl{'csum3'}					  = 0xF833; $Lbl{'clear_range'} 			= 0xF894;
		$Lbl{'clear_displays'}			  = 0xF89A; $Lbl{'copyplayerdata'}			= 0xF8C8;
		$Lbl{'check_hstd'}				  = 0xFA92; $Lbl{'credit_button'}			= 0xFB92;
		$Lbl{'check_adv'}				  = 0xFC6A; $Lbl{'check_aumd'}				= 0xFC75;
		$Lbl{'cmos_add_d'}				  = 0xFDE6; $Lbl{'cmos_a'}					= 0xFE1F;
		$Lbl{'cmos_byteloc'}			  = 0x01BB; $Lbl{'cmos_error'}				= 0xFFCB;
		$Lbl{'cmos_restore'}			  = 0xFFE5; $Lbl{'delaythread'} 			= 0xEA24;
		$Lbl{'dump_thread'} 			  = 0xEA39; $Lbl{'dsnd_pts'}				= 0xEBFE;
		$Lbl{'do_complex_snd'}			  = 0xEDA7; $Lbl{'dly_sto'} 				= 0xF4D4;
		$Lbl{'do_eb'}					  = 0xF6D6; $Lbl{'divide_ab'}				= 0xF816;
		$Lbl{'dec2hex'} 				  = 0xF834; $Lbl{'do_game_init'}			= 0xF847;
		$Lbl{'disp_mask'}				  = 0xF919; $Lbl{'disp_clear'}				= 0xF926;
		$Lbl{'dump_score_queue'}		  = 0xF994; $Lbl{'do_match'}				= 0xFB39;
		$Lbl{'do_tilt'} 				  = 0xFBE9; $Lbl{'do_aumd'} 				= 0xFC57;
		$Lbl{'do_audadj'}				  = 0xFCA5; $Lbl{'diag'}					= 0xFF2B;
		$Lbl{'diag_showerror'}			  = 0xFF7B; $Lbl{'diag_ramtest'}			= 0xFF81;
		$Lbl{'exe_buffer'}				  = 0x1130; $Lbl{'extraball'}				= 0xF6D5;
		$Lbl{'flashlamp'}				  = 0xE957; $Lbl{'factory_zeroaudits'}		= 0xEF7D;
		$Lbl{'fill_hstd_digits'}		  = 0xFB24; $Lbl{'fn_gameid'}				= 0xFD23;
		$Lbl{'fn_gameaud'}				  = 0xFD2E; $Lbl{'fn_sysaud'}				= 0xFD30;
		$Lbl{'fn_hstd'} 				  = 0xFDA9; $Lbl{'fn_replay'}				= 0xFDB1;
		$Lbl{'fn_pricec'}				  = 0xFDEF; $Lbl{'fn_prices'}				= 0xFE09;
		$Lbl{'fn_ret'}					  = 0xFE22; $Lbl{'fn_credit'}				= 0xFE26;
		$Lbl{'fn_cdtbtn'}				  = 0xFE29; $Lbl{'fn_adj'}					= 0xFE33;
		$Lbl{'fn_command'}				  = 0xFE3E; $Lbl{'get_hs_digits'}			= 0xECE4;
		$Lbl{'getswitch'}				  = 0xEE98; $Lbl{'gettabledata_w'}			= 0xF48C;
		$Lbl{'gettabledata_b'}			  = 0xF48E; $Lbl{'getx_rts'}				= 0xF49E;
		$Lbl{'give_credit'} 			  = 0xF6CB; $Lbl{'gameover'}				= 0xFA1E;
		$Lbl{'get_random'}				  = 0xFB80; $Lbl{'hex2bitpos'}				= 0xEB8E;
		$Lbl{'hex2dec'} 				  = 0xEC7F; $Lbl{'hstd_nextp'}				= 0xFAC6;
		$Lbl{'hstd_adddig'} 			  = 0xFB13; $Lbl{'has_credit'}				= 0xFBA3;
		$Lbl{'init_done'}				  = 0xE840; $Lbl{'play_sound_and_score'}	= 0xEBFA;
		$Lbl{'play_sound_A'}			  = 0xECFC; $Lbl{'play_sound_test'} 		= 0xED42;
		$Lbl{'play_sound_times'}		  = 0xED53; $Lbl{'initialize_game'} 		= 0xF878;
		$Lbl{'init_player_game'}		  = 0xF8D2; $Lbl{'init_player_up'}			= 0xF8D2;
		$Lbl{'init_player_sys'} 		  = 0xF933; $Lbl{'irq_entry'}				= 0xFFF8;
		$Lbl{'exit_thread'} 			  = 0xEA67; $Lbl{'exit_thread_sp'}			= 0xEACC;
		$Lbl{'kill_thread'} 			  = 0xEAF3; $Lbl{'kill_threads'}			= 0xEAFB;
		$Lbl{'loadpricing'} 			  = 0xEFD0; $Lbl{'lampbuffers'} 			= 0xF134;
		$Lbl{'lamp_on'} 				  = 0xF13C; $Lbl{'lamp_or'} 				= 0xF141;
		$Lbl{'lamp_commit'} 			  = 0xF147; $Lbl{'lamp_done'}				= 0xF157;
		$Lbl{'lamp_off'}				  = 0xF15B; $Lbl{'lamp_and'}				= 0xF160;
		$Lbl{'lamp_flash'}				  = 0xF169; $Lbl{'lamp_toggle'} 			= 0xF170;
		$Lbl{'lamp_eor'}				  = 0xF175; $Lbl{'lamp_on_b'}				= 0xF17E;
		$Lbl{'lamp_off_b'}				  = 0xF183; $Lbl{'lamp_toggle_b'}			= 0xF188;
		$Lbl{'lamp_on_1'}				  = 0xF18D; $Lbl{'lamp_off_1'}				= 0xF192;
		$Lbl{'lamp_toggle_1'}			  = 0xF197;
		$Lbl{'lampm_off'}				  = 0xF1A7; 		    # turn off all lamps in group [sys7_macros.txt]
		$Lbl{'lampm_noflash'}			  = 0xF1B6; $Lbl{'lampm_f'} 				= 0xF1C7;
		$Lbl{'lampm_sr1'}				  = 0xF1D5; 			# used in JL to consecutively light 10-20-30 bonus lights
		$Lbl{'lampm_a'} 				  = 0xF1EE;
		$Lbl{'lampm_b'} 				  = 0xF1F8;
		$Lbl{'lampm_8'} 				  = 0xF208; 			# turn on all lamps in group [sys7_macros.txt]
		$Lbl{'lampr_start'} 			  = 0xF21A; $Lbl{'lr_ret'}					= 0xF21F;
		$Lbl{'lampr_end'}				  = 0xF226; $Lbl{'lampr_setup'} 			= 0xF22C;
		$Lbl{'lamp_left'}				  = 0xF255; $Lbl{'ls_ret'}					= 0xF25A;
		$Lbl{'lamp_right'}				  = 0xF264; $Lbl{'lampm_c'} 				= 0xF26B;
		$Lbl{'lm_test'} 				  = 0xF26D; $Lbl{'lampm_e'} 				= 0xF27C;
		$Lbl{'lampm_d'} 				  = 0xF294; $Lbl{'lampm_z'} 				= 0xF2B3;
		$Lbl{'lampm_x'} 				  = 0xF302; $Lbl{'load_sw_no'}				= 0xF5B0;
		$Lbl{'lesscredit'}				  = 0xFBC1; $Lbl{'main'}					= 0xE8AD;
		$Lbl{'master_vm_lookup'}		  = 0xF319; $Lbl{'WVM_start'}				= 0xF3AB;
		$Lbl{'macro_rts'}				  = 0xF3AF; $Lbl{'macro_go'}				= 0xF3B5;
		$Lbl{'macro_pcminus100'}		  = 0xF3DB; $Lbl{'macro_code_start'}		= 0xF3E2;
		$Lbl{'macro_special'}			  = 0xF3EA; $Lbl{'macro_extraball'} 		= 0xF3EF;
		$Lbl{'macro_x8f'}				  = 0xF3FB; $Lbl{'macro_17'}				= 0xF418;
		$Lbl{'macro_x17'}				  = 0xF41B; $Lbl{'macro_exec'}				= 0xF46B;
		$Lbl{'macro_getnextbyte'}		  = 0xF495; $Lbl{'macro_ramadd'}			= 0xF4AA;
		$Lbl{'macro_ramcopy'}			  = 0xF4BF; $Lbl{'macro_set_pri'}			= 0xF4CA;
		$Lbl{'macro_delay_imm_b'}		  = 0xF4D2; $Lbl{'macro_getnextword'}		= 0xF4E2;
		$Lbl{'macro_get2bytes'} 		  = 0xF4EA; $Lbl{'macro_rem_th_s'}			= 0xF4EF;
		$Lbl{'macro_rem_th_m'}			  = 0xF4F6; $Lbl{'macro_jsr_noreturn'}		= 0xF4FD;
		$Lbl{'macro_a_ram'} 			  = 0xF509; $Lbl{'macro_b_ram'} 			= 0xF518;
		$Lbl{'macro_jsr_return'}		  = 0xF527; $Lbl{'macro_jmp_cpu'}			= 0xF54F;
		$Lbl{'macro_jmp_abs'}			  = 0xF566; $Lbl{'macro_pcadd'} 			= 0xF58E;
		$Lbl{'macro_setswitch'} 		  = 0xF5A4; $Lbl{'macro_clearswitch'}		= 0xF5BC;
		$Lbl{'macro_branch'}			  = 0xF5CD; $Lbl{'next_sw'} 				= 0xE910;
		$Lbl{'nextthread'}				  = 0xE9FF; $Lbl{'spawn_thread_alt'}		= 0xEA78;
		$Lbl{'spawn_thread'}			  = 0xEAC4; $Lbl{'nmi_entry'}				= 0xFFFC;
		$Lbl{'end_of_ball'} 			  = 0xF9AB; 						  # called at end of left trough switch thread
		$Lbl{'p1_gamedata'} 			  = 0x1140; 						  # gamedata buffers: 20 bytes per player
		$Lbl{'p2_gamedata'} 			  = 0x1159; $Lbl{'p3_gamedata'} 			= 0x1172;
		$Lbl{'p4_gamedata'} 			  = 0x118B; $Lbl{'pia_sound_data'}			= 0x2100;
		$Lbl{'pia_sound_ctrl'}			  = 0x2101; $Lbl{'pia_comma_data'}			= 0x2102;
		$Lbl{'pia_comma_ctrl'}			  = 0x2103; $Lbl{'pia_sol_low_data'}		= 0x2200;
		$Lbl{'pia_sol_low_ctrl'}		  = 0x2201; $Lbl{'pia_sol_high_data'}		= 0x2202;
		$Lbl{'pia_sol_high_ctrl'}		  = 0x2203; $Lbl{'pia_lamp_row_data'}		= 0x2400;
		$Lbl{'pia_lamp_row_ctrl'}		  = 0x2401; $Lbl{'pia_lamp_col_data'}		= 0x2402;
		$Lbl{'pia_lamp_col_ctrl'}		  = 0x2403; $Lbl{'pia_disp_digit_data'} 	= 0x2800;
		$Lbl{'pia_disp_digit_ctrl'} 	  = 0x2801; $Lbl{'pia_disp_seg_data'}		= 0x2802;
		$Lbl{'pia_disp_seg_ctrl'}		  = 0x2803; $Lbl{'pia_switch_return_data'}	= 0x3000;
		$Lbl{'pia_switch_return_ctrl'}	  = 0x3001; $Lbl{'pia_switch_strobe_data'}	= 0x3002;
		$Lbl{'pia_switch_strobe_ctrl'}	  = 0x3003; $Lbl{'pia_alphanum_digit_data'} = 0x4000;
		$Lbl{'pia_alphanum_digit_ctrl'}   = 0x4001; $Lbl{'pia_alphanum_seg_data'}	= 0x4002;
		$Lbl{'pia_alphanum_seg_ctrl'}	  = 0x4003; $Lbl{'pri_next'}				= 0xEB0A;
		$Lbl{'pri_skipme'}				  = 0xEB17; $Lbl{'pack_done'}				= 0xEEB8;
		$Lbl{'pia_ddr_data'}			  = 0xF10E; $Lbl{'pc_sto2'} 				= 0xF505;
		$Lbl{'pc_sto'}					  = 0xF54A; $Lbl{'pull_ba_rts'} 			= 0xF75C;
		$Lbl{'ptrx_plus_1'} 			  = 0xF77F; $Lbl{'ptrx_plus_a'} 			= 0xF784;
		$Lbl{'ptrx_plus'}				  = 0xF785; $Lbl{'player_ready'}			= 0xF8DD;
		$Lbl{'powerup_init'}			  = 0xFA34; $Lbl{'reset'}					= 0xE800;
		$Lbl{'reset_audits'}			  = 0xEF6F; $Lbl{'restore_hstd'}			= 0xEF9D;
		$Lbl{'ram_sto2'}				  = 0xF4BA; $Lbl{'ret_sto'} 				= 0xF529;
		$Lbl{'ram_sto'} 				  = 0xF574; $Lbl{'ret_false'}				= 0xF657;
		$Lbl{'ret_true'}				  = 0xF65E; $Lbl{'resetplayerdata'} 		= 0xF952;
		$Lbl{'rambad'}					  = 0xFF1F; $Lbl{'res_entry'}				= 0xFFFE;
		$Lbl{'switch_queue'}			  = 0x1100; $Lbl{'sol_queue'}				= 0x1118;
		$Lbl{'score_queue'} 			  = 0x1128; $Lbl{'switches'}				= 0xE90D;
		$Lbl{'sw_break'}				  = 0xE942; $Lbl{'solq'}					= 0xE970;
		$Lbl{'snd_queue'}				  = 0xE98C; $Lbl{'solbuf'}					= 0xEB23;
		$Lbl{'set_solenoid'}			  = 0xEB47; $Lbl{'set_ss_off'}				= 0xEB5F;
		$Lbl{'set_s_pia'}				  = 0xEB62; $Lbl{'set_ss_on'}				= 0xEB6B;
		$Lbl{'soladdr'} 				  = 0xEB71; $Lbl{'ssoladdr'}				= 0xEB82;
		$Lbl{'set_comma_bit'}			  = 0xEBC4; $Lbl{'snd_pts'} 				= 0xEC01;
		$Lbl{'score_main'}				  = 0xEC05; $Lbl{'score_update'}			= 0xEC1D;
		$Lbl{'score2hex'}				  = 0xEC86; $Lbl{'sh_exit'} 				= 0xEC95;
		$Lbl{'split_ab'}				  = 0xECF3; $Lbl{'sound_sub'}				= 0xED03;
		$Lbl{'snd_exit_pull'}			  = 0xED99; $Lbl{'snd_exit'}				= 0xED9B;
		$Lbl{'send_snd_save'}			  = 0xED9E; $Lbl{'send_snd'}				= 0xEDA0;
		$Lbl{'store_csndFlag'}			  = 0xEDBF; $Lbl{'sw_ignore'}				= 0xEE01;
		$Lbl{'sw_active'}				  = 0xEE02; $Lbl{'sw_down'} 				= 0xEE04;
		$Lbl{'sw_dtime'}				  = 0xEE15; $Lbl{'sw_trig_yes'} 			= 0xEE19;
		$Lbl{'sw_proc'} 				  = 0xEE48; $Lbl{'sw_pack'} 				= 0xEEAB;
		$Lbl{'sw_get_time'} 			  = 0xEEDB; $Lbl{'sw_tbl_lookup'}			= 0xEEF7;
		$Lbl{'x_plus_a'}				  = 0xEEFF; $Lbl{'setup_vm_stack'}			= 0xEF22;
		$Lbl{'stack_done'}				  = 0xEF3F; $Lbl{'x_plus_b'}				= 0xEF4D;
		$Lbl{'sys_irq'} 				  = 0xEFF7; $Lbl{'spec_sol_def'}			= 0xF122;
		$Lbl{'switch_entry'}			  = 0xF3CB; $Lbl{'set_logic'}				= 0xF68B;
		$Lbl{'store_display_mask'}		  = 0xF8A4; $Lbl{'set_playerbuffer'}		= 0xF8BC;
		$Lbl{'saveplayertobuffer'}		  = 0xF9CB; $Lbl{'show_hstd'}				= 0xFA0B;
		$Lbl{'set_gameover'}			  = 0xFA44; $Lbl{'show_all_scores'} 		= 0xFA58;
		$Lbl{'set_hstd'}				  = 0xFAD7; $Lbl{'stop_background_sound'}	= 0xFB30;
		$Lbl{'start_new_game'}			  = 0xFBBC; $Lbl{'selftest_entry'}			= 0xFC23;
		$Lbl{'st_diagnostics'}			  = 0xFC31; $Lbl{'st_init'} 				= 0xFC80;
		$Lbl{'st_nexttest'} 			  = 0xFC94; $Lbl{'show_func'}				= 0xFCCF;
		$Lbl{'st_reset'}				  = 0xFD16; $Lbl{'st_display'}				= 0xFE43;
		$Lbl{'st_sound'}				  = 0xFE62; $Lbl{'st_lamp'} 				= 0xFE8D;
		$Lbl{'st_autocycle'}			  = 0xFEAC; $Lbl{'st_solenoid'} 			= 0xFECB;
		$Lbl{'st_switch'}				  = 0xFEF0; $Lbl{'st_swnext'}				= 0xFEFC;
		$Lbl{'swi_entry'}				  = 0xFFFA; $Lbl{'time'}					= 0xE8F0;
		$Lbl{'test_mask_b'} 			  = 0xEBD0; $Lbl{'to_ldx_rts'}				= 0xEE95;
		$Lbl{'to_macro_go1'}			  = 0xF433; $Lbl{'to_macro_go2'}			= 0xF4BC;
		$Lbl{'to_getx_rts'} 			  = 0xF516; $Lbl{'to_macro_go4'}			= 0xF54C;
		$Lbl{'to_macro_go3'}			  = 0xF5C7; $Lbl{'to_macro_getnextbyte'}	= 0xF5CA;
		$Lbl{'to_rts3'} 				  = 0xF63A; $Lbl{'test_z'}					= 0xF643;
		$Lbl{'test_c'}					  = 0xF64A; $Lbl{'to_rts4'} 				= 0xF68A;
		$Lbl{'to_pula_rts'} 			  = 0xF898; $Lbl{'to_copyblock'}			= 0xF9E3;
		$Lbl{'to_rts1'} 				  = 0xFB23; $Lbl{'to_rts2'} 				= 0xFB91;
		$Lbl{'tilt_warning'}			  = 0xFBDD; $Lbl{'testdata'}				= 0xFBFA;
		$Lbl{'testlists'}				  = 0xFC04; $Lbl{'to_clear_range'}			= 0xFC91;
		$Lbl{'to_audadj'}				  = 0xFCA3; $Lbl{'tightloop'}				= 0xFF7F;
		$Lbl{'update_commas'}			  = 0xEBA1; $Lbl{'update_eb_count'} 		= 0xEBDB;
		$Lbl{'unpack_byte'} 			  = 0xF19C; $Lbl{'update_hstd'} 			= 0xFAF5;
		$Lbl{'vm_irqcheck'} 			  = 0xE946; $Lbl{'vm_lookup_0x'}			= 0xF339;
		$Lbl{'vm_lookup_1x_a'}			  = 0xF347; $Lbl{'vm_lookup_1x_b'}			= 0xF357;
		$Lbl{'vm_lookup_2x'}			  = 0xF35F; $Lbl{'vm_lookup_4x'}			= 0xF365;
		$Lbl{'vm_lookup_5x'}			  = 0xF36B; $Lbl{'vm_control_0x'}			= 0xF3D3;
		$Lbl{'vm_control_1x'}			  = 0xF3F4; $Lbl{'vm_control_2x'}			= 0xF436;
		$Lbl{'vm_control_3x'}			  = 0xF442; $Lbl{'vm_control_4x'}			= 0xF44F;
		$Lbl{'vm_control_5x'}			  = 0xF4A1; $Lbl{'vm_control_6x'}			= 0xF540;
		$Lbl{'vm_control_7x'}			  = 0xF544; $Lbl{'vm_control_8x'}			= 0xF548;
		$Lbl{'vm_control_9x'}			  = 0xF558; $Lbl{'vm_control_ax'}			= 0xF562;
		$Lbl{'vm_control_bx'}			  = 0xF56B; $Lbl{'vm_control_cx'}			= 0xF578;
		$Lbl{'vm_control_dx'}			  = 0xF57D; $Lbl{'vm_control_ex'}			= 0xF587;
		$Lbl{'vm_control_fx'}			  = 0xF587; $Lbl{'write_range'} 			= 0xF840;
		$Lbl{'wordplusbyte'}			  = 0xFB17;
        }
	} # if ($WMS_System == 7)

#----------------------------------------------------------------------
# WVM11 Interface
#	- fixed
#	- magic
#----------------------------------------------------------------------

	elsif ($WMS_System == 11) {
 
			setLabel('_Reg-A',0x00);			 # non-volatile registers
			setLabel('_Reg-B',0x01);
			setLabel('_Reg-C',0x02);
			setLabel('_Reg-D',0x03);
			setLabel('_Reg-E',0x04);
			setLabel('_Reg-F',0x05);
			setLabel('_Reg-G',0x06);
			setLabel('_Reg-H',0x07);
			setLabel('_Reg-I',0x08);			 # volatile registers
			setLabel('_Reg-J',0x09);
			setLabel('_Reg-K',0x0A);
			setLabel('_Reg-L',0x0B);
			setLabel('_Reg-M',0x0C);
			setLabel('_Reg-N',0x0D);
			setLabel('_Reg-O',0x0E);
			setLabel('_Reg-P',0x0F);

			setLabel('_bufSel_p1',			0x3A);			   	# 0: main buffer, FF: alt buffer
			setLabel('_bufSel_p2',			0x3B);
			setLabel('_bufSel_p3',			0x3C);
			setLabel('_bufSel_p4',			0x3D);

			sub init_system_11() {				# system 11 magic (done after reading ROM)
				$Address = 0xFFC6;
					for (my($o)=1; $o<8; $o++) { setLabel("=Lamps+$o",WORD($Address)+$o); }
					def_ptr_hex_alt('^=Lamps','=Lamps','Debugger Pointers');
					for (my($o)=1; $o<8; $o++) { setLabel("=Flags+$o",WORD($Address)+$o); }
					def_ptr_hex_alt('^=Flags','=Flags');
					for (my($o)=1; $o<8; $o++) { setLabel("=Lamps_bufSel+$o",WORD($Address)+$o); }
					def_ptr_hex_alt('^=Lamps_bufSel','=Lamps_bufSel');
					for (my($o)=1; $o<8; $o++) { setLabel("=Lamps_altBuf+$o",WORD($Address)+$o); }
					def_ptr_hex_alt('^=Lamps_altBuf','=Lamps_altBuf');
					for (my($o)=1; $o<8; $o++) { setLabel("=Lamps_blinkBuf+$o",WORD($Address)+$o); }
					def_ptr_hex_alt('^=Lamps_blinkBuf','=Lamps_blinkBuf');
					for (my($o)=1; $o<8; $o++) { setLabel("=Switches+$o",WORD($Address)+$o); }
					def_ptr_hex_alt('^=Switches','=Switches');
					push(@Switch2WVMSubroutines,WORD($Address));
					def_code_ptr('^WVM_start','WVM_start');
				    def_ptr_hex_alt('^_IRQ_tics_counter','_IRQ_tics_counter');
					def_code_ptr('^WVM_exitThread','WVM_exitThread');
					def_ptr_hex('^unknown_debug_ptr');
					def_ptr_hex_alt('^__threads_running_ptr','__threads_running_ptr');
					setLabel('__current_thread_ptr+1',WORD($Address)+1);
					def_ptr_hex_alt('^__current_thread_ptr','__current_thread_ptr');
					setLabel('__WVM_PC+1',WORD($Address)+1);
					def_ptr_hex_alt('^__WVM_PC','__WVM_PC');
					def_code_ptr('^WVM_sleep','WVM_sleep');
					def_code_ptr('^WVM_sleepI','WVM_sleepI',undef,'_SLEEP macro (JSR WVM_sleepI; .DB #xx)');
					def_code_ptr('^next_WVM_op_debugger_hook','next_WVM_op_debugger_hook','Debugger Hooks');
					def_byteblock_code(3,'debugger_stepper_hook?');
					def_byteblock_code(3,'kill_thread_debugger_hook');
					def_byteblock_code(3,'thread_switch_debugger_hook');
					def_byteblock_code(3,'pre_exec_debugger_hook');
					def_byteblock_code(3,'WVM_halt_loop_debugger_hook');
					def_byteblock_code(2,'debug_macro_hook');

				$Address = $Lbl{'WVM_exitThread'}+0x11; 					# derived magic
					$lbl = 'spawn_thread_WVM_id06'; def_code($lbl);
				$Address = $Lbl{$lbl}+0x06;     
					$lbl = 'spawn_thread_WVM'; def_code($lbl);
				$Address = $Lbl{$lbl}+0x07;     
					$lbl = 'spawn_thread_6800_[A]'; def_code($lbl);
				$Address = $Lbl{$lbl}+0x02;     
					$lbl = 'spawn_thread_6800'; def_code($lbl);
				$Address = $Lbl{$lbl}+0x4C;     
					$lbl = 'spawn_thread_6800_id06';
					if (&BYTE($Address-1) == 0x39) {						# RTS, PinBot
						# do nothing
					} elsif (&BYTE($Address-1) == 0x01) {					# NOP, BadCats
						$Address += 2;
					} else {
						die(sprintf("cannot find spawn_thread_6800_id06 routine (%02X)",&BYTE($Address-1)));
					}
					def_code($lbl);
					$Address = $Lbl{$lbl}+0x08;
					$lbl = 'kill_this_thread'; def_code($lbl);
				$Address = $Lbl{$lbl}+0x2A;     
                    $lbl = 'kill_thread'; def_code($lbl);
	        }
	} elsif (defined($WMS_System)) {
		die("$0: unknown WMS_System $WMS_System\n");
	}
	print(STDERR "\n");
} # import

#----------------------------------------------------------------------
# Load ROM Image
#----------------------------------------------------------------------

sub load_ROM($$)
{
	my($fn,$saddr) = @_;
	my($nread,$buf,$eaddr);

	open(RF,$fn) || die("$fn: $!");
	for (my($ofs)=0; ($nread = sysread(RF,$buf,1024)) > 0; $ofs+=$nread) {
		@ROM[($saddr+$ofs)..($saddr+$ofs+$nread-1)] = unpack('C*',$buf);
		$eaddr = $saddr + $ofs + $nread - 1;
	}
	close(RF);
	printf(STDERR "ROM[\$%04X..\$%04X] loaded\n",$saddr,$eaddr)
		if ($verbose > 1);
	$MIN_ROM_ADDR = $saddr unless defined($MIN_ROM_ADDR);
	$MIN_ROM_ADDR = $saddr if ($saddr < $MIN_ROM_ADDR);
	$MAX_ROM_ADDR = $eaddr unless ($eaddr < $MAX_ROM_ADDR);
	&init_system_11() if ($WMS_System==11 && WORD(0xFFFE)>0);
}

#----------------------------------------------------------------------
# Label Functions
#	- 2 data structures need to be maintained in sync:
#		- %Lbl{label} = addr
#		- @LBL[addr]  = label
#	- setLabel:
#		- if 3rd argument evaluates to true, allow for duplicate
#	      definitions (C711 -x)
#		- {}label is STICKY; address added between braces
#		- first non-automatic label overwrites any previous auto lbl
#		- otherwise, no overwriting
#	- label_address:
#		- set @AUTO_LBL[addr] to be used when no label is set during output
#	- substitute_label:
#		- set %Lbl_refs{label} = # of references
#----------------------------------------------------------------------

sub setLabel($$)
{
	my($lbl,$addr) = @_;

#	die(sprintf("trying to define empty label [setLabel($lbl,0x%04X,$allow_multiple)]\n",$addr))
#		if (length($lbl) == 0);
	return 0 if (length($lbl) == 0);							# don't think return value is used for anything

	$lbl = sprintf('{%04X}%s',$addr,$') 						# STICKY -> fill address
		if ($lbl =~ /^{}/);
	undef($Lbl{$LBL[$addr]})									# overwrite existing auto label with non-auto label
		if (($LBL[$addr] =~ m{_[0-9A-F]{4}$}) &&				#	otherwise, make duplicate
    		!($lbl =~ m{_[0-9A-F]{4}$}));
	$LBL[$addr] = $lbl;											# define label
	$Lbl{$lbl} = $addr;
	return 1;
}

sub overwriteLabel($$)
{
	my($lbl,$addr) = @_;

#	print(STDERR "overwriteLabel($lbl) [$LBL[$addr]]\n");
   	undef($Lbl{$LBL[$addr]});			
	$LBL[$addr] = $lbl;					
	$Lbl{$lbl} = $addr;
	return 1;
}

sub underwriteLabel($$)
{
	my($lbl,$addr) = @_;

#	print(STDERR "underwriteLabel($lbl) [$LBL[$addr]]\n");
   	return 0 if defined($LBL[$addr]);
	$LBL[$addr] = $lbl;					
	$Lbl{$lbl} = $addr;
	return 1;
}

sub label_with_addr($$)											# add hex address to end of label for ROM addresses
{																# mark RAM and PIA addresses
	my($lbl,$addr) = @_;

	if ($addr > $MAX_ROM_ADDR) {								# ROM address
		return sprintf('syscall_%04X',$addr);
	}

	if ($addr >= $MIN_ROM_ADDR) {								# ROM address
		$lbl = $` if ($lbl =~ m{_[0-9A-F]{4}$});				# remove previous address (if there is one)
		return sprintf('%s_%04X',$lbl,$addr);
	}

	if ($addr > 0x7FF) {										# PIA address
		return sprintf('PIA_%04X',$addr);
	}

	if ($addr > 0xFF) {											# 16-bit RAM address
		return sprintf('RAM_%04X',$addr);
	} else {													# 8-bit
		return sprintf('RAM_%02X',$addr);
	}
}

sub label_address($$@)											# save auto lbl for output and return hex address
{
	my($addr,$auto_lbl,$nosuffix) = @_;
	$auto_lbl = 'library' if ($AUTO_LBL[$addr] =~ m{_[0-9A-F]{4}$});
	$AUTO_LBL[$addr] = $nosuffix ? $auto_lbl : label_with_addr($auto_lbl,$addr);
	return ($addr > 255) ? sprintf('$%04X',$addr)
						 : sprintf('$%02X',$addr);
}

sub substitute_label($$)										# replace addresses in a single arg with labels
{
	my($opa,$opaddr) = @_;										# argument to process
	return $opa if ($nolabel[$opaddr]);

	my($pf,$addr,$mark) = ($opa =~ m{^(\#?\$)([0-9A-Fa-f]+)(!?)$});	# hex number ($ followed by hex digits) => potential address
	return $opa unless defined($addr);							# not an address => nothing to substitute
	return $pf.$addr if ($mark eq '!');							# address marked with trailing '!' (.DB, .DW) => do not substitute with labels
	$addr = hex($addr);											# translate from hex
	my($imm) = (substr($opa,0,1) eq '#') ? '#' : '';			# immediate addressing marker
	return $opa													# don't substitute 8-bit immediate values
		if ($addr == 0 || ($imm && $addr<0x100 && $OP[$opaddr] ne 'LDX'));	

	my($lbl) = $LBL[$addr]; 									# check if label is defined
	$Lbl_refs{$lbl}++, return $imm.$lbl							# substitute its name
		if defined($lbl);			

	my($auto_lbl) = $AUTO_LBL[$addr];							# use auto label if defined
	return $opa unless defined($auto_lbl);
    
	if (defined($Lbl{$auto_lbl})) { 							# auto label already defined
		$Lbl_refs{$auto_lbl}++, return $imm.$auto_lbl			# and it matches
			if ($Lbl{$auto_lbl} == $addr);	
		my($i);
		for ($i=1; defined($Lbl{"${auto_lbl}$i"}); $i++) {		# find unique alternative
			return $imm."${auto_lbl}$i"							# already defined
				if ($Lbl{"${auto_lbl}$i"} == $addr);
		}
		$auto_lbl = "${auto_lbl}$i";						  	# new, unique label
	}
	setLabel($auto_lbl,$addr);								   	# define label
	$Lbl_refs{$auto_lbl}++;
	return $imm.$auto_lbl;
}

sub substitute_labels()											# replace addresses with labels as much as possible
{
	for (local($addr)=0; $addr<@ROM; $addr++) {
		for (my($i)=0; $i<@{$OPA[$addr]}; $i++) {
			$OPA[$addr][$i] = substitute_label($OPA[$addr][$i],$addr);
		}
	}
	foreach my $addr (keys(%label_arith_exprs)) {				# substitude expressions defined with def_lbl_arith()
		die unless (@{$OPA[$addr-1]} == 1);
		$OPA[$addr-1][0] = ($OPA[$addr-1][0] =~ /^#/) ? '#' : '';
		$OPA[$addr-1][0] .= $label_arith_exprs{$addr};
	}
	foreach my $addr (keys(%pointer)) {							# substitude labels defined with def_ptr2lbl()
		die(sprintf("%04X: $OP[$addr] @{$OPA[$addr]}",$addr)) unless (@{$OPA[$addr]} == 1);
		$OPA[$addr][0] = $pointer{$addr};
	}
}

sub disassemble_unfollowed_labels()								# from begin/end6800 and def_byteblock_code
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

sub insert_divider($$)											# Subroutine, Jump Target, etc.
{
	my($addr,$label) = @_;
#	return if ($DIVIDER[$addr] || !defined($label));
	return unless defined($label);

	$DIVIDER[$addr] = 1;
	push(@{$EXTRA[$addr]},'');
	push(@{$EXTRA_IND[$addr]},0); $EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1;
	push(@{$EXTRA[$addr]},';----------------------------------------------------------------------');
	push(@{$EXTRA_IND[$addr]},0); $EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1;
	push(@{$EXTRA[$addr]},"; $label");
	push(@{$EXTRA_IND[$addr]},0); $EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1;
	push(@{$EXTRA[$addr]},';----------------------------------------------------------------------');
	push(@{$EXTRA_IND[$addr]},0); $EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1;
	push(@{$EXTRA[$addr]},'');
	push(@{$EXTRA_IND[$addr]},0); $EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1;
}

#----------------------------------------------------------------------
# Disassembler Control
#----------------------------------------------------------------------

sub reset(@)													# to allow restarting it
{
	$Address = $_[0] if (@_);									# address is optional argument
	
	$unclean = 0;												# set when disassebler encounters errors
	undef(@SCORE);												# list of score instruction addresses decoded

	undef(@LBL); undef(@OP); undef(@OPA); undef(@REM);			# label, operator, operands, remarks
	undef(@decoded);											# flag set to 1 to mark already decoded code
	undef(@TYPE);												# code type (only set for bytes with OPs)
	undef(@EXTRA);												# extra lines to add before OP
	undef(@DIVIDER);											# code divider to add before everything
	undef(@IND); undef(@EXTRA_IND); 							# indentation
	undef(@N_LABELS);											# # of labels pointing to address
}

my($sAddress,$sunclean,@sSCORE,@sLBL,@sOP,@sOPA,@sREM); 		# saved state
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
# Motorola 6800 Disassembler
#----------------------------------------------------------------------

sub op_IMP(@)													# operation with implied addressing
{
	my($opc,$ind,$op,@args) = @_;
	return undef unless (BYTE($addr) == $opc);
	$OP[$addr] = $op; $IND[$addr] = $ind;
	@{$OPA[$addr]} = @args;
	$decoded[$addr++] = 1;
	return 1;
}

sub op_IMM(@)													# operation with immediate addressing
{
	my($opc,$ind,$op,@args) = @_;
	return undef unless (BYTE($addr) == $opc);
	$OP[$addr] = $op; $IND[$addr] = $ind;
	push(@{$OPA[$addr]},@args);
	push(@{$OPA[$addr]},sprintf('#$%02X',BYTE($addr+1)));
	$decoded[$addr++] = $decoded[$addr++] = 1;
	return 1;
}

sub op_IMM2(@)													# operation with immediate 2-byte addressing
{
	my($opc,$ind,$op,@args) = @_;
	return undef unless (BYTE($addr) == $opc);
	$OP[$addr] = $op; $IND[$addr] = $ind;
	push(@{$OPA[$addr]},@args);
	push(@{$OPA[$addr]},sprintf('#$%04X',WORD($addr+1)));
	$decoded[$addr++] = $decoded[$addr++] = $decoded[$addr++] = 1;
	return 1;
}

sub op_DIR(@)													# operation with direct addressing
{
	my($opc,$ind,$op,@args) = @_;
	return undef unless (BYTE($addr) == $opc);
	my($op_DIR) = BYTE($addr+1);
	$OP[$addr] = $op; $IND[$addr] = $ind;
	push(@{$OPA[$addr]},@args);
	push(@{$OPA[$addr]},label_address($op_DIR,$lbl_root));
	$decoded[$addr++] = $decoded[$addr++] = 1;
	return 1;
}

sub op_EXT(@)													# operation with extended addressing
{
	my($opc,$ind,$op,@args) = @_;
	return undef unless (BYTE($addr) == $opc);
	my($op_EXT) = WORD($addr+1);
	$OP[$addr] = $op; $IND[$addr] = $ind;
	push(@{$OPA[$addr]},@args);
	push(@{$OPA[$addr]},label_address($op_EXT,$lbl_root));
	$decoded[$addr++] = $decoded[$addr++] = $decoded[$addr++] = 1;
	return $op_EXT;												# return address!!
}

sub op_REL($$$$$)												# operation with relative addressing
{
	my($opc,$ind,$op,$lbl_root,$follow_code) = @_;
	return undef unless (BYTE($addr) == $opc);
	my($trg_addr) = $addr + 2 + ((BYTE($addr+1) < 128) ? BYTE($addr+1) : BYTE($addr+1)-256);
	$OP[$addr] = $op; $IND[$addr] = $ind;
	$OPA[$addr][0] = label_address($trg_addr,$lbl_root);
	$decoded[$addr++] = $decoded[$addr++] = 1;
	if ($follow_code) {
		disassemble_6800($ind,$trg_addr,$lbl_root);
	} else {				   									# don't follow code in byte-limited sections
		push(@unfollowed_lbl,$trg_addr);
	}
		
	return 1;
}

sub op_IND(@)													# operation with indirect addressing
{
	my($opc,$ind,$op,@args) = @_;
	return undef unless (BYTE($addr) == $opc);
	$OP[$addr] = $op; $IND[$addr] = $ind;
	push(@{$OPA[$addr]},@args);
	push(@{$OPA[$addr]},sprintf('%d,X',BYTE($addr+1)));
	$decoded[$addr++] = $decoded[$addr++] = 1;
	return 1;
}


sub disassemble_6800(@) 										# disassemble 6800 CPU code
{
	my($ind,$addr,$lbl_root,$divider_label) = @_;
	return disassemble_6800_nbytes($ind,$addr,$lbl_root,9e99,1,$divider_label);		# follow_code = 1
}

sub disassemble_6800_nbytes(@)									# disassemble 6800 CPU code with byte limit
{
	local($ind,$addr,$lbl_root,$max_bytes,$follow_code,$divider_label) = @_;
#	printf("disassemble_6800_nbytes($ind,%04X,$lbl_root,$max_bytes,$follow_code)\n",$addr);

	unless (defined(BYTE($addr))) { 												# outside loaded ROM range
		return unless ($WMS_System == 11);											# okay for Sys 7 and M6800 assembly
		printf(STDERR "; WARNING: disassembly address %04X outside ROM range\n",$addr)
			if ($verbose > 0);
		$unclean = 1;
		return;
	}
	if ($decoded[$addr] && !defined($OP[$addr])) {								   # not at start of instruction
		printf("ABORT: disassembly M6800 code at \$%04X within already disassembled instruction code\n" .
			   "\t[$lbl_root]\n",$addr)
			if ($verbose > 0);
		$unclean = 1;
		return;
	}
	insert_divider($addr,$divider_label);  
	$N_LABELS[$addr]++;

	my($start_addr) = $addr;
	while ($addr-$start_addr < $max_bytes) {
#		printf("M6800 disassembling opcode %02X at %04X\n",BYTE($addr),$addr);
		unless (defined(BYTE($addr))) {
			printf(STDERR "; WARNING: disassembly address %04X outside ROM range\n",$addr)
				if ($verbose > 0);
			$unclean = 1;
			return;
		}
		return if ($decoded[$addr]);
#		printf("disassemble_6800(%04X) %d bytes to go\n",
#			$addr,$max_bytes-$addr+$start_addr) if ($max_bytes < 1000);
		$TYPE[$addr] = $CodeType_6800;

		next if op_IMP(0x01,$ind,'NOP');
		next if op_IMP(0x06,$ind,'TAP'); next if op_IMP(0x07,$ind,'TPA');
		next if op_IMP(0x08,$ind,'INX'); next if op_IMP(0x09,$ind,'DEX');
		next if op_IMP(0x0A,$ind,'CLV'); next if op_IMP(0x0B,$ind,'SEV');
		next if op_IMP(0x0C,$ind,'CLC'); next if op_IMP(0x0D,$ind,'SEC');
		next if op_IMP(0x0E,$ind,'CLI'); next if op_IMP(0x0F,$ind,'SEI');
	    
		next if op_IMP(0x10,$ind,'SBA'); next if op_IMP(0x11,$ind,'CBA');
		next if op_IMP(0x16,$ind,'TAB'); next if op_IMP(0x17,$ind,'TBA');
		next if op_IMP(0x19,$ind,'DAA');
		next if op_IMP(0x1B,$ind,'ABA'); 

		if (op_REL(0x20,$ind,'BRA',$lbl_root,$follow_code)) {
		    push(@{$EXTRA[$addr]},'');
	        push(@{$EXTRA_IND[$addr]},0);
			$EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1;
			return;
		}

		next if op_REL(0x22,$ind,'BHI',$lbl_root,$follow_code); next if op_REL(0x23,$ind,'BLS',$lbl_root,$follow_code);
		next if op_REL(0x24,$ind,'BCC',$lbl_root,$follow_code); next if op_REL(0x25,$ind,'BCS',$lbl_root,$follow_code);
		next if op_REL(0x26,$ind,'BNE',$lbl_root,$follow_code); next if op_REL(0x27,$ind,'BEQ',$lbl_root,$follow_code);
		next if op_REL(0x28,$ind,'BVC',$lbl_root,$follow_code); next if op_REL(0x29,$ind,'BVS',$lbl_root,$follow_code);
		next if op_REL(0x2A,$ind,'BPL',$lbl_root,$follow_code); next if op_REL(0x2B,$ind,'BMI',$lbl_root,$follow_code);
		next if op_REL(0x2C,$ind,'BGE',$lbl_root,$follow_code); next if op_REL(0x2D,$ind,'BLT',$lbl_root,$follow_code);
		next if op_REL(0x2E,$ind,'BGT',$lbl_root,$follow_code); next if op_REL(0x2F,$ind,'BLE',$lbl_root,$follow_code);
	    
		next if op_IMP(0x30,$ind,'TSX');  next if op_IMP(0x31,$ind,'INS');
		next if op_IMP(0x32,$ind,'PULA'); next if op_IMP(0x33,$ind,'PULB');
		next if op_IMP(0x34,$ind,'DES');  next if op_IMP(0x35',$ind,'TXS');
		next if op_IMP(0x36,$ind,'PSHA'); next if op_IMP(0x37,$ind,'PSHB');
		if (op_IMP(0x39,$ind,'RTS')) {
		    push(@{$EXTRA[$addr]},'');
	        push(@{$EXTRA_IND[$addr]},0);
			$EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1;
			return;
		}
		if (op_IMP(0x3B,$ind,'RTI')) {
		    push(@{$EXTRA[$addr]},'');
	        push(@{$EXTRA_IND[$addr]},0);
			$EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1;
			return;
		}
		next if op_IMP(0x3E,$ind,'WAI');
		if (op_IMP(0x3F,$ind,'SWI')) {
		    push(@{$EXTRA[$addr]},'');
	        push(@{$EXTRA_IND[$addr]},0);
			$EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1;
			return;
		}
	    
		next if op_IMP(0x40,$ind,'NEGA');
		next if op_IMP(0x43,$ind,'COMA');
		next if op_IMP(0x44,$ind,'LSRA');
		next if op_IMP(0x46,$ind,'RORA'); next if op_IMP(0x47,$ind,'ASRA');
		next if op_IMP(0x48,$ind,'ASLA'); next if op_IMP(0x49,$ind,'ROLA');
		next if op_IMP(0x4A,$ind,'DECA');
		next if op_IMP(0x4C,$ind,'INCA'); next if op_IMP(0x4D,$ind,'TSTA');
		next if op_IMP(0x4F,$ind,'CLRA');

		next if op_IMP(0x50,$ind,'NEGB');
		next if op_IMP(0x53,$ind,'COMB');
		next if op_IMP(0x54,$ind,'LSRB');
		next if op_IMP(0x56,$ind,'RORB'); next if op_IMP(0x57,$ind,'ASRB');
		next if op_IMP(0x58,$ind,'ASLB'); next if op_IMP(0x59,$ind,'ROLB');
		next if op_IMP(0x5A,$ind,'DECB');
		next if op_IMP(0x5C,$ind,'INCB'); next if op_IMP(0x5D,$ind,'TSTB');
		next if op_IMP(0x5F,$ind,'CLRB');

		next if op_IND(0x60,$ind,'NEG');
		next if op_IND(0x63,$ind,'COM');
		next if op_IND(0x64,$ind,'LSR');
		next if op_IND(0x66,$ind,'ROR'); next if op_IND(0x67,$ind,'ASR');
		next if op_IND(0x68,$ind,'ASL'); next if op_IND(0x69,$ind,'ROL');
		next if op_IND(0x6A,$ind,'DEC');
		next if op_IND(0x6C,$ind,'INC'); next if op_IND(0x6D,$ind,'TST');
		if (op_IND(0x6E,$ind,'JMP')) {															  # NB: cannot follow an indexed jump
		    push(@{$EXTRA[$addr]},'');
	        push(@{$EXTRA_IND[$addr]},0);
			$EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1;
			return;
		}

		next if op_IND(0x6F,$ind,'CLR');

		next if op_EXT(0x70,$ind,'NEG');
		next if op_EXT(0x73,$ind,'COM');
		next if op_EXT(0x74,$ind,'LSR');
		next if op_EXT(0x76,$ind,'ROR'); next if op_EXT(0x77,$ind,'ASR');
		next if op_EXT(0x78,$ind,'ASL'); next if op_EXT(0x79,$ind,'ROL');
		next if op_EXT(0x7A,$ind,'DEC');
		next if op_EXT(0x7C,$ind,'INC'); next if op_EXT(0x7D,$ind,'TST');
		my($jmp_addr);
		if ($jmp_addr=op_EXT(0x7E,$ind,'JMP')) {
			if (hex(substr($OPA[$addr-3][0],1,4)) == $Lbl{'WVM_exitThread'}) {						# needs adaptation to system 7 !!!!!
				$OP[$addr-3] = '_EXIT_THREAD'; undef($OPA[$addr-3][0]);
			    push(@{$EXTRA[$addr]},'');
		        push(@{$EXTRA_IND[$addr]},0);
				$EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr-3]}] = 1;
			} else {
			    push(@{$EXTRA[$addr]},'');
		        push(@{$EXTRA_IND[$addr]},0);
				$EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1;
				if ($follow_code) {
					disassemble_6800($ind,$jmp_addr,$lbl_root);
				} else {
					push(@unfollowed_lbl,$jmp_addr);
				}
					
			}
			return;
		}
		next if op_EXT(0x7F,$ind,'CLR');

		next if op_IMM(0x80,$ind,'SUBA'); next if op_IMM(0x81,$ind,'CMPA');
		next if op_IMM(0x82,$ind,'SBCA');
		next if op_IMM(0x84,$ind,'ANDA'); next if op_IMM(0x85,$ind,'BITA');
		next if op_IMM(0x86,$ind,'LDAA');
		next if op_IMM(0x88,$ind,'EORA'); next if op_IMM(0x89,$ind,'ADCA');
		next if op_IMM(0x8A,$ind,'ORAA'); next if op_IMM(0x8B,$ind,'ADDA');
		next if op_IMM2(0x8C,$ind,'CPX');
		
		#
		# Special Handling for BSR
		#	- required, because of two OS subroutines with special behavior
		#
		if (defined($WMS_System)) {
			if (BYTE($addr)==0x8D) {												# BSR
				my($trg_addr) = $addr + 2 + ((BYTE($addr+1) < 128) ? BYTE($addr+1) : BYTE($addr+1)-256);
				if ($trg_addr == $Lbl{'WVM_start'}) {								# BSR WVM_start => _WVM_MODE
					$OP[$addr] = '_WVM_MODE'; $IND[$addr] = $ind;
					$decoded[$addr] = $decoded[$addr+1] = 1;
					disassemble_wvm($ind,$addr+2,$lbl_root);
					$addr += 2;
					return;
				} elsif ($trg_addr == $Lbl{'WVM_sleepI'}) { 						# BSR WVM_sleepI, .DB tics => _SLEEP #tics
					$OP[$addr] = '_SLEEP'; $IND[$addr] = $ind;
					$OPA[$addr][0] = sprintf('#%d',BYTE($addr+2));
					$decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = 1;
					$addr += 3;
				} else {															# regular BSR
					$OP[$addr] = 'BSR'; $IND[$addr] = $ind;
					my($jump_to) = $trg_addr;
					$OPA[$addr][0] = label_address($jump_to,$lbl_root);
					$decoded[$addr] = $decoded[$addr+1] = 1;
					if ($follow_code) {
						disassemble_6800($code_base_indent,$jump_to,$lbl_root);
					} else {
						push(@unfollowed_lbl,$jump_to);
					}
						
					$addr += 2;
	
					foreach my $sraddr (@Switch2WVMSubroutines) {					# M6800 subroutines returning in WVM mode
						next unless ($jump_to == $sraddr);
						disassemble_wvm($ind,$addr,$lbl_root);
						return;
					}
	
				}
				next;
	        }
        } elsif (BYTE($addr)==0x8D) {												# standard M6800 BSR (no WMS_System defined)
			$OP[$addr] = 'BSR'; $IND[$addr] = $ind;
			my($trg_addr) = $addr + 2 + ((BYTE($addr+1) < 128) ? BYTE($addr+1) : BYTE($addr+1)-256);
			$OPA[$addr][0] = label_address($trg_addr,$lbl_root);
			$decoded[$addr] = $decoded[$addr+1] = 1;
			if ($follow_code) {
				disassemble_6800($code_base_indent,$trg_addr,$lbl_root);
			} else {
				push(@unfollowed_lbl,$trg_addr);
			}
				
			$addr += 2;
			next;
        }

		next if op_IMM2(0x8E,$ind,'LDS');
	    
		next if op_DIR(0x90,$ind,'SUBA'); next if op_DIR(0x91,$ind,'CMPA');
		next if op_DIR(0x92,$ind,'SBCA');
		next if op_DIR(0x94,$ind,'ANDA'); next if op_DIR(0x95,$ind,'BITA');
		next if op_DIR(0x96,$ind,'LDAA'); next if op_DIR(0x97,$ind,'STAA');
		next if op_DIR(0x98,$ind,'EORA'); next if op_DIR(0x99,$ind,'ADCA');
		next if op_DIR(0x9A,$ind,'ORAA'); next if op_DIR(0x9B,$ind,'ADDA');
		next if op_DIR(0x9C,$ind,'CPX'); 
		next if op_DIR(0x9E,$ind,'LDS'); next if op_DIR(0x9F,$ind,'STS');
	    
		next if op_IND(0xA0,$ind,'SUBA'); next if op_IND(0xA1,$ind,'CMPA');
		next if op_IND(0xA2,$ind,'SBCA');
		next if op_IND(0xA4,$ind,'ANDA'); next if op_IND(0xA5,$ind,'BITA');
		next if op_IND(0xA6,$ind,'LDAA'); next if op_IND(0xA7,$ind,'STAA');
		next if op_IND(0xA8,$ind,'EORA'); next if op_IND(0xA9,$ind,'ADCA');
		next if op_IND(0xAA,$ind,'ORAA'); next if op_IND(0xAB,$ind,'ADDA');
		next if op_IND(0xAC,$ind,'CPX'); next if op_IND(0xAD,$ind,'JSR');		# JSR 0,X
		next if op_IND(0xAE,$ind,'LDS'); next if op_IND(0xAF,$ind,'STS');
	    
		next if op_EXT(0xB0,$ind,'SUBA'); next if op_EXT(0xB1,$ind,'CMPA');
		next if op_EXT(0xB2,$ind,'SBCA');
		next if op_EXT(0xB4,$ind,'ANDA'); next if op_EXT(0xB5,$ind,'BITA');
		next if op_EXT(0xB6,$ind,'LDAA'); next if op_EXT(0xB7,$ind,'STAA');
		next if op_EXT(0xB8,$ind,'EORA'); next if op_EXT(0xB9,$ind,'ADCA');
		next if op_EXT(0xBA,$ind,'ORAA'); next if op_EXT(0xBB,$ind,'ADDA');
		next if op_EXT(0xBC,$ind,'CPX');
		next if op_EXT(0xBE,$ind,'LDS'); next if op_EXT(0xBF,$ind,'STS');

		#
		# Special Handling for JSR with extended addressing (EXT)
		#	- required, because of two OS subroutines with special behavior
		#
		if (defined($WMS_System)) {
			if (BYTE($addr)==0xBD) {												# JSR <ADDR>
				if (WORD($addr+1) == $Lbl{'WVM_start'}) {							# JSR WVM_start => _WVM_MODE
					$OP[$addr] = '_WVM_MODE'; $IND[$addr] = $ind;
					$decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = 1;
					disassemble_wvm($ind,$addr+3,$lbl_root);
					$addr += 3;
					return;
				} elsif (WORD($addr+1) == $Lbl{'WVM_sleepI'}) { 					# JSR WVM_sleepI, .DB tics => _SLEEP #tics
					$OP[$addr] = '_SLEEP'; $IND[$addr] = $ind;
					$OPA[$addr][0] = sprintf('#%d',BYTE($addr+3));
					$decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = $decoded[$addr+3] = 1;
					$addr += 4;
				} else {															# regular JSR
					$OP[$addr] = 'JSR'; $IND[$addr] = $ind;
					my($jump_to) = WORD($addr+1);
					$OPA[$addr][0] = label_address($jump_to,$lbl_root);
					$decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = 1;
					if ($follow_code) {
						disassemble_6800($code_base_indent,$jump_to,$lbl_root);
					} else {
						push(@unfollowed_lbl,$jump_to);
					}
					$addr += 3;
	
					foreach my $sraddr (@Switch2WVMSubroutines) {					# M6800 subroutines returning in WVM mode
						next unless ($jump_to == $sraddr);
						disassemble_wvm($ind,$addr,$lbl_root);
						return;
					}
	
				}
				next;
	        }
        } elsif (BYTE($addr)==0xBD) {												# regular M6800 disassembly ($WMS_System not defined)
			$OP[$addr] = 'JSR'; $IND[$addr] = $ind;
			my($jump_to) = WORD($addr+1);
			$OPA[$addr][0] = label_address($jump_to,$lbl_root);
			$decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = 1;
			if ($follow_code) {
				disassemble_6800($code_base_indent,$jump_to,$lbl_root);
			} else {
				push(@unfollowed_lbl,$jump_to);
			}
			$addr += 3;
			next;
        }

		next if op_IMM(0xC0,$ind,'SUBB'); next if op_IMM(0xC1,$ind,'CMPB');
		next if op_IMM(0xC2,$ind,'SBCB');
		next if op_IMM(0xC4,$ind,'ANDB'); next if op_IMM(0xC5,$ind,'BITB');
		next if op_IMM(0xC6,$ind,'LDAB'); 
		next if op_IMM(0xC8,$ind,'EORB'); next if op_IMM(0xC9,$ind,'ADCB');
		next if op_IMM(0xCA,$ind,'ORAB'); next if op_IMM(0xCB,$ind,'ADDB');
		next if op_IMM2(0xCE,$ind,'LDX'); 

		next if op_DIR(0xD0,$ind,'SUBB'); next if op_DIR(0xD1,$ind,'CMPB');
		next if op_DIR(0xD2,$ind,'SBCB');
		next if op_DIR(0xD4,$ind,'ANDB'); next if op_DIR(0xD5,$ind,'BITB');
		next if op_DIR(0xD6,$ind,'LDAB'); next if op_DIR(0xD7,$ind,'STAB');
		next if op_DIR(0xD8,$ind,'EORB'); next if op_DIR(0xD9,$ind,'ADCB');
		next if op_DIR(0xDA,$ind,'ORAB'); next if op_DIR(0xDB,$ind,'ADDB');
		next if op_DIR(0xDE,$ind,'LDX'); next if op_DIR(0xDF,$ind,'STX');
	    
		next if op_IND(0xE0,$ind,'SUBB'); next if op_IND(0xE1,$ind,'CMPB');
		next if op_IND(0xE2,$ind,'SBCB');
		next if op_IND(0xE4,$ind,'ANDB'); next if op_IND(0xE5,$ind,'BITB');
		next if op_IND(0xE6,$ind,'LDAB'); next if op_IND(0xE7,$ind,'STAB');
		next if op_IND(0xE8,$ind,'EORB'); next if op_IND(0xE9,$ind,'ADCB');
		next if op_IND(0xEA,$ind,'ORAB'); next if op_IND(0xEB,$ind,'ADDB');
		next if op_IND(0xEE,$ind,'LDX'); next if op_IND(0xEF,$ind,'STX');
	    
		next if op_EXT(0xF0,$ind,'SUBB'); next if op_EXT(0xF1,$ind,'CMPB');
		next if op_EXT(0xF2,$ind,'SBCB');
		next if op_EXT(0xF4,$ind,'ANDB'); next if op_EXT(0xF5,$ind,'BITB');
		next if op_EXT(0xF6,$ind,'LDAB'); next if op_EXT(0xF7,$ind,'STAB');
		next if op_EXT(0xF8,$ind,'EORB'); next if op_EXT(0xF9,$ind,'ADCB');
		next if op_EXT(0xFA,$ind,'ORAB'); next if op_EXT(0xFB,$ind,'ADDB');
		next if op_EXT(0xFE,$ind,'LDX'); next if op_EXT(0xFF,$ind,'STX');
	    
        printf("ABORT: Unknown M6800 opcode \$%02X at addr \$%04X\n",BYTE($addr),$addr)
        	if ($verbose > 0);
		$OP[$addr] = '.DB'; $IND[$addr] = $ind;
		$OPA[$addr][0] = sprintf('$%02X!',BYTE($addr));
		$REM[$addr] = 'WARNING: Unknown M6800 opcode';
		$decoded[$addr++] = 1;
		$unclean = 1;
		return;
	}
}

#----------------------------------------------------------------------
# WVM Disassembler
#----------------------------------------------------------------------

sub wvm_bitOp($$$)												# operation acting on lamps/flags
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

sub wvm_lampOp($$$) 											# operation acting on lamps with masks
{																# at least in system 11, these take multiple args
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

sub wvm_indOp($$$)												# operation acting on first 15 bytes of memory (registers)
{
	my($opc,$ind,$op) = @_;
	return undef unless (BYTE($addr) eq $opc);
	my($base_addr) = $addr;
    
	$OP[$base_addr] = $op; $IND[$base_addr] = $ind;
	$decoded[$addr++] = 1;
	while (BYTE($addr)&0x80) {									# at least in system 11 these take multiple args
		push(@{$OPA[$base_addr]},sprintf('[Reg-%c]',65+BYTE($addr)&~0x80));
		$decoded[$addr++] = 1;
	}
	push(@{$OPA[$base_addr]},sprintf('[Reg-%c]',65+BYTE($addr)));
	$decoded[$addr++] = 1;
	return 1;
}

sub wvm_bitgroupOp($$$) 										# operation acting on flag/lamp groups
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
#	 printf(STDERR "%04X: $OP[$base_addr] @{$OPA[$base_addr]}\n",$base_addr);
	return 1;
}

#----------------------------------------------------------------------
# Recursive Parser for WMS Expressions
#	- prefix notation (old infix code --- with bugs --- commented out above)
#	- argument to parse function determines type of expression result required:
#		- false: logical (logical statements, e.g. _If, %logicOr:, ...)
#		- true : arithmetic (math statements, e.g. %equal:, %bitOr:, ...)
#----------------------------------------------------------------------

sub wvm_parse_expr(@)														# recursive descent parser for WVM7 expressions
{																			# PREFIX NOTATION
	my($arithmetic_result) = @_;
	if (BYTE($addr) < 0xF0) {												# flags, lamps, adjustments and registers
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
	} elsif (BYTE($addr) == 0xF0) { 										# GAME TILTED
		push(@{$OPA[$base_addr]},'%gameTilted');
		$decoded[$addr++] = 1;
	} elsif (BYTE($addr) == 0xF1) {
		push(@{$OPA[$base_addr]},'%gameOver');								# GAME OVER
		$decoded[$addr++] = 1;
	} elsif (BYTE($addr) == 0xF2) { 										# Number: prefix required for immediate values >= $F0
		push(@{$OPA[$base_addr]},'%number:');
		push(@{$OPA[$base_addr]},sprintf('#$%02X',BYTE($addr+1)));
		$decoded[$addr++] = $decoded[$addr++] = 1;
	}  elsif (BYTE($addr) == 0xF3) {									 # LOGICAL NOT
		push(@{$OPA[$base_addr]},'%logicNot:');
		$decoded[$addr++] = 1;
		wvm_parse_expr();
	}  elsif (BYTE($addr) == 0xF4) {										# LAMP BLINKING
		push(@{$OPA[$base_addr]},'%lampBlinking:');
		$decoded[$addr++] = 1;
		push(@{$OPA[$base_addr]},(BYTE($addr) >= 0xE0) ?
										sprintf('[Reg-%c]',65+(BYTE($addr)&0x0F)) :
										sprintf('Lamp#%02X',BYTE($addr)));
		$decoded[$addr++] = 1;
	} elsif (BYTE($addr) == 0xF5) { 										# BITGROUP ALL OFF
		push(@{$OPA[$base_addr]},'%allFlagsClear:');
		$decoded[$addr++] = 1;
		if (BYTE($addr) >= 0xE0) {											# indirect (register)
			push(@{$OPA[$base_addr]},sprintf('[Reg-%c]',65+(BYTE($addr)&0x0F)));
		} else {															# lamp
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
	} elsif (BYTE($addr) == 0xF6) { 										# BITGROUP ALL ON
		push(@{$OPA[$base_addr]},'%allFlagsSet:');
		$decoded[$addr++] = 1;
		if (BYTE($addr) >= 0xE0) {											# indirect (register)
			push(@{$OPA[$base_addr]},sprintf('[Reg-%c]',65+(BYTE($addr)&0x0F)));
		} else {															# lamp 
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
	} elsif (BYTE($addr) == 0xF7) { 										# LAMP OFF
		push(@{$OPA[$base_addr]},'%lampAltbuf:');
		$decoded[$addr++] = 1;
		if (BYTE($addr) >= 0xE0) {											# indirect (register)
			push(@{$OPA[$base_addr]},sprintf('[Reg-%c]',65+(BYTE($addr)&0x0F)));
		} else {															# lamp 
			push(@{$OPA[$base_addr]},(BYTE($addr) & 0x40) ?
										sprintf('Lamp#%02X|$40',BYTE($addr)&~0x40) :
										sprintf('Lamp#%02X',BYTE($addr)));
		}
		$decoded[$addr++] = 1;
	} elsif (BYTE($addr) == 0xF8) {
		push(@{$OPA[$base_addr]},'%switchClosed:'); 						  # SWITCH
		$decoded[$addr++] = 1;
		push(@{$OPA[$base_addr]},(BYTE($addr) >= 0xE0) ?
										sprintf('[Reg-%c]',65+(BYTE($addr)&0x0F)) :
										sprintf('Switch#%02X',BYTE($addr)));
		$decoded[$addr++] = 1;
	} elsif (BYTE($addr) == 0xF9) { 										# bitwise OR
		$decoded[$addr++] = 1;
		push(@{$OPA[$base_addr]},'%bitOr:');
		wvm_parse_expr(1); wvm_parse_expr(1);
	} elsif (BYTE($addr) == 0xFA) { 										# logical AND
		$decoded[$addr++] = 1;
		push(@{$OPA[$base_addr]},'%logicAnd:');
		wvm_parse_expr(); wvm_parse_expr(); 
	} elsif (BYTE($addr) == 0xFB) { 										# logical OR
		$decoded[$addr++] = 1;
		push(@{$OPA[$base_addr]},'%logicOr:');
		wvm_parse_expr(); wvm_parse_expr(); 
	} elsif (BYTE($addr) == 0xFC) { 										# EQUAL
		$decoded[$addr++] = 1;
		push(@{$OPA[$base_addr]},'%equal:');
		wvm_parse_expr(1); wvm_parse_expr(1);
	} elsif (BYTE($addr) == 0xFD) { 										# GREATER THAN
		$decoded[$addr++] = 1;
		push(@{$OPA[$base_addr]},'%greaterThan:');
		wvm_parse_expr(1); wvm_parse_expr(1);
	} elsif (BYTE($addr) == 0xFE) { 										# FIND RUNNING THREADS
		$decoded[$addr++] = 1;
		push(@{$OPA[$base_addr]},'%findThread:');
		wvm_parse_expr(1);													# Flags Mask
		if ($WMS_System == 11) {											# on sys7 thread id is number; on sys 11 it is expression
			wvm_parse_expr(1);
		} else {															# in system 7, thread id is a constant
			push(@{$OPA[$base_addr]},sprintf('Thread#%02X',BYTE($addr)));
			$decoded[$addr++] = 1;
		}
	} elsif (BYTE($addr) == 0xFF) { 										# bitwise AND
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

sub regVal($)																		# signed single-byte register value
{
	my($usv) = @_;
	return sprintf('#%d',($usv > 127) ? ($usv - 256) : $usv);
}

sub disassemble_wvm(@)
{
	local($ind,$addr,$lbl_root,$divider_label) = @_;								# local allows wvm_*() to modify $addr

	die("disassemble_wvm() requires defined \$WMS_System\n")
		unless defined($WMS_System);

	unless (defined(BYTE($addr))) { 												# outside loaded ROM range
		return if ($WMS_System == 7);												# okay for Sys 7
		printf(STDERR "; WARNING: WVM disassembly address %04X outside ROM range\n",$addr)
			if ($verbose > 0);
		$unclean = 1;
		return;
	}
	if ($decoded[$addr] && !defined($OP[$addr])) {									# not at start of instruction
		printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code\n",$addr)
			if ($verbose > 0);
		$unclean = 1;
		return;
	}
	insert_divider($addr,$divider_label);
	$N_LABELS[$addr]++; 															# we got here somehow, so there's a label

	while (!$decoded[$addr]) {
#		printf("WVM disassembling opcode %02X at %04X\n",BYTE($addr),$addr);

		my($base_addr) = $addr;
		$TYPE[$base_addr] = $CodeType_wvm;

		if (wvm_nargOp(0x00,$ind,'halt')) { 											# miscellaneous operations
			printf(STDERR "; WARNING: halt WVM instruction at address \$%04X\n",$addr)
				if ($verbose > 0);
			next;
#			$unclean = 1;
#			return;
		}
		next   if wvm_nargOp(0x01,$ind,'noOperation');
		return if wvm_nargOp(0x02,$ind,'return');
		return if wvm_nargOp(0x03,$ind,'exitThread');
		if (wvm_nargOp(0x04,$ind,'M6800_mode')) {
			disassemble_6800($ind,$addr,$lbl_root);
			return;
		}
		next if wvm_nargOp(0x05,$ind,'awardSpecial');
		next if wvm_nargOp(0x06,$ind,'awardExtraball');

		if ($WMS_System == 11) {														# System 11 additional opcodes (info from Scott Charles)
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
				disassemble_6800($ind,WORD($addr+2),$lbl);
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
				disassemble_6800($ind,WORD($addr+1),$lbl);
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

		next if wvm_bitOp(0x10,$ind,'setBits'); 										# flag & lamp operators
		next if wvm_bitOp(0x11,$ind,'clearBits');
		next if wvm_bitOp(0x12,$ind,'toggleBits');
		next if wvm_bitOp(0x13,$ind,'blinkLamps');
		next if wvm_indOp(0x14,$ind,'setBits'); 	   # indirect
		next if wvm_indOp(0x15,$ind,'clearBits');	   # indirect
		next if wvm_indOp(0x16,$ind,'toggleBits');	   # indirect
		next if wvm_indOp(0x17,$ind,'blinkLamps');	   # indirect
		next if wvm_bitgroupOp(0x18,$ind,'setBitgroups');
		next if wvm_bitgroupOp(0x19,$ind,'clearBitgroups');
		next if wvm_bitgroupOp(0x1A,$ind,'fillBitgroups');
		next if wvm_bitgroupOp(0x1B,$ind,'fillWrapBitgroups');
		next if wvm_bitgroupOp(0x1C,$ind,'drainBitgroups');
		next if wvm_bitgroupOp(0x1D,$ind,'rotLeftBitgroups');
		next if wvm_bitgroupOp(0x1E,$ind,'rotRightBitgroups');
		next if wvm_bitgroupOp(0x1F,$ind,'toggleBitgroups');

		next if wvm_lampOp(0x20,$ind,'setAltbuf');										# set lamp to alternate buffer
		next if wvm_lampOp(0x21,$ind,'clearAltbuf');									# set lamp to primary buffer
		next if wvm_lampOp(0x22,$ind,'toggleAltbuf');									# toggle lamp buffer to use
#		next if wvm_lampOp(0x23,$ind,'INVALID');										# this opcode does not exist
		next if wvm_indOp(0x24,$ind,'setAltbuf');
		next if wvm_indOp(0x25,$ind,'clearAltbuf');
		next if wvm_indOp(0x26,$ind,'toggleAltbuf');
#		next if wvm_indOp(0x27,$ind,'INVALID');										   # this opcode does not exist
		next if wvm_bitgroupOp(0x28,$ind,'setBitgroupsAltbuf');
		next if wvm_bitgroupOp(0x29,$ind,'clearBitgroupsAltbuf');
		next if wvm_bitgroupOp(0x2A,$ind,'fillBitgroupsAltbuf');
		next if wvm_bitgroupOp(0x2B,$ind,'fillWrapBitgroupsAltbuf');
		next if wvm_bitgroupOp(0x2C,$ind,'drainBitgroupsAltbuf');
		next if wvm_bitgroupOp(0x2D,$ind,'rotLeftBitgroupsAltbuf');
		next if wvm_bitgroupOp(0x2E,$ind,'rotRightLGroupsAltbuf');
		next if wvm_bitgroupOp(0x2F,$ind,'toggleLGroupsAltbuf');
	    
		if ((BYTE($addr)&0xF0) == 0x30) {												# solControl ($30-$3F)
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
				if	  ($flags == 0x00) { $op = 'off'; }
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

		if (BYTE($addr) == 0x40) {														# playSound_score
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
		if (BYTE($addr) == 0x41) {														  # queueScore
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
		if (BYTE($addr) == 0x42) {														  # score
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
		if (BYTE($addr) == 0x43) {														  # score_digitSound
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

		if (BYTE($addr)>=0x44 && BYTE($addr)<=0x4F) {									# begin6800/end6800
			$OP[$base_addr] = 'begin6800'; $IND[$base_addr] = $ind;
			my($nbytes) = (BYTE($addr)&0x0F) - 2;									   	# max 13 bytes; 3 spare needed at end => 16-byte buffer
			$decoded[$addr++] = 1;
			disassemble_6800_nbytes($ind+1,$addr,$lbl_root,$nbytes,0);					# $follow_code = 0
			undef($N_LABELS[$addr]);													# ignore default label
			$addr += $nbytes;
			push(@{$EXTRA[$addr]},'end6800'); push(@{$EXTRA_IND[$addr]},$ind);
			$EXTRA_BEFORE_LABEL[$addr][$#{$EXTRA[$addr]}] = 1;
			next;
		}

		if	(BYTE($addr) == 0x50) { 													# add two registers 
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
		if	(BYTE($addr) == 0x51) { 													# copy value from one register to other
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

		if	(BYTE($addr) == 0x52) { 													# setThreadFlags
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
		if (BYTE($addr) == 0x53) {														  # sleep / lSleep (the latter is only used when sleep would be better)
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
		if (BYTE($addr) == 0x54) {														  # killThread
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
		if (BYTE($addr) == 0x55) {														  # killThreads
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
		if (BYTE($addr) == 0x56) {														  # jumpSubroutine
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
		if (BYTE($addr) == 0x57) {														  # jumpSubroutine6800
			if ($decoded[$addr+1] || $decoded[$addr+2] ) {
				printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
					if ($verbose > 0);
				$unclean = 1;
				return;
			}
			$OP[$base_addr] = 'jumpSubroutine6800'; $IND[$base_addr] = $ind;
			$OPA[$base_addr][0] = label_address(WORD($addr+1),$lbl_root);
			$decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = 1; 
			disassemble_6800($code_base_indent,WORD($addr+1),$lbl_root);
			$addr += 3;
			next;
		}
		next if wvm_jumpOp(0x58,$ind,'jumpIf'); 										  # conditional jumps
		next if wvm_jumpOp(0x59,$ind,'jumpUnless');
		next if wvm_branchOp(0x5A,$ind,'branchIf'); 									  # conditional branches
		next if wvm_branchOp(0x5B,$ind,'branchUnless');
		if (BYTE($addr) == 0x5C) {														  # jump6800
			if ($decoded[$addr+1] || $decoded[$addr+2] ) {
				printf(STDERR "ABORT: WVM disassembly at %04X within already disassembled instruction code ($OP[$addr+1] @{$OPA[$addr+1]})\n",$addr)
					if ($verbose > 0);
				$unclean = 1;
				return;
			}
			$OP[$base_addr] = 'jump6800'; $IND[$base_addr] = $ind;
			$OPA[$base_addr][0] = label_address(WORD($addr+1),$lbl_root);
			$decoded[$addr] = $decoded[$addr+1] = $decoded[$addr+2] = 1; 
			disassemble_6800($code_base_indent,WORD($addr+1),$lbl_root);
			$addr += 3;
			return;
		}
		if (BYTE($addr) == 0x5D) {														  # triggerSwitches
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
		if (BYTE($addr) == 0x5E) {														  # clearSwitches
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
		if (BYTE($addr) == 0x5F) {														  # jump
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

		if ((BYTE($addr)&0xF0) == 0x60) {												# sleep_indirect
			$OP[$base_addr] = 'sleep'; $IND[$base_addr] = $ind;
			$OPA[$base_addr][0] = sprintf('[Reg-%c]',65+(BYTE($addr)&0x0F));
			$decoded[$addr++] = 1;
			next;
		}

		if ((BYTE($addr)&0xF0) == 0x70) {												# sleep
			$OP[$base_addr] = 'sleep'; $IND[$base_addr] = $ind;
			$OPA[$base_addr][0] = sprintf('%d',BYTE($addr)&0x0F);
			$decoded[$addr++] = 1; 
			next;
		}

		if ((BYTE($addr)&0xF0) == 0x80) {												# branch
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

		if ((BYTE($addr)&0xF0) == 0x90) {												# branchSubroutine
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

		if ((BYTE($addr)&0xF0) == 0xA0) {												# branchSubroutine6800
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
			disassemble_6800($code_base_indent,$bra_target,$lbl_root);
			next;
		}

		if ((BYTE($addr)&0xF0) == 0xB0) {												# add immediate signed byte value to register
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

		if ((BYTE($addr)&0xF0) == 0xC0) {												# loadRegister
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

		if ((BYTE($addr)&0xF0) == 0xD0) {												# playSound n-times
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

		if ((BYTE($addr)&0xE0) == 0xE0) {												# playSound ($E0-$FF)
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
}

#----------------------------------------------------------------------
# Label Arithmetic
#	- def_lbl_arith(<expr>) adds the current expression to a table
#	- table is used to add label expressions at the end
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
#	- define constants (e.g. default number of balls per game)
#	- define pointers to several system tables
#	- define pointers to code sections (recursive disassembly)
#----------------------------------------------------------------------

sub def_word_hex(@)																	# data word (not pointer)
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

sub def_ptr_hex(@)																	# pointer (not data word)
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

sub def_ptr_hex_alt(@)																# pointer (not data word)
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
	die if (($WMS_System == 6) && (BYTE($Address) > 0x4F)) ||
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
	if ($c & 0x80) {												# period after character
		$suffix = '.';
		$c &= 0x7F;
	}
	if ($c == 32)		{ return ' ' . $suffix; }												# space
	elsif ($c <= 47)	{ return sprintf('\\%02X',$c) . $suffix; } 								# other
	elsif ($c <= 57)	{ return sprintf('%c',$c) . $suffix; }									# 0-9
	elsif ($c <= 64)	{ return ' ' . $suffix; }												# space
	elsif ($c <= 90)	{ return sprintf('%c',$c) . $suffix; }									# A-Z
	elsif ($c == 91)	{ return '0' . $suffix; }												# fancy
	elsif ($c == 92)	{ return '1' . $suffix; }												# fancy
	elsif ($c == 93)	{ return '2' . $suffix; }												# fancy
	elsif ($c == 94)	{ return '3' . $suffix; }												# fancy
	elsif ($c == 95)	{ return '5' . $suffix; }												# fancy
	elsif ($c == 96)	{ return '6' . $suffix; }												# fancy
	elsif ($c == 97)	{ return '7' . $suffix; }												# fancy
	elsif ($c == 98)	{ return '9' . $suffix; }												# fancy
	elsif ($c == 99)	{ return '\\63' . $suffix; }											# all segments lit
	elsif ($c <= 104)	{ return sprintf('%c',$c-40) . $suffix; }								# < = > ? @
	elsif ($c <= 107)	{ return sprintf('%c',$c-69) . $suffix; }								# $ % &
	elsif ($c == 108)	{ return ',' . $suffix; }
	elsif ($c == 109)	{ return '.' . $suffix; }
	elsif ($c == 110)	{ return '+' . $suffix; }
	elsif ($c == 111)	{ return '-' . $suffix; }
	elsif ($c == 112)	{ return '/' . $suffix; }
	elsif ($c == 113)	{ return '\\' . $suffix; }
	elsif ($c <= 116)	{ return sprintf('%c',$c-21) . $suffix; }								# ] ^ _
	elsif ($c == 117)	{ return '{' . $suffix; }
	elsif ($c == 118)	{ return '*' . $suffix; }
	elsif ($c == 119)	{ return '}' . $suffix; }
	elsif ($c == 120)	{ return '"' . $suffix; }
	elsif ($c == 121)	{ return '[' . $suffix; }
	elsif ($c == 121)	{ return '@' . $suffix; }												# fancy
	else { return sprintf('\\%02X',$c) . $suffix; } 											# other
}

sub def_string(@)
{
	my($len,$lbl,$divider_label,$rem) = @_;

	die unless defined($Address);
##	return if ($decoded[$Address]);		# disabled, since there are overlapping strings
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
#	printf(STDERR "def_string($len,$lbl,$divider_label,$rem) -> $OP[$Address] $OPA[$Address][0]\n");
	$Address += $o;
}   
		    
sub def_string_table(@)
{
	my($nstr,$lbl,$divider_label,$rem,$def_len,@exceptions) = @_;

	die unless defined($Address);
	insert_divider($Address,$divider_label);

	my($next_exception,$eLen);													# exception list
	for (my($s)=0; $s<$nstr; $s++) {
		setLabel(sprintf('^%s#%04X',$lbl,$s),$Address);
		$IND[$Address] = $data_indent; $TYPE[$Address] = $CodeType_data;
		$OP[$Address] = '.DW'; $OPA[$Address][0] = sprintf('$%04X',WORD($Address));
		$decoded[$Address] = $decoded[$Address+1] = 1; 
		$REM[$Address] = $rem unless defined($REM[$Address]); undef($rem);

		my($tmp) = $Address;													# define string at pointer address
		$Address = WORD($Address);
		
		unless (defined($next_exception)) {										# list with string-length exceptions
			$next_exception = shift(@exceptions);
			if ($next_exception < 0) {
				$eLen = -$next_exception;
				$next_exception = shift(@exceptions);
			}
		}

		if (defined($next_exception) && $s == $next_exception) {				# this string is an exception
			def_string($eLen,sprintf('%s#%04X',$lbl,$s));
			undef($next_exception);
		} else {																# this string is a default string
#			printf(STDERR "def_string($def_len,%s#%04X) @ %04X\n",$lbl,$s,$Address);
			def_string($def_len,sprintf('%s#%04X',$lbl,$s));
		}
		$Address = $tmp + 2;													# continue with next string pointer in table
	}
}

#----------------------------------------------------------------------
# Grow Lengt-1 Strings
#	- extend 1-long strings to fill short gaps
#	- grows any string extending into a gap
#	- in order to avoid "overgrowing", define a label
#	- this was the first attempt at dealing with string tables with
#	  overlapping strings
#	- while it more-or-less works, the problem is that there is a
#	  single max_len for all strings, which is typically incorrect
#	  as there are 8 and 16-long strings
#	- therefore, I did not use this in either Pinbot or Bad Cats
#----------------------------------------------------------------------

sub grow_1strings($)
{
	my($max_len) = @_;

	for (my($addr)=0; $addr<@ROM-1; $addr++) {
		next unless ($OP[$addr] eq '.STR');										# only grow .STR strings
		next if $decoded[$addr+1];												# ... that are length 1
		
#		print(STDERR "before: $OPA[$addr][0]\n");
		$OPA[$addr][0] = "'" . decode_STR_char($addr);
		for (my($o)=1; $o<$max_len; $o++) {
			last if defined($OP[$addr+$o]);
			$OPA[$addr][0] .= decode_STR_char($addr+$o);
			$decoded[$addr+$o] = 1;
		}
	    $OPA[$addr][0] .= "'";
#		print(STDERR "after: $OPA[$addr][0]\n");
	}
}

#----------------------------------------------------------------------
# String Length
#----------------------------------------------------------------------

sub src_strlen($)																	# true length of string 
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
#			printf(STDERR "lenthening length-$sl string $OPA[$addr][0] at address %04X\n",$addr);
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
#	- re-encode all strings at the end when all labels are known
#	- do not lengthen strings
#----------------------------------------------------------------------

sub trim_overlapping_strings()
{
	for (my($addr)=0; $addr<@ROM-1; $addr++) {
		next unless ($OP[$addr] eq '.STR');
		my($ssl) = src_strlen($OPA[$addr][0]) - 2;										# current length of source string
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
		elsif ($c == 0x06) { $OPA[$Address][0] .= '1'; }	# also I
		elsif ($c == 0x5B) { $OPA[$Address][0] .= '2'; }	# also Z
		elsif ($c == 0x4F) { $OPA[$Address][0] .= '3'; }
		elsif ($c == 0x66) { $OPA[$Address][0] .= '4'; }
		elsif ($c == 0x6D) { $OPA[$Address][0] .= '5'; }	# also S
		elsif ($c == 0x7D) { $OPA[$Address][0] .= '6'; }
		elsif ($c == 0x07) { $OPA[$Address][0] .= '7'; }
		elsif ($c == 0x7F) { $OPA[$Address][0] .= '8'; }	# also B
		elsif ($c == 0x6F) { $OPA[$Address][0] .= '9'; }
		elsif ($c == 0x77) { $OPA[$Address][0] .= 'A'; }
		elsif ($c == 0x7C) { $OPA[$Address][0] .= 'b'; }
		elsif ($c == 0x39) { $OPA[$Address][0] .= 'C'; }	# also K (in German)
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
		elsif ($c == 0x67) { $OPA[$Address][0] .= 'q'; }	# maybe also g?
		elsif ($c == 0x31) { $OPA[$Address][0] .= 'R'; }	# F without middle line
		elsif ($c == 0x50) { $OPA[$Address][0] .= 'r'; }
		elsif ($c == 0x78) { $OPA[$Address][0] .= 't'; }    
		elsif ($c == 0x3E) { $OPA[$Address][0] .= 'U'; }	# also V
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

	my($next_exception,$eLen);													# exception list
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

		if (defined($next_exception) && $s == $next_exception) {				# this string is an exception
			def_7segment_string($eLen,sprintf('%s#%04X',$lbl,$s));
			undef($next_exception);
		} else {																# this string is a default string
			def_7segment_string(7,sprintf('%s#%04X',$lbl,$s));
		}
		$Address = $tmp + 2;
	}
}


#----------------------------------------------------------------------
# Flag Group Table Pointer
#	length is 15 for JL and 14 for PB => needs to be supplied (manually?)
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
			$OPA[$Address][1] = label_address(WORD($Address+1),$swn.'_handler',1);		# suppress address suffix in label
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
	$OP[$addr] 	 = '.DB';
	$IND[$addr]  = $data_indent;
	$TYPE[$addr] = $CodeType_data;

	for (my($nbytes)=1,my($col)=0,my($full)=0; ; $nbytes++,$col++) {
		if ($col > 7) {												# new line every 8th byte
			$full++;
			$OP[$addr+8*$full] = '.DB';
			$IND[$addr+8*$full] = $data_indent;
			$TYPE[$addr+8*$full] = $CodeType_data;
			$col = 0;
		}

		if (BYTE($addr+$nbytes-1) == 0xF9) {							# quote
			push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
			$decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
		} elsif (BYTE($addr+$nbytes-1) == 0xFA) {						# jump (parser does not follow!!!)
			push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
			$decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
			push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
			$decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
			push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
			$decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
			last;
		} elsif (BYTE($addr+$nbytes-1) == 0xFC) {						# gobble next 2 bytes
			push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
			$decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
			push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
			$decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
		} elsif (BYTE($addr+$nbytes-1) == 0xFD) {						# gobble next byte
			push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
			$decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
		} elsif (BYTE($addr+$nbytes-1) == 0xFE) {						# gobble next byte
			push(@{$OPA[$addr+8*$full]},sprintf('$%02X!',BYTE($addr+$nbytes-1)));
			$decoded[$addr+$nbytes-1] = 1; $nbytes++; $col++;
		} elsif (BYTE($addr+$nbytes-1) == 0xFF) {						# end of list
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

	disassemble_6800($code_base_indent,$code_addr,$code_lbl,$divider_label);
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

sub def_code(@) 									 # does not update $Address
{
	my($lbl,$divider_label) = @_;
	die("$lbl,$divider_label") unless defined($Address);

	my($usr_lbl) = $LBL[$Address];
	$lbl = $usr_lbl if defined($usr_lbl);
	setLabel($lbl,$Address);
    return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);

	disassemble_6800($code_base_indent,$Address,$lbl,$divider_label);
}


sub def_wvm_code(@) 							 # does not update $Address
{
	my($lbl,$divider_label) = @_;
	die unless defined($Address);

	my($usr_lbl) = $LBL[$Address];
	$lbl = $usr_lbl if defined($usr_lbl);
	setLabel($lbl,$Address);
    return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);

	disassemble_wvm($code_base_indent,$Address,$lbl,$divider_label);
}


#----------------------------------------------------------------------

sub def_byteblock_bin(@)
{
	my($nbytes,$lbl,$divider_label,$rem) = @_;
	die unless defined($Address);
	setLabel($lbl,$Address);
    $Address+=$nbytes,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
	insert_divider($Address,$divider_label) if defined($divider_label);

	$OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
	$OPA[$Address][0] = sprintf('%%%08b',BYTE($Address)); $REM[$Address] = $rem unless defined($REM[$Address]);
	$decoded[$Address++] = 1;

	for (my($i)=1; $i<$nbytes; $i++) {
		$OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
		$OPA[$Address][0] = sprintf('%%%08b',BYTE($Address));
		$decoded[$Address++] = 1;
	}
}


sub def_byteblock_hex(@)
{
	my($nbytes,$lbl,$divider_label,$rem) = @_;
	die unless defined($Address);
	setLabel($lbl,$Address);
    $Address+=$nbytes,return unless ($Address>=$MIN_ROM_ADDR && $Address<=$MAX_ROM_ADDR);
	insert_divider($Address,$divider_label) if defined($divider_label);

	do {
		printf(STDERR "def_byteblock_hex(@_) operator already defined ($OP[$Address],$decoded[$Address]) at \$%04X\n",$Address)
			if (defined($OP[$Address]));
		$OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
		$REM[$Address]=$rem,undef($rem) unless defined($REM[$Address]);
		my($bAddress) = $Address;
#		die if (@{$OPA[$bAddress]});
		for (my($col)=0; $nbytes>0 && $col<8; $col++,$nbytes--) {
			push(@{$OPA[$bAddress]},sprintf('$%02X!',BYTE($Address)));
			$decoded[$Address++] = 1;
		}
	} while ($nbytes > 0);
}


#----------------------------------------------------------------------
# Similar to def_byteblock_hex, except that
#	1) already decoded bytes are silently ignored. This is necessary
#	   for dasm files generated with C711 -x where checksum bytes are
#	   defined before regular disassembly. Special treatment is needed,
#	   because there may be a checksum byte following # a data table.
#	2) pointers in data tables are handled correctly
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
}


sub def_bytelist_hex(@) 														# value-terminated list
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
}

sub def_bytelist_hex_cols(@)													# value-terminated list
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

	disassemble_6800_nbytes($code_base_indent,$Lbl{$lbl},$lbl,$nbytes,0,$divider_label);	# follow_code = 0
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


sub def_wordblock_hex(@)														# data words (not pointers)
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
}

sub def_ptrblock_hex(@)															# block with pointers (not regular data words)
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
}

sub def_bytebytelist_hex(@) 														# value-terminated list (end of list can be specific high- or low-byte value)
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
	if (BYTE($Address+1)==$EOLob) {
		$OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
		$OPA[$Address][0] = sprintf('$%02X!',BYTE($Address));
		$OPA[$Address][1] = sprintf('$%02X!',BYTE($Address+1));
		$decoded[$Address++] = $decoded[$Address++] = 1;
	} else {
		$OP[$Address] = '.DB'; $IND[$Address] = $data_indent; $TYPE[$Address] =  $CodeType_data;
		$OPA[$Address][0] = sprintf('$%02X!',BYTE($Address));
		$decoded[$Address++] = 1;
	}
}

sub tablerow_newline($$)
{
	my($addr,$op) = @_;

	$OP[$addr]		= $op;
	$IND[$addr] 	= $data_indent;
	$TYPE[$addr]	= $CodeType_data;
	$REM[$addr] 	= $rem unless defined($REM[$addr]);
}

sub def_tablerow(@) 												# format chars: h)ex no label, H)ex w/label, $ ptr to M6800 code, ^ ptr (returned)
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

		if ($f ne $prev_fmt) {										# same format, same line
			tablerow_newline($base_addr,$prev_pragma);				# different format new line
			$base_addr += $bytes_consumed;
			$bytes_consumed = 0;
        }

		if ($f eq 'h') {											# hex bytes without label substitution
			$prev_pragma = '.DB';
			push(@{$OPA[$base_addr]},sprintf('$%02X!',BYTE($Address)));
			$bytes_consumed++;
			$decoded[$Address++] = 1;
		} elsif ($f eq 'H') {									   # hex bytes with label substitution
			$prev_pragma = '.DB';
			push(@{$OPA[$base_addr]},sprintf('$%02X',BYTE($Address)));
			$bytes_consumed++;
			$decoded[$Address++] = 1;
		} elsif ($f eq 's') {									   # string (length taken from argument)
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
			$f = '';												# suppress combination of multiple strings on same line
		} elsif ($f eq '^') {									  	# pointer (value of last pointer in format is returned by def_tablerow)
			$prev_pragma = '.DW';
			my($target) = WORD($Address);
			push(@{$OPA[$base_addr]},label_address(WORD($Address),$lbl));
			$decoded[$Address++] = $decoded[$Address++] = 1;
			$retval = $target;
			$bytes_consumed += 2;
		} elsif ($f eq '$') {										# pointer to M6800 code
			$prev_pragma = '.DW';
			my($target) = WORD($Address);
			push(@{$OPA[$base_addr]},label_address(WORD($Address),"${lbl}_code"));
			disassemble_6800($code_base_indent,$target,"${lbl}_code");
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
# Code-Structure Processing
#----------------------------------------------------------------------

# determine whether two addresses are in the same code block, as follows:
#	- no, if start/end of block is beyond limits of enclosing block
#	- no, if there are intervening statements that are differenlty (less) indented
#	- no, if there is an exit in the block
#	- no, if there are labels in the block (for this to work all labels need to be pre-defined see -l)

sub same_block($$)
{
	my($la,$ha) = @_;															# low and high addresses
	my($block_ind) = defined($EXTRA_IND[$la][0]) ? $EXTRA_IND[$la][0] : $IND[$la];

	return 0 if ($la < $BEGIN_BLOCK[$#BEGIN_BLOCK])
			 || ($ha > $END_BLOCK[$#END_BLOCK]);
	return 0 if exit_in_block($la,$ha);
	for (my($a)=$la; $a<=$ha; $a++) {
		return 0 if defined($LBL[$a]);
		next unless defined($OP[$a]);
		return 0 if ($IND[$a] != $block_ind);
		return 0 if defined($EXTRA_IND[$a][0]) && ($EXTRA_IND[$a][0] != $block_ind);
	}
	return ((!defined($EXTRA_IND[$ha][0]) && ($IND[$ha] == $block_ind)) ||
			( defined($EXTRA_IND[$ha][0]) && ($EXTRA_IND[$trg][0] == $block_ind)));
}

# test if there is a return or jump statement somehwere in this block,
# excluding conditional statements
#	- this is done by testing only statements at same indentation level
#	- BRA/branch are not included in this list, because they are commonly
#	  used for if-then-else statements

sub exit_in_block($$)
{
	return undef;																	# DISABLED JAN 25, 2020
	my($la,$ha) = @_;
	my($block_ind) = defined($EXTRA_IND[$la][0]) ? $EXTRA_IND[$la][0] : $IND[$la];

	for (my($a)=$la; $a<=$ha; $a++) {
		next unless defined($OP[$a]);
		next unless (!defined($EXTRA_IND[$a][0]) && ($IND[$a] == $block_ind)) ||
					( defined($EXTRA_IND[$a][0]) && ($EXTRA_IND[$a][0] == $block_ind));
		return 1 if ($OP[$a] eq 'JMP' || $OP[$a] eq 'jump');
	}
	return undef;
}

sub cs_loop_while($$$$$)
{
	my($addr,$saddr,$branch_op,$loop_op,$endloop_op) = @_;
    
	if ($OP[$addr] eq $branch_op) { 												# initial BRA at the end of the loop
		my($trg) = ($OPA[$addr][$#{$OPA[$addr]}] =~ m{\$([0-9A-Fa-f]+)$});
		$trg = hex($trg);
		if (($trg < $addr) && ($trg >= $saddr)										# target is earlier in same enclosing block
				&& same_block($trg,$addr)									 		# ... and at the same indentation
				&& !($OP[$trg] =~ m{^_})											# ... and not a macro (there can be confusion)
				&& !defined($NoLoop{$trg})) {										# ... and has not been excempted from loops
			push(@{$EXTRA[$trg]},$loop_op); push(@{$EXTRA_IND[$trg]},$IND[$trg]);
			$OP[$addr] = $endloop_op; pop(@{$OPA[$addr]});
			$IND[$trg]++;
			for (my($a)=$trg+1; $a<$addr; $a++) {
				$IND[$a]++;
				for (my($i)=0; $i<@{$EXTRA[$a]}; $i++) {
					$EXTRA_IND[$a][$i]++;
				}
			}
			push(@BEGIN_BLOCK,$trg);
			push(@END_BLOCK,$addr);
			return 1;
		}
	}
	return 0;
}

# more complex loop with test at beginning, and BRA back to test at end of block
sub cs_while_loop($$$$$$)
{
	my($addr,$eaddr,$test_op,$branch_op,$loop_op,$endloop_op) = @_;

	if ($OP[$addr] eq $test_op) {
		my($endloop_trg) = ($OPA[$addr][$#{$OPA[$addr]}] =~ m{\$([0-9A-Fa-f]+)$});
		$endloop_trg = hex($endloop_trg);
		if (($endloop_trg > $addr) && ($endloop_trg <= $eaddr)
				&& same_block($addr,$endloop_trg)
				&& !($OP[$endloop_trg] =~ m{^_})
				&& !defined($NoLoop{$addr})) {
			if ($OP[$endloop_trg-2] eq $branch_op) {
				 my($loop_trg) = ($OPA[$trg-2][$#{$OPA[$trg-2]}] =~ m{\$([0-9A-Fa-f]+)$});
				 $loop_trg = hex($loop_trg);
				 if ($loop_trg == $addr) {
					$OP[$addr] = $loop_op; pop(@{$OPA[$addr]});
					$OP[$endloop_trg-2] = undef; undef(@{$OPA[$addr]});
					push(@{$EXTRA[$endloop_trg]},$endloop_op);
					push(@{$EXTRA_IND[$endloop_trg]},$IND[$endloop_trg]);
					$EXTRA_BEFORE_LABEL[$endloop_trg][$#{$EXTRA[$endloop_trg]}] = 1;
					$IND[$endloop_trg]++;
					for (my($a)=$addr+1; $a<$endloop_trg; $a++) {
						$IND[$a]++;
						for (my($i)=0; $i<@{$EXTRA[$a]}; $i++) {
							$EXTRA_IND[$a][$i]++;
						}
					} # indent loop
					push(@BEGIN_BLOCK,$addr);
					push(@END_BLOCK,$endloop_trg);
					return 1;
				 } # found a loop
			} # found a BRA statement at end of loop body
		} # initial BRA is forward, not too far, and in same block
	}
	return 0;
}
					    
# if-else
sub cs_if_else($$$$$$$)
{
	my($addr,$eaddr,$test_op,$branch_op,$if_op,$else_op,$endif_op) = @_;

	if ($OP[$addr] eq $test_op) {											# conditional BRA...
		my($else_trg) = ($OPA[$addr][$#{$OPA[$addr]}] =~ m{\$([0-9A-Fa-f]+)$});
		$else_trg = hex($else_trg);

		if (($else_trg > $addr) && ($else_trg <= $eaddr) && 				# ... that is forward and...
				same_block($addr,$else_trg)) {								# ... in same block => IF
			if ($OP[$else_trg-2] eq $branch_op) {							# unconditional BRA before ELSE target...
				my($endif_trg) = ($OPA[$else_trg-2][$#{$OPA[$else_trg-2]}] =~ m{\$([0-9A-Fa-f]+)$});
				$endif_trg = hex($endif_trg);
				if (($endif_trg > $else_trg) && ($endif_trg <= $eaddr) &&	# ... that is forward and...
							same_block($else_trg,$endif_trg)) {				# ... in same block => IF-ELSE-ENDIF
					$OP[$addr]		 = $if_op;	 pop(@{$OPA[$addr]});		# IF replaces initial conditional BRA
					$OP[$else_trg-2] = $else_op; pop(@{$OPA[$else_trg-2]});	# ELSE replaces unconditional BRA
					push(@{$EXTRA[$endif_trg]},$endif_op);					# insert ENDIF
					push(@{$EXTRA_IND[$endif_trg]},$IND[$endif_trg]);
					$EXTRA_BEFORE_LABEL[$endif_trg][$#{$EXTRA[$endif_trg]}] = 1;
					for (my($a)=$addr+1; $a<$else_trg-2; $a++) {			# indent THEN block
						$IND[$a]++;
						for (my($i)=0; $i<@{$EXTRA[$a]}; $i++) {
							$EXTRA_IND[$a][$i]++;
						}
					}
					for (my($a)=$else_trg; $a<$endif_trg; $a++) {			# indent ELSE block
						$IND[$a]++;
						for (my($i)=0; $i<@{$EXTRA[$a]}; $i++) {
							$EXTRA_IND[$a][$i]++;
						}
					}
					push(@BEGIN_BLOCK,$else_trg);
					push(@END_BLOCK,$endif_trg);
					return 1;
				} # if legal ELSE-forward branch
			} # if BRA at end of IF-bloc														    
																			# no BRA at end of IF block => no ELSE
			$OP[$addr] = $if_op; pop(@{$OPA[$addr]});						# IF replaces initial conditional BRA
			push(@{$EXTRA[$else_trg]},$endif_op);							# insert ENDIF
			push(@{$EXTRA_IND[$else_trg]},$IND[$else_trg]);
			$EXTRA_BEFORE_LABEL[$else_trg][$#{$EXTRA[$else_trg]}] = 1;

			for (my($a)=$addr+1; $a<$else_trg; $a++) {						# indent THEN block
				$IND[$a]++;
				for (my($i)=0; $i<@{$EXTRA[$a]}; $i++) {
					$EXTRA_IND[$a][$i]++;
				}
			}
			push(@BEGIN_BLOCK,$addr);
			push(@END_BLOCK,$else_trg);
			return 1;
		} # if valid conditional forward BRA
	} # if statement is conditional BRA
	return 0;
}
					    
sub process_code_structure($$)
{
	my($saddr,$eaddr) = @_;
	local(@BEGIN_BLOCK,@END_BLOCK);

	push(@BEGIN_BLOCK,$saddr);
	push(@END_BLOCK,$eaddr);
	for (my($addr)=$saddr; $addr<=$eaddr; $addr++) {
		if ($addr >= @END_BLOCK[$#END_BLOCK]) {												# end current block
			pop(@BEGIN_BLOCK); pop(@END_BLOCK);
		}
		next unless defined($OP[$addr]);
		next if defined($unstructured[$addr]);

		next if cs_if_else($addr,$eaddr,'BNE','BRA','_IF_EQ','_ELSE','_ENDIF');				# M6800 if-statements
		next if cs_if_else($addr,$eaddr,'BEQ','BRA','_IF_NE','_ELSE','_ENDIF');
		next if cs_if_else($addr,$eaddr,'BLT','BRA','_IF_GE','_ELSE','_ENDIF');
		next if cs_if_else($addr,$eaddr,'BGT','BRA','_IF_LE','_ELSE','_ENDIF');
		next if cs_if_else($addr,$eaddr,'BLE','BRA','_IF_GT','_ELSE','_ENDIF');
		next if cs_if_else($addr,$eaddr,'BGE','BRA','_IF_LT','_ELSE','_ENDIF');
		next if cs_if_else($addr,$eaddr,'BHI','BRA','_IF_LS','_ELSE','_ENDIF');
		next if cs_if_else($addr,$eaddr,'BLS','BRA','_IF_HI','_ELSE','_ENDIF');
		next if cs_if_else($addr,$eaddr,'BCC','BRA','_IF_CS','_ELSE','_ENDIF');
		next if cs_if_else($addr,$eaddr,'BCS','BRA','_IF_CC','_ELSE','_ENDIF');
		next if cs_if_else($addr,$eaddr,'BVC','BRA','_IF_VS','_ELSE','_ENDIF');
		next if cs_if_else($addr,$eaddr,'BVS','BRA','_IF_VC','_ELSE','_ENDIF');
		next if cs_if_else($addr,$eaddr,'BPL','BRA','_IF_MI','_ELSE','_ENDIF');
		next if cs_if_else($addr,$eaddr,'BMI','BRA','_IF_PL','_ELSE','_ENDIF');

		next if cs_if_else($addr,$eaddr,'branchUnless','branch','_If','_Else','_EndIf');	# WVM if-statements
		next if cs_if_else($addr,$eaddr,'branchIf','branch','_Unless','_Else','_EndUnless');

		next if cs_while_loop($addr,$eaddr,'branchIf','branch','_Until','_EndLoop');		# WVM loops
		next if cs_while_loop($addr,$eaddr,'branchUnless','branch','_While','_EndLoop');

		next if cs_while_loop($addr,$eaddr,'BNE','BRA','_UNTIL_NE','_ENDLOOP'); 			# M6800 loops
		next if cs_while_loop($addr,$eaddr,'BEQ','BRA','_UNTIL_EQ','_ENDLOOP');
		next if cs_while_loop($addr,$eaddr,'BLE','BRA','_UNTIL_LE','_ENDLOOP');
		next if cs_while_loop($addr,$eaddr,'BGE','BRA','_UNTIL_GE','_ENDLOOP');
		next if cs_while_loop($addr,$eaddr,'BLT','BRA','_UNTIL_LT','_ENDLOOP');
		next if cs_while_loop($addr,$eaddr,'BGT','BRA','_UNTIL_GT','_ENDLOOP');
		next if cs_while_loop($addr,$eaddr,'BHI','BRA','_UNTIL_HI','_ENDLOOP');
		next if cs_while_loop($addr,$eaddr,'BLS','BRA','_UNTIL_LS','_ENDLOOP');
		next if cs_while_loop($addr,$eaddr,'BCC','BRA','_UNTIL_CC','_ENDLOOP'); 	    
		next if cs_while_loop($addr,$eaddr,'BCS','BRA','_UNTIL_CS','_ENDLOOP');
		next if cs_while_loop($addr,$eaddr,'BVC','BRA','_UNTIL_VC','_ENDLOOP');
		next if cs_while_loop($addr,$eaddr,'BVS','BRA','_UNTIL_VS','_ENDLOOP');
		next if cs_while_loop($addr,$eaddr,'BMI','BRA','_UNTIL_MI','_ENDLOOP');
		next if cs_while_loop($addr,$eaddr,'BPL','BRA','_UNTIL_PL','_ENDLOOP');

		next if cs_loop_while($addr,$saddr,'branch','_Loop','_EndLoop');					# WVM loops 
		next if cs_loop_while($addr,$saddr,'branchIf','_Loop','_While');
		next if cs_loop_while($addr,$saddr,'branchUnless','_Loop','_Until');

		next if cs_loop_while($addr,$saddr,'BRA','_LOOP','_ENDLOOP');						# M6800 loops
		next if cs_loop_while($addr,$saddr,'BLE','_LOOP','_WHILE_LE');
		next if cs_loop_while($addr,$saddr,'BGE','_LOOP','_WHILE_GE');
		next if cs_loop_while($addr,$saddr,'BLT','_LOOP','_WHILE_LT');
		next if cs_loop_while($addr,$saddr,'BGT','_LOOP','_WHILE_GT');
		next if cs_loop_while($addr,$saddr,'BEQ','_LOOP','_WHILE_EQ');
		next if cs_loop_while($addr,$saddr,'BNE','_LOOP','_WHILE_NE');
		next if cs_loop_while($addr,$saddr,'BHI','_LOOP','_WHILE_HI');
		next if cs_loop_while($addr,$saddr,'BLS','_LOOP','_WHILE_LS');
		next if cs_loop_while($addr,$saddr,'BCC','_LOOP','_WHILE_CC');			
		next if cs_loop_while($addr,$saddr,'BCS','_LOOP','_WHILE_CS');
		next if cs_loop_while($addr,$saddr,'BVC','_LOOP','_WHILE_VC');
		next if cs_loop_while($addr,$saddr,'BVS','_LOOP','_WHILE_VS');
		next if cs_loop_while($addr,$saddr,'BMI','_LOOP','_WHILE_MI');
		next if cs_loop_while($addr,$saddr,'BPL','_LOOP','_WHILE_PL');
	}
	die if (@BEGIN_BLOCK);
}


#sub undo_code_structure($$$)																# called for labels inside code structure
#{
#	my($F,$lbl_addr,$ind) = @_;
#
##	printf(STDERR "$LBL[$lbl_addr] @ %04X\n",$lbl_addr);
#
#	my($a) = $lbl_addr;																		# search backward, marking if, until and while
#	my($min_ind) = $ind;
#	while (1) {	
#		$a--;
#		next unless defined($OP[$a]);
#		next if ($OP[$a] eq '_ELSE' || $OP[$a] eq '_Else');
#		next if ($IND[$a] >= $min_ind);
#		if (($OP[$a] =~ m{^_IF}) 	|| ($OP[$a] =~ m{^_If}) ||
#			($OP[$a] =~ m{^_UNTIL}) || ($OP[$a] =~ m{^_Until}) ||
#			($OP[$a] =~ m{^_While}) || ($OP[$a] =~ m{^_Unless})) {
#				printf($F "\$unstructured[0x%04X] = 1;\n",$a);
#				$min_ind = $IND[$a] if ($IND[$a] > $code_base_indent);
#				next;
#		}
#		last if ($IND[$a] == $code_base_indent);
#	}
#
#	$a = $lbl_addr;	$min_ind = $ind;														# search forward, marking until, until and while
#	while (1) {	
#		$a++;
#		next unless defined($OP[$a]);
#		next if ($OP[$a] eq '_ELSE' || $OP[$a] eq '_Else');
#		next if ($IND[$a] >= $min_ind);
#		if (($OP[$a] =~ m{^_ENDLOOP}) || ($OP[$a] =~ m{^_EndLoop}) ||
#			($OP[$a] =~ m{^_WHILE})   || ($OP[$a] =~ m{^_While}) ||
#			($OP[$a] =~ m{^_Until}) || ($OP[$a] =~ m{^_Unless})) {
#				printf($F "\$unstructured[0x%04X] = 1;\n",$a);
#				$min_ind = $IND[$a] if ($IND[$a] > $code_base_indent);
#				next;
#		}
#		last if ($IND[$a] == $code_base_indent);
#	}
#}

#----------------------------------------------------------------------
# Game Specific Identifiers
#----------------------------------------------------------------------

sub substitute_identifiers()																# substitute game-specific identifiers
{
	for (my($addr)=0; $addr<@ROM; $addr++) {
		next unless defined($OP[$addr]);
		for (my($i)=0; $i<@{$OPA[$addr]}; $i++) {
			if ($OPA[$addr][$i] =~ m{^Adj#}) {												# game adjustments
				$OPA[$addr][$i] = $Adj[hex($')] if defined($Adj[hex($')]);
			} elsif ($OPA[$addr][$i] =~ m{^Sol#}) {											# solenoids
				my($num,$len) = ($' =~ m{([0-9A-Fa-f]+)(.*)});
				$OPA[$addr][$i] = $Sol[hex($num)] . $len if defined($Sol[hex($num)]);
			} elsif ($OPA[$addr][$i] =~ m{^Lamp#([0-9A-Fa-f]+)}) {							# lamps
				$OPA[$addr][$i] = $Lamp[hex($1)].$' if defined($Lamp[hex($1)]);
			} elsif ($OPA[$addr][$i] =~ m{^Flag#}) {										# flags
				$OPA[$addr][$i] = $Flag[hex($')] if defined($Flag[hex($')]);
			} elsif ($OPA[$addr][$i] =~ m{^Bitgroup#([0-9A-Fa-f]+)}) {						# bitgroups
				$OPA[$addr][$i] = $BitGroup[hex($1)].$' if defined($BitGroup[hex($1)]);
			} elsif ($OPA[$addr][$i] =~ m{^Sound#([0-9A-Fa-f]+)}) {							# sounds
				$OPA[$addr][$i] = $Sound[hex($1)].$' if defined($Sound[hex($1)]);
			} elsif ($OPA[$addr][$i] =~ m{^Switch#}) {										# switches
				$OPA[$addr][$i] = $Switch[hex($')] if defined($Switch[hex($')]);
			} elsif ($OPA[$addr][$i] =~ m{^Thread#}) {										# threads
				$OPA[$addr][$i] = $Thread[hex($')] if defined($Thread[hex($')]);
			} 
		}
	}
}

#----------------------------------------------------------------------
# Produce Output
#	- also deals with gaps & .ORGs
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

sub output_aliases($@)
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

sub output_labels($)
{
	my($title) = @_;

	print(";----------------------------------------------------------------------\n");
	print("; $title\n");
	print(";----------------------------------------------------------------------\n\n");

	foreach my $lbl (sort { $Lbl{$a} <=> $Lbl{$b} } keys(%Lbl)) {
		next unless defined($Lbl{$lbl});
		next if defined($ROM[$Lbl{$lbl}]);
		$line = '.LBL';
		$line .= indent($line,$hard_tab*$def_name_indent);
		$line .= $lbl;
		$line .= indent($line,$hard_tab*$def_val_indent) .
					sprintf($Lbl{$lbl}>0xFF?"\$%04X\n":"\$%02X\n",$Lbl{$lbl});
		print($line);
	}
	print("\n");
}


sub produce_output(@)														# with a filename arg, writes structure-hints into file
{
	my($org,$line);
	my($decoded) = my($ROMbytes) = 0;

	if (@_) {
		open(F,">$_[0]") || die("$_[0]: $!\n");
	}

	output_aliases('Game Adjustment Aliases','Adj#%02X',@Adj);				# game-specific identifiers
	output_aliases('Solenoid Aliases','Sol#%02X',@Sol);
	output_aliases('Lamp Aliases','Lamp#%02X',@Lamp);
	output_aliases('Flag Aliases','Flag#%02X',@Flag);
	output_aliases('Bitgroup Aliases','Bitgroup#%02X',@BitGroup);
	output_aliases('Switch Aliases','Switch#%02X',@Switch);
	output_aliases('Sound Aliases','Sound#%02X',@Sound);
	output_aliases('Thread Aliases','Thread#%02X',@Thread);

	output_labels('External Labels');										# manually defined labels outside ROM

	my($gapLen,$codeStarted);
#	for (my($addr)=0; $addr<@ROM; $addr++) {								# loop through addresses
	for (my($addr)=$MIN_ROM_ADDR; $addr<=$MAX_ROM_ADDR; $addr++) {			# loop through addresses
		$decoded++ if $decoded[$addr];
		$ROMbytes++ if defined(BYTE($addr));
		if (defined($OP[$addr])) {											# there is code at this address
			unless (defined($org)) {										# new .ORG after a gap
				if ($code_started) {
					print("\n");
				} else {
					printf("<%04X>\t",$addr) if ($print_addrs);
					printf('			')	if ($print_code);
					print(";----------------------------------------------------------------------\n");
					printf("<%04X>\t",$addr) if ($print_addrs);
					printf('			')	if ($print_code);
					print("; GAME ROM START\n");
					printf("<%04X>\t",$addr) if ($print_addrs);
					printf('			')	if ($print_code);
					print(";----------------------------------------------------------------------\n");
					printf("<%04X>\t",$addr) if ($print_addrs);
					print("\n");
					$code_started = 1;
				}
				printf("<%04X>\t",$addr) if ($print_addrs);
				printf('			')	if ($print_code);
				$line = indent('',$hard_tab*$IND[$addr]) . sprintf(".ORG \$%04X",$org=$addr);
				$line .= indent($line,$hard_tab*$rem_indent)  . sprintf("; %d-byte gap",$gapLen)
					if ($gapLen > 0);
				$line .= "\n";					
				print($line); $line = '';
				$gapLen = 0;
			}

			for (my($i)=0; $i<@{$EXTRA[$addr]}; $i++) { 							# first, the pre-label constructs (ENDIF, ...)
				next unless ($EXTRA_BEFORE_LABEL[$addr][$i]);
				$line .= indent($line,$hard_tab*$EXTRA_IND[$addr][$i]) . $EXTRA[$addr][$i];
				printf("<%04X>\t",$addr) if ($print_addrs);
				printf('			')	   if ($print_code);
				print("$line\n"); undef($line);
			}
			 
			my($lbl) = $LBL[$addr]; 												# then, any labels (NB: multiple possible, required for auto disassembly)
			if (defined($lbl)) {
				foreach my $l (keys(%Lbl)) {										# dump duplicate labels
					next if ($l eq $lbl);
					next unless ($Lbl{$l} == $addr);
					print("$l:\n");
				}
				$line = "$lbl:";
				my($ind) = ($EXTRA_IND[$addr][0] > 0)								# indent to use
						  ? $EXTRA_IND[$addr][0] : $IND[$addr];
# THE FOLLOWING CODE IS DISABLED BECAUSE IT IS ALREADY HANDLED CORRECTLY IN same_block()
#				undo_code_structure(F,$addr,$ind)									# label inside structured code 
#					if (@_ && $TYPE[$addr] != $CodeType_data) && ($ind > $code_base_indent);						  
				if (length($line) >= $hard_tab*$ind) {								# long label => separate line
					$line .= indent($line,$hard_tab*$rem_indent)."\t; ".$REM[$addr],undef($REM[$addr])
						if defined($REM[$addr]);									# comment
					printf("<%04X>\t",$addr) if ($print_addrs);						# output the line
					printf('			')	if ($print_code);
					print("$line\n"),undef($line)							   
				}
			}

			for (my($i)=0; $i<@{$EXTRA[$addr]}; $i++) { 							# then, "extra" OPs (always pseudo ops)
				next if ($EXTRA_BEFORE_LABEL[$addr][$i]);
				$line .= indent($line,$hard_tab*$EXTRA_IND[$addr][$i]) . $EXTRA[$addr][$i];
				printf("<%04X>\t",$addr) if ($print_addrs);
				printf('			')	   if ($print_code);
				print("$line\n"); undef($line);
			}
			 
			$line .= indent($line,$hard_tab*$IND[$addr]) . $OP[$addr];				# then, the operator
			$line .= indent($line,$hard_tab*($IND[$addr]+$op_width[$TYPE[$addr]]));	# and any operands
			foreach my $opa (@{$OPA[$addr]}) {	
				$line .= $opa . ' ';
			}

																			# comments
			$line .= indent($line,$hard_tab*$rem_indent)."\t; ".$REM[$addr],undef($REM[$addr])
				if defined($REM[$addr]);

			printf("<%04X>\t",$addr) if ($print_addrs);
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
		} elsif (!$decoded[$addr]) {										# this address was not decoded -> gap
			if ($fill_gaps && defined($org)) {								# output gaps as byte blocks
				die("$0: cannot print code with gap auto filling enabled (implementation restriction)\n")
					if ($print_code);
				printf("<%04X>\t",$addr) if ($print_addrs);
				$LBL[$addr] = 'ANALYSIS_GAP' unless defined($LBL[$addr]);
				printf("$LBL[$addr]:") if defined($LBL[$addr]);
				printf("%s.DB \$%02X",indent("$LBL[$addr]:",$hard_tab*$data_indent),BYTE($addr));
				my($col) = 1;
#				while ($addr<0xFFFF && !$decoded[$addr+1]) {
				while ($addr<=$MAX_ROM_ADDR && !$decoded[$addr+1]) {
					$addr++;
					if (defined($LBL[$addr])) {
						printf("\n");
						printf("<%04X>\t",$addr) if ($print_addrs);
						printf("$LBL[$addr]:%s.DB  \$%02X",indent("$LBL[$addr]:",$hard_tab*$data_indent),BYTE($addr));
						$col = 1;
					} elsif ($col == 8) {
						printf("\n");
						printf("<%04X>\t",$addr) if ($print_addrs);
						printf("ANALYSIS_GAP:");
						printf("%s.DB \$%02X",indent("ANALYSIS_GAP:",$hard_tab*$data_indent),BYTE($addr));
						$col = 1;
					} else {
						printf(" \$%02X",BYTE($addr));
						$col++;
					}
				}
				printf("\n");
			} elsif ($print_code && defined($org)) {						# print code in gaps
				printf("<%04X>\t",$addr) if ($print_addrs);
				printf("%02X		  $LBL[$addr]:\n",BYTE($addr));
			} else {
				undef($org);
				$gapLen++;
			}
		}
	}
	print(STDERR "decoded/ROMbytes = $decoded/$ROMbytes\n");
	return $decoded/$ROMbytes;
}

#----------------------------------------------------------------------
# Debug Routines
#----------------------------------------------------------------------

sub dump_labels($)
{
	my($fmt) = @_;

	if ($fmt == 1) {														# label code
		foreach my $lbl (sort { $Lbl{$a} <=> $Lbl{$b} } keys(%Lbl)) {
			next unless defined($Lbl{$lbl});
			printf("D711::overwriteLabel('$lbl',0x%04X);\n",$Lbl{$lbl});
		}	
	} else {
		print("Labels:\n");
		foreach my $lbl (sort { $Lbl{$a} <=> $Lbl{$b} } keys(%Lbl)) {
			next unless defined($Lbl{$lbl});
			print("\t");
			print($decoded[$Lbl{$lbl}]	? ' ' : 'D');
			print(($Lbl_refs{$lbl} > 0) ? ' ' : 'O');
			printf("\t0x%04X $lbl\n",$Lbl{$lbl});
	    }
	}
#	print("Label Refs:\n");
#	foreach my $lbl (keys(%Lbl)) {
#		printf("\t%3d\t$lbl\n",$Lbl_refs{$lbl});
#	}
}
		    
1;
