(*DONT_TOUCH = "TRUE"*) module LZD_16 (
    input [15:0] in,
    output all_zero,
    output [3:0] out
);

    wire a0, a1, a2, a3, dummy;
    wire [1:0] y0, y1, y2, y3, y4;
    
    //Instantiation
    LZD_4 inst0_4(in[15:12], a0, y0);
    LZD_4 inst1_4(in[11:8], a1, y1);
    LZD_4 inst2_4(in[7:4], a2, y2);
    LZD_4 inst3_4(in[3:0], a3, y3);

    LZD_4 instf_4({!a0, !a1, !a2, !a3}, dummy, y4);

    assign out[3:2] = y4;

    assign out[1:0] = (y4[1])? ((y4[0])? y3 : y2) : ((y4[0])? y1 : y0);

    assign all_zero = ~|(in);

endmodule