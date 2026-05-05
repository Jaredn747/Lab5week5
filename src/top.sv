module top (
    input CLK,          
    output LCD_CLK,     
    output LCD_DEN,    
    output [4:0] LCD_R, 
    output [5:0] LCD_G, 
    output [4:0] LCD_B 
);

    assign LCD_CLK = CLK;

    // Timing parameters
    parameter H_ACTIVE = 480;
    parameter H_TOTAL  = 525;

    parameter V_ACTIVE = 272;
    parameter V_TOTAL  = 285;

    // to evenly out the colors 
    localparam part1 = H_ACTIVE / 3;
    localparam SECTION_2 = (2 * H_ACTIVE) / 3;

    //  counters 
    reg [9:0] x_counter = 0;
    reg [9:0] y_counter = 0;

    always @(posedge CLK) begin
        if (x_counter < H_TOTAL - 1) begin
            x_counter <= x_counter + 1;
        end else begin
            x_counter <= 0;

            if (y_counter < V_TOTAL - 1) begin
                y_counter <= y_counter + 1;
            end else begin
                y_counter <= 0;
            end
        end
    end

    // the area that is need to show 
    assign LCD_DEN = (x_counter < H_ACTIVE) && (y_counter < V_ACTIVE);

    reg [4:0] r_out;
    reg [5:0] g_out;
    reg [4:0] b_out;

    always @(*) begin
       // start out with black
        r_out = 5'd0;
        g_out = 6'd0;
        b_out = 5'd0;

        if (LCD_DEN) begin
            if (x_counter < part1) begin
                // Red
                r_out = 5'd31;
                g_out = 6'd0;
                b_out = 5'd0;
            end else if (x_counter < SECTION_2) begin
                //  Green
                r_out = 5'd0;
                g_out = 6'd63;
                b_out = 5'd0;
            end else begin
                // Blue
                r_out = 5'd0;
                g_out = 6'd0;
                b_out = 5'd31;
            end
        end
    end

    assign LCD_R = r_out;
    assign LCD_G = g_out;
    assign LCD_B = b_out;

endmodule
