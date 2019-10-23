`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// COMPANY:		Ruhr University Bochum, Embedded Security
// AUTHOR:		https://eprint.iacr.org/2018/203
//////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, Amir Moradi, Aein Rezaei Shahmirzadi
// All rights reserved.
//
// BSD-3-Clause License
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the copyright holder, their organization nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

module Cipher_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [127:0] InputData;
	reg [127:0] Key;

	// Outputs
	wire [127:0] OutputData;
	wire done;

	// Instantiate the Unit Under Test (UUT)
	Cipher uut (
		.clk(clk), 
		.rst(rst), 
		.InputData(InputData), 
		.Key(Key), 
		.OutputData(OutputData), 
		.done(done)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		InputData = 128'h340737e0a29831318d305a88a8f64332;
		Key = 128'h3c4fcf098815f7aba6d2ae2816157e2b;

		// Wait 100 ns for global reset to finish
		#100;
      rst = 0;
		@(negedge done) begin
		
			#5;
			
			if(OutputData == 128'h320b6a19978511dcfb09dc021d842539) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("\------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'h320b6a19978511dcfb09dc021d842539);
			end
			$stop;
		end
		

	end

	always #5 clk = ~clk;
	
endmodule

