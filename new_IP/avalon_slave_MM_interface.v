module avalon_slave_MM_interface(//Avalon MM interface signals
                                 input reset,
                                 input clock,
                                 input chipselect,
                                 input [2:0]  address, 
                                 input write,
                                 input [31:0] writedata,
                                 input read,                                         
                                 output reg [31:0] readdata,
                                 //Interface con nuestra logica.
                                   // Registros 0 y 1 de lectura 
                                 output reg [31:0] reg0, reg1, 
                                   // Datos para el registro interno reg3
                                 input  [31:0] data,
                                   // Write enable para el registro interno.
                                 input   we);
                                            
                                        
// Componente con 3 registros mapeados en memoria reg0, reg1 y reg2
// reg0 y reg1 son registros de lectura y escritura
// reg2 es un registro de solo lectura
reg [31:0] reg2;
always @(posedge clock)
    if (reset)
    begin
          reg0 <= 32'd0;
          reg1 <= 32'd0;
          reg2 <= 32'd0;    
          readdata <= 32'd0; 
     end                                
     else
    begin
          if (chipselect)
          begin
              // Proceso de escritura en el interface Avalon MM
              if (write)
               begin
                   case(address)
                     3'd0: reg0 <= writedata;
                     3'd1: reg1 <= writedata;
                    endcase           
              end
              // Proceso de lectura del interface Avalon MM
              if (read)
              begin
                    case(address)
                    3'd0: readdata <= reg0;
                    3'd1: readdata <= reg1;
                    3'd2: readdata <= reg2;
                    // Si la direccion es incorrecta devuelvo todo ceros.
                   default: readdata <= 32'd0; 
                   endcase  
              end
              // Proceso de escritura en el registro 2
           end
           if (we) reg2 <= data;           
        
    end                                         
endmodule