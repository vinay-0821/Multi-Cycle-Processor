module top_level_processor(
    input clk,             // System clock
    input proc_rst         // System reset
);

    // Internal signals
    wire [15:0] pc_out;          // Program counter output
    wire [15:0] instruction;     // Current instruction from instruction memory
    wire [3:0]  opcode = instruction[15:12];  // Opcode from instruction

    // Control signals from the control unit
    wire reg_write, mem_read, mem_write, alu_src, pc_write, branch, jump ;
    wire [2:0] alu_op;
    reg Carry, Zero;

    // Instantiate the Program Counter
    program_counter PC (
        .clk(clk),
        .proc_rst(proc_rst),
        .pc_write(pc_write),
        .pc_in(pc_out),      // Use the ALU result as the next PC value for jumps/branches
        .pc_out(pc_out)
    );

    // Instantiate Instruction Memory
    instruction_memory IM (
        .address(pc_out),     // Address provided by the Program Counter
        .instruction(instruction)  // Fetch the instruction from memory
    );

    // Instantiate Control Unit
    control_unit CU (
        .clk(clk),
        .proc_rst(proc_rst),
        .opcode(opcode),
        .Carry(Carry),
        .Zero(Zero),
        .instruction(instruction),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .pc_write(pc_write),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op)
    );

    // Instantiate Datapath
    datapath DP (
        .clk(clk),
        .proc_rst(proc_rst),
        .instruction(instruction),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .Carry(Carry),
        .Zero(Zero),
        .alu_src(alu_src),
        .pc_write(pc_write),
        .alu_op(alu_op),
        .pc_out(pc_out)  // Connect the Program Counter output to the datapath
    );

endmodule
