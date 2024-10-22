module datapath(
    input         clk, proc_rst,
    input           Carry, Zero,
    input  [15:0] instruction,  // Instruction fetched from memory
    input         reg_write,    // Register write enable from control unit
    input         mem_read,     // Memory read enable
    input         mem_write,    // Memory write enable
    input         alu_src,      // ALU source (register or immediate)
    input         pc_write,     // Program counter write enable
    input  [2:0]  alu_op,       // ALU operation code
    output  [15:0] pc_out       // Program Counter output
);
    // Extracting instruction fields
    wire [2:0] Ra = instruction[11:9];   // Source register A
    wire [2:0] Rb = instruction[8:6];    // Source register B
    wire [2:0] Rc = instruction[5:3];    // Destination register C
    wire [3:0] opcode = instruction[15:12];  // Opcode
    wire [5:0] imm = instruction[5:0];  // Immediate value (for I-type)

    wire [15:0] Ra_data, Rb_data;
    wire [15:0] alu_result;
    wire [15:0] mem_data;
    reg  [15:0] pc = 16'b0, Rc_data;  // Program Counter initialized to 0
    reg  [15:0] memory [255:0];  // Memory for LW/SW instructions

    // Register file with R0 as Program Counter
    reg_file regFile (
        .clk(clk),
        .ra(Ra),
        .rb(Rb),
        .rc((opcode == 4'b1010)?Ra: Rc),
        .proc_rst(proc_rst),
        .ra_data(Ra_data),
        .rb_data(Rb_data),
        .rc_data((opcode == 4'b1010) ?memory[alu_result]:alu_result),  // ALU result is written back
        .reg_write(reg_write)
    );

    // ALU performs operations based on ALUop from control unit
    ALU alu (
        .B(Rb_data),
        .A((alu_src) ? {10'b0, imm} : Ra_data),  // Immediate or Register A as ALU input
        .ALUop(alu_op),
        .Carry(Carry),
        .Zero(Zero),
        .Result(alu_result)

    );

    // Memory Access
    always @(posedge clk) begin
        if (mem_read) begin
            Rc_data <= memory[alu_result];  // Load word (LW)
            $display("address %d data %d ra_data %d", alu_result, memory[alu_result], Ra_data);
        end
        else if (mem_write)  begin
            memory[alu_result] <= Ra_data;  // Store word (SW)
            $display("address %d data %d ra_data %d", alu_result, memory[alu_result], Ra_data);
        end
    end

    

    // assign pc_out = pc;  // Output the current PC value
endmodule
