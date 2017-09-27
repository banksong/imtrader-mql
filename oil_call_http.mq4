//+------------------------------------------------------------------+
//|                                                    call_http.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

#include <mql4-http.mqh>

input double alarm_num = 0.5;
input int kPeriod = 4;
datetime Now = 0;
bool hasSent = false;

int start () {
  
   if( isNewBar() || hasSent == false)
    {
    
      int highestBar = iHighest(Symbol(),PERIOD_M5,MODE_HIGH,kPeriod,0);
      double highest_price = iHigh(Symbol(),PERIOD_M5,highestBar);
      int lowestBar = iLowest(Symbol(),PERIOD_M5,MODE_LOW,kPeriod,0); 
      double lowest_price = iLow(Symbol(),PERIOD_M5,lowestBar); 
      double price_gap = highest_price - lowest_price;
      
      if(isNewBar()) {
         Print("oil new bar just come, the price gap is:" + price_gap);
         if (hasSent){
            hasSent = false;
         }
      }   
      Now = Time[0];
    
      datetime higestTimeForSent = Time[highestBar];
      datetime lowestTimeForSent = Time[lowestBar];
      
      if(!isInSamePeriod(higestTimeForSent, lowestTimeForSent))
         return(0);
        
      string mailText = "波动超过5美元(二十分钟线)" + ",highest price is:" + highest_price + ",at:" + higestTimeForSent
         + " ,lowest price is:" + lowest_price + ",at:" + lowestTimeForSent
         + ",price gap is:" + price_gap;
   
       if(price_gap > alarm_num){
         //-- SendMail("[imTrader黄金波动提示]" , mailText);
           string send_mail_rest = "http://127.0.0.1:9000/sendmail/imTrader石油波动提示/" + mailText;
           string send_mail_resp = "";
           send_mail_resp = httpGET(send_mail_rest);
          if (send_mail_resp == "OK") {
            Print("have sent sms for oil price fluctuates larger than 0.5 dollar:" + mailText);
          } else {
            Print("send mail failed");
          }
          hasSent = true;
      } 
     }
     
   return(0);

}
int OnInit()
  {
//--- indicator buffers mapping
   
//---
    Now = Time[0];
  
    return(INIT_SUCCEEDED);
  }
  
bool isNewBar(){

   bool result =  (Now == Time[1]);
   return(result) ;
}

bool isInSamePeriod(datetime beginDate, datetime endDate) {
   if (TimeDay(beginDate) != TimeDay(endDate))
      return(false);
   if (TimeHour(endDate) - TimeHour(beginDate) > 1)
      return(false);
   return(true);
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
