module counter #(   parameter   WIDTH = 32)  
                (   
                    input               iclk,               //bit       - Signal clock
                    input               ireset,             //bit       - Signal reset
                    input               ienable,            //bit       - Signal enable
                    input               clearTC_threshold,  //bit       - Signal to clear oTC_threshold (IRQ)
                    input       [WIDTH-1:0]  iload_value,   //U[31:0]   - End load value
                    input       [WIDTH-1:0]  threshold,     //U[31:0]   - Value 
                    output reg  oterminal_count,            //bit       - End count
                    output reg  oTC_threshold,              //bit       - Signal 
                    output reg  [WIDTH-1:0]  ocount         //U[31:0]   - Count value

                );

always @(posedge iclk or negedge ireset)
    begin
        if(!ireset)
            begin
                ocount <= {WIDTH{1'b0}};
                oterminal_count <= 1'b0;
                oTC_threshold <= 1'b0;
            end
        else
            begin
                if(ienable)
                    begin   
                        if(ocount<(iload_value-1'b1))       //The loop executes one more time than the condition is met.
                            ocount <= ocount+1'b1;
                        else // END COUNTER
                            begin
                                oterminal_count <= 1'b1;   //Enable final count
                                ocount <= {WIDTH{1'b0}};
                            end
                    end  
                    //todo: case else ienable = 0                      
            end
    end

//falta anyadir la limpieza de irq
//falta anyadir la comparacion del umbral par habilitar led THº

endmodule 


// verificar con test bench solo el counter