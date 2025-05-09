(*DONT_TOUCH = "TRUE"*)module Ladner_Fischer_Prefix_Adder #(parameter N = 64) (
    input [N-1:0] g_in, p_in,
    output [N-1:0] g_out, p_out
);

    genvar i, j, l, c, z, r;

    //Interconnects:
    wire [1:0] w [$clog2(N):0][N-1:0];
    wire [1:0] s [N-1:0];

    generate
        for (i = 0; i < $clog2(N); i = i + 1) begin :Level_1
            for (j = 0; j < N; j = j + (2**(i + 1))) begin :Level_2
                Prefix_Circuit PC_0(w[i][(2**(i) - 1) + j], w[0][(2**i) + j], w[i + 1][(2**i) + j]);
                for (c = 1; c < (i + 1); c = c + 1) begin :Level_3
                    for (l = 0; l < (2**(c - 1)); l = l + 1) begin :Level_4
                        Prefix_Circuit PC(w[i][(2**(i) - 1) + j], w[c][(2**i) + 2**(c - 1) + l + j], w[i + 1][(2**i) + 2**(c - 1) + l + j]);
                    end
                end
            end
        end
    endgenerate

    generate
        for (z = 0; z < N; z = z + 1) begin :generate_x
            assign w[0][z] = {g_in[z], p_in[z]};
        end
            assign s[0] = w[0][0];
            for (z = 1; z < ($clog2(N) + 1); z = z + 1) begin :generate_level
                for (r = (2**(z - 1)); r < 2**z; r = r + 1) begin :generate_bit
                    assign s[r] = w[z][r];
                end
            end
            for (z = 0; z < N; z = z + 1) begin :generate_out
                assign {g_out[z], p_out[z]} = s[z];
            end
    endgenerate

endmodule