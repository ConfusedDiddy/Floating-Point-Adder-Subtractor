(*DONT_TOUCH = "TRUE"*) module LZD_32 (
    input [31:0] in,
    output [4:0] out
);

    wire a0, a1;
    wire [3:0] y0, y1;
    
    //Instantiation
    LZD_16 inst0_16(in[31:16], a0, y0);
    LZD_16 inst1_16(in[15:0], a1, y1);

    assign out[4] = a0;

    assign out[3:0] = (a0)? y1 : y0;

endmodule