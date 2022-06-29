/*

CUSTOMIZE THE FOLLOWING TO GET YOUR OWN EXPERT ADVISOR UP AND RUNNING

EvaluateEntry : To insert your custom entry signal

EvaluateExit : To insert your custom exit signal

ExecuteTrailingStop : To insert your trailing stop rules

StopLossPriceCalculate : To set your custom Stop Loss value

TakeProfitPriceCalculate : To set your custom Take Profit value

*/

//-PROPERTIES-//
//Properties help the software look better when you load it in MT4
//Provide more information and details
//This is what you see in the About tab when you load an Indicator or an Expert Advisor
#property link          "https://www.earnforex.com/metatrader-expert-advisors/expert-advisor-template/"
#property version       "1.00"
#property strict
#property copyright     "EarnForex.com - 2020-2021"
#property description   "This is a template for a generic Automated EA" 
#property description   " "
#property description   "WARNING : You use this software at your own risk."
#property description   "The creator of these plugins cannot be held responsible for any damage or loss."
#property description   " "
#property description   "Find More on EarnForex.com"
//You can add an icon for when the EA loads on chart but it's not necessary
//The commented line below is an example of icon, icon must be in the MQL4/Files folder and have a ico extension
//#property icon          "\\Files\\EF-Icon-64x64px.ico"

//-INCLUDES-//
//Include allows to import code from another file
//In the following instance the file has to be placed in the MQL4/Include Folder
#include <MQLTA ErrorHandling.mqh>

//-COMMENTS-//
//This is a single line comment and I do it placing // at the start of the comment, this text is ignored when compiling

/*
This is a multi line comment
it starts with /* and it finishes with the * and / like below
*/


//-ENUMERATIVE VARIABLES-//
//Enumerative variables are useful to associate numerical values to easy to remember strings
//It is similar to constants but also helps if the variable is set from the input page of the EA
//The text after the // is what you see in the input paramenters when the EA loads
//It is good practice to place all the enumberative at the start

//Enumerative for the hour of the day
enum ENUM_HOUR{
   h00=00,     //00:00
   h01=01,     //01:00
   h02=02,     //02:00
   h03=03,     //03:00
   h04=04,     //04:00
   h05=05,     //05:00
   h06=06,     //06:00
   h07=07,     //07:00
   h08=08,     //08:00
   h09=09,     //09:00
   h10=10,     //10:00
   h11=11,     //11:00
   h12=12,     //12:00
   h13=13,     //13:00
   h14=14,     //14:00
   h15=15,     //15:00
   h16=16,     //16:00
   h17=17,     //17:00
   h18=18,     //18:00
   h19=19,     //19:00
   h20=20,     //20:00
   h21=21,     //21:00
   h22=22,     //22:00
   h23=23,     //23:00
};

//Enumerative for the entry signal value
enum ENUM_SIGNAL_ENTRY{
   SIGNAL_ENTRY_NEUTRAL=0,    //SIGNAL ENTRY NEUTRAL
   SIGNAL_ENTRY_BUY=1,        //SIGNAL ENTRY BUY
   SIGNAL_ENTRY_SELL=-1,      //SIGNAL ENTRY SELL
};

//Enumerative for the exit signal value
enum ENUM_SIGNAL_EXIT{
   SIGNAL_EXIT_NEUTRAL=0,     //SIGNAL EXIT NEUTRAL
   SIGNAL_EXIT_BUY=-1,         //SIGNAL EXIT BUY
   SIGNAL_EXIT_SELL=1,       //SIGNAL EXIT SELL
   SIGNAL_EXIT_ALL=2,         //SIGNAL EXIT ALL
};

//Enumerative for the allowed trading direction
enum ENUM_TRADING_ALLOW_DIRECTION{
   TRADING_ALLOW_BOTH=0,      //ALLOW BOTH BUY AND SELL
   TRADING_ALLOW_BUY=1,       //ALLOW BUY ONLY
   TRADING_ALLOW_SELL=-1,     //ALLOW SELL ONLY
};

//Enumerative for the base used for risk calculation
enum ENUM_RISK_BASE{
   RISK_BASE_EQUITY=1,        //EQUITY
   RISK_BASE_BALANCE=2,       //BALANCE
   RISK_BASE_FREEMARGIN=3,    //FREE MARGIN
};

//Enumerative for the default risk size
enum ENUM_RISK_DEFAULT_SIZE{
   RISK_DEFAULT_FIXED=1,      //FIXED SIZE
   RISK_DEFAULT_AUTO=2,       //AUTOMATIC SIZE BASED ON RISK
};

//Enumerative for the Stop Loss mode
enum ENUM_MODE_SL{
   SL_FIXED=0,                //FIXED STOP LOSS
   SL_AUTO=1,                 //AUTOMATIC STOP LOSS
};

//Enumerative for the Take Profit Mode
enum ENUM_MODE_TP{
   TP_FIXED=0,                //FIXED TAKE PROFIT
   TP_AUTO=1,                 //AUTOMATIC TAKE PROFIT
};

//Enumerative for the stop loss calculation
enum ENUM_MODE_SL_BY{
   SL_BY_POINTS=0,            //STOP LOSS PASSED IN POINTS
   SL_BY_PRICE=1,             //STOP LOSS PASSED BY PRICE
};


//-INPUT PARAMETERS-//
//The input parameters are the ones that can be set by the user when launching the EA
//If you place a comment following the input variable this will be shown as description of the field

//This is where you should include the input parameters for your entry and exit signals
input string Comment_strategy="==========";                          //Entry And Exit Settings
//Add in this section the parameters for the indicators used in your entry and exit

