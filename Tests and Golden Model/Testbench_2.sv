module tb_fp_add_sub_random;
    // Parameters
    parameter NUM_TESTS = 1_000_000;
    parameter SEED = 50;  // Random seed for reproducibility
    
    // Signals
    logic [31:0] a, b;
    logic add_sub;
    logic [31:0] res_golden, res_uut;
    int error_count = 0;

    logic exp_stacked, sig_non_zero, exp_non_zero, significand_equal, scps_comp;
    logic [1:0] special_cases;

    assign exp_stacked = uut.ctrl.exp_stacked;
    assign sig_non_zero = uut.ctrl.sig_non_zero;
    assign exp_non_zero = uut.ctrl.exp_non_zero;
    assign significand_equal = uut.ctrl.significand_equal;
    assign special_cases = uut.special_cases;
    assign scps_comp = uut.ctrl.scps_comp;

    
    // Clock generation
    bit clk = 0;
    always #5 clk = ~clk;
    
    // Instantiate your design (UUT)
    FP_Add_Sub_Top uut (
        .operand_1(a),
        .operand_2(b),
        .add_or_sub(add_sub),
        .result(res_uut)
    );
    
    // Golden reference function
    function automatic logic [31:0] fp_add_sub_golden(
        input logic [31:0] a_bits,
        input logic [31:0] b_bits,
        input logic add_sub
    );
        shortreal a_real, b_real, result_real;
        a_real = $bitstoshortreal(a_bits);
        b_real = $bitstoshortreal(b_bits);
        
        if (add_sub) result_real = a_real - b_real;  // Subtraction
        else         result_real = a_real + b_real;  // Addition
        
        return $shortrealtobits(result_real);
    endfunction
    
    // Test procedure
    initial begin
        $display("Starting random test with %0d iterations...", NUM_TESTS);
        $timeformat(-9, 0, "ns", 10);
        
        // Initialize random seed
        $urandom(SEED);
        
        for (int i = 0; i < NUM_TESTS; i++) begin
            // Generate random inputs
            a = $urandom();
            b = $urandom();
            add_sub = $urandom_range(0, 1);
            
            // Calculate golden reference
            res_golden = fp_add_sub_golden(a, b, add_sub);
            
            // Apply to UUT
            @(posedge clk);
            
            // Check results
            @(negedge clk);
            if ((res_golden != res_uut) & (((a[30:23] != 0) & (b[30:23] != 0)) & (res_golden[30:23] != 0) & sig_non_zero)) begin
                error_count++;
                $display("[%0t] Error #%0d at iteration %0d:", $time, error_count, i);
                $display("  a       = 32'h%h (%f)", a, $bitstoshortreal(a));
                $display("  b       = 32'h%h (%f)", b, $bitstoshortreal(b));
                $display("  op      = %s", add_sub ? "SUB" : "ADD");
                $display("  UUT     = 32'h%h (%f)", res_uut, $bitstoshortreal(res_uut));
                $display("  Golden  = 32'h%h (%f)", res_golden, $bitstoshortreal(res_golden));    
            end
            
            // Progress reporting
            if (i % 100_00 == 0) begin
                $display("Completed %0d/%0d tests (%0d errors)", i, NUM_TESTS, error_count);
            end
        end
        
        // Test summary
        $display("\nTest completed:");
        $display("  Total tests : %0d", NUM_TESTS);
        $display("  Errors      : %0d", error_count);
        $display("  Error rate  : %0.4f%%", (error_count*100.0)/NUM_TESTS);
        
        $stop;
    end
    
endmodule