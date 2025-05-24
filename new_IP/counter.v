module counter #(   parameter   WIDTH = 32)  
                (   
                    input               iclk,               // Signal clock
                    input               ireset,             // Signal reset
                    input               ienable,            // Signal enable
                    input       [WIDTH-1:0]  iload_value,   // End load value
                    input       [WIDTH-1:0]  threshold,     // Value 
                    output reg  [WIDTH-1:0]  ocount,        // Count value
                    output reg  oterminal_count             // End count
                );

always @(posedge iclk or posedge ireset) //revisar el del juego de vida
    begin
        if(!ireset)
            begin
                ocount <= {WIDTH{1'b0}};
                oterminal_count <= 1'b0;
            end
        else
            begin
                if(ienable)
                    begin   
                        if(ocount<iload_value)
                            ocount <= ocount+1'b1;
                        else // END COUNTER
                            begin
                                oterminal_count <= 1'b1;   //Enable final count
                                ocount <= {WIDTH{1'b0}};
                            end
                    end                        
            end
    end

//falta anyadir la limpieza de irq
//falta anyadir la comparacion del umbral par habilitar led THº

endmodule 


// verificar con test bench solo el counter