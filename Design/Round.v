(*DONT_TOUCH = "TRUE"*) module Round (
    input [27:0] shifted_sum,
    input sign,
    output [24:0] rounded_significand
);

    wire guard, round, sticky;
    wire round_up;
    reg [27:0] shifted_sum_comp;
    integer i;


    always @(*) begin
        shifted_sum_comp = ((sign)? ~shifted_sum : shifted_sum ) + sign;
    end

    assign guard = shifted_sum_comp[2];
    assign round = shifted_sum_comp[1];
    assign sticky = shifted_sum_comp[0];

    assign round_up = (guard & ((round | sticky) | (shifted_sum_comp[3])));

    assign rounded_significand = shifted_sum_comp[27:3] + round_up;
    
endmodule