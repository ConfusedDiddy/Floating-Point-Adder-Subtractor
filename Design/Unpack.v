(*DONT_TOUCH = "TRUE"*) module Unpack (
    input [31:0] operand_1, operand_2,
    output operand_1_sign, operand_2_sign, significand_equal, sig_non_zero, exp_stacked,
    output [7:0] operand_1_exponent, operand_2_exponent,
    output [24:0] operand_1_significand, operand_2_significand
);

    assign operand_1_sign = operand_1[31];
    assign operand_2_sign = operand_2[31];

    assign operand_1_exponent = operand_1[30:23];
    assign operand_2_exponent = operand_2[30:23];

    assign operand_1_significand = {1'b0, 1'b1, operand_1[22:0]};
    assign operand_2_significand = {1'b0, 1'b1, operand_2[22:0]};

    assign significand_equal = (operand_1[22:0] == operand_2[22:0]);

    assign sig_non_zero = (|(operand_1[22:0])) | (|(operand_2[22:0]));

    assign exp_stacked = (&(operand_1_exponent)) | (&(operand_2_exponent));

endmodule