//General input parameters
input string Comment_0="==========";                                 //Risk Management Settings
input ENUM_RISK_DEFAULT_SIZE RiskDefaultSize=RISK_DEFAULT_AUTO;      //Position Size Mode
input double DefaultLotSize=1;                                       //Position Size (if fixed or if no stop loss defined)
input ENUM_RISK_BASE RiskBase=RISK_BASE_BALANCE;                     //Risk Base
input int MaxRiskPerTrade=2;                                         //Percentage To Risk Each Trade
input double MinLotSize=0.01;                                        //Minimum Position Size Allowed
input double MaxLotSize=100;                                         //Maximum Position Size Allowed

input string Comment_1="==========";                                 //Trading Hours Settings
input bool UseTradingHours=false;                                    //Limit Trading Hours
input ENUM_HOUR TradingHourStart=h10;                                //Trading Start Hour (Broker Server Hour)
input ENUM_HOUR TradingHourEnd=h17;                                  //Trading End Hour (Broker Server Hour)

input string Comment_2="==========";                                 //Stop Loss And Take Profit Settings
input ENUM_MODE_SL StopLossMode=SL_FIXED;                            //Stop Loss Mode
input int DefaultStopLoss=0;                                         //Default Stop Loss In Points (0=No Stop Loss)
input int MinStopLoss=0;                                             //Minimum Allowed Stop Loss In Points
input int MaxStopLoss=5000;                                          //Maximum Allowed Stop Loss In Points
input ENUM_MODE_TP TakeProfitMode=TP_FIXED;                          //Take Profit Mode
input int DefaultTakeProfit=0;                                       //Default Take Profit In Points (0=No Take Profit)
input int MinTakeProfit=0;                                           //Minimum Allowed Take Profit In Points
input int MaxTakeProfit=5000;                                        //Maximum Allowed Take Profit In Points

input string Comment_3="==========";                                 //Trailing Stop Settings
input bool UseTrailingStop=false;                                    //Use Trailing Stop

input string Comment_4="==========";                                 //Additional Settings
input int MagicNumber=0;                                             //Magic Number For The Orders Opened By This EA
input string OrderNote="";                                           //Comment For The Orders Opened By This EA
input int Slippage=5;                                                //Slippage in points
input int MaxSpread=100;                                             //Maximum Allowed Spread To Trade In Points


//-GLOBAL VARIABLES-//
//The variables included in this section are global, hence they can be used in any part of the code
//It is useful to add a comment to remember what is the variable for

bool IsPreChecksOk=false;                 //Indicates if the pre checks are satisfied
bool IsNewCandle=false;                   //Indicates if this is a new candle formed
bool IsSpreadOK=false;                    //Indicates if the spread is low enough to trade
bool IsOperatingHours=false;              //Indicates if it is possible to trade at the current time (server time)
bool IsTradedThisBar=false;               //Indicates if an order was already executed in the current candle

double TickValue=0;                       //Value of a tick in account currency at 1 lot
double LotSize=0;                         //Lot size for the position

int OrderOpRetry=10;                      //Number of attempts to retry the order submission
int TotalOpenOrders=0;                    //Number of total open orders
int TotalOpenBuy=0;                       //Number of total open buy orders
int TotalOpenSell=0;                      //Number of total open sell orders
int StopLossBy=SL_BY_POINTS;              //How the stop loss is passed for the lot size calculation

ENUM_SIGNAL_ENTRY SignalEntry=SIGNAL_ENTRY_NEUTRAL;      //Entry signal variable
ENUM_SIGNAL_EXIT SignalExit=SIGNAL_EXIT_NEUTRAL;         //Exit signal variable

double initialBalance = AccountBalance();

//ZigZag 
double permSwing[6];
int chancount=3; //Number of time frames from above array to populate


//-NATIVE MT4 EXPERT ADVISOR RUNNING FUNCTIONS-//

//OnInit is executed once, when the EA is loaded
//OnInit is also executed if the time frame or symbol for the chart is changed
int OnInit(){
   //It is useful to set a function to check the integrity of the initial parameters and call it as first thing
   CheckPreChecks();
   
   
   //If the initial pre checks have something wrong, stop the program
   if(!IsPreChecksOk){
      OnDeinit(INIT_FAILED);
      return(INIT_FAILED);
   }   
   //Function to initialize the values of the global variables
   InitializeVariables();
   
   //If everything is ok the function returns successfully and the control is passed to a timer or the OnTike function
   return(INIT_SUCCEEDED);
}


//The OnDeinit function is called just before terminating the program
void OnDeinit(const int reason){
   //You can include in this function something you want done when the EA closes
   //For example clean the chart form graphical objects, write a report to a file or some kind of alert
}


//The OnTick function is triggered every time MT4 receives a price change for the symbol in the chart
void OnTick(){
   if(AccountBalance() >= 2*initialBalance) 
      return;
   //Re-initialize the values of the global variables at every run
   InitializeVariables();
   //ScanOrders scans all the open orders and collect statistics, if an error occurs it skips to the next price change
   if(!ScanOrders()) return;
   //CheckNewBar checks if the price change happened at the start of a new bar
   CheckNewBar();
   //CheckOperationHours checks if the current time is in the operating hours
   CheckOperationHours();
   //CheckSpread checks if the spread is above the maximum spread allowed
   CheckSpread();
   //CheckTradedThisBar checks if there was already a trade executed in the current candle
   CheckTradedThisBar();
   //EvaluateExit contains the code to decide if there is an exit signal
   EvaluateExit();
   //ExecuteExit executes the exit in case there is an exit signal
   ExecuteExit();
   //Scan orders again in case some where closed, if an error occurs it skips to the next price change
   if(!ScanOrders()) return;
   //Execute Trailing Stop
   ExecuteTrailingStop();
   //EvaluateEntry contains the code to decide if there is an entry signal
   EvaluateEntry();
   //ExecuteEntry executes the entry in case there is an entry signal
   ExecuteEntry();
}


