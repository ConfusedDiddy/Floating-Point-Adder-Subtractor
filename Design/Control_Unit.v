(*DONT_TOUCH = "TRUE"*) module Control_Unit (
    input operand_1_sign, operand_2_sign, add_or_sub, exponent_sub_sign, cpa_sign_bit, normalize_2_shamt, cpa_overflow, significand_equal, sig_non_zero, exp_non_zero, exp_stacked,
    input [7:0] normalize_1_shamt,
    input [7:0] exponent_sub_result,
    input [24:0] operand_1_significand, operand_2_significand,
    input [7:0] operand_1_exponent, operand_2_exponent,
    output scps_swap, cpa_cin, round_comp, scps_comp,
    output reg final_sign,
    output reg [1:0] special_cases,
    output reg [7:0] final_exp,
    output reg [24:0] penultimate_significand
);

    localparam ZERO = 2'b01;
    localparam INF = 2'b10;
    localparam NAN = 2'b11;

    wire significand_comp, exp_comp, exp_equal, absolutely_greater;

    assign significand_comp = operand_1_significand > operand_2_significand;

    assign exp_comp = ~exponent_sub_sign;
    assign exp_equal = ~(|(exponent_sub_result));

    assign scps_comp = operand_1_sign ^ operand_2_sign ^ add_or_sub;
    assign cpa_cin = scps_comp;

    assign absolutely_greater = exp_comp | (exp_equal & significand_comp);

    assign scps_swap = exponent_sub_sign;

    assign round_comp = (cpa_sign_bit ^ cpa_overflow);


    always @(*) begin
        final_sign = (~absolutely_greater & !operand_2_sign & add_or_sub) | (~absolutely_greater & operand_2_sign & !add_or_sub) | (absolutely_greater & operand_1_sign);     //Used K-Maps
        
        final_exp = ((exponent_sub_sign)? (operand_2_exponent) : (operand_1_exponent)) - normalize_1_shamt + normalize_2_shamt; //Final Exponent Logic

        if (exp_stacked && ((sig_non_zero) || (significand_equal & scps_comp))) begin   //Result is NaN
            special_cases = NAN;
        end 
        else if (significand_equal & exp_equal & !exp_stacked & ( (!sig_non_zero & !exp_non_zero) | (sig_non_zero & exp_non_zero & scps_comp) )) begin  //Result is Zero
            special_cases = ZERO;
        end
        else if ((exp_stacked & !sig_non_zero & !scps_comp) | (!exp_stacked & !scps_comp & (final_exp == 8'b11111111))) begin   //Result is Infinity
            special_cases = INF;
        end
        else begin
            special_cases = 0;
        end

        if (significand_equal & exp_equal & !exp_non_zero & !sig_non_zero & scps_comp) begin    //Inputs is Zero
            final_sign = 1;
        end
        else if ((special_cases == ZERO) & scps_comp & add_or_sub & operand_1_sign) begin       //Output is Zero
            final_sign = 1;
        end

        if ((operand_1_exponent == 8'b11111111) & (|operand_1_significand)) begin   //Operand 1 is NaN
            final_exp = operand_1_exponent;
            penultimate_significand = operand_1_significand;
            final_sign = operand_1_sign;
        end
        else if ((operand_2_exponent == 8'b11111111) & (|operand_2_significand)) begin  //Operand 2 is NaN
            final_exp = operand_2_exponent;
            penultimate_significand = operand_2_significand;
            final_sign = operand_2_sign;
        end
        else begin  //if Result is NaN
            penultimate_significand = {3'b1, 22'b0};
        end

    end
    
endmodule