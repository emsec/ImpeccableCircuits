----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://eprint.iacr.org/2018/203
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Anita Aghaie, Amir Moradi
-- All rights reserved.

-- BSD-3-Clause License
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--     * Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in the
--       documentation and/or other materials provided with the distribution.
--     * Neither the name of the copyright holder, their organization nor the
--       names of its contributors may be used to endorse or promote products
--       derived from this software without specific prior written permission.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Functions.all;

entity Red_TweakeySchedule is
	GENERIC ( 
		Tweakey : POSITIVE;
	   size    : POSITIVE;
		LFTable : STD_LOGIC_VECTOR(63 downto 0);
		LFC	  : STD_LOGIC_VECTOR(3  downto 0));
	 Port (    
		clk 			   : in  STD_LOGIC;
		rst 			   : in  STD_LOGIC;
		Key 			   : in  STD_LOGIC_VECTOR (16*Tweakey*size-1 downto 0);
	   LFSRIn         : in  STD_LOGIC_VECTOR (8*Tweakey*4-1 DOWNTO 8*4);
		KeyRegIn			: out STD_LOGIC_VECTOR (16*Tweakey*size-1 downto 0);
		KeyReg			: out STD_LOGIC_VECTOR (16*Tweakey*size-1 downto 0);
		TweakeyOutput 	: out STD_LOGIC_VECTOR ((16*size)/2-1 downto 0));
					  
end Red_TweakeySchedule;

architecture Behavioral of Red_TweakeySchedule is

	signal key_Feedback   : STD_LOGIC_VECTOR(16*Tweakey*size-1 downto 0);
	signal PermutedKey    : STD_LOGIC_VECTOR(16*Tweakey*size-1 downto 0);
	signal KeyRegInput    : STD_LOGIC_VECTOR (16*Tweakey*size-1 downto 0);
	signal KeyRegOutput   : STD_LOGIC_VECTOR (16*Tweakey*size-1 downto 0);

begin

	KEYMUX: ENTITY work.MUX
		GENERIC Map ( size => 16*Tweakey*size)
		PORT Map ( 
			sel	=> rst,
			D0   	=> key_Feedback,
			D1 	=> Key,
			Q 		=> KeyRegInput);

	KeyRegInst: ENTITY work.reg
		GENERIC Map ( size => 16*Tweakey*size)
		PORT Map ( 
			clk	=> clk,
			D 		=> KeyRegInput,
			Q 		=> KeyRegOutput);
	
	----
							
	Gen1: 
	If Tweakey =1 GENERATE	
     	TweakeyOutput <= KeyRegOutput (16*Tweakey*size-1 downto 8*Tweakey*size);
	END GENERATE;
	
	Gen2: 
	If Tweakey =2 GENERATE	
     	AddTweakeyXOR: ENTITY work.XOR_2n  
		GENERIC Map ( size => size, count => 8)
		PORT Map ( 
			KeyRegOutput (16*Tweakey*size-1 downto 12*Tweakey*size),
			KeyRegOutput (16*(Tweakey-1)*size-1 downto 8*(Tweakey-1)*size), 
			TweakeyOutput,
			LFC(size-1 downto 0));
	END GENERATE;
	
   Gen3: 
	If Tweakey =3 GENERATE	
		AddTweakeyXOR: ENTITY work.XOR_3n  
		GENERIC Map ( size => size, count => 8)
		PORT Map ( 
			KeyRegOutput (16*Tweakey*size-1 downto 13*Tweakey*size + size),
			KeyRegOutput (16*(Tweakey-1)*size-1 downto 12*(Tweakey-1)*size),
			KeyRegOutput (16*(Tweakey-2)*size-1 downto 8*(Tweakey-2)*size), 
			TweakeyOutput);
	END GENERATE;		
	
	-- PERMUTATION & LFSR -------------------------------------------------------------
	Gen4:
	If Tweakey >=1 GENERATE
		
		-- PERMUTATION -----------------
		Permut: ENTITY work.Permutation
			GENERIC MAP (size => size)
			PORT MAP ( KeyRegOutput (16*Tweakey*size-1 downto 16*(Tweakey-1)*size),PermutedKey(16*Tweakey*size-1 downto 16*(Tweakey-1)*size));
				
		-- NO LFSR ---------------------
		key_Feedback (16*Tweakey*size-1 downto 16*(Tweakey-1)*size) <= PermutedKey (16*Tweakey*size-1 downto 16*(Tweakey-1)*size);

	END GENERATE;
		
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
	
	Gen5:
	If Tweakey >=2 GENERATE
		
		-- PERMUTATION -----------------
		Permut: ENTITY work.Permutation
			GENERIC MAP (size => size)
			PORT MAP ( KeyRegOutput (16*(Tweakey-1)*size-1 downto 16*(Tweakey-2)*size),PermutedKey(16*(Tweakey-1)*size-1 downto 16*(Tweakey-2)*size));
				
		-- LFSR ---------------------
	
		Gen6:
      FOR i IN 0 TO 7 GENERATE
			LFSRUpdateInst2: ENTITY work.LFSRUpdate
			GENERIC Map (
			   size        => size,
				Tweakey     => 2,
				Table 		=> LFTable) 
			PORT Map (LFSRIn(63-(4*i) downto 60-(4*i)),key_Feedback(16*(Tweakey-1)*size-1-(size*i) downto 16*(Tweakey-1)*size-size-(size*i)));
	   END GENERATE;

		key_Feedback(16*(Tweakey-1)*size-1-8*size downto 16*(Tweakey-2)*size)  <= PermutedKey(16*(Tweakey-1)*size-1-8*size downto 16*(Tweakey-2)*size);
		
	END GENERATE;
			
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
	
	Gen7:
	If Tweakey =3 GENERATE

		-- PERMUTATION -----------------
		Permut2: ENTITY work.Permutation
			GENERIC MAP (size => size)
			PORT MAP (KeyRegOutput (16*(Tweakey-2)*size-1 downto 16*(Tweakey-3)*size),PermutedKey(16*(Tweakey-2)*size-1 downto 16*(Tweakey-3)*size));
				
		-- LFSR ---------------------
	
		Gen9:
		FOR i IN 0 TO 7 GENERATE
			LFSRUpdateInst3: ENTITY work.LFSRUpdate
			GENERIC Map (
			   size        => size,
				Table 		=> LFTable,
				Tweakey => 3)
			PORT Map (LFSRIn(95-(4*i) downto 92-(4*i)),key_Feedback(16*(Tweakey-2)*size-1-(size*i) downto 16*(Tweakey-2)*size-size-(size*i)));
	    
		END GENERATE;
   
		 key_Feedback(8*(Tweakey-2)*size-1 downto 0) <= PermutedKey(8*(Tweakey-2)*size-1 downto 0);
		 
	 END GENERATE;
	 
	KeyRegIn  <= KeyRegInput;	
   KeyReg  	 <= KeyRegOutput;		
	 
end Behavioral;
