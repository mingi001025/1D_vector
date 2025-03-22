module clkgate(en, clk, gclk);
    input   clk;
    input   en;
    output  gclk;

    reg     en_q;

    assign gclk = en_q & en;
    
    always @(!clk) begin
        en_q <= en;
    end


endmodule