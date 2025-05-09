(*DONT_TOUCH = "TRUE"*) module Exponent_Sub (
    input [7:0] operand_1_exponent, operand_2_exponent,
    output reg [7:0] result,
    output reg sign, exp_non_zero
);

    always @(*) begin
        if (operand_1_exponent > operand_2_exponent) begin
            result = operand_1_exponent - operand_2_exponent;
            sign = 0;
        end
        else begin
            result = operand_2_exponent - operand_1_exponent;
            sign = 1;
        end

        exp_non_zero = |(operand_1_exponent);
    end
    
endmodule