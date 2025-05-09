(*DONT_TOUCH = "TRUE"*) module FP_Add_Sub_Top (
    input add_or_sub,
    input [31:0] operand_1, operand_2,
    output [31:0] result
);

    //Internal Wire Declaration
    wire operand_1_sign, operand_2_sign, exponent_sub_sign, scps_swap, scps_comp, cpa_cin, cpa_overflow, cpa_cout, normalize_2_shamt, round_comp, final_sign,
        cpa_sign_bit, significand_equal, sig_non_zero, exp_non_zero, exp_stacked;

    wire [1:0] special_cases;

    wire [7:0] exponent_sub_result;
    
    wire [7:0] normalize_1_shamt;

    wire [7:0] operand_1_exponent, operand_2_exponent, final_exp;

    wire [24:0] operand_1_significand, operand_2_significand, operand_1_significand_scps_result, operand_2_significand_scps_result;

    wire [24:0] rounded_significand, shifted_significand, penultimate_significand;
    
    wire [27:0] operand_1_significand_shifted, operand_2_significand_shifted;
    
    wire [27:0] cpa_sum, shifted_sum;

    //Instantiation
    Unpack up(operand_1, operand_2, operand_1_sign, operand_2_sign, significand_equal, sig_non_zero, exp_stacked, operand_1_exponent, operand_2_exponent, 
            operand_1_significand, operand_2_significand);

    Exponent_Sub es(operand_1_exponent, operand_2_exponent, exponent_sub_result, exponent_sub_sign, exp_non_zero);

    SCPS scps(operand_1_significand, operand_2_significand, scps_swap, scps_comp, operand_1_significand_scps_result, operand_2_significand_scps_result);

    Align_Significands as(scps_comp, operand_1_significand_scps_result, operand_2_significand_scps_result, exponent_sub_result, operand_1_significand_shifted, 
                            operand_2_significand_shifted);
    
    CPA cpa(operand_1_significand_shifted, operand_2_significand_shifted, cpa_cin, cpa_cout, cpa_overflow, cpa_sign_bit, cpa_sum);

    Normalize_1 n1(cpa_sum, round_comp, cpa_overflow, normalize_1_shamt, shifted_sum);

    Round rnd(shifted_sum, round_comp, rounded_significand);

    Normalize_2 n2(cpa_overflow, rounded_significand, normalize_2_shamt, shifted_significand);

    Control_Unit ctrl(operand_1_sign, operand_2_sign, add_or_sub, exponent_sub_sign, cpa_sign_bit, normalize_2_shamt, cpa_overflow, significand_equal, sig_non_zero, 
                    exp_non_zero, exp_stacked, normalize_1_shamt, exponent_sub_result, operand_1_significand, operand_2_significand, operand_1_exponent, 
                    operand_2_exponent, scps_swap, cpa_cin, round_comp, scps_comp, final_sign, special_cases, final_exp, penultimate_significand);

    Pack p(shifted_significand, penultimate_significand, final_exp, special_cases, final_sign, result);

endmodule