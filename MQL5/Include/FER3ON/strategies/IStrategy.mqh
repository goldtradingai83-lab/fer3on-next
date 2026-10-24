#property strict

#ifndef FER3ON_ISTRATEGY_MQH
#define FER3ON_ISTRATEGY_MQH

#include "../SignalContract.mqh"
#include "../DecisionContract.mqh"
#include "../Domain.mqh"

class IFER3ONStrategy
  {
public:
   virtual string Id()=0;
   virtual string Version()=0;
   virtual bool Evaluate(const FER3ON_MARKET_CONTEXT &context,FER3ON_SIGNAL &signal)=0;
   virtual bool BuildTrade(const FER3ON_SIGNAL &signal,const FER3ON_MARKET_CONTEXT &context,FER3ON_TRADE_PLAN &plan)=0;
  };

#endif
