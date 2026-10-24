#property strict

#ifndef FER3ON_TRADE_JOURNAL_MQH
#define FER3ON_TRADE_JOURNAL_MQH

#include "BuildInfo.mqh"
#include "SignalContract.mqh"
#include "DecisionContract.mqh"

class CFer3onTradeJournal
  {
private:
   int    m_handle;
   string m_file;
   bool   m_ready;

   bool IsSignalComplete(const FER3ON_SIGNAL &signal)
     {
      if(signal.build_id=="" || signal.strategy_id=="" || signal.strategy_version=="") return false;
      if(signal.symbol=="" || signal.created_bar_time<=0) return false;
      if(signal.state==FER3ON_STATE_ENTER && signal.direction==FER3ON_DIRECTION_NONE) return false;
      if(signal.state==FER3ON_STATE_ENTER && signal.entry_price<=0.0) return false;
      return true;
     }

   bool IsPlanComplete(const FER3ON_TRADE_PLAN &plan)
     {
      if(!plan.valid) return false;
      if(plan.entry<=0.0 || plan.structural_sl<=0.0 || plan.structural_target<=0.0) return false;
      if(plan.risk_distance<=0.0 || plan.reward_distance<=0.0) return false;
      if(plan.rr_ratio<=0.0 || plan.lot_final<=0.0) return false;
      return true;
     }

   string DirectionText(const FER3ON_DIRECTION direction)
     {
      if(direction==FER3ON_DIRECTION_BUY) return "BUY";
      if(direction==FER3ON_DIRECTION_SELL) return "SELL";
      return "NONE";
     }

public:
   CFer3onTradeJournal(void)
     {
      m_handle=INVALID_HANDLE;
      m_file="";
      m_ready=false;
     }

   bool Open(const string file_name)
     {
      m_file=file_name;
      m_handle=FileOpen(m_file,FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_SHARE_READ,';');
      if(m_handle==INVALID_HANDLE)
        {
         m_ready=false;
         return false;
        }
      if(FileSize(m_handle)==0)
        {
         FileWrite(m_handle,
                   "event_time","event_type","build_id","signal_id","strategy_id",
                   "strategy_version","symbol","timeframe","state","direction",
                   "entry","sl","tp","risk_cash","lot_theoretical","lot_final",
                   "rr_ratio","reason_code","detail");
         FileFlush(m_handle);
        }
      FileSeek(m_handle,0,SEEK_END);
      m_ready=true;
      return true;
     }

   void Close(void)
     {
      if(m_handle!=INVALID_HANDLE) FileClose(m_handle);
      m_handle=INVALID_HANDLE;
      m_ready=false;
     }

   bool Ready(void) const { return m_ready && m_handle!=INVALID_HANDLE; }

   bool WriteDecision(const FER3ON_SIGNAL &signal,const FER3ON_TRADE_PLAN &plan,const string reason_code,const string detail)
     {
      // A journal entry must be explainable even when the strategy waits.
      if(!Ready() || !IsSignalComplete(signal)) return false;
      if(signal.state==FER3ON_STATE_ENTER && !IsPlanComplete(plan)) return false;

      FileWrite(m_handle,
                TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),
                "DECISION",signal.build_id,signal.signal_id,signal.strategy_id,
                signal.strategy_version,signal.symbol,(int)signal.timeframe,
                (int)signal.state,DirectionText(signal.direction),
                DoubleToString(plan.entry,_Digits),
                DoubleToString(plan.structural_sl,_Digits),
                DoubleToString(plan.structural_target,_Digits),
                DoubleToString(plan.risk_cash,2),
                DoubleToString(plan.lot_theoretical,2),
                DoubleToString(plan.lot_final,2),
                DoubleToString(plan.rr_ratio,2),reason_code,detail);
      FileFlush(m_handle);
      return true;
     }

   bool WriteExecution(const FER3ON_SIGNAL &signal,const FER3ON_EXECUTION_RESULT &result,const string reason_code)
     {
      if(!Ready() || !IsSignalComplete(signal)) return false;
      FileWrite(m_handle,
                TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),
                "EXECUTION",signal.build_id,signal.signal_id,signal.strategy_id,
                signal.strategy_version,signal.symbol,(int)signal.timeframe,
                (int)signal.state,DirectionText(signal.direction),
                DoubleToString(result.fill_price,_Digits),
                DoubleToString(result.sl,_Digits),DoubleToString(result.tp,_Digits),
                "", "", DoubleToString(result.volume,2), "",
                reason_code,LongToString(result.retcode));
      FileFlush(m_handle);
      return true;
     }
  };

#endif
