`timescale 1ns/1ps

module counter_tsb ();

reg clock;
reg reset;
reg enable;
reg clearTC_count;

localparam counter_value = 1000; // Example counter value
localparam threshold_value = 500; // Example threshold value

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
endmodule 