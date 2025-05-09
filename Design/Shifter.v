(*DONT_TOUCH = "TRUE"*) module Shifter (
    input [27:0] sum,
    input [7:0] shamt,
    output [27:0] shifted_sum
);

    reg [27:0] w1;
    reg [27:0] w2;
    reg [27:0] w3;
    reg [27:0] w4;
    reg [27:0] w5;
    reg [27:0] w6;

    always @(*) begin
        if (shamt[0]) begin //shift by 1
            w1 = sum << 1;
        end
        else begin
            w1 = sum;
        end

        if (shamt[1]) begin //shift by 2
            w2 = w1 << 2;
        end
        else begin
            w2 = w1;
        end

        if (shamt[2]) begin //shift by 4
            w3 = w2 << 4;
        end
        else begin
            w3 = w2;
        end

        if (shamt[3]) begin //shift by 8
            w4 = w3 << 8;
        end
        else begin
            w4 = w3;
        end

        if (shamt[4]) begin //shift by 16
            w5 = w4 << 16;
        end
        else begin
            w5 = w4;
        end

        if (shamt[5]) begin //Shift by 32
            w6 = w5 << 32;
        end
        else begin
            w6 = w5;
        end

    end

    assign shifted_sum = w6;

endmodule