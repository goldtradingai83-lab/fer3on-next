#property strict

#ifndef FER3ON_DECISION_CONTRACT_MQH
#define FER3ON_DECISION_CONTRACT_MQH

#include "SignalContract.mqh"

struct FER3ON_TRADE_PLAN
  {
   bool valid;
   double entry;
   double structural_sl;
   double structural_target;
   double risk_distance;
   double reward_distance;
   double rr_ratio;
   double risk_cash;
   double lot_theoretical;
   double lot_final;
   string reason_code;
  };

struct FER3ON_RISK_DECISION
  {
   bool approved;
   string reason_code;
   double account_equity;
   double daily_pnl;
   double daily_loss_limit;
   double open_exposure;
   double same_direction_exposure;
   double margin_required;
   double margin_free;
  };

struct FER3ON_EXECUTION_RESULT
  {
   FER3ON_ACTION action;
   long retcode;
   ulong ticket;
   double fill_price;
   double sl;
   double tp;
   double volume;
   string execution_reason;
  };

#endif
