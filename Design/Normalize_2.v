(*DONT_TOUCH = "TRUE"*) module Normalize_2 (
    input overflow,
    input [24:0] rounded_significand,
    output normalize_2_shamt,
    output [24:0] shifted_significand
);

    assign normalize_2_shamt = rounded_significand[24];
   
    assign shifted_significand = (normalize_2_shamt)? ({1'b0, rounded_significand[24:1]}) : rounded_significand;        //Right shift if control is one 

endmodule