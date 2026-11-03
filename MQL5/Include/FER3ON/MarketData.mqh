#property strict

#ifndef FER3ON_MARKET_DATA_MQH
#define FER3ON_MARKET_DATA_MQH

#include "Domain.mqh"

// Phase 2 contract: bars are always closed bars. Position 0 is never read.
struct FER3ON_BAR
  {
   datetime time;
   double   open;
   double   high;
   double   low;
   double   close;
   long     tick_volume;
   long     real_volume;
   int      spread_points;
  };

struct FER3ON_TICK
  {
   datetime time;
   double   bid;
   double   ask;
   double   last;
   ulong    volume;
   uint     flags;
  };

struct FER3ON_MARKET_DATA_STATUS
  {
   bool     valid;
   bool     enough_bars;
   bool     has_tick;
   bool     has_gap;
   int      bars_requested;
   int      bars_loaded;
   datetime newest_closed_bar;
   datetime oldest_loaded_bar;
   datetime gap_time;
   string   reason_code;
   string   detail;
  };

struct FER3ON_MARKET_SNAPSHOT
  {
   bool                  valid;
   string                symbol;
   ENUM_TIMEFRAMES       timeframe;
   FER3ON_TICK           tick;
   FER3ON_BAR            latest_closed;
   FER3ON_MARKET_DATA_STATUS status;
  };

