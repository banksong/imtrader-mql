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
input int kPeriod = 19;
datetime Now = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
      
      Now = Time[0];
//--- indicator buffers mapping

//---
   return(INIT_SUCCEEDED);
  }
  
int start() {
    if( Now != Time[0])
    {
      Now = Time[0];
      double highest_price = iHigh(Symbol(),PERIOD_M1,0); 
      double lowest_price = iLow(Symbol(),PERIOD_M1,0); 
      double close_price = iClose(Symbol(),PERIOD_M1,0);

      if(close_price > 0)
         Print("this bar is done:" + close_price);
      else
         Print(highest_price + ":" + lowest_price);
   
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
