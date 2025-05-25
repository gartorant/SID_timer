module counter #(   parameter   WIDTH = 32)  
                (   
                    input                   iclk,               //bit       - Clock signal
                    input                   ireset,             //bit       - Asynchronous reset signal
                    input                   ienable,            //bit       - Enable signal
                    input                   clearTC_count,      //bit       - Clear oTC_counter (IRQ)
                    input       [WIDTH-1:0] iload_value,        //U[31:0]   - Counter load value
                    input       [WIDTH-1:0] threshold,          //U[31:0]   - Threshold value for oTC_threshold
                    output reg              oTC_count,          //bit       - End-of-count signal
                    output reg              oTC_threshold,      //bit       - Threshold reached signal (CONDUIT)
                    output reg  [WIDTH-1:0] ocount              //U[31:0]   - Current counter value
                );

always @(posedge iclk or negedge ireset)
    begin
        if(!ireset)
            begin
                ocount          <= {WIDTH{1'b0}};
                oTC_threshold		<= 1'b0;
                oTC_count       <= 1'b0;
            end
        else
            begin
                if(ienable)
                    begin   
                        if(ocount<(iload_value-1'b1))       //The loop executes one more time than the condition is met.
                            ocount  <= ocount+1'b1;         //Increment counter
                        else // END COUNTER
                            begin
                                ocount      <= {WIDTH{1'b0}};   //Reset counter
                                oTC_count   <= 1'b1;            //Enable final count
                            end
                            
                        if(ocount < threshold)
                            oTC_threshold <= 1'b0; 
                        else
                            oTC_threshold <= 1'b1;

                        if(clearTC_count == 1'b1)
                            oTC_count <= 1'b0;      //Clear interrupt by user request
                    end                     
            end
    end

endmodule 