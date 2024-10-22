module instruction_memory(
    input  [15:0] address,     // Address from the Program Counter (PC)
    output reg [15:0] instruction  // Fetched instruction
);
    reg [15:0] memory [255:0];  // Instruction memory (256 16-bit words)

    initial begin  // Example instructions
        //memory[0] = 16'b1001_001_010_000010; 
       // Example instructions
        //memory[1] = 16'b1010_111_010_011_000; 
        memory[0] = 16'b0000_001_010_011_010; // Example instructions
        //memory[3] = 16'b0000001010011000;  // More instructions
        // Load more instructions here...
    end

      // Fetch the instruction
    always@(*) begin
         instruction = memory[address];
       $display("time: %0d Instruction is %b and address", $time, instruction, address);
    end
endmodule
