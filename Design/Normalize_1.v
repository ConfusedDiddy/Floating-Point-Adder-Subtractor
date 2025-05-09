(*DONT_TOUCH = "TRUE"*) module Normalize_1 (
    input [27:0] sum,
    input mode, overflow,
    output [7:0] shamt,
    output [27:0] shifted_sum
);

    wire [27:0] shifter_out;
    wire [7:0] shifter_shamt;

    Zero_One_Counter ZOC(sum, mode, overflow, shifter_shamt);

    Shifter shift(sum, shifter_shamt, shifter_out);

    assign shifted_sum = ((shifter_out[27] ^ mode) | overflow)? {1'b0, shifter_out[27:2], (shifter_out[1] | shifter_out[0])} : shifter_out;

    assign shamt = shifter_shamt - ((shifter_out[27] ^ mode) | overflow);
    
endmodule