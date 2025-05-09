(*DONT_TOUCH = "TRUE"*)module Adder_Top_Module #(
    parameter N = 32
) (
    input [N-1:0] a, b,
    output [N-1:0] s
);

    wire [N-1:0] g_in, p_in, g_out, p_out;
    genvar j;

    assign g_in = a & b;
    assign p_in = a ^ b;

    //Instantiaing Ladner-Fischer Prefix Adder
    Ladner_Fischer_Prefix_Adder #(N) LF(g_in, p_in, g_out, p_out);

    generate //Computing Sum
        for (j = 0; j < N - 1; j = j + 1) begin :Sum_Block
            assign s[j + 1] = p_in[j + 1] ^ g_out[j];
        end
        assign s[0] = p_out[0];
    endgenerate
    
endmodule