//-CUSTOM EA FUNCTIONS-//

//Perform integrity checks when the EA is loaded
void CheckPreChecks(){
   IsPreChecksOk=true;
   //Check if Live Trading is enabled in MT4
   if(!IsTradeAllowed()){
      IsPreChecksOk=false;
      Print("Live Trading is not enabled, please enable it in MT4 and chart settings");
      return;
   }
   //Check if the default stop loss you are setting in above the minimum and below the maximum
   if(DefaultStopLoss<MinStopLoss || DefaultStopLoss>MaxStopLoss){
      IsPreChecksOk=false;
      Print("Default Stop Loss must be between Minimum and Maximum Stop Loss Allowed");
      return;
   }
   //Check if the default take profit you are setting in above the minimum and below the maximum
   if(DefaultTakeProfit<MinTakeProfit || DefaultTakeProfit>MaxTakeProfit){
      IsPreChecksOk=false;
      Print("Default Take Profit must be between Minimum and Maximum Take Profit Allowed");
      return;
   }
   //Check if the Lot Size is between the minimum and maximum
   if(DefaultLotSize<MinLotSize || DefaultLotSize>MaxLotSize){
      IsPreChecksOk=false;
      Print("Default Lot Size must be between Minimum and Maximum Lot Size Allowed");
      return;
   }
   //Slippage must be >= 0
   if(Slippage<0){
      IsPreChecksOk=false;
      Print("Slippage must be a positive value");
      return;
   }
   //MaxSpread must be >= 0
   if(MaxSpread<0){
      IsPreChecksOk=false;
      Print("Maximum Spread must be a positive value");
      return;
   }
   //MaxRiskPerTrade is a % between 0 and 100
   if(MaxRiskPerTrade<0 || MaxRiskPerTrade>100){
      IsPreChecksOk=false;
      Print("Maximum Risk Per Trade must be a percentage between 0 and 100");
      return;
   }
}


//Initialize variables
void InitializeVariables(){
   IsNewCandle=false;
   IsTradedThisBar=false;
   IsOperatingHours=false;
   IsSpreadOK=false;
   
   LotSize=DefaultLotSize;
   TickValue=0;
   
   TotalOpenBuy=0;
   TotalOpenSell=0;
   TotalOpenOrders=0;
   
   SignalEntry=SIGNAL_ENTRY_NEUTRAL;
   SignalExit=SIGNAL_EXIT_NEUTRAL;
}


//Evaluate if there is an entry signal
void EvaluateEntry(){
   SignalEntry=SIGNAL_ENTRY_NEUTRAL;
   //if(!IsSpreadOK) return;    //If the spread is too high don't give an entry signal
   //if(UseTradingHours && !IsOperatingHours) return;      //If you are using trading hours and it's not a trading hour don't give an entry signal
   //if(!IsNewCandle) return;      //If you want to provide a signal only if it's a new candle opening
   //if(IsTradedThisBar) return;   //If you don't want to execute multiple trades in the same bar
   if(TotalOpenOrders>0) return; //If there are already open orders and you don't want to open more
   zigZag();
   //Alert("1:", permSwing[0]); 
   //Alert("2:", permSwing[1]); 
   //Alert("3:", permSwing[2]); 
   //Alert("4:", permSwing[3]); 
   
   
   //Volume 
   bool vol = increasingVol();
   
   //OBV
   bool upObv = increasingObv();
   bool downObv = decreasingObv();
   
   /* Dragon */
   double dragonH =iMA(Symbol(), PERIOD_CURRENT, 34, 0, MODE_EMA, PRICE_HIGH, 0);
   double dragonL =iMA(Symbol(), PERIOD_CURRENT, 34, 0, MODE_EMA, PRICE_LOW, 0);
   double dragonC =iMA(Symbol(), PERIOD_CURRENT, 34, 0, MODE_EMA, PRICE_CLOSE, 0);
   
   /* Trend */
   double trend = iMA(Symbol(), PERIOD_CURRENT, 89, 0, MODE_EMA, PRICE_CLOSE, 0);
   
   //This is where you should insert your Entry Signal for BUY orders
   //Include a condition to open a buy order, the condition will have to set SignalEntry=SIGNAL_ENTRY_BUY
   //&& l_h_hl() == true
   if(ZigZagUp() == true && TotalOpenBuy <= 0 && upObv == true && vol == true && trend < dragonC && Close[1] > Open[1] &&Close[0] > dragonH 
         && iADX(Symbol(), PERIOD_CURRENT, 20, PRICE_CLOSE, MODE_PLUSDI, 0) > iADX(Symbol(), PERIOD_CURRENT, 20, PRICE_CLOSE, MODE_MINUSDI, 0)){
      SignalEntry = SIGNAL_ENTRY_BUY;
   }
   //This is where you should insert your Entry Signal for SELL orders
   //Include a condition to open a sell order, the condition will have to set SignalEntry=SIGNAL_ENTRY_SELL 
  //&& h_l_lh() == true
  if(ZigZagDown() == true  && TotalOpenSell <= 0 &&downObv == true && vol == true && trend > dragonC && Close[1] < Open[1] && Close[0] < dragonL 
       && iADX(Symbol(), PERIOD_CURRENT, 20, PRICE_CLOSE, MODE_PLUSDI, 0) < iADX(Symbol(), PERIOD_CURRENT, 20, PRICE_CLOSE, MODE_MINUSDI, 0)){ 
      SignalEntry = SIGNAL_ENTRY_SELL;
   }
}


