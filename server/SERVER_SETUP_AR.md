# إعداد سيرفر World Dominion 1.2 Combat / Frontlines للإنتاج التجريبي

## الخيار الموصى به لمباراتك: Render + PostgreSQL

### 1. ارفع المشروع إلى GitHub

ارفع المشروع كاملاً. مجلد السيرفر هو `server/`.

### 2. أنشئ Web Service في Render

- Root Directory: `server`
- Build Command: `npm install --no-audit --no-fund`
- Start Command: `npm start`
- Health Check: `/health`
- Node: 22

يوجد `render.yaml` جاهز في جذر المشروع.

### 3. متغيرات البيئة

الأساسية:

```text
DATABASE_URL=postgresql://...
ADMIN_KEY=ضع_سلسلة_عشوائية_طويلة_ولا_ترسلها_للتطبيق
DEVELOPER_NAME=اسمك أو اسم شركتك كما سيظهر في Google Play
SUPPORT_EMAIL=your-support@example.com
MAX_PLAYERS=64
MAX_ROOMS=500
MIN_PLAYERS_TO_START=2
TURN_SECONDS=300
ROOM_TTL_MINUTES=1440
DATA_RETENTION_DAYS=90
```

`DATABASE_URL` يمكن أن يأتي من أي PostgreSQL مُدار. بدون هذا المتغير يستخدم السيرفر JSON محلياً؛ هذا مناسب لجهازك/VPS بقرص دائم لكنه غير موصى به لاستضافة مجانية ذات قرص مؤقت.

### 4. تحقق من السيرفر

افتح:

```text
https://YOUR-SERVER/health
```

في الإنتاج ينبغي أن ترى تقريباً:

```json
{
  "ok": true,
  "version": "1.3.0-provinces",
  "protocol": 1,
  "persistence": "postgres",
  "authoritative": true,
  "policyConfigured": true
}
```

داخل التطبيق استخدم:

```text
wss://YOUR-SERVER
```

### 5. صفحات عامة مطلوبة/مفيدة

```text
https://YOUR-SERVER/privacy
https://YOUR-SERVER/terms
https://YOUR-SERVER/delete-data
```

لا تنشر في Google Play قبل أن يظهر اسم المطور وبريد الدعم الحقيقيان في الصفحات.

## الإشراف والبلاغات

قائمة أحدث البلاغات، للمشرف فقط:

```text
GET /moderation?key=ADMIN_KEY
```

لإجراء حظر على بلاغ:

```http
POST /moderation/action?key=ADMIN_KEY
Content-Type: application/json

{"room":"ROOMCODE","reportId":"REPORT_ID","days":30}
```

الحظر يعتمد على Hash لمعرّف تثبيت مستعار؛ المعرّف الخام لا يُحفظ على السيرفر. اللاعب المحظور يُفصل وتتحول أراضيه إلى AI إذا كان في مباراة.

إحصاءات الغرف:

```text
GET /stats?key=ADMIN_KEY
```

لا تضع `ADMIN_KEY` داخل Flutter أو GitHub Variables العامة.

## تشغيل السيرفر على كمبيوترك

داخل `server/`:

```bash
npm install
npm run check
npm start
```

ثم محلياً:

```text
http://localhost:8080/health
ws://localhost:8080
```

Debug Android يسمح cleartext localhost. نسخة Release مصممة للاتصال العام المشفر `wss://` فقط.

إذا أردت أن يصل صديقك إلى جهازك، استخدم Tunnel آمن أو إعداد شبكة مناسب. للاستعمال المتكرر أو البيع يفضّل استضافة عامة ثابتة وقاعدة PostgreSQL ونسخ احتياطي.

## Docker

```bash
cd server
docker build -t world-dominion-server .
docker run --rm -p 8080:8080 --env-file .env world-dominion-server
```

## قبل فتح الخدمة للغرباء

- استخدم كلمة `ADMIN_KEY` طويلة وعشوائية.
- استخدم قاعدة بيانات Production ببيانات اعتماد لا تُرفع إلى GitHub.
- راقب سجلات الأخطاء واستهلاك الموارد.
- راجع البلاغات بانتظام واتخذ إجراءً مناسباً؛ وجود زر Report وحده لا يكفي لخدمة عامة.
- ضع سياسة نسخ احتياطي واستعادة لقاعدة البيانات.
- ضع حد إنفاق/تنبيه عند مزود الاستضافة حتى لا يفاجئك استهلاك عام كبير.
- لا تعتمد على الخطة المجانية كسيرفر تجاري نهائي بدون فهم حدودها ووقت النوم/الموارد المتاح وقت الإطلاق.
