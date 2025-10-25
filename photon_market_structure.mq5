string symbol = "XAUUSD";                     // symbol chart for market structure           
int trend = -1;                               // 1 is bullish, 0 is bearish
ENUM_TIMEFRAMES timeframe = PERIOD_D1;        // specify timeframe for which you want to get marketstructure

double higher_low = 0.0;            // when trend is bullish
double higher_high = 0.0;

double lower_high = 0.0;            // when trend is bearish
double lower_low = 0.0;

int OnInit() {

   return INIT_SUCCEEDED;
}

void OnTick() {
   trend = get_trend_100();
}

int get_trend_100() {
   int trend_100 = 1;
   
   double high = iHigh(symbol, timeframe, 100);
   double low = iLow(symbol, timeframe, 100);
   
   double higher_high = high;
   double higher_low = low;
   double pullback_higher_low = high;
   
   double lower_low = low;
   double lower_high = high;
   double pullback_lower_high = low;
   
   for (int i = 100; i > 0; i--) {
      high = iHigh(symbol, timeframe, i);
      low = iLow(symbol, timeframe, i);
      
      if (trend_100 == 1) {            // in bullish trend
         
         if (high < higher_high) {     // pullback
            if (low < higher_low) {    // change of charackter
               Print("low ", low, " of ", iTime(symbol, timeframe, i), " break higher low ", higher_low);
               Print("trend switched bearish");
               Print("lower high is ", higher_high);
               Print("---------");
               
               trend_100 = 0;          
               
               lower_low = low;
               lower_high = higher_high;
               pullback_lower_high = low;
               
               
               
            } else {
               if (low < pullback_higher_low) {
                  pullback_higher_low = low;
               }
            }
                     
         } else {                   // we are purely bullish without pullback or having a BOS
            
            if (pullback_higher_low != higher_high) {     // we having break of structure and need to set new higher low
               
               if (low < pullback_higher_low) {           // if low of the candle that caused BOS is lower than pullback_higher_low
                  higher_low = low;
               } else {
                  higher_low = pullback_higher_low;
               }
               
               Print("Bullish break of structure at ", iTime(symbol, timeframe, i));
               Print("New higher low is ", higher_low);
               Print("-----------");
               
            }
            
            higher_high = high;
            
            pullback_higher_low = high;
         }         
         
      } else {          // in bearish trend

         if (low > lower_low) {        // pullback
            if (high > lower_high) {   // change of character
               Print("high ", high, " of ", iTime(symbol, timeframe, i), " break lower high ", lower_high);
               Print("trend switched bullish");
               Print("higher low is ", lower_low);
               Print("---------");
            
               trend_100 = 1;          // trend is bullish now
               
               higher_high = high;
               higher_low = lower_low;
               pullback_higher_low = high;
                              
            } else {
               if (high > pullback_lower_high) {
                  pullback_lower_high = high;
               }
            }
            
         } else {       // continuing bearish or BOS occured
            
            if (pullback_lower_high != lower_high) {     // BOS
            
               if (high > pullback_lower_high) {
                  lower_high = high;
               } else {
                  lower_high = pullback_lower_high;
               }
               
               Print("Bearish break of structure at: ", iTime(symbol, timeframe, i));
               Print("New lower high: ", lower_high);
               Print("----------------");
            }
            
            lower_low = low;
            pullback_lower_high = low;
         }
      }
   }
   
   return trend_100;
}
