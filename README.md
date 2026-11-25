# 电子商务网站 · 书屿商店

《JavaEE 框架开发技术》第 4 次作业。沿用第 1 次作业选题 2「电子商务网站」，Java 包名为 `com.wangzhoujun17`。

## 功能

| 页面 | 操作 |
| --- | --- |
| 商品 | 新增、列表查询、编辑、删除 |
| 用户 | 新增、列表查询、编辑、删除、查看某用户的所有订单 |
| 订单 | 新增、列表查询、编辑、删除、查看某订单的所有商品及购买数量 |
| 订单明细 | 新增、列表查询、编辑、删除 |

库存可在商品页维护。订单和明细页用于录入、修改订单记录。订单删除通过 Spring 事务先移除明细、再移除订单。删除已被订单引用的用户或已被明细引用的商品时，页面提示关联约束。

## 数据库

`database/schema.sql` 创建独立的 MySQL 数据库、四张表和演示数据。商品单价用 `DECIMAL(10,2)` 保存，订单日期用 `DATE` 保存，订单明细通过外键引用订单与商品。同一张订单中的同一商品对应一条明细。

- 一对多查询使用 `UserMapper.xml` 的 `LEFT JOIN` 和 `collection`，演示数据中的 `joy` 有两张订单。
- 多对多查询使用 `OrdersMapper.xml` 连接 `orders`、`orderdetails` 和 `products`，可在订单 #1 查看两种图书及购买数量。没有明细的订单仍能打开查询页。

## 在 IntelliJ IDEA 或 Tomcat 中运行

1. 准备 JDK 11、Maven、MySQL 8.0.16 或更高版本，以及 Tomcat 9。使用 IDEA 打开 `pom.xml` 导入 Maven 项目。
2. 将 `database/schema.sql` 作为 UTF-8 SQL 脚本执行。脚本会创建 `ecommerce_ssm_202401150317` 数据库。
3. 在 `src/main/resources/` 新建 `db.local.properties`，填写数据库用户名和密码。默认连接 URL 与驱动配置见同目录的 `db.properties`，服务器地址或端口不同时，可在本地文件里覆盖 `jdbc.url`。
   ```properties
   jdbc.username=你的数据库用户名
   jdbc.password=你的数据库密码
   ```
4. 在 IDEA 里新建 Tomcat Server → Local 运行配置，部署 `ecommerce-ssm:war exploded`，把 Application context 设为 `/ecommerce-ssm`。也可以运行 `mvn clean package`，将 `target/ecommerce-ssm.war` 放进 Tomcat 的 `webapps` 目录后启动 Tomcat。
5. 访问 `http://localhost:8080/ecommerce-ssm/`，从商品页进入其他功能。

课程演示使用本地数据库和模拟账号资料。项目压缩包内的配置需要填入运行环境自己的数据库连接信息。

## 配置入口

- `WEB-INF/web.xml` 注册 Spring 根容器、UTF-8 过滤器和 `DispatcherServlet`。
- `WEB-INF/springmvc-servlet.xml` 扫描控制器，配置 JSP 视图解析和静态资源访问。
- `applicationContext.xml` 加载 Druid 数据源，注册事务管理器、`SqlSessionFactoryBean` 和 `MapperScannerConfigurer`，设置 Mapper XML 路径和实体别名。
- `mybatis-config.xml` 开启下划线字段名到 Java 驼峰属性名的自动映射。
