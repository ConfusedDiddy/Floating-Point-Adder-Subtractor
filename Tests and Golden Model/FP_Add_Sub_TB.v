`timescale 1ns/1ps
module FP_Add_Sub_TB (
);

    //Ports:
    reg add_or_sub;
    reg [31:0] operand_1, operand_2;
    wire [31:0] result;

    //Internal Wires:
    wire round_up, sign, final_sign, cpa_overflow, cpa_sign_bit, guard, round, sticky, round_comp, significand_equal, exp_equal, exp_stacked, sig_non_zero, exp_non_zero, scps_comp, 
        absolutely_greater, operand_1_sign, operand_2_sign;
    wire [7:0] normalize_1_shamt, shifter_shamt;
    wire [7:0] final_exp;
    wire [24:0] rounded_significand, shifted_significand;
    wire [27:0] operand_1_significand_shifted, operand_2_significand_shifted; 
    wire [27:0] cpa_sum, shifted_sum;
    wire [27:0] shifted_sum_comp;

    //Instantiation:
    FP_Add_Sub_Top dut(add_or_sub, operand_1, operand_2, result);

    initial begin
        add_or_sub = 0;
        operand_1 = 32'b01000000101000000000000000000000; // 5.0
        operand_2 = 32'b01000000010000000000000000000000; // 3.0
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01000001001000000000000000000000; // 10.0
        operand_2 = 32'b01000000001000000000000000000000; // 2.5
        #10;
        add_or_sub = 0;
        operand_1 = 32'b00111111110000000000000000000000; // 1.5
        operand_2 = 32'b00111111110000000000000000000000; // 1.5
        #10;
        add_or_sub = 0;
        operand_1 = 32'b01000000001100000000000000000000; // 2.75
        operand_2 = 32'b00111111000000000000000000000000; // 0.5
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01000000010000000000000000000000; // 3.0
        operand_2 = 32'b01000000101000000000000000000000; // 5.0
        #10;
        add_or_sub = 0;
        operand_1 = 32'b01111111011111111111111111111111; // big number
        operand_2 = 32'b01111111011111111111111111111111; // big number
        #10;
        add_or_sub = 0;
        operand_1 = 32'b01001110100000000000000000000000; // 1.07e9
        operand_2 = 32'b00110010100000000000000000000000; // 1.49e-8
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01001110100000000000000000000000; // 1.07e9
        operand_2 = 32'b00110010100000000000000000000000; // 1.49e-8
        #10;
        add_or_sub = 0;
        operand_1 = 32'b01000000011111111111111111111111; // 3.999999
        operand_2 = 32'b01000000000000000000000000000001; // 2.0
        #10;
        add_or_sub = 0;
        operand_1 = 32'b01000000100111111111111111111111; // 4.999999
        operand_2 = 32'b00111111100111111111111111111111; // 1.25
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01001001000000000000000000000001; // 52488
        operand_2 = 32'b01001001000000000000000000000000; // 52488
        #10;
        add_or_sub = 1;
        operand_1 = 32'b00111111111111111111111111111111; // 2.0
        operand_2 = 32'b01000000000000000000000000000000; // 2.0
        #10;
        add_or_sub = 0;
        operand_1 = 32'b00111111100000000000000000000001; // 1.0
        operand_2 = 32'b00111010100000000000000000000001; // 0.000976563
        #10;
        add_or_sub = 0;
        operand_1 = 32'b01111111011111111111111111111111; // big number
        operand_2 = 32'b00000000000000000000000000000001; // 1.4e-45
        #10;
        add_or_sub = 0;
        operand_1 = 32'b00111111100000000000000000000001; // 1.0
        operand_2 = 32'b00111111100000000000000000000001; // 1.0
        #10;
        add_or_sub = 0;
        operand_1 = 32'b00111111100000000000000000000000; // 1.0
        operand_2 = 32'b00110000000000000000000000000001; // 4.66e-10
        #10;
        add_or_sub = 0;
        operand_1 = 32'b00111111111111111111111111111111; // 2.0
        operand_2 = 32'b10111111111111111111111111111110; // -2.0
        #10;
        add_or_sub = 0;
        operand_1 = 32'b01000000010000000000000000000000; // 3.0
        operand_2 = 32'b01000000010000000000000000000000; // 3.0
        #10;
        add_or_sub = 0;
        operand_1 = 32'b01111111011111111111111111111111; // Largest finite float
        operand_2 = 32'b01000000000000000000000000000000; // 2.0
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01000001000100000000000000000000; // 9.0
        operand_2 = 32'b01000001000011111111111111111111; // Slightly less than 9.0
        #10;
        add_or_sub = 0;
        operand_1 = 32'b01111111000000000000000000000000; // Large float
        operand_2 = 32'b00111111100000000000000000000000; // 1.0
        #10;
        add_or_sub = 0;
        operand_1 = 32'b01111111100000000000000000000000; // Positive infinity
        operand_2 = 32'b01111111100000000000000000000000; // Positive infinity
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01111111100000000000000000000000; // Positive infinity
        operand_2 = 32'b01111111100000000000000000000000; // Positive infinity
        #10;
        add_or_sub = 1;
        operand_1 = 32'b00000000000000000000000000000000; // Zero
        operand_2 = 32'b00000000000000000000000000000000; // Zero
        #10;
        add_or_sub = 1;
        operand_1 = 32'b11111111011111111111111111111111; // Largest negative float
        operand_2 = 32'b11000000000000000000000000000000; // -2.0
        #10;
        add_or_sub = 0;
        operand_1 = 32'b01000001001000000000000000000000; // 10.0
        operand_2 = 32'b11000001001000000000000000000000; // -10.0
        #10;
        add_or_sub = 1;
        operand_1 = 32'b00111111111111111111111111111111; // 1.11111111111111111111111
        operand_2 = 32'b00111111100000000000000000000001; // 1.00000000000000000000001
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01000100010000000000000000000000; // 1.1 × 2^10
        operand_2 = 32'b01000011101111111111111111111111; // 1.01111111111111111111111 × 2^9
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01000100001010101010101010101010; // 1.01010101010101010101010 × 2^10
        operand_2 = 32'b01000100010101010101010101010101; // 1.10101010101010101010101 × 2^10
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01000011011111111111111111111111; // 1.11111111111111111111111 × 2^7            to test overflow
        operand_2 = 32'b01000011000000000000000000000001; // 1.00000000000000000000001 × 2^7
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01000000110011001100110011001101; // 1.10011001100110011001101 × 2^2            to test guard
        operand_2 = 32'b01000000001101101101101101101101; // 1.01101101101101101101101 × 2^1
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01111110100100100100100100100100; // 1.00100100100100100100100 × 2^126          extreme exponent
        operand_2 = 32'b01111110000000000000000000000000; // 1.00000000000000000000000 × 2^125
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01100110101010101010101010101010; // 1.01010101010101010101010 × 2^50           chaotic
        operand_2 = 32'b01100110110101010101010101010101; // 1.10101010101010101010101 × 2^50
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01000011100000000000000000000001; // 1.00000000000000000000001 × 2^8            to test sticky
        operand_2 = 32'b01000101000000000000000000000000; // 1.00000000000000000000000 × 2^11
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01110010111111111111111111111111; // 1.11111111111111111111111 × 2^102          massive exponent shift
        operand_2 = 32'b01110010000000000000000000000000; // 1.00000000000000000000000 × 2^101
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01000010010011001100110011001100; // 1.10011001100110011001100 × 2^5            bit ripple across entire mantissa
        operand_2 = 32'b01000010001100110011001100110011; // 1.01100110011001100110011 × 2^5
        #10;
        add_or_sub = 1;
        operand_1 = 32'b00111111100000000000000000000000; // 1.00000000000000000000000 × 2^0            bit ripple across entire mantissa
        operand_2 = 32'b00111110111111111111111111111111; // 1.11111111111111111111111 × 2^-2
        #10;
        add_or_sub = 1;
        operand_1 = 32'b11111111001010101010101010101010; // -1.01010101010101010101010 × 2^127         negative overflow
        operand_2 = 32'b01111110110101010101010101010101; // 1.10101010101010101010101 × 2^126
        #10;
        add_or_sub = 1;
        operand_1 = 32'b00111111111111111111111111111110; // 1.11111111111111111111110 × 2^0            to test rounding
        operand_2 = 32'b00111110100000000000000000000001; // 1.00000000000000000000001 × 2^-2
        #10;
        add_or_sub = 1;
        operand_1 = 32'h156cea40;
        operand_2 = 32'h14d3be65;
        #10;
        add_or_sub = 0;
        operand_1 = 32'b00111010010000101010101011010001;
        operand_2 = 32'b11011010001110111000000001100100;
        #10;
        add_or_sub = 0;
        operand_1 = 32'b01110000101001100000001010100100;
        operand_2 = 32'b11101111100010000000110000010010;
        #10;
        add_or_sub = 1;
        operand_1 = 32'b01010000111100111010011001001001;
        operand_2 = 32'b11010000101110110110101111111010;
        #10;
        $stop;
    end

    //Hierarchical Calling:
    assign operand_1_significand_shifted = dut.operand_1_significand_shifted;
    assign operand_2_significand_shifted = dut.operand_2_significand_shifted;
    assign cpa_sum = dut.cpa_sum;
    assign shifted_sum = dut.shifted_sum;
    assign rounded_significand = dut.rounded_significand;
    assign round_up = dut.rnd.round_up;
    assign shifted_significand = dut.shifted_significand;
    assign sign = dut.rnd.sign;
    assign final_sign = dut.final_sign;
    assign final_exp = dut.final_exp;
    assign shifted_sum_comp = dut.rnd.shifted_sum_comp;
    assign cpa_overflow = dut.cpa_overflow;
    assign cpa_sign_bit = dut.cpa_sign_bit;
    assign normalize_1_shamt = dut.normalize_1_shamt;
    assign guard = dut.as.guard;
    assign round = dut.as.round;
    assign sticky = dut.as.sticky;
    assign round_comp = dut.round_comp;
    assign scps_comp = dut.scps_comp;
    assign significand_equal = dut.significand_equal;
    assign exp_equal = dut.ctrl.exp_equal;
    assign exp_stacked = dut.exp_stacked;
    assign sig_non_zero = dut.sig_non_zero;
    assign exp_non_zero = dut.exp_non_zero;
    assign operand_1_sign = dut.ctrl.operand_1_sign;
    assign operand_2_sign = dut.ctrl.operand_2_sign;
    assign absolutely_greater = dut.ctrl.absolutely_greater;
    assign shifter_shamt = dut.n1.shifter_shamt;

endmodule