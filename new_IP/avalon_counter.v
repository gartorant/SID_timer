module avalon_counter(  input reset,
                        input clock,
                        input chipselect,
                        input [2:0]  address,
                        input write,
                        input [31:0] writedata,
                        input read,
                        output [31:0] readdata,
                        //COUNTER INTERFACE
                        input enable,
                        input [31:0] load_value,
                        output reg [31:0] count);


avalon_slave_MM_interface u1_av_sl_MM (//Avalon MM interface signals
                                        .reset(reset),
                                        .clock(clock),
                                        .chipselect(chipselect),
                                        .address(address), 
                                        .write(write),
                                        .writedata(writedata),
                                        .read(read),                                          
                                        .readdata(readdata),
                                       //Interface con nuestra logica.
                                         // Registros 0 y 1 de lectura 
                                        .reg0(reg0), 
                                        .reg1(reg1), 
                                         //Datos para el registro interno reg3
                                        .data(32'h87654321), 
                                        .we(1'b1)); // Write enabl. de reg3
                                                  

endmodule 