`define IF  3'b000
`define ID  3'b001
`define EX  3'b010
`define MEM 3'b011
`define WB  3'b100

module control_unit(
    input        clk, proc_rst,
    input [3:0]  opcode,        // Opcode from the instruction
    input [15:0] instruction,   // The current instruction
    input        Carry,         // Carry flag from ALU
    input        Zero,          // Zero flag from ALU
    output reg   reg_write,     // Register file write enable
    output reg   mem_read,      // Memory read enable
    output reg   mem_write,     // Memory write enable
    output reg   alu_src,       // ALU input source (register or immediate)
    output reg   pc_write,      // PC write enable
    output reg   branch,        // Branch enable
    output reg   jump,          // Jump enable
    output reg [2:0] alu_op     // ALU operation code
);

    // Define the state registers
    reg [2:0] current_state, next_state;

    

    // State transition on clock or reset
    always @(posedge clk or posedge proc_rst) begin
        $display("instruction at control Unit is %b", instruction);
        if (proc_rst) begin
            current_state <= `IF;  // Reset to instruction fetch state
            next_state <= `ID;
            end
        else
            current_state <= next_state;
         $display("State is %0d, next_state = %d,  pc_write = %b", current_state, next_state, pc_write);
    end



    // initial begin
        
    // end
    
    // State machine logic
    always @(*) begin
        // Default control signal values
        reg_write = 0;
        mem_read = 0;
        mem_write = 0;
        //alu_src = 0;
        //pc_write = 0;
        branch = 0;
        jump = 0;
        //alu_op = 3'b000;

        case (current_state)
            `IF: begin
                pc_write = 1;
                alu_src = 0;
                next_state = `ID;
            end
            `ID: begin
                pc_write = 0;
                $display("state is ID and opcode is %d", opcode);
                case (opcode)
                    4'b0000, 4'b0010: next_state = `EX;
                    4'b1010, 4'b1001: begin
                        alu_src = 1;
                        next_state = `EX;
                        
                    end

                    4'b1011, 4'b1101: next_state = `EX;
                    default: next_state = `IF;
                endcase
            end
            `EX: begin
                case (opcode)
                    4'b0000: begin
                        alu_op = 3'b000;
                        next_state = `WB;
                    end
                    4'b0010: begin
                         alu_op = 3'b010;
                          next_state = `WB;
                          
                        end
                    4'b1011: branch = 1;
                    4'b1010, 4'b1001: begin
                        alu_op = 3'b000;
                        // alu_src = 1;
                        next_state = `MEM;
                    end
                    4'b1101: jump = 1;
                    default: next_state = `IF;
                endcase
            end
            `MEM: begin
                case (opcode)
                    4'b1010: begin
                        mem_read = 1;
                        next_state = `WB;
                    end
                    4'b1001: begin
                        mem_write = 1;
                        next_state = `IF;
                    end
                endcase
            end
            `WB: begin
                reg_write = 
                    ((opcode == 4'b0000 && instruction[1:0]== 2'b10 && Carry == 0)||
                    (opcode == 4'b0010 && instruction[1:0]== 2'b01 && Zero == 0))
                    ?
                     0: 1;
                next_state = `IF;
                pc_write = 0;
            end
            default: next_state = `IF;
        endcase


       
    end
endmodule
