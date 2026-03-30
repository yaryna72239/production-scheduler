# 生產排程管理系統 - Supabase 接入完成

## 🚀 已完成項目

### 1. 網站已接入 Supabase
- ✅ 載入 Supabase JS Client
- ✅ 從資料庫讀取訂單資料
- ✅ 自動轉換資料格式對應網站欄位
- ✅ 移除靜態測試資料

### 2. 資料庫連線資訊
```
Project URL: https://rbtkdhmpaiufirvkexwn.supabase.co
anon key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJidGtkaG1wYWl1ZmlydmtleHduIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ4NTIxOTQsImV4cCI6MjA5MDQyODE5NH0.T-M79J0-gNoKZF2XLoGuFDHn41VDL46XMyDk99ucZmw
```

---

## 📋 使用步驟

### 步驟 1：建立資料表

1. 進入 [Supabase Dashboard](https://supabase.com/dashboard/project/rbtkdhmpaiufirvkexwn)
2. 左側選單 → **SQL Editor** → **New query**
3. 開啟 `supabase-schema.sql` 檔案，複製全部內容
4. 貼上到 SQL Editor，點擊 **Run**

這會建立：
- `customers` - 客戶資料
- `vendors` - 廠商資料
- `products` - 產品資料
- `orders` - 訂單主表
- `progress_logs` - 進度記錄

並自動插入測試資料（高柏科技、創新科技、數位生活等）。

### 步驟 2：更新 GitHub Pages

1. 將修改後的 `index.html` 上傳到你的 GitHub 倉庫
2. 推送到 `main` 分支
3. GitHub Pages 會自動更新

```bash
cd /path/to/production-scheduler
git add index.html
git commit -m "接入 Supabase 資料庫"
git push origin main
```

### 步驟 3：測試

開啟網站：https://yaryna72239.github.io/production-scheduler

應該會顯示從 Supabase 載入的訂單卡片！

---

## 📊 資料對應關係

| 網站欄位 | Supabase 欄位 |
|---------|--------------|
| 專案編號 | orders.order_no |
| 產品名稱 | products.name |
| 客戶名稱 | customers.name |
| 聯絡人 | customers.contact_person |
| 數量 | orders.quantity |
| 交期 | orders.deadline |
| 進度 | orders.customer_progress |
| 狀態 | orders.customer_status |

---

## 🔮 後續可擴充

1. **編輯儲存** - 將編輯後的資料寫回 Supabase
2. **新增訂單** - 實作新增專案功能
3. **廠商進度** - 在卡片上顯示廠商進度條
4. **即時更新** - 使用 Supabase Realtime 自動刷新
5. **工單列表** - 擴充 detail view 的工單資料

---

## 📁 檔案說明

| 檔案 | 說明 |
|------|------|
| `index.html` | 修改後的網站（已接入 Supabase） |
| `supabase-schema.sql` | 資料庫結構 + 測試資料 |
| `README.md` | 本說明文件 |

---

## ⚠️ 注意事項

- 目前使用 `anon` key，資料表已開啟 RLS 但設為 Allow All（開發階段）
- 正式上線時應該加入身份驗證機制
- 編輯功能目前只更新本地資料，尚未寫回資料庫
