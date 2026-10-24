# خارطة طريق FER3ON Next

## Phase 0 — تثبيت المتطلبات والعقود

الحالة: **مكتملة في 2026-10-23**.

المخرجات المطلوبة:

- هوية Build.
- العقود الموحدة.
- سجل القرار.
- قواعد المخاطر.
- قرارات معمارية موثقة.

شرط النجاح: لا توجد قيم متكررة للمخاطر أو SL/TP، وكل مطور يعرف مكان كل مسؤولية.

تم تنفيذ العقود الأولية في `MQL5/Include/FER3ON` وتسجيلها في `docs/IMPLEMENTATION_LOG_AR.md`.

## Phase 1 — Domain وTrade Journal

الحالة: **مكتملة في 2026-10-24**.

- كتابة `Domain.mqh`.
- كتابة `BuildInfo.mqh`.
- كتابة `SignalContract.mqh` و`DecisionContract.mqh`.
- كتابة `TradeJournal.mqh`.
- اختبارات serialization ومنع السجلات الناقصة.

تم تنفيذ `TradeJournal.mqh` ومخطط السجل والاختبار البنيوي. الخطوة التالية هي Phase 2.

## Phase 2 — Market Data

الحالة: **الخطوة التالية**.

- شموع مغلقة فقط.
- M15/H1/H4.
- Tick وBid/Ask.
- منع Lookahead.
- كشف نقص البيانات.

## Phase 3 — Structure وLevels

- HH/HL/LH/LL.
- Protected Swings.
- BOS وCHOCH.
- FVG وOrder Block.
- Previous Day/Week وSession Levels.

## Phase 4 — Risk وStructural SL/TP

- وقف مركزي.
- هدف مركزي.
- حساب اللوت من الخطر.
- 0.01 بداية، 0.02 سقف.
- 5% أو 50$ يوميًا، أيهما أقل.

## Phase 5 — Execution

- OrderCheck.
- OrderSend.
- Tick Size/Value.
- Stops Level/Freeze Level.
- Idempotency.
- Hedging/Netting.

## Phase 6 — Strategies

BOS، FVG، Order Block، TSM، Donchian، Impulse Retest، P2، Scenario Tree، Impulse Midpoint.

كل استراتيجية ACTIVE فقط إذا كانت قادرة على إنتاج أمر حقيقي، وإلا تكون RETIRED خارج التشغيل وليس Shadow.

## Phase 7 — Position Management

- BE بعد +1R وإغلاق شمعة.
- Partial/Trailing بعد اعتماد مرحلة BE فقط.

## Phase 8 — Tester

- Real Ticks.
- Spread/Commission/Slippage.
- In-Sample / Validation / Out-of-Sample.
- Walk-Forward.
- MFE/MAE.

## Phase 9 — Demo

- الحساب Demo.
- حجم 0.01.
- لا تدخل يدوي أثناء القياس.
- كل الصفقات والرفض مسجلة.

## Phase 10 — القرار

KEEP / ADJUST / PAUSED_12H / RETIRED.

لا رفع للحجم قبل 30 صفقة مغلقة على الأقل، ويفضل 50–100 حسب تكرار الاستراتيجية.
