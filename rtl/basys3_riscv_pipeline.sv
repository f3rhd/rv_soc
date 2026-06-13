`include "../include/execution_interface.svh"
`include "../include/pre_exec_interface.svh"
`include "../include/decode_output.svh"

module basys3_riscv_pipeline #(
    parameter HISTORY_SIZE = 10,
    I_CACHE_SIZE = 1024,
    D_CACHE_SIZE = 1 << 16,
    BTB_SIZE = 128
) (
    input logic clk,
    input logic reset
);

    // Fetch signals
    logic fetch_en;
    logic fetch_reset;
    logic fetch_output_bubble;
    logic fetch_instruction_valid;
    logic [31:0] fetch_instruction_addr;
    logic [31:0] fetch_instruction_raw;
    logic [1:0] fetch_btb_hit_way;
    logic fetch_btb_hit;

    // Prediction signals
    logic prediction_reset;
    logic prediction_enable;
    logic prediction_output_bubble;
    logic prediction_prediction;
    logic prediction_predict;
    logic prediction_btb_hit;
    logic prediction_redirect;
    logic prediction_instruction_valid;
    logic [HISTORY_SIZE -1:0] prediction_pht_index;
    logic [1:0] prediction_btb_hit_way;
    logic [31:0] prediction_redirect_target;
    logic [31:0] prediction_instruction_raw;
    logic [31:0] prediction_instruction_addr;

    // Decode signals
    logic decode_enable;
    logic decode_output_bubble;

    // Register file signals
    logic register_file_reset;
    logic register_file_write_enable;
    logic [4:0] register_file_write_addr;
    logic [31:0] register_file_write_data;

    // Execution signals
    pre_exec_if #(.HISTORY_SIZE(HISTORY_SIZE)) pre_exec_if ();
    execution_if #(.HISTORY_SIZE(HISTORY_SIZE)) execution_if ();
    logic execution_output_bubble;


    // Stage control signals
    logic [3:0] stage_controller_flush_vector, stage_controller_stall_vector;


    stage_controller stage_controller (
        .i_misprediction(execution_if.redirect),
        .i_load_stall   (execution_if.stall_pipeline),
        .flush_vector   (stage_controller_flush_vector),
        .stall_vector   (stage_controller_stall_vector)
    );

    fetch #(
        .I_CACHE_SIZE(I_CACHE_SIZE),
        .BTB_SIZE(BTB_SIZE)
    ) fetch (
        .clk                        (clk),
        .i_en                       (fetch_en),
        .i_reset                    (fetch_reset),
        .i_output_bubble            (fetch_output_bubble),
        .i_predictor_redirect_target(prediction_redirect_target),
        .i_predictor_redirect       (prediction_redirect),
        .exi                        (execution_if),
        .o_instruction_valid        (fetch_instruction_valid),
        .o_instruction_addr         (fetch_instruction_addr),
        .o_instruction_raw          (fetch_instruction_raw),
        .o_btb_hit_way              (fetch_btb_hit_way),
        .o_btb_hit                  (fetch_btb_hit)
    );
    prediction #(
        .HISTORY_SIZE(HISTORY_SIZE)
    ) prediction (
        .clk                      (clk),
        .i_reset                  (prediction_reset),
        .i_en                     (prediction_enable),
        .i_output_bubble          (prediction_output_bubble),
        .i_predict                (prediction_predict),
        .i_btb_hit                (fetch_btb_hit),
        .i_btb_hit_way            (fetch_btb_hit_way),
        .i_instruction_raw        (fetch_instruction_raw),
        .i_instruction_addr       (fetch_instruction_addr),
        .i_instruction_valid      (fetch_instruction_valid),
        .exi                      (execution_if),
        .o_prediction             (prediction_prediction),
        .o_pht_index              (prediction_pht_index),
        .o_btb_hit                (prediction_btb_hit),
        .o_btb_hit_way            (prediction_btb_hit_way),
        .o_predictor_redirect     (prediction_redirect),
        .o_predictor_redirect_addr(prediction_redirect_target),
        .o_instruction_raw        (prediction_instruction_raw),
        .o_instruction_addr       (prediction_instruction_addr),
        .o_instruction_valid      (prediction_instruction_valid)
    );

    decode #(
        .HISTORY_SIZE(HISTORY_SIZE  /* default 10 */)
    ) decode (
        .clk                   (clk),
        .i_enable              (decode_enable),
        .i_output_bubble       (decode_output_bubble),
        .i_instruction_valid   (prediction_instruction_valid),
        .i_btb_hit             (prediction_btb_hit),
        .i_btb_way_hit         (prediction_btb_hit_way),
        .i_predictor_prediction(prediction_prediction),
        .i_predictor_pht_index (prediction_pht_index),
        .i_instruction_raw     (prediction_instruction_raw),
        .i_instruction_addr    (prediction_instruction_addr),
        .pre_exec_if           (pre_exec_if)
    );


    register_file register_file (
        .clk           (clk),
        .i_reset       (register_file_reset),
        .i_write_enable(register_file_write_enable),
        .i_write_addr  (register_file_write_addr),
        .i_write_data  (register_file_write_data),
        .i_read_addr0  (pre_exec_if.decode_data.src1),
        .i_read_addr1  (pre_exec_if.decode_data.src2),
        .o_read_result0(pre_exec_if.src1_data),
        .o_read_result1(pre_exec_if.src2_data)
    );

    execute execute (
        .clk            (clk),
        .i_output_bubble(execution_output_bubble),
        .pre_exi        (pre_exec_if),
        .exi            (execution_if)
    );


    memory #(
        .SIZE(D_CACHE_SIZE)
    ) memory (
        .clk                   (clk),
        .ei                    (execution_if),
        .o_register_write_index(register_file_write_addr),
        .o_register_write_data (register_file_write_data),
        .o_register_write      (register_file_write_enable)
    );

    always_comb begin
        fetch_en                 = ~stage_controller_stall_vector[0];
        fetch_reset              = reset;
        fetch_output_bubble      = stage_controller_flush_vector[0];


        prediction_reset         = reset;  // TODO : WORK ON ALTERNATIVES LATER
        prediction_enable        = ~stage_controller_stall_vector[1];
        prediction_output_bubble = stage_controller_flush_vector[1] | reset;
        prediction_predict       = fetch_btb_hit & fetch_instruction_valid;


        decode_enable            = ~stage_controller_stall_vector[2];
        decode_output_bubble     = stage_controller_flush_vector[2];


        register_file_reset      = reset;

        execution_output_bubble  = stage_controller_flush_vector[3];
    end
endmodule
