module program_counter(
    input        clk, proc_rst,
    input        pc_write,     // Control signal to update PC
    input [15:0] pc_in,        // New PC value for jumps/branches
    output reg [15:0] pc_out   // Current PC value
);

    always @(posedge pc_write or posedge proc_rst) begin
        if (proc_rst) begin
            pc_out <= 16'd0;  // Reset PC to 0
        end
        else if (pc_write)
            pc_out <= pc_in + 1;  // Update PC with jump/branch target
        else
            pc_out <= pc_in;  // Default: Increment PC

        $display("pc_in %d pc_out %d in program counter at time %0d",pc_in, pc_out, $time);
    end
endmodule
