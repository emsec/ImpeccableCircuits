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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY test_Skinny64Enc IS
END test_Skinny64Enc;
 
ARCHITECTURE behavior OF test_Skinny64Enc IS 
 
    COMPONENT Skinny64Enc
    Generic (TweakeySize: POSITIVE );
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         Plaintext : IN  std_logic_vector(63 downto 0);
         Key : IN  std_logic_vector(TweakeySize*64-1 downto 0);
         Ciphertext : OUT  std_logic_vector(63 downto 0);
         done : OUT  std_logic
        );
    END COMPONENT;
	 
  Constant TweakeySize: POSITIVE :=1;
  
   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal Plaintext : std_logic_vector(63 downto 0) := (others => '0');
   signal Key : std_logic_vector(TweakeySize*64-1 downto 0) := (others => '0');

 	--Outputs
   signal Ciphertext : std_logic_vector(63 downto 0);
   signal done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Skinny64Enc 
	GENERIC MAP ( TweakeySize => TweakeySize)
	PORT MAP (
          clk => clk,
          rst => rst,
          Plaintext => Plaintext,
          Key => Key,
          Ciphertext => Ciphertext,
          done => done
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin			

  if TweakeySize=1 then
	  
    	wait for clk_period*5.5;

		Plaintext 	<= x"06034f957724d19d";
		Key 			<= x"f5269826fc681238";
		
		rst			<= '1';  
		
		wait for clk_period*1;
		
		rst			<= '0';

		wait until done='1';
		
		wait for clk_period*2;

		if (Ciphertext = x"bb39dfb2429b8ac7") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;	
	
  else if TweakeySize=2 then
	  
    	wait for clk_period*5.5;

		Plaintext 	<= x"cf16cfe8fd0f98aa";
		Key 			<= x"9eb93640d088da6376a39d1c8bea71e1";
		
		rst			<= '1';  
		
		wait for clk_period*1;
		
		rst			<= '0';

		wait until done='1';
		
		wait for clk_period*2;

		if (Ciphertext = x"6ceda1f43de92b9e") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
	
	else if TweakeySize=3 then
	  
    	wait for clk_period*5.5;

		Plaintext 	<= x"530c61d35e8663c3";
		Key 			<= x"ed00c85b120d68618753e24bfd908f60b2dbb41b422dfcd0";
		
		rst			<= '1';  
		
		wait for clk_period*2;
		
		rst			<= '0';

		wait until done='1';
		
		wait for clk_period*5;

		if (Ciphertext = x"dd2cf1a8f330303c") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		
	end if;
  end if;
 end if;
  
  
      wait;
   end process;

END;
