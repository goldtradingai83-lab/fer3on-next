# FER3ON Next MQL5

بوت Expert Advisor أصلي لـMT5 مخصص لـXAUUSD، مبني على خطة FER3ON الرئيسية.

## الحالة الحالية

- المرحلة الحالية: **Phase 0 — تثبيت المتطلبات والعقود**.
- حالة التداول: **غير موجود بعد / لا يوجد تنفيذ تداول**.
- الحساب المستهدف: Demo فقط أثناء التطوير.
- Python: أدوات بحث وتحليل خارج مسار إرسال الأوامر.
- Shadow: ممنوع داخل EA.
- أول Commit: `b10a250`.

## قواعد غير قابلة للكسر

1. مصدر إعدادات واحد.
2. Risk Gate واحد.
3. SL/TP مركزيان.
4. لا تستخدم الشمعة الحالية لاكتشاف Structure أو CHOCH أو BOS.
5. كل صفقة لها Thesis وأسباب قابلة للتدقيق.
6. كل رفض يسجل سببه.
7. لا يتم رفع اللوت بسبب يوم رابح أو صفقة رابحة واحدة.
8. لا يتم تشغيل Real قبل اعتماد Demo صريح.

## مسار العمل

اقرأ بالترتيب:

1. `docs/MASTER_IMPLEMENTATION_PLAN_AR.md`
2. `docs/ROADMAP_AR.md`
3. `docs/IMPLEMENTATION_LOG_AR.md`
4. `docs/ARCHITECTURE_DECISIONS_AR.md`
5. `docs/STATUS_AR.md`

## مراحل التنفيذ

- Phase 0: تثبيت المتطلبات والعقود.
- Phase 1: Domain وLogger.
- Phase 2: Market Data وMulti-Timeframe.
- Phase 3: Structure وTrend وLevels.
- Phase 4: Structural SL/TP وRisk.
- Phase 5: Execution.
- Phase 6: نقل الاستراتيجيات.
- Phase 7: Position Management.
- Phase 8: Strategy Tester وWalk-Forward.
- Phase 9: Demo Validation.
- Phase 10: اعتماد أو تعديل أو تقاعد.
