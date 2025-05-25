`timescale 1ns/1ps

module counter_tsb ();

reg clock;
reg reset;
reg enable;
reg clearTC_count;

localparam counter_value = 1000; // Example counter value
localparam threshold_value = 500; // Example threshold value
localparam T = 20;

wire TC_COUNT;
wire TC_THRESHOLD;
wire [31:0] count_value;

counter uut_counter (
    .iclk(clock),
    .ireset(reset),
    .ienable(enable),
    .clearTC_count(clearTC_count),
    .iload_value(counter_value),
    .threshold(threshold_value),
    .oTC_count(TC_COUNT),
    .oTC_threshold(TC_THRESHOLD),
    .ocount(count_value)
);

initial 
    begin
    // Initialize signals
    clock           = 1'b0;
    reset           = 1'b0;
    enable          = 1'b0;
    clearTC_count   = 1'b0;

    $display("Simulando contador");
    
    #(2*T)

    reset_counter_tsk; // Reset the counter
    enable_counter_tsk; // Enable the counter
    #(1100*T)
    clearTC_count_tsk; // Clear the TC count
    #(600*T)
    reset_counter_tsk; // Reset the counter again
    #(200*T)
    disable_counter_tsk; // Disable the counter
    #(300*T)
    $display("Final de la simulación");
    $stop;

    end

always
    begin
        #(T/2) clock = ~clock;
    end

task reset_counter_tsk ();
    begin
        @(negedge clock);
        reset = 1'b1;
        #(2*T);
        reset = 1'b0;
        #(2*T);
    end
endtask

task enable_counter_tsk ();
    begin
        @(negedge clock);
        enable = 1'b1;
        #(2*T);
    end
endtask

task clearTC_count_tsk ();
    begin
        @(negedge clock);
        clearTC_count = 1'b1;
        #(2*T);
        clearTC_count = 1'b0;
        #(2*T);
    end
endtask

task disable_counter_tsk ();
    begin
        @(negedge clock);
        enable = 1'b0;
        #(2*T);
    end
endtask



endmodule 