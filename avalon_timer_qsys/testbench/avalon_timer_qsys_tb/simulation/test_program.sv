`timescale 1 ns / 1 ps

// console messaging level
`define VERBOSITY VERBOSITY_INFO

//BFM jerarquía
`define CLK tb.avalon_timer_qsys_inst_clk_bfm_clk_clk
`define RST tb.avalon_timer_qsys_inst_reset_bfm_reset_reset
`define BFM tb.avalon_timer_qsys_inst.mm_master_bfm_0

`define AV_ADDRESS_W 3
`define AV_DATA_W 32

module test_program();

import avalon_mm_pkg::*;
import verbosity_pkg::*;

reg [`AV_DATA_W-1:0] datos_out;
int j=0;

initial
    begin
        set_verbosity(`VERBOSITY);
            `BFM.init();

        // Espera hasta que el reset esté inactivo
        wait(`RST == 1);
        #100
        // Escribe un dato en el esclavo*/
        avalon_write (3'h0,32'h000003E8); //valor final a 1000
        repeat (5) @(posedge `CLK);
        avalon_write (3'h3,32'h000001F4); //threshold a 500
        repeat (5) @(posedge `CLK);
        avalon_write (3'h1,32'h00000001); // enable
        $display("Operacion Escritura acabada");
        repeat (5) @(posedge `CLK);
    
        // Lee dato del esclavo y comprueba si es correcto
        repeat(800) avalon_read (3'h2,datos_out);
        avalon_write (3'h1,32'h00000003); // clean and enable 
        repeat (5) @(posedge `CLK);
        $display("Datos leidos del IP: %h",datos_out);
        
        j++;
        
        $display("//////// ITERACION %d /////////",j);
        $stop();
    end
// ============================================================
// Tasks
// ============================================================
//
// Avalon-MM single-transaction read and write procedures.
//
// ------------------------------------------------------------
task avalon_write (
                    input [`AV_ADDRESS_W-1:0] addr,
                    input [`AV_DATA_W-1:0] data
                   );
    begin
        // Construct the BFM request
        `BFM.set_command_request(REQ_WRITE);
        `BFM.set_command_idle(0, 0);
        `BFM.set_command_init_latency(0);
        `BFM.set_command_address(addr);
        `BFM.set_command_byte_enable('1,0);
        `BFM.set_command_data(data, 0);
        `BFM.set_command_burst_count(1);
        `BFM.set_command_burst_size(1);
        // Queue the command
        `BFM.push_command();
        // Wait until the transaction has completed
        while (`BFM.get_response_queue_size() != 1)
        @(posedge `CLK);
        // Dequeue the response and discard
        `BFM.pop_response();
    end
endtask
// ------------------------------------------------------------
task avalon_read (
                    input [`AV_ADDRESS_W-1:0] addr,
                    output [`AV_DATA_W-1:0] data
                );
    begin
        // Construct the BFM request
        `BFM.set_command_request(REQ_READ);
        `BFM.set_command_idle(0, 0);
        `BFM.set_command_init_latency(0);
        `BFM.set_command_address(addr);
        `BFM.set_command_byte_enable('1,0);
        `BFM.set_command_data(0, 0);
        `BFM.set_command_burst_count(1);
        `BFM.set_command_burst_size(1);
        // Queue the command
        `BFM.push_command();
        // Wait until the transaction has completed
        while (`BFM.get_response_queue_size() != 1)
        @(posedge `CLK);
        // Dequeue the response and return the data
        `BFM.pop_response();
        data = `BFM.get_response_data(0);
    end
endtask
endmodule