//+------------------------------------------------------------------+
//|                                                close_for_one.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#define MAGICMA  20180001
#include <mql4-http.mqh>
double gap = 0.07;
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

void CheckForClose()
  {

   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()== MAGICMA || OrderSymbol()==Symbol() && OrderType()==OP_BUY) {
         if(Bid > OrderOpenPrice() + gap)
           {
            if(!OrderClose(OrderTicket(),OrderLots(),Bid,100,White))
               Print("OrderClose error ",GetLastError());
               
           } else {
                string mailText = "Close USD at" + Bid;
              // string send_mail_rest = "http://127.0.0.1:9000/sendsms/CloseGC/" + mailText;
               Print(mailText);
           }
    
        }
     }
//---
  }
  
void OnTick()
  {
//---
//--- check for history and trading
   if(Bars<100 || IsTradeAllowed()==false)
      return;
   CheckForClose();
   
  }
//+------------------------------------------------------------------+
