module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;


// Memory
reg      [24:0]    tag [0:15][0:1];    // valid, dirty, tag
reg      [255:0]   data[0:15][0:1];

integer            i, j;

reg [24:0] tag_o;
reg [255:0] data_o;
reg hit_o, read_miss;
reg LRU [0:15];
wire [22:0] tag_bit;
wire dirty_bit;
wire valid_bit;

assign tag_bit = tag_i[22:0];
assign dirty_bit = tag_i[23];
assign valid_bit = tag_i[24];


// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    //$display("sram data_i: %h", data_i);
    //$display("sram write_i: %h", write_i);
    //$display("sram dirty_bit: %h", dirty_bit);
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            for (j=0;j<2;j=j+1) begin
                tag[i][j] = 25'b0;
                data[i][j] = 256'b0;
            end
            LRU[i] = 1'b0;
            hit_o = 1'b0;
            read_miss = 1'b0;
        end
    end

    if (enable_i) begin //read miss and write miss
        if(!(tag_bit == tag[addr_i][0][22:0] && valid_bit == tag[addr_i][0][24])&&!(tag_bit == tag[addr_i][1][22:0] && valid_bit == tag[addr_i][1][24])) begin 
            tag_o = tag[addr_i][LRU[addr_i]];
            data_o = data[addr_i][LRU[addr_i]];
            hit_o = 1'b0;
            read_miss = 1'b1;
        end
    end 
    if (enable_i && write_i) begin //write hit
        if(tag_bit == tag[addr_i][0][22:0] && valid_bit == tag[addr_i][0][24]) begin 
            tag[addr_i][0] = tag_i;
            data[addr_i][0] = data_i;
            if(dirty_bit) begin
                LRU[addr_i] = 1'b1;
            end
            tag_o = tag_i;
            data_o = data_i;
            hit_o = 1'b1;
            read_miss = 1'b0;
        end
        else if(tag_bit == tag[addr_i][1][22:0] && valid_bit == tag[addr_i][1][24]) begin
            tag[addr_i][1] = tag_i;
            data[addr_i][1] = data_i;
            if(dirty_bit) begin
                LRU[addr_i] = 1'b0;
            end
            tag_o = tag_i;
            data_o = data_i;
            hit_o = 1'b1;
            read_miss = 1'b0;
        end
        else if (!dirty_bit)begin
            tag[addr_i][LRU[addr_i]] = tag_i;
            data[addr_i][LRU[addr_i]] = data_i;
            LRU[addr_i] = !LRU[addr_i];
            tag_o = tag_i;
            data_o = data_i;
            hit_o = 1'b1;
            read_miss = 1'b0;
        end
    end
end
always @(tag_i or data_i or addr_i) begin   // read hit
    if (enable_i) begin
        if(tag_bit == tag[addr_i][0][22:0] && valid_bit == tag[addr_i][0][24]) begin 
            tag_o = tag[addr_i][0];
            data_o = data[addr_i][0];
            hit_o = 1'b1;
            LRU[addr_i] = 1'b1;
        end
        else if(tag_bit == tag[addr_i][1][22:0] && valid_bit == tag[addr_i][1][24]) begin
            tag_o = tag[addr_i][1];
            data_o = data[addr_i][1];
            hit_o = 1'b1;
            LRU[addr_i] = 1'b0;
        end
        else begin
            hit_o = 1'b0;
            tag_o = tag[addr_i][LRU[addr_i]]; //25'b0;
            data_o = tag[addr_i][LRU[addr_i]]; //255'b0;
        end
    end
end
// Read Data      
// TODO: tag_o=? data_o=? hit_o=?

endmodule
