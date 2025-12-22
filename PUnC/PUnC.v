//==============================================================================
// Module for PUnC LC3 Processor
//==============================================================================

module PUnC(
    // External Inputs
    input  wire        clk,            // Clock
    input  wire        rst,            // Reset

    // Debug Signals
    input  wire [15:0] mem_debug_addr,
    input  wire [2:0]  rf_debug_addr,
    output wire [15:0] mem_debug_data,
    output wire [15:0] rf_debug_data,
    output wire [15:0] pc_debug_data
);

    //----------------------------------------------------------------------
    // Interconnect Wires
    //----------------------------------------------------------------------

    // Controller → Datapath control signals
    wire [1:0] mem_r_addr_sel;
	wire       mem_w_addr_sel;
	wire       mem_w_data_sel;
	wire       mem_w_en;

	wire       rf_r_addr_0_sel;
	wire       rf_r_addr_1_sel;
	wire       rf_w_addr_sel;
	wire [1:0] rf_w_data_sel;
	wire       rf_w_en;

	wire [1:0] pc_src_sel;
	wire [1:0] alu_src_0_sel;
	wire [2:0] alu_src_1_sel;
	wire [1:0] alu_fn;
    wire       alu_en;

	wire mem_reg_ld;
	wire mem_reg_rst;

	wire ir_ld;

	wire pc_ld;
	wire pc_up;
	wire pc_rst;

	wire br_en;
	wire [15:0] ir;
	wire [15:0] alu_out;
	wire nzp_en;
    wire nzp_rst;

    //----------------------------------------------------------------------
    // Control Module
    //----------------------------------------------------------------------
    PUnCControl ctrl(
		.clk             (clk),
		.rst             (rst),

		.br_en           (br_en),
		.ir              (ir),
		.alu_out         (alu_out),
		
		.mem_r_addr_sel  (mem_r_addr_sel),
		.mem_w_addr_sel  (mem_w_addr_sel),
		.mem_w_data_sel  (mem_w_data_sel),
		.mem_w_en        (mem_w_en),
		.mem_reg_ld      (mem_reg_ld),
		.mem_reg_rst     (mem_reg_rst),
		
		.rf_r_addr_0_sel (rf_r_addr_0_sel),
		.rf_r_addr_1_sel (rf_r_addr_1_sel),
		.rf_w_addr_sel   (rf_w_addr_sel),
		.rf_w_data_sel   (rf_w_data_sel),
		.rf_w_en         (rf_w_en),
		
		.ir_ld           (ir_ld),
		.pc_ld           (pc_ld),
		.pc_up           (pc_up),
		.pc_rst          (pc_rst),
		.pc_src_sel      (pc_src_sel),
		
		.alu_src_0_sel   (alu_src_0_sel),
		.alu_src_1_sel   (alu_src_1_sel),
		.alu_fn          (alu_fn),
		.alu_en          (alu_en),
		
		.nzp_en          (nzp_en),
		.nzp_rst         (nzp_rst)
    );

    //----------------------------------------------------------------------
    // Datapath Module
    //----------------------------------------------------------------------
    PUnCDatapath dpath(
		.clk             (clk),
		.rst             (rst),

		.mem_debug_addr  (mem_debug_addr),
		.rf_debug_addr   (rf_debug_addr),
		.mem_debug_data  (mem_debug_data),
		.rf_debug_data   (rf_debug_data),
		.pc_debug_data   (pc_debug_data),

		.mem_r_addr_sel	 (mem_r_addr_sel),
		.mem_w_addr_sel	 (mem_w_addr_sel),
		.mem_w_data_sel	 (mem_w_data_sel),
		.mem_w_en		 (mem_w_en),

		.rf_r_addr_0_sel (rf_r_addr_0_sel),
		.rf_r_addr_1_sel (rf_r_addr_1_sel),
		.rf_w_addr_sel	 (rf_w_addr_sel),
		.rf_w_data_sel	 (rf_w_data_sel),
		.rf_w_en		 (rf_w_en),

		.pc_src_sel		 (pc_src_sel),
		.alu_src_0_sel	 (alu_src_0_sel),
		.alu_src_1_sel	 (alu_src_1_sel),
		.alu_fn		   	 (alu_fn),
		.alu_en          (alu_en),
		
		.mem_reg_ld      (mem_reg_ld),
		.mem_reg_rst     (mem_reg_rst),
		.ir_ld           (ir_ld),
		.pc_ld           (pc_ld),
		.pc_up           (pc_up),
		.pc_rst          (pc_rst),
		.nzp_en          (nzp_en),	
		.nzp_rst         (nzp_rst),

		.br_en			 (br_en),
		.ir       	 	 (ir),
		.alu_out         (alu_out)
    );

endmodule



