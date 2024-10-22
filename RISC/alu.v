module ALU(
    input      [15:0] A, B,    // Inputs (operands)
    input      [2:0]  ALUop,   // ALU operation code
    output reg [15:0] Result,  // ALU result
    output reg        Carry,   // Carry flag
    output reg        Zero     // Zero flag
);

    always @(ALUop) begin
        // Default values for Carry and Zero
        Carry = 0;
        Zero = 0;

        case (ALUop)
            3'b000: begin  // ADD
                {Carry, Result} = A + B;
                Zero = (Result == 16'd0) ? 1 : 0;
            end

            3'b010: begin  // NDU (NAND)
                Result = ~(A & B);
                Zero = (Result == 16'd0) ? 1 : 0;
            end


        endcase
        $display("Carry %b Zero: %b", Carry, Zero);
        $display("At time %0d,A = %d, B = %d,alu_op = %d, alu_result = %d",$time,A, B,ALUop,  Result);
    end
endmodule