//Execute entry if there is an entry signal
void ExecuteEntry(){
   //If there is no entry signal no point to continue, exit the function
   if(SignalEntry==SIGNAL_ENTRY_NEUTRAL) return;
   int Operation;
   double OpenPrice=0;
   double StopLossPrice=0;
   double TakeProfitPrice=0;
   //If there is a Buy entry signal
   if(SignalEntry==SIGNAL_ENTRY_BUY){
      RefreshRates();   //Get latest rates
      Operation=OP_BUY; //Set the operation to BUY
      OpenPrice=Ask;    //Set the open price to Ask price
      //If the Stop Loss is fixed and the default stop loss is set
      if(StopLossMode==SL_FIXED && DefaultStopLoss>0){
         StopLossPrice=OpenPrice-DefaultStopLoss*Point;
      }
      //If the Stop Loss is automatic
      if(StopLossMode==SL_AUTO){
         //Set the Stop Loss to the custom stop loss price
         StopLossPrice=StopLossPriceCalculate(OP_BUY);
      }
      //If the Take Profix price is fixed and defined
      if(TakeProfitMode==TP_FIXED && DefaultTakeProfit>0){
         TakeProfitPrice=OpenPrice+DefaultTakeProfit*Point;
      }
      //If the Take Profit is automatic
      if(TakeProfitMode==TP_AUTO){
         //Set the Take Profit to the custom take profit price
         TakeProfitPrice=TakeProfitCalculate(OP_BUY);
      }
      //Normalize the digits for the float numbers
      OpenPrice=NormalizeDouble(OpenPrice,Digits());
      StopLossPrice=NormalizeDouble(StopLossPrice,Digits());
      TakeProfitPrice=NormalizeDouble(TakeProfitPrice,Digits());   
      //Submit the order  
      SendOrder(Operation,Symbol(),OpenPrice,StopLossPrice,TakeProfitPrice);
   }
   if(SignalEntry==SIGNAL_ENTRY_SELL){
      RefreshRates();   //Get latest rates
      Operation=OP_SELL; //Set the operation to SELL
      OpenPrice=Bid;    //Set the open price to Ask price
      //If the Stop Loss is fixed and the default stop loss is set
      if(StopLossMode==SL_FIXED && DefaultStopLoss>0){
         StopLossPrice=OpenPrice+DefaultStopLoss*Point();
      }
      //If the Stop Loss is automatic
      if(StopLossMode==SL_AUTO){
         //Set the Stop Loss to the custom stop loss price
         StopLossPrice=StopLossPriceCalculate(OP_SELL);
      }
      //If the Take Profix price is fixed and defined
      if(TakeProfitMode==TP_FIXED && DefaultTakeProfit>0){
         TakeProfitPrice=OpenPrice-DefaultTakeProfit*Point();
      }
      //If the Take Profit is automatic
      if(TakeProfitMode==TP_AUTO){
         //Set the Take Profit to the custom take profit price
         TakeProfitPrice=TakeProfitCalculate(OP_SELL);
      }
      //Normalize the digits for the float numbers
      OpenPrice=NormalizeDouble(OpenPrice,Digits());
      StopLossPrice=NormalizeDouble(StopLossPrice,Digits());
      TakeProfitPrice=NormalizeDouble(TakeProfitPrice,Digits());   
      //Submit the order  
      SendOrder(Operation,Symbol(),OpenPrice,StopLossPrice,TakeProfitPrice);
   }
   
}


//Evaluate if there is an exit signal
void EvaluateExit(){
   SignalExit=SIGNAL_EXIT_NEUTRAL;
   
   //This is where you should include your exit signal for BUY orders
   //If you want, include a condition to close the open buy orders, condition will have to set SignalExit=SIGNAL_EXIT_BUY then return 
   if(OrderType() == OP_BUY && (iClose(Symbol(), PERIOD_CURRENT, 0) >= 1.0025*OrderOpenPrice() 
      || (TimeCurrent()-OrderOpenTime() > 72000)
      || (OrderProfit() <-100 && TimeCurrent()-OrderOpenTime() > 36000)  
      || (OrderProfit() <- 75 && TimeCurrent()-OrderOpenTime() >24000)
      || (iClose(Symbol(), PERIOD_CURRENT, 0) >= 1.001*OrderOpenPrice()  && TimeCurrent()-OrderOpenTime() >36000))){
      SignalExit = SIGNAL_EXIT_BUY;
   }
   //This is where you should include your exit signal for SELL orders
   //If you want, include a condition to close the open sell orders, condition will have to set SignalExit=SIGNAL_EXIT_SELL then return 
   if(OrderType() == OP_SELL && (iClose(Symbol(), PERIOD_CURRENT, 0) <= 0.9975 * OrderOpenPrice()  
      || (TimeCurrent()-OrderOpenTime() > 72000)
      || (OrderProfit() < -100 && TimeCurrent()-OrderOpenTime() > 36000)  
      || (OrderProfit() <- 75 && TimeCurrent()-OrderOpenTime() >24000)
      || (iClose(Symbol(), PERIOD_CURRENT, 0) <= 0.999*OrderOpenPrice()  && TimeCurrent()-OrderOpenTime() >36000))){
      SignalExit =  SIGNAL_EXIT_SELL;
   }
   
   //This is where you should include your exit signal for ALL orders
   //If you want, include a condition to close all the open orders, condition will have to set SignalExit=SIGNAL_EXIT_ALL then return 
   
}


