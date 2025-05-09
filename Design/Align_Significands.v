(*DONT_TOUCH = "TRUE"*) module Align_Significands (
    input comp,
    input [24:0] operand_1_significand, operand_2_significand,
    input [7:0] shamt,
    output [27:0] operand_1_significand_shifted, operand_2_significand_shifted
);

    reg [25:0] w1;
    reg [27:0] w2;
    reg [31:0] w3;
    reg [39:0] w4;
    reg [55:0] w5;

    wire guard, round, sticky;

    always @(*) begin   // Complemented Operand 1 as the textbook stated
        if (shamt[0]) begin //shift by 1
            w1 = {operand_2_significand[24], operand_2_significand};
        end
        else begin
            w1[25:1] = operand_2_significand;
            w1[0] = 0;
        end

        if (shamt[1]) begin //shift by 2
            w2 = {{2{w1[25]}}, w1};
        end
        else begin
            w2[27:2] = w1;
            w2[1:0] = 0;
        end

        if (shamt[2]) begin //shift by 4
            w3 = {{4{w2[27]}}, w2};
        end
        else begin
            w3[31:4] = w2;
            w3[3:0] = 0;
        end

        if (shamt[3]) begin //shift by 8
            w4 = {{8{w3[31]}}, w3};
        end
        else begin
            w4[39:8] = w3;
            w4[7:0] = 0;
        end

        if (shamt[4]) begin //shift by 16
            w5 = {{16{w4[39]}}, w4};
        end
        else begin
            w5[55:16] = w4;
            w5[15:0] = 0;
        end
    end

    assign guard = w5[30];
    assign round = w5[29];
    assign sticky = |(w5[28:0]);

    assign operand_1_significand_shifted = {operand_1_significand, {3{comp}}};
    assign operand_2_significand_shifted = (shamt[7:5])? 0 : {w5[55:31], guard, round, sticky};

endmodule