class CFer3onMarketData
  {
private:
   int PeriodSeconds(const ENUM_TIMEFRAMES timeframe) const
     {
      int seconds=PeriodSeconds(timeframe);
      if(seconds<=0) return 0;
      return seconds;
     }

   void ResetStatus(FER3ON_MARKET_DATA_STATUS &status,const int requested) const
     {
      status.valid=false;
      status.enough_bars=false;
      status.has_tick=false;
      status.has_gap=false;
      status.bars_requested=requested;
      status.bars_loaded=0;
      status.newest_closed_bar=0;
      status.oldest_loaded_bar=0;
      status.gap_time=0;
      status.reason_code="UNINITIALIZED";
      status.detail="";
     }

   bool IsFinitePositive(const double value) const
     {
      return value>0.0 && MathIsValidNumber(value);
     }

public:
   // Reads from start_pos=1 by design: the forming candle at position 0 is excluded.
   bool LoadClosedBars(const string symbol,
                       const ENUM_TIMEFRAMES timeframe,
                       const int requested,
                       FER3ON_BAR &bars[],
                       FER3ON_MARKET_DATA_STATUS &status,
                       const int max_gap_periods=3) const
     {
      ResetStatus(status,requested);
      ArrayResize(bars,0);

      if(symbol=="" || requested<=0)
        {
         status.reason_code="INVALID_REQUEST";
         status.detail="symbol and requested bars must be valid";
         return false;
        }

      const int period_seconds=PeriodSeconds(timeframe);
      if(period_seconds<=0)
        {
         status.reason_code="UNSUPPORTED_TIMEFRAME";
         status.detail="timeframe has no valid period length";
         return false;
        }

      MqlRates raw[];
      ArraySetAsSeries(raw,true);
      const int copied=CopyRates(symbol,timeframe,1,requested,raw);
      if(copied<=0)
        {
         status.reason_code="COPY_RATES_FAILED";
         status.detail=IntegerToString(GetLastError());
         return false;
        }

      ArrayResize(bars,copied);
      for(int i=0;i<copied;i++)
        {
         bars[i].time=raw[i].time;
         bars[i].open=raw[i].open;
         bars[i].high=raw[i].high;
         bars[i].low=raw[i].low;
         bars[i].close=raw[i].close;
         bars[i].tick_volume=(long)raw[i].tick_volume;
         bars[i].real_volume=(long)raw[i].real_volume;
         bars[i].spread_points=(int)raw[i].spread;

         if(bars[i].time<=0 ||
            !IsFinitePositive(bars[i].open) ||
            !IsFinitePositive(bars[i].high) ||
            !IsFinitePositive(bars[i].low) ||
            !IsFinitePositive(bars[i].close) ||
            bars[i].high<bars[i].low)
           {
            status.reason_code="INVALID_BAR";
            status.detail="invalid OHLC data at index "+IntegerToString(i);
            ArrayResize(bars,0);
            return false;
           }

         // CopyRates is series-oriented here: index 0 is the newest closed bar.
         if(i>0)
           {
            const int delta=(int)(bars[i-1].time-bars[i].time);
            const int allowed=MathMax(period_seconds,max_gap_periods*period_seconds);
            if(delta<=0)
              {
               status.reason_code="NON_MONOTONIC_BARS";
               status.detail="bar timestamps are not strictly ordered";
               ArrayResize(bars,0);
               return false;
              }
            // A large gap is reported, not silently repaired or filled.
            if(delta>allowed)
              {
               status.has_gap=true;
               if(status.gap_time==0) status.gap_time=bars[i-1].time;
              }
           }
        }

      status.bars_loaded=copied;
      status.enough_bars=(copied>=requested);
      status.newest_closed_bar=bars[0].time;
      status.oldest_loaded_bar=bars[copied-1].time;
      if(!status.enough_bars)
        {
         status.reason_code="INSUFFICIENT_BARS";
         status.detail="requested="+IntegerToString(requested)+" loaded="+IntegerToString(copied);
         return false;
        }
      if(status.has_gap)
        {
         status.reason_code="DATA_GAP_DETECTED";
         status.detail="gap starts near "+TimeToString(status.gap_time,TIME_DATE|TIME_MINUTES);
         return false;
        }

      status.valid=true;
      status.reason_code="OK";
      status.detail="closed bars only; position 0 excluded";
      return true;
     }

   bool ReadTick(const string symbol,FER3ON_TICK &tick,string &reason_code,string &detail) const
     {
      tick.time=0;
      tick.bid=0.0;
      tick.ask=0.0;
      tick.last=0.0;
      tick.volume=0;
      tick.flags=0;
      reason_code="UNINITIALIZED";
      detail="";

      if(symbol=="")
        {
         reason_code="INVALID_SYMBOL";
         detail="symbol is empty";
         return false;
        }

      MqlTick raw;
      ZeroMemory(raw);
      if(!SymbolInfoTick(symbol,raw))
        {
         reason_code="TICK_UNAVAILABLE";
         detail=IntegerToString(GetLastError());
         return false;
        }
      if(!IsFinitePositive(raw.bid) || !IsFinitePositive(raw.ask) || raw.ask<raw.bid)
        {
         reason_code="INVALID_TICK";
         detail="bid/ask are not valid";
         return false;
        }

      tick.time=raw.time;
      tick.bid=raw.bid;
      tick.ask=raw.ask;
      tick.last=raw.last;
      tick.volume=raw.volume;
      tick.flags=raw.flags;
      reason_code="OK";
      detail="valid bid/ask tick";
      return true;
     }

   bool BuildSnapshot(const string symbol,
                      const ENUM_TIMEFRAMES timeframe,
                      const int requested,
                      FER3ON_MARKET_SNAPSHOT &snapshot) const
     {
      snapshot.valid=false;
      snapshot.symbol=symbol;
      snapshot.timeframe=timeframe;
      string tick_reason="";
      string tick_detail="";
      snapshot.status.has_tick=ReadTick(symbol,snapshot.tick,tick_reason,tick_detail);

      FER3ON_BAR bars[];
      if(!LoadClosedBars(symbol,timeframe,requested,bars,snapshot.status))
        {
         if(!snapshot.status.has_tick)
           {
            snapshot.status.reason_code="MARKET_DATA_INVALID";
            snapshot.status.detail=snapshot.status.detail+"; tick="+tick_reason+":"+tick_detail;
           }
         return false;
        }
      if(!snapshot.status.has_tick)
        {
         snapshot.status.valid=false;
         snapshot.status.reason_code="TICK_UNAVAILABLE";
         snapshot.status.detail=tick_detail;
         return false;
        }

      snapshot.latest_closed=bars[0];
      snapshot.status.valid=true;
      snapshot.valid=true;
      return true;
     }
  };

#endif