//Execute exit if there is an exit signal
void ExecuteExit(){
   //If there is no Exit Signal no point to continue the routine
   if(SignalExit==SIGNAL_EXIT_NEUTRAL) return;
   //If there is an exit signal for all orders
   if(SignalExit==SIGNAL_EXIT_ALL){
      //Close all orders
      CloseAll(OP_ALL);
   }
   //If there is an exit signal for BUY order
   if(SignalExit==SIGNAL_EXIT_BUY){
      //Close all BUY orders
      CloseAll(OP_BUY);
   }
   //If there is an exit signal for SELL orders
   if(SignalExit==SIGNAL_EXIT_SELL){
      //Close all SELL orders
      CloseAll(OP_SELL);
   }

}


//Execute Trailing Stop to limit losses and lock in profits
void ExecuteTrailingStop(){
   //If the option is off then exit
   if(!UseTrailingStop) return;
   //If there are no open orders no point to continue the code
   if(TotalOpenOrders==0) return;
   //if(!IsNewCandle) return;      //If you only want to do the stop trailing once at the beginning of a new candle
   //Scan all the orders to see if some needs a stop loss update
   for(int i=0;i<OrdersTotal();i++) {
      //If there is a problem reading the order print the error, exit the function and return false
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false){
         int Error=GetLastError();
         string ErrorText=GetLastErrorText(Error);
         Print("ERROR - Unable to select the order - ",Error," - ",ErrorText);
         return;
      }
      //If the order is not for the instrument on chart we can ignore it
      if(OrderSymbol()!=Symbol()) continue;
      //If the order has Magic Number different from the Magic Number of the EA then we can ignore it
      if(OrderMagicNumber()!=MagicNumber) continue;
      //Define current values
      RefreshRates();
      double SLPrice=NormalizeDouble(OrderStopLoss(),Digits());     //Current Stop Loss price for the order
      double TPPrice=NormalizeDouble(OrderTakeProfit(),Digits());   //Current Take Profit price for the order
      double Spread=MarketInfo(Symbol(),MODE_SPREAD)*Point();       //Current Spread for the instrument
      double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point(); //Minimum distance between current price and stop loss

      //If it is a buy order then trail stop for buy orders
      if(OrderType()==OP_BUY){
         //Include code to trail the stop for buy orders
         double NewSLPrice=0;
         
         //This is where you should include the code to assign a new value to the STOP LOSS
         
         
         double NewTPPrice=TPPrice;
         //Normalize the price before the submission
         NewSLPrice=NormalizeDouble(NewSLPrice,Digits());
         //If there is no new stop loss set then skip to next order
         if(NewSLPrice==0) continue;
         //If the new stop loss price is lower than the previous then skip to next order, we only move the stop closer to the price and not further away
         if(NewSLPrice<=SLPrice) continue;
         //If the distance between the current price and the new stop loss is not enough then skip to next order
         //This allows to avoid error 130 when trying to update the order
         if(Bid-NewSLPrice<StopLevel) continue;
         //Submit the update
         ModifyOrder(OrderTicket(),OrderOpenPrice(),NewSLPrice,NewTPPrice);         
      }
      //If it is a sell order then trail stop for sell orders
      if(OrderType()==OP_SELL){
         //Include code to trail the stop for sell orders
         double NewSLPrice=0;
         
         //This is where you should include the code to assign a new value to the STOP LOSS
         
         
         double NewTPPrice=TPPrice;
         //Normalize the price before the submission
         NewSLPrice=NormalizeDouble(NewSLPrice,Digits());
         //If there is no new stop loss set then skip to next order
         if(NewSLPrice==0) continue;
         //If the new stop loss price is higher than the previous then skip to next order, we only move the stop closer to the price and not further away
         if(NewSLPrice>=SLPrice) continue;
         //If the distance between the current price and the new stop loss is not enough then skip to next order
         //This allows to avoid error 130 when trying to update the order
         if(NewSLPrice-Ask<StopLevel) continue;
         //Submit the update
         ModifyOrder(OrderTicket(),OrderOpenPrice(),NewSLPrice,NewTPPrice);         
      }
   }
   return;
}


//Check and return if the spread is not too high
void CheckSpread(){
   //Get the current spread in points, the (int) transforms the double coming from MarketInfo into an integer to avoid a warning when compiling
   int SpreadCurr=(int)MarketInfo(Symbol(),MODE_SPREAD);
   if(SpreadCurr<=MaxSpread){
      IsSpreadOK=true;
   }
   else{
      IsSpreadOK=false;
   }
}


//Check and return if it is operation hours or not
void CheckOperationHours(){
   //If we are not using operating hours then IsOperatingHours is true and I skip the other checks
   if(!UseTradingHours){
      IsOperatingHours=true;
      return;
   }
   //Check if the current hour is between the allowed hours of operations, if so IsOperatingHours is set true
   if(TradingHourStart==TradingHourEnd && Hour()==TradingHourStart) IsOperatingHours=true;
   if(TradingHourStart<TradingHourEnd && Hour()>=TradingHourStart && Hour()<=TradingHourEnd) IsOperatingHours=true;
   if(TradingHourStart>TradingHourEnd && ((Hour()>=TradingHourStart && Hour()<=23) || (Hour()<=TradingHourEnd && Hour()>=0))) IsOperatingHours=true;
}


