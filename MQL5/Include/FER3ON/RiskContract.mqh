#property strict

#ifndef FER3ON_RISK_CONTRACT_MQH
#define FER3ON_RISK_CONTRACT_MQH

// Phase 1 safety envelope. These values are centralized here and must not be
// redefined in strategy files.
#define FER3ON_START_LOT              0.01
#define FER3ON_PHASE1_MAX_LOT         0.02
#define FER3ON_DAILY_LOSS_PERCENT     5.0
#define FER3ON_DAILY_LOSS_CASH        50.0
#define FER3ON_MAX_OPEN_TRADES        4
#define FER3ON_BREAK_EVEN_R           1.0
#define FER3ON_MIN_RR                 1.20

struct FER3ON_RISK_LIMITS
  {
   double start_lot;
   double max_lot;
   double daily_loss_percent;
   double daily_loss_cash;
   int max_open_trades;
   double break_even_r;
   double min_rr;
  };

void FER3ON_DefaultRiskLimits(FER3ON_RISK_LIMITS &limits)
  {
   limits.start_lot=FER3ON_START_LOT;
   limits.max_lot=FER3ON_PHASE1_MAX_LOT;
   limits.daily_loss_percent=FER3ON_DAILY_LOSS_PERCENT;
   limits.daily_loss_cash=FER3ON_DAILY_LOSS_CASH;
   limits.max_open_trades=FER3ON_MAX_OPEN_TRADES;
   limits.break_even_r=FER3ON_BREAK_EVEN_R;
   limits.min_rr=FER3ON_MIN_RR;
  }

#endif
