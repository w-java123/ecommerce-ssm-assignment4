-- =============================================================
-- 选题 2：电子商务网站
-- 数据库：ecommerce_ssm_202401150317
-- 表：users / products / orders / orderdetails
-- 关联关系：
--   一对多 users(1) -> orders(N)
--   多对多 orders(N) <-> orderdetails <-> products(N)
-- =============================================================

CREATE DATABASE IF NOT EXISTS ecommerce_ssm_202401150317 DEFAULT CHARSET=utf8mb4;
USE ecommerce_ssm_202401150317;

-- -------------------------------------------------------------
-- 1. 用户表 users （一对多关系中的“一”方）
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id       INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID，主键',
    username VARCHAR(50)  NOT NULL UNIQUE    COMMENT '用户名',
    password CHAR(64)  NOT NULL           COMMENT '密码',
    email    VARCHAR(100)                    COMMENT '邮箱'
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO users (id, username, password, email) VALUES
(1, 'joy',   SHA2('demo-account', 256), 'joy@example.com'),
(2, 'jack',  SHA2('demo-account', 256), 'jack@example.com'),
(3, 'tom',   SHA2('demo-account', 256), 'tom@example.com');

-- -------------------------------------------------------------
-- 2. 商品表 products
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS products (
    id    INT PRIMARY KEY AUTO_INCREMENT COMMENT '商品ID，主键',
    name  VARCHAR(100) NOT NULL            COMMENT '商品名称',
    price DECIMAL(10,2)       NOT NULL            COMMENT '商品单价',
    stock INT          NOT NULL DEFAULT 0  COMMENT '库存数量',
    CONSTRAINT chk_stock CHECK (stock >= 0),
    CONSTRAINT chk_price CHECK (price >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO products (id, name, price, stock) VALUES
(1, 'Java基础入门',        45.0, 100),
(2, 'JavaWeb程序设计',     50.0, 80),
(3, 'SSM框架整合实战',     62.5, 60),
(4, 'MySQL数据库原理',     39.9, 120);

-- -------------------------------------------------------------
-- 3. 订单表 orders （一对多关系中的“多”方，user_id 为外键）
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
    id         INT PRIMARY KEY AUTO_INCREMENT COMMENT '订单ID，主键',
    user_id    INT  NOT NULL                  COMMENT '下单用户ID，外键',
    order_date DATE NOT NULL                  COMMENT '下单日期',
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO orders (id, user_id, order_date) VALUES
(1, 1, '2026-09-20'),
(2, 1, '2026-09-22'),
(3, 2, '2026-09-25'),
(4, 3, '2026-09-28');

-- -------------------------------------------------------------
-- 4. 订单详情表 orderdetails （订单与商品的多对多中间表）
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS orderdetails (
    id         INT PRIMARY KEY AUTO_INCREMENT COMMENT '详情ID，主键',
    order_id   INT NOT NULL                   COMMENT '订单ID，外键',
    product_id INT NOT NULL                   COMMENT '商品ID，外键',
    quantity   INT NOT NULL DEFAULT 1         COMMENT '购买数量',
    CONSTRAINT chk_quantity CHECK (quantity > 0),
    CONSTRAINT uq_order_product UNIQUE (order_id, product_id),
    CONSTRAINT fk_detail_order   FOREIGN KEY (order_id)   REFERENCES orders(id),
    CONSTRAINT fk_detail_product FOREIGN KEY (product_id) REFERENCES products(id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO orderdetails (id, order_id, product_id, quantity) VALUES
(1, 1, 1, 2),
(2, 1, 3, 1),
(3, 2, 2, 5),
(4, 3, 1, 1),
(5, 3, 4, 3),
(6, 4, 2, 2);
