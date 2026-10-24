# تشغيل FER3ON Next بجملة واحدة

من PowerShell أو CMD، استخدم ملف BAT فقط:

```powershell
& "D:\fer3on_next_active_clean\start_demo.bat"
```

أو من داخل المجلد الخارجي:

```powershell
.\start_demo.bat
```

للتشغيل كل 5 دقائق:

```powershell
& "D:\fer3on_next_active_clean\start_demo.bat" --interval 300
```

المشغل يحدد المسارات بنفسه، ينشئ `fer3on_next\\.venv` عند الحاجة، يثبت `MetaTrader5` والحزمة المحلية، يضبط Demo، وينشئ السجل الجديد في:

```text
fer3on_next\\reports\\live_demo_ledger.jsonl
```

لا تستخدم `start_demo.ps1` ولا `Activate.ps1`. لا يحتاج التشغيل إلى `cd` أو تفعيل البيئة يدويًا.

لإيقاف البوت: `Ctrl+C`. إيقاف البرنامج لا يغلق الصفقات المفتوحة تلقائيًا.
