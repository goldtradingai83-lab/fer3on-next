#property strict

#ifndef FER3ON_DOMAIN_MQH
#define FER3ON_DOMAIN_MQH

enum FER3ON_DIRECTION
  {
   FER3ON_DIRECTION_NONE = 0,
   FER3ON_DIRECTION_BUY  = 1,
   FER3ON_DIRECTION_SELL = -1
  };

enum FER3ON_SIGNAL_STATE
  {
   FER3ON_STATE_WAIT = 0,
   FER3ON_STATE_ENTER,
   FER3ON_STATE_EXPIRED,
   FER3ON_STATE_INVALID
  };

enum FER3ON_ACTION
  {
   FER3ON_ACTION_SKIPPED = 0,
   FER3ON_ACTION_SENT,
   FER3ON_ACTION_REJECTED
  };

struct FER3ON_REASON
  {
   string code;
   string detail;
  };

struct FER3ON_MARKET_CONTEXT
  {
   string symbol;
   ENUM_TIMEFRAMES timeframe;
   datetime closed_bar_time;
   double bid;
   double ask;
   double atr;
   string trend;
   string regime;
   string session;
  };

#endif
