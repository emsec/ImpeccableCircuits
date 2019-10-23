----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://doi.org/10.13154/tosc.v2019.i1.5-45 
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Amir Moradi 
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
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL; 

ENTITY test_Cipher IS
END test_Cipher;
 
ARCHITECTURE behavior OF test_Cipher IS 
 
    COMPONENT Cipher
	 Generic ( 
		withTweak 		: integer;
		withDec   		: integer;
		withKeyMasking : integer);
	 PORT(
         clk     : IN  std_logic;
         rst     : IN  std_logic;
         EncDec  : IN  std_logic;
			Input1  : IN  std_logic_vector(63 downto 0);
			Input2  : IN  std_logic_vector(63 downto 0);
			Input3  : IN  std_logic_vector(63 downto 0);
         Key1    : IN  std_logic_vector(127 downto 0);
         Key2    : IN  std_logic_vector(127 downto 0);
         Key3    : IN  std_logic_vector(127 downto 0);
			Tweak   : IN  std_logic_vector( 63 downto 0);
         Output1 : OUT  std_logic_vector(63 downto 0);
         Output2 : OUT  std_logic_vector(63 downto 0);
         Output3 : OUT  std_logic_vector(63 downto 0);
         done    : OUT  std_logic
        );
    END COMPONENT;
    
	constant withKeyMasking : integer := 1; 
	 

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal EncDec : std_logic := '0';
	signal Input1 : std_logic_vector(63 downto 0) := (others => '0');
	signal Input2 : std_logic_vector(63 downto 0) := (others => '0');
	signal Input3 : std_logic_vector(63 downto 0) := (others => '0');
   signal Key1 : std_logic_vector(127 downto 0) := (others => '0');
   signal Key2 : std_logic_vector(127 downto 0) := (others => '0');
   signal Key3 : std_logic_vector(127 downto 0) := (others => '0');
	signal Tweak  : std_logic_vector( 63 downto 0) := (others => '0');

	signal Input : std_logic_vector(63 downto 0)  := (others => '0');
   signal Key   : std_logic_vector(127 downto 0) := (others => '0');
   signal Output11 : std_logic_vector(63 downto 0);
   signal Output10 : std_logic_vector(63 downto 0);
   signal Output01 : std_logic_vector(63 downto 0);
   signal Output00 : std_logic_vector(63 downto 0);

	signal Mask1	 : std_logic_vector(63  downto 0)  := (others => '0');
	signal Mask2	 : std_logic_vector(63  downto 0)  := (others => '0');
	signal Mask3	 : std_logic_vector(127 downto 0)  := (others => '0');
	signal Mask4	 : std_logic_vector(127 downto 0)  := (others => '0');


 	--Outputs
   signal Output11_1 : std_logic_vector(63 downto 0);
   signal Output11_2 : std_logic_vector(63 downto 0);
   signal Output11_3 : std_logic_vector(63 downto 0);
   signal done11 : std_logic;

   signal Output10_1 : std_logic_vector(63 downto 0);
   signal Output10_2 : std_logic_vector(63 downto 0);
   signal Output10_3 : std_logic_vector(63 downto 0);
   signal done10 : std_logic;

   signal Output01_1 : std_logic_vector(63 downto 0);
   signal Output01_2 : std_logic_vector(63 downto 0);
   signal Output01_3 : std_logic_vector(63 downto 0);
   signal done01 : std_logic;

   signal Output00_1 : std_logic_vector(63 downto 0);
   signal Output00_2 : std_logic_vector(63 downto 0);
   signal Output00_3 : std_logic_vector(63 downto 0);
   signal done00 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
 	type INT_ARRAY  is array (integer range <>) of integer;
	type REAL_ARRAY is array (integer range <>) of real;
	type BYTE_ARRAY is array (integer range <>) of std_logic_vector(7 downto 0);

	signal r: INT_ARRAY (47 downto 0);
	signal m: BYTE_ARRAY(47 downto 0);

