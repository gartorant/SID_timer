module avalon_counter(  input reset,
                        input clock,
                        input chipselect,
                        input [2:0]  address,
                        input write,
                        input [31:0] writedata,
                        input read,
                        output [31:0] readdata,
                        //COUNTER INTERFACE
                        output IRQ,
                        output th //senyal final de umbral
                        // input [31:0] load_value, viene del reg 0
                        );
wire [31:0] reg1, reg0, reg3, count;    

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
                                        .reg3(reg3),
                                         //Datos para el registro interno reg3
                                        .data(ocount), 
                                        .we(1'b1)); // Write enabl. de reg3
//fijar a 32
counter#(    parameter   END_COUNT --> reg0 ,
                    parameter   WIDTH = $clog2(END_COUNT-1) // Width of the counter
                )
                (
                    .iclk(clk),                       // Signal clock
                    .ireset(reset),                     // Signal reset
                    .ienable(reg1[0]),                    // Signal enable
                    .iload_value(reg0),    // End load value
                    .clcIRQ(reg1[1]),
                    .umbral(reg3)
                    .ocount(ocount),         // Count value
                    .oterminal_count(IRQ)            // End count
                    .oTCumbral(th)
                );




endmodule 