//Check if it is a new bar
datetime NewBarTime=TimeCurrent();
void CheckNewBar(){
   //NewBarTime contains the open time of the last bar known
   //if that open time is the same as the current bar then we are still in the current bar, otherwise we are in a new bar
   if(NewBarTime==iTime(Symbol(),PERIOD_CURRENT,0)) IsNewCandle=false;
   else{
      NewBarTime=iTime(Symbol(),PERIOD_CURRENT,0);
      IsNewCandle=true;
   }
}


//Check if there was already an order open this bar
datetime LastBarTraded;
void CheckTradedThisBar(){
   //LastBarTraded contains the open time the last trade
   //if that open time is in the same bar as the current then IsTradedThisBar is true
   if(iBarShift(Symbol(),PERIOD_CURRENT,LastBarTraded)==0) IsTradedThisBar=true;
   else IsTradedThisBar=false;
}


//Lot Size Calculator
void LotSizeCalculate(double SL=0){
   //If the position size is dynamic
   if(RiskDefaultSize==RISK_DEFAULT_AUTO){
      //If the stop loss is not zero then calculate the lot size
      if(SL!=0){
         double RiskBaseAmount=0;
         //TickValue is the value of the individual price increment for 1 lot of the instrument, expressed in the account currenty
         TickValue=MarketInfo(Symbol(),MODE_TICKVALUE);    
         //Define the base for the risk calculation depending on the parameter chosen    
         if(RiskBase==RISK_BASE_BALANCE) RiskBaseAmount=AccountBalance();
         if(RiskBase==RISK_BASE_EQUITY) RiskBaseAmount=AccountEquity();
         if(RiskBase==RISK_BASE_FREEMARGIN) RiskBaseAmount=AccountFreeMargin();
         //Calculate the Position Size
         LotSize=(RiskBaseAmount*MaxRiskPerTrade/100)/(SL*TickValue);
      }
      //If the stop loss is zero then the lot size is the default one
      if(SL==0){
         LotSize=DefaultLotSize;
      }
   }
   //Normalize the Lot Size to satisfy the allowed lot increment and minimum and maximum position size
   LotSize=MathFloor(LotSize/MarketInfo(Symbol(),MODE_LOTSTEP))*MarketInfo(Symbol(),MODE_LOTSTEP);
   //Limit the lot size in case it is greater than the maximum allowed by the user
   if(LotSize>MaxLotSize) LotSize=MaxLotSize;
   //Limit the lot size in case it is greater than the maximum allowed by the broker
   if(LotSize>MarketInfo(Symbol(),MODE_MAXLOT)) LotSize=MarketInfo(Symbol(),MODE_MAXLOT);
   //If the lot size is too small then set it to 0 and don't trade
   if(LotSize<MinLotSize || LotSize<MarketInfo(Symbol(), MODE_MINLOT)) LotSize=0;
}


//Stop Loss Price Calculation if dynamic
double StopLossPriceCalculate(int Command=-1){
   double StopLossPrice=0;
   //Include a value for the stop loss, ideally coming from an indicator
   return StopLossPrice;
}


//Take Profit Price Calculation if dynamic
double TakeProfitCalculate(int Command=-1){
   double TakeProfitPrice=0;
   //Include a value for the take profit, ideally coming from an indicator
   return TakeProfitPrice;
}


//Send Order Function adjusted to handle errors and retry multiple times
void SendOrder(int Command, string Instrument, double OpenPrice, double SLPrice, double TPPrice, datetime Expiration=0){
   //Retry a number of times in case the submission fails
   for(int i=1; i<=OrderOpRetry; i++){
      //Set the color for the open arrow for the order
      color OpenColor=clrBlueViolet;
      if(Command==OP_BUY){
         OpenColor=clrChartreuse;
      }
      if(Command==OP_SELL){
         OpenColor=clrDarkTurquoise;
      }
      //Calculate the position size, if the lot size is zero then exit the function
      double SLPoints=0;
      //If the Stop Loss price is set then find the points of distance between open price and stop loss price, and round it
      if(SLPrice>0) SLPoints=MathCeil(MathAbs(OpenPrice-SLPrice)/Point());
      //Call the function to calculate the position size
      LotSizeCalculate(SLPoints);
      //If the position size is zero then exit and don't submit any orderInit
      if(LotSize==0) return;
      //Submit the order
      int res=OrderSend(Instrument,Command,LotSize,OpenPrice,Slippage,NormalizeDouble(SLPrice,Digits()),NormalizeDouble(TPPrice,Digits()),OrderNote,MagicNumber,Expiration,OpenColor);
      //If the submission is successful print it in the log and exit the function
      if(res!=-1){
         Print("TRADE - OPEN SUCCESS - Order ",res," submitted: Command ",Command," Volume ",LotSize," Open ",OpenPrice," Stop ",SLPrice," Take ",TPPrice," Expiration ",Expiration);
         break;
      }
      //If the submission failed print the error
      else{
         Print("TRADE - OPEN FAILED - Order ",res," submitted: Command ",Command," Volume ",LotSize," Open ",OpenPrice," Stop ",SLPrice," Take ",TPPrice," Expiration ",Expiration);
         int Error=GetLastError();
         string ErrorText=GetLastErrorText(Error);
         Print("ERROR - NEW - error sending order, return error: ",Error," - ",ErrorText);
      } 
   }
   return;
}


