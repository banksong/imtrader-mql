//+------------------------------------------------------------------+
//|                                compareLastLowPriceAndSendMsg.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
input double alarm_num = 0.5;
input int kPeriod = 4;
datetime Now = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

//---
   Now = Time[0];
   return(INIT_SUCCEEDED);
  }
  
int start() {
    if( Now != Time[0])
    {
      Now = Time[0];
      double highest_price = iHigh(Symbol(),PERIOD_M5,iHighest(Symbol(),PERIOD_M5,MODE_HIGH,kPeriod,0)); 
      double lowest_price = iLow(Symbol(),PERIOD_M5,iLowest(Symbol(),PERIOD_M5,MODE_LOW,kPeriod,0)); 
      double price_gap = highest_price - lowest_price;
      Print(Now + ",oil price gap is:" + price_gap); 
         
      string mailText = "石油波动超过0.5美元(二十分钟线)," + ",highest price is:" + highest_price
         + ",lowest price is:" + lowest_price
         + ",price gap is:" + price_gap;
   
      if(price_gap > alarm_num){
         SendMail("[imTrader石油价波动提示]" , mailText);
         Print("have sent sms for oil price fluctuates larger than 0.5 dollar:" + mailText);
      } 
    }
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
