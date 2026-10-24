#property strict

#ifndef FER3ON_SIGNAL_CONTRACT_MQH
#define FER3ON_SIGNAL_CONTRACT_MQH

#include "Domain.mqh"
#include "BuildInfo.mqh"

struct FER3ON_SIGNAL
  {
   string signal_id;
   string strategy_id;
   string strategy_version;
   string symbol;
   ENUM_TIMEFRAMES timeframe;
   FER3ON_DIRECTION direction;
   FER3ON_SIGNAL_STATE state;
   double entry_price;
   string structure_bias;
   string location_type;
   string reaction_type;
   string thesis;
   double confidence;
   datetime created_bar_time;
   datetime expires_bar_time;
   FER3ON_REASON reasons[];
   string build_id;
  };

void FER3ON_InitSignal(FER3ON_SIGNAL &signal,const string strategy_id,const string strategy_version,const string symbol,ENUM_TIMEFRAMES timeframe)
  {
   signal.signal_id="";
   signal.strategy_id=strategy_id;
   signal.strategy_version=strategy_version;
   signal.symbol=symbol;
   signal.timeframe=timeframe;
   signal.direction=FER3ON_DIRECTION_NONE;
   signal.state=FER3ON_STATE_WAIT;
   signal.entry_price=0.0;
   signal.structure_bias="";
   signal.location_type="";
   signal.reaction_type="";
   signal.thesis="";
   signal.confidence=0.0;
   signal.created_bar_time=0;
   signal.expires_bar_time=0;
   ArrayResize(signal.reasons,0);
   signal.build_id=FER3ON_BUILD_ID;
  }

#endif
