module reg_file (
    input         clk,           // Clock signal
    input         reg_write,     // Write enable signal
    input  [2:0]  ra,            // Address of register A (source 1)
    input  [2:0]  rb,            // Address of register B (source 2)
    input  [2:0]  rc,            // Address of register C (destination)
    input  [15:0] rc_data,       // Data to write to register C
    output [15:0] ra_data,       // Data from register A
    output [15:0] rb_data,       // Data from register B
    input         pc_write,      // PC write enable signal (for R0 update)
    input  [15:0] pc_in,         // Data to write to R0 (Program Counter)
    input         proc_rst       // Reset signal
);

    // 8 general-purpose registers (R0 to R7)
    reg [15:0] registers [7:0];
    integer i;  // Loop variable for resetting and displaying register values

    // Read operation (combinational logic)
    assign ra_data = registers[ra];  // Output data from register A
    assign rb_data = registers[rb];  // Output data from register B

    // Write and reset operation (synchronous)
    always @(posedge clk or posedge proc_rst) begin
        // If reset is asserted, clear all registers
        if (proc_rst) begin
            for (i = 0; i < 8; i = i + 1) begin
                registers[i] <= 16'hffff;  // Reset all registers to 0
            end
            //registers[1] <= 16'd5;
            $display("All registers reset to 0 at time %0d", $time);
        end
        else begin
            // R0 acts as Program Counter (PC)
            if (pc_write)
                registers[0] <= pc_in;  
            // Write data to register C if reg_write is enabled
            else if (reg_write)
                registers[rc] <= rc_data;  
        end

        // Display register values on each clock cycle
        $display("Register values at time %0d:", $time);
        for (i = 0; i < 8; i = i + 1) begin
            $display("R%0d = %d", i, registers[i]);
        end
    end

endmodule
