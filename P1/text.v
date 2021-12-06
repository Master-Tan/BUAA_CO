`timescale 1ns / 1ps
`default_nettype none
module top_module(input clk,
                  input [7:0] in,
                  input reset,                 // Synchronous reset
                  output reg [23:0] out_bytes,
                  output reg done);
    
    reg [255:0] bfr;  //»º³åÇø
    
    initial begin
        bfr       = "";
        done      = 1'b0;
        out_bytes = "";
    end
    always @(*) begin
        
    end
    always @(posedge clk) begin
        if (reset) begin
            bfr <= "";
            done <= 1'b0;
        end
        else begin
            bfr <= (bfr << 8) | in;
            if (bfr[19] == 1) begin
                done      <= 1;
                out_bytes <= bfr[23:0];
                bfr       <= bfr << 16;
            end
            else begin
                done      <= 0;
                out_bytes <= "";
            end
        end
    end
    
endmodule
