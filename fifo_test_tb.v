`timescale 1ns/1ns
`define wrclk_period 20
`define rdclk_period 10

module fifo_test_tb();

    reg rst;                    // Reset sinyali
    reg wr_clk;                 // Yazma saat sinyali
    reg rd_clk;                 // Okuma saat sinyali
    reg [7:0] din;              // Yazılacak veri
    reg wr_en;                  // Yazma işlemi kontrol sinyali
    reg rd_en;                  // Okuma işlemi kontrol sinyali
    
    wire [7:0] dout;            // Okunan veri  // çıkış olduğu için wire

    fifo_test fifo_test_U1
    (
        .rst(rst),
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .din(din),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .dout(dout)
    );
  
    always #(`wrclk_period/2) wr_clk = ~wr_clk;     // Yazma saatini belirli periyotlarla değiştir
    always #(`rdclk_period/2) rd_clk = ~rd_clk;     // Okuma saatini belirli periyotlarla değiştir

    integer i, j;                                   // Döngü sayaçları
  
    initial begin
        din = 0;                                   // Yazılacak veriyi sıfırla
        wr_en = 0;                                 // Yazma kontrol sinyalini sıfırla
        rd_en = 0;                                 // Okuma kontrol sinyalini sıfırla
        rst = 0;                                   // Reset sinyalini sıfırla
        wr_clk = 1;                                // Yazma saatini başlangıç değerine ayarla
        rd_clk = 1;                                // Okuma saatini başlangıç değerine ayarla
        
        #(`wrclk_period);                          // Yazma saatinden önce bir bekleme süresi
        
        // Reset işlemi
        rst = 1;                                   // Reset sinyalini etkinleştir
        #(`wrclk_period);                          // Belirli bir süre boyunca reset sinyali etkin kalır
        
        rst = 0;                                   // Reset sinyalini devre dışı bırak
        #(`wrclk_period * 3);                      // Resetin etkin olması için beklenen süre (3 kez yazma periyodu)
        // Bu beklemenin amacı, sistemin reset işlemini tamamlaması için gerekli zamanı sağlamaktır. 
        //Bu süre boyunca, reset sinyali devre dışı bırakıldıktan sonra belirli bir süre daha beklenir, 
        //böylece sistem istenen duruma geçebilir ve ardından veri yazma ve okuma işlemleri gerçekleştirilebilir.
        
        // Veri yazma işlemi
        for(i = 0; i < 6 ; i = i + 1) begin
            din = i;                               // Yazılacak veriyi ata
            wr_en = 1;                             // Yazma kontrol sinyalini etkinleştir

            #(`wrclk_period);                      // Belirli bir süre boyunca yazma işlemi yapılır
         end
         wr_en = 0;                                 // Yazma kontrol sinyalini devre dışı bırak
         #(`wrclk_period);                          // Son bir bekleme süresi
        
        // Veri okuma işlemi
        #(`rdclk_period);                           // Okuma saatinden önce bir bekleme süresi
        for (j = 0; j < 6; j = j + 1) begin
           rd_en = 1;                               // Okuma kontrol sinyalini etkinleştir
                   
           #(`rdclk_period);                        // Belirli bir süre boyunca okuma işlemi yapılır
        end
        rd_en = 0;                                   // Okuma kontrol sinyalini devre dışı bırak
        #(`rdclk_period);                            // Son bir bekleme süresi
        
        $finish;                                     // Simülasyonu sonlandır
    end   
  
endmodule
