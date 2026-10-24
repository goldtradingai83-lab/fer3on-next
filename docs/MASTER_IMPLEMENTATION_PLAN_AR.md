# FER3ON Next — مرجع التنفيذ الرئيسي

النسخة الكاملة المعتمدة من الخطة موجودة في ملف الجلسة:
`/home/ubuntu/FER3ON_MASTER_IMPLEMENTATION_PLAN_AR.md`

هذا الملف داخل المستودع هو المرجع المختصر المرحلي. يجب تحديثه عند تغير ترتيب أو شروط أي مرحلة.

## القرار

نبني EA أصليًا بلغة MQL5 داخل MT5 Desktop/VPS. Python للبحث والتقارير فقط. لا يوجد Shadow داخل EA.

## الترتيب الإلزامي

1. العقود والهوية والسجل.
2. بيانات السوق والفريمات.
3. Structure/Trend/Levels.
4. Structural SL/TP والمخاطر.
5. التنفيذ والتحقق من الوسيط.
6. الاستراتيجيات التسع.
7. إدارة المراكز وBreak-even.
8. Strategy Tester وWalk-Forward.
9. Demo.
10. الاعتماد أو التعديل أو التقاعد.

## المكونات التي تنقل

CHOCH/BOS، Retest، FVG، Order Block، Donchian Retest، TSM، Swing Structure، Previous Day/Week، Session Levels، History، MFE/MAE، Kill Switch، Broker Validation.

## المكونات التي لا تنقل

Shadow Learning القديم، random simulated outcomes، تعدد Brain/ML، Smart Counter-Trading، التعلم التلقائي أثناء التداول، وتعدد مصادر SL/Risk.

## حدود البداية

- Demo فقط.
- البداية `0.01` lot.
- سقف Phase 1: `0.02`.
- حد خسارة يومي: 5% أو 50 دولارًا، أيهما أقل.
- BE عند `+1R` بعد إغلاق شمعة.
- Partial/Trailing مؤجل حتى تحليل BE.
