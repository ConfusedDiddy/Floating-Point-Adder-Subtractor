(*DONT_TOUCH = "TRUE"*) module Prefix_Circuit (
    input [1:0] x0, x1,
    output [1:0] y
);

    assign y[0] = x0[0] & x1[0]; //Calculating P
    assign y[1] = (x0[1] & x1[0]) | x1[1]; //Calculating G

endmodule