# دليل تشغيل FER3ON Next على Windows

## التشغيل التجريبي Demo

ضع MT5 مفتوحًا على حساب Demo، ثم افتح PowerShell في مجلد المشروع الرئيسي وشغّل:

```powershell
.\start_demo.bat
```

لا تحتاج إلى تفعيل `.venv` يدويًا. المشغل ينشئ البيئة الافتراضية، يثبت المشروع محليًا وMetaTrader5، يزامن تاريخ الصفقات المغلقة إلى SQLite، ثم يبدأ كل Profiles المفعلة.

للتقييم مرة واحدة فقط بدل الحلقة المستمرة:

```powershell
.\start_demo.bat --once
```

لتغيير الفترة بين الدورات:

```powershell
.\start_demo.bat --interval 120
```

المشغل يعمل في Demo فقط، ولا يفعل LIVE.

بعد كل دورة مزامنة لتاريخ MT5، إذا تغير ملف الصفقات المغلقة، يشغّل المشروع
تحليل MFE/MAE تلقائيًا في عملية قراءة منفصلة. النتائج الأخيرة تكون في:

```text
fer3on_next\reports\post_analysis_live\latest_trades.csv
fer3on_next\reports\post_analysis_live\latest_summary.json
fer3on_next\reports\post_analysis_live\post_analysis_live.log
```

التحليل لا يرسل أوامر ولا يوقف حلقة Demo. ويمكن تعطيله فقط عند الحاجة:

```powershell
$env:FER3ON_POST_ANALYSIS_ENABLED = "NO"
```

ويمكن تحديد ملف شموع مختلف عن طريق:

```powershell
$env:FER3ON_POST_ANALYSIS_CANDLES = "data\xauusd_kaggle\normalized\xauusd_15m.csv"
```

## فحص الإعدادات دون MT5 أو أوامر

```powershell
cd .\fer3on_next
.\.venv\Scripts\python.exe main.py --mode inspect --strategies all
```

## مزامنة تاريخ MT5 فقط

```powershell
cd .\fer3on_next
.\.venv\Scripts\python.exe main.py --mode history --history-lookback-days 30
```

هذا الأمر للقراءة فقط ولا يحلل إشارات ولا يرسل أوامر.

## تحليل الصفقات المغلقة وMFE/MAE

من مجلد المشروع الرئيسي:

```powershell
.\run_post_analysis.bat `
  ".\fer3on_next\reports\mt5_closed_trades.csv" `
  ".\fer3on_next\data\xauusd_kaggle\normalized\xauusd_15m.csv" 20
```

أو مباشرة:

```powershell
cd .\fer3on_next
.\.venv\Scripts\python.exe tools\trade_post_analysis.py `
  --trades reports\mt5_closed_trades.csv `
  --candles data\xauusd_kaggle\normalized\xauusd_15m.csv `
  --out reports\post_analysis_manual `
  --post-exit-bars 20
```

ينتج التحليل ملف CSV تفصيليًا وملف JSON ملخصًا، ولا يعدل القرارات ولا يرسل أوامر.

## الاختبارات

```powershell
cd .\fer3on_next
.\.venv\Scripts\python.exe -m pytest -q
```

## ملاحظات مهمة

- `start_demo.bat` يطلق `run_demo.py`، الذي يحمّل جميع Profiles من TOML.
- كل استراتيجية لها إعداد مستقل ونسخة وMagic Number مستقل.
- TSM الجديد لا يدخل بعد FVG وحده؛ يلزمه CHOCH مؤكد ثم Retest ثم قبول سعري.
- الملفات التاريخية ليست تدريبًا آليًا؛ تستخدم للـBacktest والتحليل فقط.
- قبل أي استنتاج أداء نهائي يجب استخدام بيانات XAUUSD الخاصة بالوسيط، لأن بيانات GC=F أو مصادر أخرى لا تطابق دائمًا سعر MT5.
