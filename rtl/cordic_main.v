`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2026 02:45:42 PM
// Design Name: 
// Module Name: cordic_main
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


`define data_width 17
`define angle_width 15
`define iteration 14

module cordic_main(
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire [1:0] mode,

    input  wire signed [`data_width-1:0]  X_in,
    input  wire signed [`data_width-1:0]  Y_in,
    input  wire signed [`angle_width-1:0] z_in,

    output reg  signed [`data_width-1:0]  x_out,
    output reg  signed [`data_width-1:0]  y_out,
    output reg  signed [`angle_width-1:0] z_out,

    output reg busy,
    output reg done
);

    reg signed [`data_width-1:0]  x, y;
    reg signed [`angle_width-1:0] z;

    reg [1:0] current_mode;
    reg [3:0] step;

    // Hyperbolic shift mapping (Shift sequence: 1, 2, 3, 4, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13)
    reg [3:0] hyp_shift;
    always @(*) begin
        case (step)
            4'd0:  hyp_shift = 4'd1;
            4'd1:  hyp_shift = 4'd2;
            4'd2:  hyp_shift = 4'd3;
            4'd3:  hyp_shift = 4'd4;
            4'd4:  hyp_shift = 4'd4;  
            4'd5:  hyp_shift = 4'd5;
            4'd6:  hyp_shift = 4'd6;
            4'd7:  hyp_shift = 4'd7;
            4'd8:  hyp_shift = 4'd8;
            4'd9:  hyp_shift = 4'd9;
            4'd10: hyp_shift = 4'd10;
            4'd11: hyp_shift = 4'd11;
            4'd12: hyp_shift = 4'd12;
            4'd13: hyp_shift = 4'd13;
            default: hyp_shift = 4'd1;
        endcase
    end

   
    reg [3:0] shift_amt;
    always @(*) begin
        if (current_mode == 2'd2) begin
            shift_amt = hyp_shift;
        end else begin
            shift_amt = step;
        end
    end

    
    wire signed [`angle_width-1:0] angle_lut;
    cordic_angle u_rom (
        .mode  (current_mode),
        .iter  (step),
        .alpha (angle_lut)
    );

    wire signed [`data_width-1:0] x_shifted  = x >>> shift_amt;
    wire signed [`data_width-1:0] y_shifted  = y >>> shift_amt;
    wire                          z_positive = ~z[`angle_width-1]; // 1 if Z >= 0, 0 if Z < 0

    reg signed [`data_width-1:0]  x_next;
    reg signed [`data_width-1:0]  y_next;
    reg signed [`angle_width-1:0] z_next;

    always @(*) begin
        if (current_mode == 2'd1) begin          // Linear Mode
            x_next = x;
        end else if (current_mode == 2'd2) begin  // Hyperbolic Mode
            if (z_positive) begin
                x_next = x + y_shifted;
            end else begin
                x_next = x - y_shifted;
            end
        end else begin                           // Circular Mode
            if (z_positive) begin
                x_next = x - y_shifted;
            end else begin
                x_next = x + y_shifted;
            end
        end

        if (z_positive) begin
            y_next = y + x_shifted;
        end else begin
            y_next = y - x_shifted;
        end

        // Compute z_next
        if (z_positive) begin
            z_next = z - angle_lut;
        end else begin
            z_next = z + angle_lut;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy         <= 1'b0;
            done         <= 1'b0;
            step         <= 4'd0;
            current_mode <= 2'd0;
            x            <= 'd0;
            y            <= 'd0;
            z            <= 'd0;
            x_out        <= 'd0;
            y_out        <= 'd0;
            z_out        <= 'd0;
        end else begin
            done <= 1'b0; 
            if (!busy) begin
                if (start) begin
                    x            <= X_in;
                    y            <= Y_in;
                    z            <= z_in;
                    current_mode <= mode;
                    step         <= 4'd0;
                    busy         <= 1'b1;
                end
            end else begin
                x <= x_next;
                y <= y_next;
                z <= z_next;
                if (step == (`iteration - 1)) begin
                    busy  <= 1'b0;
                    done  <= 1'b1;
                    x_out <= x_next;
                    y_out <= y_next;
                    z_out <= z_next;
                end else begin
                    step  <= step + 4'd1;
                end
            end
        end
    end

endmodule