BEGIN
 
  	maskgen: process
		 variable seed1, seed2: positive;        -- seed values for random generator
		 variable rand: REAL_ARRAY(47 downto 0); -- random real-number value in range 0 to 1.0  
		 variable range_of_rand : real := 256.0; -- the range of random values created will be 0 to +1000.
	begin
		 
		FOR i in 0 to 47 loop
			uniform(seed1, seed2, rand(i));   -- generate random number
			r(i) <= integer(rand(i)*range_of_rand);  -- rescale to 0..1000, convert integer part 
			m(i) <= std_logic_vector(to_unsigned(r(i), m(i)'length));
		end loop;
		
		wait for clk_period;
	end process;  

	---------
	
	maskassign: FOR i in 0 to 7 GENERATE
		Mask1(i*8+7 downto i*8)	<= m(i);
		Mask2(i*8+7 downto i*8)	<= m(8+i);
		Mask3(i*8+7 downto i*8)	<= m(16+i);
		Mask3(i*8+64+7 downto i*8+64)	<= m(24+i);
		Mask4(i*8+7 downto i*8)			<= m(32+i);
		Mask4(i*8+64+7 downto i*8+64)	<= m(40+i);
	END GENERATE;
	
	
   uut11: Cipher 
	GENERIC MAP (withTweak => 1, withDec => 1, withKeyMasking => withKeyMasking)
	PORT MAP (
          clk => clk,
          rst => rst,
          EncDec => EncDec,
			 Input1 => Input1,
			 Input2 => Input2,
			 Input3 => Input3,
          Key1 => Key1,
          Key2 => Key2,
          Key3 => Key3,
			 Tweak => Tweak,
          Output1 => Output11_1,
          Output2 => Output11_2,
          Output3 => Output11_3,
          done => done11
        );

   uut10: Cipher 
	GENERIC MAP (withTweak => 1, withDec => 0, withKeyMasking => withKeyMasking)
	PORT MAP (
          clk => clk,
          rst => rst,
          EncDec => EncDec,
			 Input1 => Input1,
			 Input2 => Input2,
			 Input3 => Input3,
          Key1 => Key1,
          Key2 => Key2,
          Key3 => Key3,
			 Tweak => Tweak,
          Output1 => Output10_1,
          Output2 => Output10_2,
          Output3 => Output10_3,
          done => done10
        );

   uut01: Cipher 
	GENERIC MAP (withTweak => 0, withDec => 1, withKeyMasking => withKeyMasking)
	PORT MAP (
          clk => clk,
          rst => rst,
          EncDec => EncDec,
			 Input1 => Input1,
			 Input2 => Input2,
			 Input3 => Input3,
          Key1 => Key1,
          Key2 => Key2,
          Key3 => Key3,
			 Tweak => Tweak,
          Output1 => Output01_1,
          Output2 => Output01_2,
          Output3 => Output01_3,
          done => done01
        );

   uut00: Cipher 
	GENERIC MAP (withTweak => 0, withDec => 0, withKeyMasking => withKeyMasking)
	PORT MAP (
          clk => clk,
          rst => rst,
          EncDec => EncDec,
			 Input1 => Input1,
			 Input2 => Input2,
			 Input3 => Input3,
          Key1 => Key1,
          Key2 => Key2,
          Key3 => Key3,
			 Tweak => Tweak,
          Output1 => Output00_1,
          Output2 => Output00_2,
          Output3 => Output00_3,
          done => done00
        );		  

	-------------------------------------------------

	Input1	<= Input XOR Mask1 XOR Mask2;
	Input2	<= Mask1;
	Input3	<= Mask2;
	
	Key2		<= Mask3;
	Key3		<= Mask4;

	GenwithKeyMasking: IF withKeyMasking /= 0 GENERATE
		Key1		<= Key XOR Mask3 XOR Mask4;
	END GENERATE;	

	GenwithoutKeyMasking: IF withKeyMasking = 0 GENERATE
		Key1		<= Key;
	END GENERATE;

	Output11 <= Output11_1 XOR Output11_2 XOR Output11_3;
	Output10 <= Output10_1 XOR Output10_2 XOR Output10_3;
	Output01 <= Output01_1 XOR Output01_2 XOR Output01_3;
	Output00 <= Output00_1 XOR Output00_2 XOR Output00_3;

	-------------------------------------------------
	
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

		Input   		<= (others => '0');
		Key 			<= (others => '0');
		Tweak			<= x"0123456789abcdef";
		EncDec		<= '0';
		
		rst			<= '1';

      wait for clk_period*2;
		
		rst			<= '0';

		wait until done11='1'; 
		wait for clk_period*1.5;

		if (Output11 = x"42B05270E21B3FFF") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;

		if (Output10 = x"42B05270E21B3FFF") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;

		if (Output01 = x"F630538883063100") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;

		if (Output00 = x"F630538883063100") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		
		
		wait for clk_period*5;

		Input 		<= x"0123456789ABCDEF";
		Key 			<= x"18F4EEBDFCED7841D9E0E38CFE6A9405";
		Tweak			<= x"17F291A9A3AA0400";
		rst			<= '1';  
		
		wait for clk_period*2;
		
		rst			<= '0';

		wait until done11='1';
		wait for clk_period*1.5;

		if (Output11 = x"111DF5062A8D88C9") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;

		if (Output10 = x"111DF5062A8D88C9") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;

		if (Output01 = x"614D03B82A8A2817") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		
		if (Output00 = x"614D03B82A8A2817") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		
		wait for clk_period*5;

		Input 		<= (others => '1');
		Key 			<= (others => '1');
		Tweak			<= x"F0F0F0F0F0F0F0F0";
		rst			<= '1';  
		
		wait for clk_period*2;
		
		rst			<= '0';

		wait until done11='1';
		wait for clk_period*1.5;

		if (Output11 = x"F2735A9ABBD27175") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;

		if (Output10 = x"F2735A9ABBD27175") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		
		if (Output01 = x"0FB8E3D17717AA03") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;		

		if (Output00 = x"0FB8E3D17717AA03") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;	

		--=================================================================
	
		wait for clk_period*5;
	
		Input   		<= x"42B05270E21B3FFF";
		Key 			<= (others => '0');
		Tweak			<= x"0123456789abcdef";
		EncDec		<= '1';
		
		rst			<= '1';

      wait for clk_period*2;
		
		rst			<= '0';

		wait until done11='1'; 
		wait for clk_period*1.5;

		if (Output11 = x"0000000000000000") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		
		if (Output01 = x"F1F1C17330319E40") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;		

		wait for clk_period*5;

		Input 		<= x"111DF5062A8D88C9";
		Key 			<= x"18F4EEBDFCED7841D9E0E38CFE6A9405";
		Tweak			<= x"17F291A9A3AA0400";
		rst			<= '1';  
		
		wait for clk_period*2;
		
		rst			<= '0';

		wait until done11='1';
		wait for clk_period*1.5;

		if (Output11 = x"0123456789ABCDEF") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;

		if (Output01 = x"AECC9B83992E1B02") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;

		wait for clk_period*5;

		Input 		<= x"F2735A9ABBD27175";
		Key 			<= (others => '1');
		Tweak			<= x"F0F0F0F0F0F0F0F0";
		rst			<= '1';  
		
		wait for clk_period*2;
		
		rst			<= '0';

		wait until done11='1';
		wait for clk_period*1.5;

		if (Output11 = x"FFFFFFFFFFFFFFFF") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;

		if (Output01 = x"4F0C81B1DAA77056") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;




      wait;
   end process;

END;

