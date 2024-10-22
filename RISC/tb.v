`timescale 1ns / 1ps

module tb;
    reg clk;
    reg reset;

    top_level_processor uut(
        .clk(clk),
        .proc_rst(reset)
    );

    initial begin

        reset = 1;
        clk = 0;

        #10 reset = 0;
        forever begin
            #10 clk = ~clk;
        end

    end
    

    initial begin
        #240 $finish;
    end
    
endmodule
