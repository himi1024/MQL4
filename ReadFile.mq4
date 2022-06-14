//+------------------------------------------------------------------+
//|                                                     ReadFile.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <WinUser32.mqh>

#import "kernel32.dll"
   int CreateFileW(string, uint, int, int, int, int, int);
   int GetFileSize(int, int);
   int ReadFile(int, uchar&[], int, int&[], int);
   int CloseHandle(int);

#import
int BytesToRead = 0;

 string CovertDateTime(){ //Get your current logs to read for example today is 28.02.2020 so logs will be 20200228
 datetime now = TimeCurrent(),
         yesterday = now - 86400; // PERIOD_D1 * 60
 string logFile2=TimeToStr(yesterday);
 string logFile1=TimeToStr(TimeCurrent(),TIME_DATE);
 StringReplace(logFile1,".","");

 return logFile1;
 }
string File = CovertDateTime();
string terminal_data_path=TerminalInfoString(TERMINAL_DATA_PATH); 
string filename= File +".log";
//string path=terminal_data_path+"/MQL4/Logs/"+File+".log";//if dont want with this condition to find your logs please remove this line and put the next line your path;
//string path = "C:/Users/Gavyy/AppData/Roaming/MetaQuotes/Terminal/A270C22676FD87E1F4CE8044BDE1756D2/logs/20200225.log";
string path = "C:/Program Files (x86)/MetaTrader 4/MQL4/Logs/20220614.log";

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   string a = ReadFile(path);
   Alert(a);
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
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+

string ReadFile(string Filename){
   string strFileContents = "";
   int Handle = CreateFileW(Filename, 0x8000000, 3, 0, 3, 0, 0);
   
   if (Handle == -1){
      //Error opening file
      Print("Error opening log file", path, "error code: ", IntegerToString(GetLastError()));
      return ("Error opening log file");
   }
   else{
      int LogFileSize = GetFileSize(Handle, 0);
      BytesToRead = LogFileSize;
      if(LogFileSize <= 0){
         //Empty File
         Print("Log file is empty ", path);
         return ("Log file is empty");
      }
      else{
         uchar buffer[];
         ArrayResize(buffer, BytesToRead);
         int read[1];
         ReadFile(Handle, buffer, BytesToRead, read, 0);
         
         if (read[0] == BytesToRead){
            strFileContents = CharArrayToString(buffer, 0, read[0]);
         }
         else{
            Print("Error reading log file ", path);
            return ("Error reading log file");
         }
         
         strFileContents = CharArrayToString(buffer, 0, read[0]);
      }
              
      CloseHandle(Handle);
   }

   return strFileContents;
}