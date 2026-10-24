# عقود المرحلة الأولى

## Signal

يجب أن يحتوي على:

- signal_id
- strategy_id
- strategy_version
- symbol
- timeframe
- direction
- state
- entry_price
- structure_bias
- location_type
- reaction_type
- thesis
- confidence
- reason_codes
- created_bar_time
- expires_bar_time

## TradePlan

يجب أن يحتوي على:

- entry
- structural_sl
- structural_target
- risk_distance
- reward_distance
- rr_ratio
- risk_cash
- lot_theoretical
- lot_final
- broker_constraints

## RiskDecision

يجب أن يحتوي على:

- approved
- reason_code
- account_equity
- daily_pnl
- daily_loss_limit
- open_exposure
- same_direction_exposure
- margin_required
- margin_free

## ExecutionResult

يجب أن يحتوي على:

- action
- retcode
- ticket
- fill_price
- sl
- tp
- volume
- execution_reason

## قواعد العقد

1. لا يتم إرسال أمر بلا Signal مكتمل.
2. لا يتم حساب اللوت قبل تثبيت SL الهيكلي.
3. لا يتم تغيير SL بعد الحساب دون إعادة تقييم Risk.
4. `NONE`, `WAIT`, `REJECTED`, `SKIPPED` ليست صفقات.
5. كل رفض يكتب في Journal مع سبب واحد رئيسي وقائمة تفاصيل.
6. كل سجل يحمل BUILD_ID وaccount_id وsymbol.
