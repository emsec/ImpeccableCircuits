----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://eprint.iacr.org/2018/203
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Anita Aghaie, Amir Moradi, Aein Rezaei Shahmirzadi
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

entity TweakeySchedule is
	GENERIC ( 
		Table   : STD_LOGIC_VECTOR (63 downto 0);
		size    : POSITIVE;
		Tweakey : POSITIVE);
	Port (    
		clk 			   : in  STD_LOGIC;
		rst 			   : in  STD_LOGIC;
		Key 			   : in  STD_LOGIC_VECTOR (16* Tweakey*size-1 downto 0);
	   LFSRIn         : out STD_LOGIC_VECTOR (8*Tweakey*size-1 DOWNTO 8*size);
		KeyRegIn			: out STD_LOGIC_VECTOR (16* Tweakey*size-1 downto 0);
		KeyReg			: out STD_LOGIC_VECTOR (16* Tweakey*size-1 downto 0);
		TweakeyOutput 	: out STD_LOGIC_VECTOR ((16*size/2)-1 downto 0));

end TweakeySchedule;

architecture Behavioral of TweakeySchedule is

	signal key_Feedback   : STD_LOGIC_VECTOR(16*Tweakey*size-1 downto 0);
	signal PermutedKey    : STD_LOGIC_VECTOR(16*Tweakey*size-1 downto 0);
	signal StateRegInput  : STD_LOGIC_VECTOR(16*Tweakey*size-1 downto 0);
	signal StateRegOutput : STD_LOGIC_VECTOR(16*Tweakey*size-1 downto 0);

begin

	KEYMUX: ENTITY work.MUX
		GENERIC Map ( size => 16*Tweakey*size)
		PORT Map ( 
			sel	=> rst,
			D0   	=> key_Feedback,
			D1 	=> Key,
			Q 		=> StateRegInput);

	StateReg: ENTITY work.reg
		GENERIC Map ( size => 16*Tweakey*size)
		PORT Map ( 
			clk	=> clk,
			D 		=> StateRegInput,
			Q 		=> StateRegOutput);
			
	----
	
	Gen1: 
	If Tweakey =1 GENERATE	
		TweakeyOutput <= StateRegOutput (63 downto 32);
	END GENERATE;

	
	Gen2: 
	If Tweakey =2 GENERATE	
	
		AddTweakeyXOR: ENTITY work.XOR_2n  
			GENERIC Map ( size => 4, count => 8)
			PORT Map ( 
			 StateRegOutput (127 downto 96),
			 StateRegOutput (63 downto 32), 
			 TweakeyOutput);
		END GENERATE;
	
   Gen3: 
	If Tweakey =3 GENERATE	
		
		AddTweakeyXOR: ENTITY work.XOR_3n  
			GENERIC Map ( size => 4, count => 8)
			PORT Map ( 
			 StateRegOutput (191 downto 160),
			 StateRegOutput (127 downto 96),
			 StateRegOutput (63 downto 32), 
			 TweakeyOutput);
	END GENERATE;		
	
	-- PERMUTATION & LFSR -------------------------------------------------------------
	Gen4:
	If Tweakey >=1 GENERATE

		-- PERMUTATION -----------------
		Permut: ENTITY work.Permutation
			GENERIC MAP (size => size)
			PORT MAP ( StateRegOutput (16*Tweakey*size-1 downto 16*(Tweakey-1)*size),PermutedKey(16*Tweakey*size-1 downto 16*(Tweakey-1)*size));
				
		-- NO LFSR ---------------------
		key_Feedback (16*Tweakey*size-1 downto 16*(Tweakey-1)*size) <= PermutedKey (16*Tweakey*size-1 downto 16*(Tweakey-1)*size);
		
	END GENERATE;
		
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
	
	Gen5:
	If Tweakey >= 2 GENERATE
		
		-- PERMUTATION -----------------
		Permut: ENTITY work.Permutation
			GENERIC MAP (size => size)
			PORT MAP ( StateRegOutput (16*(Tweakey-1)*size-1 downto 16*(Tweakey-2)*size),PermutedKey(16*(Tweakey-1)*size-1 downto 16*(Tweakey-2)*size));
				
		-- LFSR ---------------------
		
		LFSRIn(63 downto 32) <= PermutedKey(16*(Tweakey-1)*size-1 downto 16*(Tweakey-1)*size-32);
		
		Gen6:
      FOR i IN 0 TO 7 GENERATE
			LFSRUpdateInst2: ENTITY work.LFSRUpdate
			GENERIC Map ( size => size, Table => Table, Tweakey => 2) 
			PORT Map (PermutedKey(16*(Tweakey-1)*size-1-(4*i) downto 16*(Tweakey-1)*size-4-(4*i)),
			          key_Feedback(16*(Tweakey-1)*size-1-(4*i) downto 16*(Tweakey-1)*size-4-(4*i)));
	   END GENERATE;
		
		key_Feedback(16*(Tweakey-1)*size-33 downto 16*(Tweakey-1)*size-48) <= PermutedKey(16*(Tweakey-1)*size-33 downto 16*(Tweakey-1)*size-48);
		key_Feedback(16*(Tweakey-1)*size-49 downto 16*(Tweakey-1)*size-64) <= PermutedKey(16*(Tweakey-1)*size-49 downto 16*(Tweakey-1)*size-64);		
				
	END GENERATE;
			
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
	
	Gen7:
	If Tweakey =3 GENERATE
		
		-- PERMUTATION -----------------
		Permut2: ENTITY work.Permutation
			GENERIC MAP (size => size)
			PORT MAP (StateRegOutput (16*(Tweakey-2)*size-1 downto 16*(Tweakey-3)*size),PermutedKey(16*(Tweakey-2)*size-1 downto 16*(Tweakey-3)*size));
				
		-- LFSR ---------------------
		
		LFSRIn(95 downto 64) <= PermutedKey(16*(Tweakey-2)*size-1 downto 16*(Tweakey-2)*size-32);
		
		Gen8:
		FOR i IN 0 TO 7 GENERATE
			LFSRUpdateInst3: ENTITY work.LFSRUpdate
			GENERIC Map ( size => size, Table => Table,Tweakey => 3) 
			PORT Map (PermutedKey(16*(Tweakey-2)*size-1-(4*i) downto 16*(Tweakey-2)*size-4-(4*i)),
			          key_Feedback(16*(Tweakey-2)*size-1-(4*i) downto 16*(Tweakey-2)*size-4-(4*i)));
	    
		END GENERATE;
	
		key_Feedback(16*(Tweakey-2)*size-33 downto 16*(Tweakey-2)*size-48) <= PermutedKey(16*(Tweakey-2)*size-33 downto 16*(Tweakey-2)*size-48);
		key_Feedback(16*(Tweakey-2)*size-49 downto 16*(Tweakey-2)*size-64) <= PermutedKey(16*(Tweakey-2)*size-49 downto 16*(Tweakey-2)*size-64);		
	   
	 END GENERATE;
	 
  KeyRegIn  <= StateRegInput; 
  KeyReg  	<= StateRegOutput; 
	
end Behavioral;

