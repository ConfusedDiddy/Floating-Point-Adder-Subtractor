(*DONT_TOUCH = "TRUE"*) module SCPS ( //Selective Complement and Possible Swap
    input [24:0] operand_1_significand, operand_2_significand,
    input swap, comp,
    output reg [24:0] operand_1_significand_result, operand_2_significand_result
);

    always @(*) begin
        if (swap) begin
            operand_1_significand_result = operand_2_significand;
            operand_2_significand_result = operand_1_significand;
        end
        else begin
            operand_1_significand_result = operand_1_significand;
            operand_2_significand_result = operand_2_significand;
        end

        if (comp) begin
            operand_1_significand_result = ~operand_1_significand_result;
        end
    end
    
endmodule