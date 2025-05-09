(*DONT_TOUCH = "TRUE"*) module Zero_One_Counter (
    input [27:0] sum,
    input mode, overflow,
    output [7:0] shamt
);

    wire [27:0] encoder_in;
    wire [4:0] encoder_out;

    LZD_32 encoder({encoder_in[26:0], 5'b0}, encoder_out);

    assign shamt = (overflow)? 8'b0 : {3'b0, encoder_out};

    assign encoder_in = (mode)? ~sum : sum;
    
endmodule