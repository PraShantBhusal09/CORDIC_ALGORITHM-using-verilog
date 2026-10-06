`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2026 02:42:19 PM
// Design Name: 
// Module Name: cordic_angle
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cordic_angle(
  input wire [1:0] mode ,
  input wire [3:0] iter ,
  output reg  signed [14:0] alpha
    );
    
reg signed [14:0] a;
    always @(*) begin
        a = 0;
        case (mode)
        
        2'd1: case (iter)
            4'd0: a = 15'sd8192;
            4'd1: a = 15'sd4096;
            4'd2: a = 15'sd2048;
            4'd3: a = 15'sd1024;
            4'd4: a = 15'sd512;
            4'd5: a = 15'sd256;
            4'd6: a = 15'sd128;
            4'd7: a = 15'sd64;
            4'd8: a = 15'sd32;
            4'd9: a = 15'sd16;
            4'd10: a = 15'sd8;
            4'd11: a = 15'sd4;
            4'd12: a = 15'sd2;
            4'd13: a = 15'sd1;
            default: a = 0; endcase
        2'd2: case (iter)
            4'd0: a = 15'sd4500;
            4'd1: a = 15'sd2092;
            4'd2: a = 15'sd1029;
            4'd3: a = 15'sd513;
            4'd4: a = 15'sd513;
            4'd5: a = 15'sd256;
            4'd6: a = 15'sd128;
            4'd7: a = 15'sd64;
            4'd8: a = 15'sd32;
            4'd9: a = 15'sd16;
            4'd10: a = 15'sd8;
            4'd11: a = 15'sd4;
            4'd12: a = 15'sd2;
            4'd13: a = 15'sd1;
            default: a = 0; endcase
        default: case (iter)
            4'd0: a = 15'sd6434;
            4'd1: a = 15'sd3798;
            4'd2: a = 15'sd2007;
            4'd3: a = 15'sd1019;
            4'd4: a = 15'sd511;
            4'd5: a = 15'sd256;
            4'd6: a = 15'sd128;
            4'd7: a = 15'sd64;
            4'd8: a = 15'sd32;
            4'd9: a = 15'sd16;
            4'd10: a = 15'sd8;
            4'd11: a = 15'sd4;
            4'd12: a = 15'sd2;
            4'd13: a = 15'sd1;
            default: a = 0; endcase
        endcase
        alpha = a;
    end
endmodule
 
