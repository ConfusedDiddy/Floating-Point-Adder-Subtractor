(*DONT_TOUCH = "TRUE"*) module Pack (
    input [24:0] final_significand, penultimate_significand,
    input [7:0] final_exp,
    input [1:0] special_cases,
    input final_sign,
    output reg [31:0] result
);

    localparam ZERO = 2'b01;
    localparam INF = 2'b10;
    localparam NAN = 2'b11;

    always @(*) begin
            case (special_cases)
                2'b00: result = {final_sign, final_exp, final_significand[22:0]};     
                ZERO : result = {final_sign, 31'b0};
                INF  : result = {final_sign, 8'b11111111, 23'b0};
                NAN  : result = {final_sign, final_exp, 1'b1, penultimate_significand[21:0]};
                default: result = 0;
            endcase
    end
    
endmodule