`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2026 03:14:30 PM
// Design Name: 
// Module Name: tb_cordic_main
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


`timescale 1ns / 1ps

module tb_cordic_main;

    reg clk;
    reg rst;
    reg start;
    reg [1:0] mode;

    reg signed [16:0] X_in;
    reg signed [16:0] Y_in;
    reg signed [14:0] z_in;

    wire signed [16:0] x_out;
    wire signed [16:0] y_out;
    wire signed [14:0] z_out;
    wire busy;
    wire done;

    cordic_main uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .mode(mode),
        .X_in(X_in),
        .Y_in(Y_in),
        .z_in(z_in),
        .x_out(x_out),
        .y_out(y_out),
        .z_out(z_out),
        .busy(busy),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        mode = 0;
        X_in = 0;
        Y_in = 0;
        z_in = 0;
        #20;
        rst = 0;
        #20;

        // --- Test 1: Circular Mode (45 degrees) ---
        // X_in = 1/Kc * 8192 = 0.6072529 * 8192 = 4975
        // z_in = (45 * pi / 180) * 8192 = 0.785398 * 8192 = 6434
        $display("\nTest 1: Circular Mode (Angle = 45 deg)");
        mode = 2'b00;
        X_in = 17'sd4975;
        Y_in = 17'sd0;
        z_in = 15'sd6434;

        start = 1;
        #10;
        start = 0;
        wait(done);
        #10;
        $display("  x_out (cos) = %d (exp: 5792)", x_out); // cos(45 deg) * 8192 = 5792
        $display("  y_out (sin) = %d (exp: 5792)", y_out); // sin(45 deg) * 8192 = 5792
        $display("  z_out       = %d", z_out);

        // --- Test 2: Linear Mode (1.5 * 0.5) ---
        // X_in = 1.5 * 8192 = 12288
        // z_in = 0.5 * 8192 = 4096
        $display("\nTest 2: Linear Mode (Mult 1.5 * 0.5)");
        mode = 2'b01;
        X_in = 17'sd12288;
        Y_in = 17'sd0;
        z_in = 15'sd4096;

        start = 1;
        #10;
        start = 0;
        wait(done);
        #10;
        $display("  x_out       = %d (exp: 12288)", x_out);
        $display("  y_out (prod)= %d (exp: 6144)", y_out);  // 1.5 * 0.5 * 8192 = 6144
        $display("  z_out       = %d", z_out);

        // --- Test 3: Hyperbolic Mode (Z = 0.5 rad) ---
        // X_in = Ah * 8192 = 0.828156 * 8192 = 6784
        // z_in = 0.5 rad * 8192 = 4096
        $display("\nTest 3: Hyperbolic Mode (Z = 0.5 rad)");
        mode = 2'b10;
        X_in = 17'sd9892;
        Y_in = 17'sd0;
        z_in = 15'sd4096;

        start = 1;
        #10;
        start = 0;
        wait(done);
        #10;
        $display("  x_out (cosh)= %d (exp: 9237)", x_out); // cosh(0.5) * 8192 = 9237
        $display("  y_out (sinh)= %d (exp: 4268)", y_out); // sinh(0.5) * 8192 = 4268
        $display("  z_out       = %d", z_out);

        $display("\nSimulation finished.");
        #50;
        $finish;
    end

endmodule