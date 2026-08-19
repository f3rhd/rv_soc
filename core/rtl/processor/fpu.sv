/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */
`include "decode_output.svh"
module fpu (
    input logic clk,
    input logic i_reset,
    input logic i_begin,
    input opcode_e i_op,
    input logic [2:0] i_rnd_mode,
    input logic [31:0] i_src1_data,
    input logic [31:0] i_src2_data,
    input logic [31:0] i_src3_data,
    input logic [31:0] i_fcsr,
    output logic [31:0] o_fpu_result,
    output logic o_done,
    output logic o_inv_op
);
    logic [31:0] src1_data, src2_data, src3_data;
    logic [31:0] fcsr;
    logic [2:0] rnd_mode;
    opcode_e op;

    logic adder_begin;
    logic [31:0] adder_result;
    logic adder_done;
    logic adder_inv_op;

    logic mul_begin;
    logic [31:0] mul_result;
    logic mul_done;
    logic mul_inv_op;

    logic div_begin;
    logic [31:0] div_result;
    logic div_done;
    logic div_inv_op;

    logic sqrt_begin;
    logic sqrt_done;
    logic [31:0] sqrt_result;
    logic sqrt_inv_op;

    logic int_to_float_begin;
    logic int_to_float_done;
    logic int_to_float_signed;
    logic [31:0] int_to_float_result;

    logic float_to_int_begin;
    logic float_to_int_done;
    logic float_to_int_signed;
    logic [31:0] float_to_int_result;

    logic negate;
    logic add;

    wire sign1 = src1_data[31];
    wire [7:0] exponent1 = src1_data[30:23];
    wire [22:0] mantissa1 = src1_data[22:0];

    wire exp_is_zero1 = (exponent1 == 8'h00);
    wire exp_is_max1 = (exponent1 == 8'hFF);
    wire man_is_zero1 = (mantissa1 == 23'h0);

    wire is_zero1 = exp_is_zero1 && man_is_zero1;
    wire is_subnormal1 = exp_is_zero1 && !man_is_zero1;
    wire is_inf1 = exp_is_max1 && man_is_zero1;
    wire is_nan1 = exp_is_max1 && !man_is_zero1;

    wire is_snan1 = is_nan1 && (mantissa1[22] == 1'b0);
    wire is_qnan1 = is_nan1 && (mantissa1[22] == 1'b1);

    wire is_normal1 = !exp_is_zero1 && !exp_is_max1;

    wire sign2 = src2_data[31];

    wire [7:0] exponent2 = src2_data[30:23];
    wire [22:0] mantissa2 = src2_data[22:0];

    wire exp_is_zero2 = (exponent2 == 8'h00);
    wire exp_is_max2 = (exponent2 == 8'hFF);
    wire man_is_zero2 = (mantissa2 == 23'h0);

    wire is_zero2 = exp_is_zero2 && man_is_zero2;
    wire is_nan2 = exp_is_max2 && !man_is_zero2;

    wire [9:0] fclass_mask = {
        is_qnan1,  // Bit 9: Quiet NaN
        is_snan1,  // Bit 8: Signaling NaN
        (!sign1 && is_inf1),  // Bit 7: +Infinity
        (!sign1 && is_normal1),  // Bit 6: +Normal
        (!sign1 && is_subnormal1),  // Bit 5: +Subnormal
        (!sign1 && is_zero1),  // Bit 4: +Zero
        (sign1 && is_zero1),  // Bit 3: -Zero
        (sign1 && is_subnormal1),  // Bit 2: -Subnormal
        (sign1 && is_normal1),  // Bit 1: -Normal
        (sign1 && is_inf1)  // Bit 0: -Infinity
    };
    enum logic [1:0] {
        S_IDLE,
        S_PREPARE,
        S_R4_MUL,
        S_EXECUTE
    } state;

    wire either_nan = is_nan1 || is_nan2;
    wire both_zero = is_zero1 && is_zero2;

    wire [30:0] mag1 = src1_data[30:0];
    wire [30:0] mag2 = src2_data[30:0];

    wire flt_core;
    wire feq_core;

    assign feq_core = !either_nan && (both_zero || (src1_data == src2_data));

    // FLT: Less Than Logic
    assign flt_core = !either_nan && !both_zero && (
        (sign1 && !sign2) ? 1'b1 :                               // negative < positive
        (!sign1 && sign2) ? 1'b0 :  // positive > negative
        (!sign1 && !sign2) ? (mag1 < mag2) :                    // both positive: compare magnitudes
        (mag1 > mag2)  // both negative: larger magnitude means smaller value
        );

    wire fle_core = flt_core || feq_core;
    fadder fadder (
        .clk         (clk),
        .i_reset     (i_reset),
        .i_f1        (src1_data),
        .i_f2        (src2_data),
        .i_fcsr      (fcsr),
        .i_round_mode(rnd_mode),
        .i_begin     (adder_begin),
        .o_result    (adder_result),
        .o_done      (adder_done),
        .o_inv_op    (adder_inv_op)
    );
    fmultiplier fmultiplier (
        .clk         (clk),
        .i_reset     (i_reset),
        .i_f1        (src1_data),
        .i_f2        (src2_data),
        .i_fcsr      (fcsr),
        .i_round_mode(rnd_mode),
        .i_begin     (mul_begin),
        .o_result    (mul_result),
        .o_done      (mul_done),
        .o_inv_op    (mul_inv_op)
    );
    fdivider fdivider (
        .clk         (clk),
        .i_reset     (i_reset),
        .i_f1        (src1_data),
        .i_f2        (src2_data),
        .i_fcsr      (fcsr),
        .i_round_mode(rnd_mode),
        .i_begin     (div_begin),
        .o_result    (div_result),
        .o_done      (div_done),
        .o_inv_op    (div_inv_op)
    );
    fsqrt fsqrt (
        .clk         (clk),
        .i_reset     (i_reset),
        .i_f         (src1_data),
        .i_fcsr      (fcsr),
        .i_round_mode(rnd_mode),
        .i_begin     (sqrt_begin),
        .o_result    (sqrt_result),
        .o_done      (sqrt_done),
        .o_inv_op    (sqrt_inv_op)
    );
    int_to_float int_to_float (
        .clk       (clk),
        .i_reset   (i_reset),
        .i_begin   (int_to_float_begin),
        .i_signed  (int_to_float_signed),
        .i_rnd_mode(rnd_mode),
        .i_fcsr    (fcsr),
        .i_fs      (src1_data),
        .o_result  (int_to_float_result),
        .o_done    (int_to_float_done)
    );
    float_to_int float_to_int (
        .clk       (clk),
        .i_reset   (i_reset),
        .i_begin   (float_to_int_begin),
        .i_signed  (float_to_int_signed),
        .i_rnd_mode(rnd_mode),
        .i_fs      (src1_data),
        .i_fcsr    (fcsr),
        .o_result  (float_to_int_result),
        .o_done    (float_to_int_done)
    );
    always_ff @(posedge clk) begin
        o_done             <= 0;
        o_inv_op           <= 0;
        div_begin          <= 0;
        mul_begin          <= 0;
        adder_begin        <= 0;
        sqrt_begin         <= 0;
        int_to_float_begin <= 0;
        float_to_int_begin <= 0;
        if (i_reset) begin
            state        <= S_IDLE;
            o_fpu_result <= 0;
            fcsr         <= 0;
            negate       <= 0;
            add          <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    state        <= S_IDLE;
                    o_fpu_result <= 0;
                    fcsr         <= 0;
                    negate       <= 0;
                    add          <= 0;
                    if (o_done) begin
                    end else if (i_begin) begin
                        src1_data <= i_src1_data;
                        src2_data <= i_src2_data;
                        src3_data <= i_src3_data;
                        rnd_mode  <= i_rnd_mode;
                        op        <= i_op;
                        fcsr      <= i_fcsr;
                        state     <= S_PREPARE;
                    end
                end
                S_PREPARE: begin
                    case (op[4:3])
                        // R4 instructions
                        2'b00: begin
                            state     <= S_R4_MUL;
                            mul_begin <= 1'b1;
                            if (op[2]) begin
                                add <= 1;
                                // FP_FNMADD
                                if (!op[1]) begin
                                    negate <= 1;
                                end else negate <= 0;  // else  FP_FNMADD
                            end else if (op[1]) begin  // FP_FNMSUB
                                add    <= 0;
                                negate <= 1;
                            end else if (op[0]) begin  // FP_FMSUB
                                add    <= 0;
                                negate <= 0;
                            end
                        end
                        2'b01: begin
                            state <= S_EXECUTE;
                            case (op[2:0])
                                // FADD
                                3'b000: begin
                                    adder_begin <= 1'b1;
                                end
                                // FSUB
                                3'b001: begin
                                    adder_begin <= 1'b1;
                                    src2_data <= {
                                        ~src2_data[31], src2_data[30:0]
                                    };
                                end
                                // FMUL
                                3'b010: begin
                                    mul_begin <= 1'b1;
                                end
                                // FDIV
                                3'b011: begin
                                    div_begin <= 1'b1;
                                end
                                // FSGNJ
                                3'b100: begin
                                    o_done <= 1'b1;
                                    o_fpu_result <= {
                                        src2_data[31], src1_data[30:0]
                                    };
                                    state <= S_IDLE;
                                end
                                // FSGNJN
                                3'b101: begin
                                    o_done <= 1'b1;
                                    o_fpu_result <= {
                                        ~src2_data[31], src1_data[30:0]
                                    };
                                    state <= S_IDLE;
                                end
                                // FSGNJX
                                3'b110: begin
                                    o_done <= 1'b1;
                                    o_fpu_result <= {
                                        src1_data[31] ^ src2_data[31],
                                        src1_data[30:0]
                                    };
                                    state <= S_IDLE;
                                end
                            endcase
                        end
                        2'b10: begin
                            state  <= S_IDLE;
                            o_done <= 1;
                            if (op[2]) begin
                                // FP_FLE
                                if (op[0]) begin
                                    o_fpu_result <= {31'b0, fle_core};
                                end else begin  // FP_FLT
                                    o_fpu_result <= {31'b0, flt_core};
                                end
                            end else begin
                                // FP_FEQ
                                if (op[1]) begin
                                    o_fpu_result <= {31'b0, feq_core};
                                end else
                                // FP_FMAX
                                if (op[0]) begin
                                    if (is_nan1 && is_nan2)
                                        o_fpu_result <= 32'h7FC00000; // Canonical Quiet NaN
                                    else if (is_nan1) o_fpu_result <= src2_data;
                                    else if (is_nan2) o_fpu_result <= src1_data;
                                    else if (both_zero)
                                        o_fpu_result <= (sign1 && sign2) ? src1_data : 32'h00000000; // +0.0 preferred over -0.0
                                    else
                                        o_fpu_result <= flt_core ? src2_data : src1_data;
                                end else begin  // FP_FMIN
                                    if (is_nan1 && is_nan2)
                                        o_fpu_result <= 32'h7FC00000; // Canonical Quiet NaN
                                    else if (is_nan1) o_fpu_result <= src2_data;
                                    else if (is_nan2) o_fpu_result <= src1_data;
                                    else if (both_zero)
                                        o_fpu_result <= (sign1 || sign2) ? 32'h80000000 : 32'h00000000; // -0.0 preferred over +0.0
                                    else
                                        o_fpu_result <= flt_core ? src1_data : src2_data;
                                end
                            end
                        end
                        2'b11: begin
                            case (op[2:0])
                                // FSQRT
                                3'b000: begin
                                    sqrt_begin <= 1;
                                    state      <= S_EXECUTE;
                                end
                                // FCLASS
                                3'b001: begin
                                    o_fpu_result <= {22'b0, fclass_mask};
                                    o_done       <= 1'b1;
                                    state        <= S_IDLE;
                                end
                                // FCVT_W_S
                                3'b010: begin
                                    float_to_int_begin  <= 1;
                                    float_to_int_signed <= 1;
                                    state               <= S_EXECUTE;
                                end
                                // FCVT_WU_S
                                3'b011: begin
                                    float_to_int_begin  <= 1;
                                    float_to_int_signed <= 0;
                                    state               <= S_EXECUTE;
                                end
                                // FCVT_S_W
                                3'b100: begin
                                    int_to_float_begin  <= 1;
                                    int_to_float_signed <= 1;
                                    state               <= S_EXECUTE;
                                end
                                // FCVT_S_WU
                                3'b101: begin
                                    int_to_float_begin  <= 1;
                                    int_to_float_signed <= 0;
                                    state               <= S_EXECUTE;
                                end
                                // FMV_X_W
                                3'b110: begin
                                    o_done       <= 1;
                                    state        <= S_IDLE;
                                    o_fpu_result <= src1_data;
                                end
                                // FMV_W_X
                                3'b111: begin
                                    o_fpu_result <= src1_data;
                                    o_done       <= 1;
                                    state        <= S_IDLE;
                                end
                            endcase
                        end
                    endcase
                end
                S_R4_MUL: begin
                    if (mul_done) begin
                        src1_data <= mul_result;
                        src2_data   <= add ? src3_data : {~src3_data[31],src3_data[30:0]};
                        adder_begin <= 1;
                        state <= S_EXECUTE;
                    end
                end
                S_EXECUTE: begin
                    if (adder_done) begin
                        o_done <= 1;
                        o_fpu_result <= negate ? {~adder_result[31],adder_result[30:0]} : adder_result;
                        o_inv_op <= adder_inv_op;
                        state <= S_IDLE;
                    end else if (mul_done) begin
                        o_done       <= 1;
                        o_fpu_result <= mul_result;
                        o_inv_op     <= mul_inv_op;
                        state        <= S_IDLE;
                    end else if (div_done) begin
                        o_done       <= 1;
                        o_fpu_result <= div_result;
                        o_inv_op     <= div_inv_op;
                        state        <= S_IDLE;
                    end else if (sqrt_done) begin
                        o_done       <= 1;
                        o_fpu_result <= sqrt_result;
                        o_inv_op     <= sqrt_inv_op;
                        state        <= S_IDLE;
                    end else if (int_to_float_done) begin
                        o_done       <= 1;
                        o_fpu_result <= int_to_float_result;
                        state        <= S_IDLE;
                    end else if (float_to_int_done) begin
                        o_done       <= 1;
                        o_fpu_result <= float_to_int_result;
                        state        <= S_IDLE;
                    end

                end
            endcase
        end
    end
endmodule