//Modify Order Function adjusted to handle errors and retry multiple times
void ModifyOrder(int Ticket, double OpenPrice, double SLPrice, double TPPrice){
   //Try to select the order by ticket number and print the error if failed
   if(OrderSelect(Ticket,SELECT_BY_TICKET)==false){
      int Error=GetLastError();
      string ErrorText=GetLastErrorText(Error);
      Print("ERROR - SELECT TICKET - error selecting order ",Ticket," return error: ",Error);
      return;
   }
   //Normalize the digits for stop loss and take profit price
   SLPrice=NormalizeDouble(SLPrice,Digits());
   TPPrice=NormalizeDouble(TPPrice,Digits());
   //Try to submit the changes multiple times
   for(int i=1; i<=OrderOpRetry; i++){
      //Submit the change
      bool res=OrderModify(Ticket,OpenPrice,SLPrice,TPPrice,0,Blue);
      //If the change is successful print the result and exit the function
      if(res){
         Print("TRADE - UPDATE SUCCESS - Order ",Ticket," new stop loss ",SLPrice," new take profit ",TPPrice);
         break;
      }
      //If the change failed print the error with additional information to troubleshoot
      else{
         int Error=GetLastError();
         string ErrorText=GetLastErrorText(Error);
         Print("ERROR - UPDATE FAILED - error modifying order ",Ticket," return error: ",Error," Open=",OpenPrice,
               " Old SL=",OrderStopLoss()," Old TP=",OrderTakeProfit(),
               " New SL=",SLPrice," New TP=",TPPrice," Bid=",MarketInfo(OrderSymbol(),MODE_BID)," Ask=",MarketInfo(OrderSymbol(),MODE_ASK));
         Print("ERROR - ",ErrorText);
      } 
   }
   return;
}


//Close Single Order Function adjusted to handle errors and retry multiple times
void CloseOrder(int Ticket, double Lots, double CurrentPrice){
   //Try to close the order by ticket number multiple times in case of failure
   for(int i=1; i<=OrderOpRetry; i++){
      //Send the close command
      bool res=OrderClose(Ticket,Lots,CurrentPrice,Slippage,Red);
      //If the close was successful print the resul and exit the function
      if(res){
         Print("TRADE - CLOSE SUCCESS - Order ",Ticket," closed at price ",CurrentPrice);
         break;
      }
      //If the close failed print the error
      else{
         int Error=GetLastError();
         string ErrorText=GetLastErrorText(Error);
         Print("ERROR - CLOSE FAILED - error closing order ",Ticket," return error: ",Error," - ",ErrorText);
      } 
   }
   return;
}


//Close All Orders of a specified type
const int OP_ALL=-1; //Constant to define the additional OP_ALL command which is the reference to all type of orders
void CloseAll(int Command){
   //If the command is OP_ALL then run the CloseAll function for both BUY and SELL orders
   if(Command==OP_ALL){
      CloseAll(OP_BUY);
      CloseAll(OP_SELL);
      return;
   }
   double ClosePrice=0;
   //Scan all the orders to close them individually
   //NOTE that the for loop scans from the last to the first, this is because when we close orders the list of orders is updated
   //hence the for loop would skip orders if we scan from first to last
   for(int i=OrdersTotal()-1; i>=0; i--) {
      //First select the order individually to get its details, if the selection fails print the error and exit the function
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) == false ) {
         Print("ERROR - Unable to select the order - ",GetLastError());
         break;
      }
      //Check if the order is for the current symbol and was opened by the EA and is the type to be closed
      if(OrderMagicNumber()==MagicNumber && OrderSymbol()==Symbol() && OrderType()==Command) {
         //Define the close price
         RefreshRates();
         if(Command==OP_BUY) ClosePrice=Bid;
         if(Command==OP_SELL) ClosePrice=Ask;
         //Get the position size and the order identifier (ticket)
         double Lots=OrderLots();
         int Ticket=OrderTicket();
         //Close the individual order
         CloseOrder(Ticket,Lots,ClosePrice);
      }
   }
}


//Scan all orders to find the ones submitted by the EA
//NOTE This function is defined as bool because we want to return true if it is successful and false if it fails
bool ScanOrders(){
   //Scan all the orders, retrieving some of the details
   for(int i=0;i<OrdersTotal();i++) {
      //If there is a problem reading the order print the error, exit the function and return false
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false){
         int Error=GetLastError();
         string ErrorText=GetLastErrorText(Error);
         Print("ERROR - Unable to select the order - ",Error," - ",ErrorText);
         return false;
      }
      //If the order is not for the instrument on chart we can ignore it
      if(OrderSymbol()!=Symbol()) continue;
      //If the order has Magic Number different from the Magic Number of the EA then we can ignore it
      if(OrderMagicNumber()!=MagicNumber) continue;
      //If it is a buy order then increment the total count of buy orders
      if(OrderType()==OP_BUY) TotalOpenBuy++;
      //If it is a sell order then increment the total count of sell orders
      if(OrderType()==OP_SELL) TotalOpenSell++;
      //Increment the total orders count
      TotalOpenOrders++;
      //Find what is the open time of the most recent trade and assign it to LastBarTraded
      //this is necessary to check if we already traded in the current candle
      if(OrderOpenTime()>LastBarTraded || LastBarTraded==0) LastBarTraded=OrderOpenTime();
   }
   return true;
}

