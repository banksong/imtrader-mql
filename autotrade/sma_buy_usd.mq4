//+------------------------------------------------------------------+
//|                                                      sma_buy.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <mql4-http.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#define MAGICMA  20180001
//--- Inputs
input double Lots          =0.1;

input int    MovingPeriod  =20;
input int    MovingShift   =1;

int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int CalculateCurrentOrders(string symbol)
  {
   int buys=0;
//---
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      if(OrderSymbol()==symbol && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)  buys++;
        }
     }
//--- return orders volume
    return(buys);
  }
  
void CheckForOpen()
  {
   double ma;
//--- go trading only for first tiks of new bar
   if(Volume[0]>1) return;
//--- get Moving Average 
   ma=iMA(NULL,0,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,0);

//--- buy conditions
   double highestPrice = iHigh(Symbol(),0,iHighest(Symbol(),0,MODE_CLOSE,1200,0));
   if(Open[1]<ma && Close[1]>ma && Ask < highestPrice)
     {
      int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,10,0,0,"",MAGICMA,0,Blue);
      if(ticket<0) 
      { 
         Print("OrderSend failed with error #",GetLastError()); 
         
      } 
      else {
         Print("OrderSend placed successfully"); 
         string mailText = "at" + OrderOpenPrice();
         string send_mail_rest = "http://127.0.0.1:9000/sendsms/buyUSD/" + mailText;
        // httpGET(send_mail_rest);
         Print(send_mail_rest);
      }
      
      return;
     }
//---
  }
  
void OnTick()
  {
//---
   //---
//--- check for history and trading
   if(Bars<100 || IsTradeAllowed()==false)
      return;
   RefreshRates();
   int gcCurrentOrders = CalculateCurrentOrders("RF-GC");
   int usdCurrentOrders = CalculateCurrentOrders("RF-USDX");
   if ( usdCurrentOrders == 0 && gcCurrentOrders > 0 )
      CheckForOpen();
   
  }
//+------------------------------------------------------------------+
