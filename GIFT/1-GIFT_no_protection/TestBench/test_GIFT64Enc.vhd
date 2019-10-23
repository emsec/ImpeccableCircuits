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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY test_GIFT64Enc IS
END test_GIFT64Enc;
 
ARCHITECTURE behavior OF test_GIFT64Enc IS 
 
    COMPONENT GIFT64Enc
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         Plaintext : IN  std_logic_vector(63 downto 0);
         Key : IN  std_logic_vector(127 downto 0);
         Ciphertext : OUT  std_logic_vector(63 downto 0);
         done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal Plaintext : std_logic_vector(63 downto 0) := (others => '0');
   signal Key : std_logic_vector(127 downto 0) := (others => '0');

   --Outputs
   signal Ciphertext : std_logic_vector(63 downto 0);
   signal done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GIFT64Enc PORT MAP (
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
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for clk_period*1;

		Plaintext 	<= (others => '0');
		Key 			<= (others => '0');
		
		rst			<= '1';

      wait for clk_period*1;
		
		rst			<= '0';

		wait until done='1'; 
		wait for clk_period*0.5;

		if (Ciphertext = x"f62bc3ef34f775ac") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;

		wait for clk_period*5;

		Plaintext 	<= x"fedcba9876543210";
		Key 			<= x"fedcba9876543210fedcba9876543210";
		
		rst			<= '1';  
		
		wait for clk_period*1;
		
		rst			<= '0';

		wait until done='1';
		wait for clk_period*0.5;

		if (Ciphertext = x"c1b71f66160ff587") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;

		wait for clk_period*5;

		Plaintext 	<= x"c450c7727a9b8a7d";
		Key 			<= x"bd91731eb6bc2713a1f9f6ffc75044e7";
		
		rst			<= '1';  
		
		wait for clk_period*1;
		
		rst			<= '0';

		wait until done='1';
		wait for clk_period*0.5;

		if (Ciphertext = x"e3272885fa94ba8b") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		
      wait;
   end process;

END;