bool increasingObv(){
   double averageP10Obv = 0;
   double currObv = iOBV(Symbol(), PERIOD_CURRENT, PRICE_CLOSE, 0);
  for(int i=1; i <= 10; i++){
   averageP10Obv += iOBV(Symbol(),PERIOD_CURRENT, PRICE_CLOSE, i)/10;
}
if(currObv-averageP10Obv > 0) // +ve Slope(Trend)
   return true;
return false;
}

bool decreasingObv(){
    double averageP10Obv = 0;
   double currObv = iOBV(Symbol(), PERIOD_CURRENT, PRICE_CLOSE, 0);
  for(int i=1; i <= 10; i++){
   averageP10Obv += iOBV(Symbol(),PERIOD_CURRENT, PRICE_CLOSE, i)/10;
}
if(currObv-averageP10Obv < 0) // -ve Slope(Trend)
   return true;
return false;
}
bool increasingVol(){
   double averageP10Vol = 0;
   double currVol = iVolume(Symbol(), PERIOD_H1, 0);
  for(int i=1; i <= 10; i++){
   averageP10Vol += (iVolume(Symbol(),PERIOD_H1,  i)/10);
   }
if(currVol > 2*(averageP10Vol))
   return true;
return false;
}

//1. Past < dragonLow
bool l_h_hl(){
   int pastIndex = 99;
   double currentPoint =0;
   double previousPoint = 0;
   double pastPoint = 0;
   for(int i=1 ; i <= pastIndex+3; i++){
      if(currentPoint == 0){
         currentPoint = iClose(Symbol(), PERIOD_H1, i);
         continue;
      }
      else if(currentPoint !=0 && currentPoint < iClose(Symbol(), PERIOD_M15, i) && previousPoint == 0){
         currentPoint = iClose(Symbol(),PERIOD_H1, i);
         continue;
      }
      else if(previousPoint == 0){
         previousPoint = iClose(Symbol(), PERIOD_H1, i);
         continue;
      }
      else if(previousPoint != 0 && previousPoint > iClose(Symbol(), PERIOD_H1, i) && pastPoint == 0){
         previousPoint = iClose(Symbol(), PERIOD_H1, i);
         continue;
      }
      else if(pastPoint == 0){
         pastIndex = i;
         pastPoint = iClose(Symbol(), PERIOD_H1, i);
         continue;
      }
      else if(pastPoint != 0 && pastPoint < iClose(Symbol(), PERIOD_H1, i) && pastPoint == 0){
         pastIndex = i;
         pastPoint = iClose(Symbol(), PERIOD_H1, i);
         continue;
      }
      else
         break;
         //if(iClose(Symbol(),PERIOD_M15, i) > previousPoint)
            //return false;;
   }
   if(pastPoint == 0 || previousPoint ==0 || currentPoint ==0) 
      return false;
   if(pastPoint > currentPoint && previousPoint < currentPoint && pastPoint > iMA(Symbol(), PERIOD_CURRENT, 34, 0, MODE_EMA, PRICE_HIGH, 0));
      return true;

   return false;
}

//1. Past > dragonHigh
bool h_l_lh(){
    int pastIndex = 0;
   double currentPoint =0;
   double previousPoint = 0;
   double pastPoint = 0;
   for(int i=1 ; i < 10; i++){
      if(currentPoint == 0){
         currentPoint = iClose(Symbol(), PERIOD_H1, i);
         continue;
      }
      else if(currentPoint !=0 && currentPoint > iClose(Symbol(), PERIOD_M15, i) && previousPoint == 0){
         currentPoint = iClose(Symbol(),PERIOD_H1, i);
         continue;
      }
      else if(previousPoint == 0){
         previousPoint = iClose(Symbol(), PERIOD_H1, i);
         continue;
      }
      else if(previousPoint != 0 && previousPoint < iClose(Symbol(), PERIOD_M15, i) && pastPoint == 0){
         previousPoint = iClose(Symbol(), PERIOD_H1, i);
         continue;
      }
      else if(pastPoint == 0){
         pastIndex = i;
         pastPoint = iClose(Symbol(), PERIOD_H1, i);
         continue;
      }
      else if(pastPoint != 0 && pastPoint > iClose(Symbol(), PERIOD_M15, i) && pastPoint == 0){
         pastIndex = i;
         pastPoint = iClose(Symbol(), PERIOD_H1, i);
         continue;
      }
      else
         if(iClose(Symbol(),PERIOD_H1, i) < previousPoint)
            return false;
   }
   if(pastPoint == 0 || previousPoint ==0 || currentPoint ==0 ) 
      return false;
   if(pastPoint < currentPoint && previousPoint > currentPoint && pastPoint < iMA(Symbol(), PERIOD_CURRENT, 34, 0, MODE_EMA, PRICE_LOW, 0));
      return true;

   return false;
}

void zigZag(){
   for(int j=0;j<chancount;j++){
      int found=0;
      int i=0;
      while(found < 4){
         if(iCustom(Symbol(),PERIOD_H1,"ZigZag",9,5,3,0,i)!=0){
            permSwing[found]=iCustom(Symbol(),PERIOD_H1,"ZigZag",9,5,3,0,i);
            found++;
         }
         i++;
      }
   }
}

bool ZigZagUp(){
   //Check L-H-HL
   if(permSwing[3] < permSwing[1] && permSwing[2] > permSwing[1])
      if(permSwing[0] > permSwing[1])
         return true;
   return false;
}

bool ZigZagDown(){
   //Check H-L-LH
    if(permSwing[3] > permSwing[1] && permSwing[2] < permSwing[1])
      if(permSwing[0] < permSwing[1])
         return true;
   return false;
}