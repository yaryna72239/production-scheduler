-- 生產排程管理系統資料表結構
-- 適用於 Supabase PostgreSQL

-- 1. 客戶資料表
CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,                    -- 客戶名稱
    contact_person TEXT,                   -- 聯絡人
    phone TEXT,                            -- 電話
    email TEXT,                            -- 郵箱
    address TEXT,                          -- 地址
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 廠商資料表
CREATE TABLE vendors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,                    -- 廠商名稱
    contact_person TEXT,                   -- 聯絡人
    phone TEXT,                            -- 電話
    email TEXT,                            -- 郵箱
    specialty TEXT,                        -- 專長/業務類型
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 產品/項目資料表
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,                    -- 產品名稱
    specification TEXT,                    -- 規格
    unit TEXT DEFAULT '件',                -- 單位
    default_production_days INTEGER,       -- 預設生產天數
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. 訂單主表 (客戶訂單)
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_no TEXT UNIQUE NOT NULL,         -- 訂單編號 (如: ORD-2025-0001)
    customer_id UUID REFERENCES customers(id),
    product_id UUID REFERENCES products(id),
    quantity INTEGER NOT NULL,             -- 數量
    deadline DATE,                         -- 交期
    
    -- 客戶進度
    customer_status TEXT DEFAULT '待確認' CHECK (customer_status IN ('待確認', '已確認', '生產中', '待出貨', '已出貨', '已完成')),
    customer_progress INTEGER DEFAULT 0 CHECK (customer_progress >= 0 AND customer_progress <= 100), -- 進度百分比
    
    -- 廠商進度
    vendor_id UUID REFERENCES vendors(id), -- 外包廠商
    vendor_status TEXT DEFAULT '未派工' CHECK (vendor_status IN ('未派工', '已派工', '生產中', '待驗收', '已完成', '異常')),
    vendor_progress INTEGER DEFAULT 0 CHECK (vendor_progress >= 0 AND vendor_progress <= 100), -- 進度百分比
    
    notes TEXT,                            -- 備註
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. 進度更新記錄表
CREATE TABLE progress_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    log_type TEXT CHECK (log_type IN ('客戶進度', '廠商進度')), -- 區分類型
    progress INTEGER NOT NULL,             -- 當時進度
    status TEXT NOT NULL,                  -- 當時狀態
    note TEXT,                             -- 說明
    created_by TEXT,                       -- 記錄人
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 建立索引提升查詢效能
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_vendor_id ON orders(vendor_id);
CREATE INDEX idx_orders_customer_status ON orders(customer_status);
CREATE INDEX idx_orders_vendor_status ON orders(vendor_status);
CREATE INDEX idx_progress_logs_order_id ON progress_logs(order_id);

-- 設定 Row Level Security (RLS) 政策
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendors ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE progress_logs ENABLE ROW LEVEL SECURITY;

-- 允許匿名使用者讀取和寫入 (開發階段)
CREATE POLICY "Allow all" ON customers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON vendors FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON products FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON orders FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON progress_logs FOR ALL USING (true) WITH CHECK (true);

-- 插入測試資料
INSERT INTO customers (name, contact_person, phone) VALUES
    ('高柏科技', 'Joanne', '0912-345-678'),
    ('創新科技', 'Alex', '0923-456-789'),
    ('數位生活', '小美', '0934-567-890');

INSERT INTO vendors (name, contact_person, phone, specialty) VALUES
    ('協力精密工業', '陳廠長', '0945-678-901', 'CNC加工'),
    ('順發製造廠', '林經理', '0956-789-012', '表面處理'),
    ('永盛加工所', '黃老闆', '0967-890-123', '組裝代工');

INSERT INTO products (name, specification, unit, default_production_days) VALUES
    ('20寸/28寸行李箱+logo印刷', '行李箱外殼+熱轉印', '組', 10),
    ('鋁合金手機支架', '支架底座', '件', 5),
    ('USB-C 充電線組', 'Type-C 線材+包裝', '組', 7);

INSERT INTO orders (order_no, customer_id, product_id, quantity, deadline, customer_status, customer_progress, vendor_id, vendor_status, vendor_progress, notes) 
SELECT 
    'A0010-260317',
    (SELECT id FROM customers WHERE name='高柏科技'),
    (SELECT id FROM products WHERE name='20寸/28寸行李箱+logo印刷'),
    7000, '2025-04-15', '生產中', 30,
    (SELECT id FROM vendors WHERE name='協力精密工業'),
    '生產中', 25, '首批試產';

INSERT INTO orders (order_no, customer_id, product_id, quantity, deadline, customer_status, customer_progress, vendor_id, vendor_status, vendor_progress, notes) 
SELECT 
    'A0011-260318',
    (SELECT id FROM customers WHERE name='創新科技'),
    (SELECT id FROM products WHERE name='鋁合金手機支架'),
    5000, '2025-04-10', '已確認', 25,
    (SELECT id FROM vendors WHERE name='順發製造廠'),
    '已派工', 10, '報價中';

INSERT INTO orders (order_no, customer_id, product_id, quantity, deadline, customer_status, customer_progress, vendor_id, vendor_status, vendor_progress, notes) 
SELECT 
    'A0012-260319',
    (SELECT id FROM customers WHERE name='數位生活'),
    (SELECT id FROM products WHERE name='USB-C 充電線組'),
    20000, '2025-04-20', '生產中', 60,
    (SELECT id FROM vendors WHERE name='永盛加工所'),
    '生產中', 55, '打樣後';
