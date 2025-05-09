(*DONT_TOUCH = "TRUE"*) module CPA (
    input [27:0] operand_1_significand, operand_2_significand,
    input cin,
    output cout, overflow, sign_bit,
    output [27:0] sum
);

    wire [31:0] ladner_out;

    Adder_Top_Module #(32) Ladner({3'b0, operand_1_significand, cin}, {3'b0, operand_2_significand, cin}, ladner_out);

    assign cout = ladner_out[29];

    assign sum = ladner_out[28:1];
    
    assign sign_bit = sum[27];

    assign overflow = (operand_1_significand[27] & operand_2_significand[27] & ~sum[27]) || (~operand_1_significand[27] & ~operand_2_significand[27] & sum[27]);
    
endmodule