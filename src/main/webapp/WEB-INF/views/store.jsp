<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="app" value="${pageContext.request.contextPath}"/>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${title}"/> · 书屿商店</title>
    <link rel="stylesheet" href="${app}/assets/store.css">
</head>
<body>
<header class="site"><div class="shell top">
    <a class="brand" href="${app}/products"><span class="mark" aria-hidden="true">书</span>书屿商店</a>
    <nav aria-label="业务导航">
        <a href="${app}/products" class="${active eq 'products' ? 'current' : ''}" ${active eq 'products' ? 'aria-current="page"' : ''}>商品</a>
        <a href="${app}/users" class="${active eq 'users' ? 'current' : ''}" ${active eq 'users' ? 'aria-current="page"' : ''}>用户</a>
        <a href="${app}/orders" class="${active eq 'orders' ? 'current' : ''}" ${active eq 'orders' ? 'aria-current="page"' : ''}>订单</a>
        <a href="${app}/details" class="${active eq 'details' ? 'current' : ''}" ${active eq 'details' ? 'aria-current="page"' : ''}>订单明细</a>
    </nav>
</div></header>
<main class="shell">
    <c:if test="${not empty notice}"><p class="feedback success" role="status"><c:out value="${notice}"/></p></c:if>
    <c:if test="${not empty error}"><p class="feedback error" role="alert"><c:out value="${error}"/></p></c:if>
    <c:choose>
    <c:when test="${active eq 'products'}">
        <div class="heading"><h1>商品管理</h1><p>维护图书商品的单价和库存。</p></div>
        <div class="workspace">
            <section class="panel listing" aria-labelledby="list-title">
                <div class="section-head"><h2 id="list-title">商品列表</h2><span class="count">${fn:length(rows)} 条记录</span></div>
                <div class="table-wrap"><table>
                    <thead><tr><th scope="col">编号</th><th scope="col">商品名称</th><th scope="col">单价</th><th scope="col">库存</th><th scope="col">操作</th></tr></thead>
                    <tbody>
                    <c:forEach var="row" items="${rows}">
                        <tr data-row-id="${row.id}">
                            <td class="record-id">#<c:out value="${row.id}"/></td>
                            <td><c:out value="${row.name}"/></td>
                            <td>￥<fmt:formatNumber value="${row.price}" minFractionDigits="2" maxFractionDigits="2" groupingUsed="false"/></td>
                            <td><c:out value="${row.stock}"/> 册</td>
                            <td class="actions">
                                
                                <a href="${app}/products?edit=${row.id}">编辑</a>
                                <form method="post" action="${app}/products/${row.id}/delete"
                                      data-confirm="确定删除此记录？">
                                    <button class="delete" type="submit">删除</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty rows}"><tr><td colspan="5" class="empty">暂无商品记录。</td></tr></c:if>
                    </tbody>
                </table></div>
            </section>
            <section class="panel editor" aria-labelledby="editor-title">
                <div class="section-head"><h2 id="editor-title">${empty entry.id ? '新增' : '编辑'}商品</h2>
                    <c:if test="${not empty entry.id}"><a class="muted-link" href="${app}/products">取消编辑</a></c:if>
                </div>
                <form class="entry" method="post" action="${app}/products/save">
                    <c:if test="${not empty entry.id}"><input type="hidden" name="id" value="${entry.id}"></c:if>
                    <label>商品名称<input name="name" maxlength="100" required value="<c:out value="${entry.name}"/>"></label>
                    <label>单价（元）<input name="price" type="number" step="0.01" min="0" max="99999999.99" required value="<c:out value="${entry.price}"/>"></label>
                    <label>库存（册）<input name="stock" type="number" min="0" required value="<c:out value="${entry.stock}"/>"></label>
                    <button class="primary" type="submit">${empty entry.id ? '添加商品' : '保存修改'}</button>
                </form>
            </section>
        </div>
    </c:when>
    <c:when test="${active eq 'users'}">
        <div class="heading"><h1>用户管理</h1><p>维护买家资料，或按用户查询其全部订单。</p></div>
        <c:if test="${not empty relation}">
        <section class="relation" aria-labelledby="relation-title">
            <div class="section-head">
                <div><p class="relation-type">一对多关联查询</p><h2 id="relation-title"><c:out value="${relation.username}"/> 的订单</h2></div>
                <a class="muted-link" href="${app}/users">收起查询</a>
            </div>
            <p class="path">users → orders</p>
            <div class="table-wrap"><table class="relation-table">
                <thead><tr><th scope="col">订单编号</th><th scope="col">下单日期</th></tr></thead>
                <tbody>
                <c:forEach var="item" items="${relation.orderList}">
                    <tr><td><a href="${app}/orders?trace=${item.id}">#<c:out value="${item.id}"/></a></td><td><c:out value="${item.orderDate}"/></td></tr>
                </c:forEach>
                <c:if test="${empty relation.orderList}"><tr><td colspan="2" class="empty">该用户暂无订单。</td></tr></c:if>
                </tbody>
            </table></div>
        </section>
        </c:if>
        <div class="workspace">
            <section class="panel listing" aria-labelledby="list-title">
                <div class="section-head"><h2 id="list-title">用户列表</h2><span class="count">${fn:length(rows)} 条记录</span></div>
                <div class="table-wrap"><table>
                    <thead><tr><th scope="col">编号</th><th scope="col">用户名</th><th scope="col">邮箱</th><th scope="col">操作</th></tr></thead>
                    <tbody>
                    <c:forEach var="row" items="${rows}">
                        <tr data-row-id="${row.id}">
                            <td class="record-id">#<c:out value="${row.id}"/></td>
                            <td><c:out value="${row.username}"/></td>
                            <td><c:out value="${row.email}"/></td>
                            <td class="actions">
                                <a href="${app}/users?trace=${row.id}">查看订单</a>
                                <a href="${app}/users?edit=${row.id}">编辑</a>
                                <form method="post" action="${app}/users/${row.id}/delete"
                                      data-confirm="确定删除此记录？">
                                    <button class="delete" type="submit">删除</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty rows}"><tr><td colspan="4" class="empty">暂无用户记录。</td></tr></c:if>
                    </tbody>
                </table></div>
            </section>
            <section class="panel editor" aria-labelledby="editor-title">
                <div class="section-head"><h2 id="editor-title">${empty entry.id ? '新增' : '编辑'}用户</h2>
                    <c:if test="${not empty entry.id}"><a class="muted-link" href="${app}/users">取消编辑</a></c:if>
                </div>
                <form class="entry" method="post" action="${app}/users/save">
                    <c:if test="${not empty entry.id}"><input type="hidden" name="id" value="${entry.id}"></c:if>
                    <label>用户名<input name="username" maxlength="50" required value="<c:out value="${entry.username}"/>"></label>
                    <label>邮箱<input name="email" type="email" maxlength="100" value="<c:out value="${entry.email}"/>"></label>
                    <label>密码<input name="password" type="password" maxlength="64" autocomplete="new-password" ${empty entry.id ? 'required' : 'placeholder="留空则保留原密码"'}></label>
                    <button class="primary" type="submit">${empty entry.id ? '添加用户' : '保存修改'}</button>
                </form>
            </section>
        </div>
    </c:when>
    <c:when test="${active eq 'orders'}">
        <div class="heading"><h1>订单管理</h1><p>维护订单日期和所属用户，并查看该订单包含的商品。</p></div>
        <c:if test="${not empty relation}">
        <section class="relation" aria-labelledby="relation-title">
            <div class="section-head">
                <div><p class="relation-type">多对多关联查询</p><h2 id="relation-title">订单 #<c:out value="${relation.id}"/> 的商品</h2></div>
                <a class="muted-link" href="${app}/orders">收起查询</a>
            </div>
            <p class="path">orders → orderdetails → products</p>
            <div class="table-wrap"><table class="relation-table">
                <thead><tr><th scope="col">商品</th><th scope="col">单价</th><th scope="col">购买数量</th></tr></thead>
                <tbody>
                <c:forEach var="item" items="${relation.productList}">
                    <tr><td><c:out value="${item.name}"/></td><td>￥<fmt:formatNumber value="${item.price}" minFractionDigits="2" maxFractionDigits="2" groupingUsed="false"/></td><td><c:out value="${item.orderedQuantity}"/> 册</td></tr>
                </c:forEach>
                <c:if test="${empty relation.productList}"><tr><td colspan="3" class="empty">该订单暂无商品。</td></tr></c:if>
                </tbody>
            </table></div>
        </section>
        </c:if>
        <div class="workspace">
            <section class="panel listing" aria-labelledby="list-title">
                <div class="section-head"><h2 id="list-title">订单列表</h2><span class="count">${fn:length(rows)} 条记录</span></div>
                <div class="table-wrap"><table>
                    <thead><tr><th scope="col">编号</th><th scope="col">下单用户</th><th scope="col">下单日期</th><th scope="col">操作</th></tr></thead>
                    <tbody>
                    <c:forEach var="row" items="${rows}">
                        <tr data-row-id="${row.id}">
                            <td class="record-id">#<c:out value="${row.id}"/></td>
                            <td><c:forEach var="user" items="${users}"><c:if test="${user.id eq row.userId}"><c:out value="${user.username}"/></c:if></c:forEach> <span class="muted">#<c:out value="${row.userId}"/></span></td>
                            <td><c:out value="${row.orderDate}"/></td>
                            <td class="actions">
                                <a href="${app}/orders?trace=${row.id}">查看商品</a>
                                <a href="${app}/orders?edit=${row.id}">编辑</a>
                                <form method="post" action="${app}/orders/${row.id}/delete"
                                      data-confirm="确定删除此订单及所属明细？">
                                    <button class="delete" type="submit">删除</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty rows}"><tr><td colspan="4" class="empty">暂无订单记录。</td></tr></c:if>
                    </tbody>
                </table></div>
            </section>
            <section class="panel editor" aria-labelledby="editor-title">
                <div class="section-head"><h2 id="editor-title">${empty entry.id ? '新增' : '编辑'}订单</h2>
                    <c:if test="${not empty entry.id}"><a class="muted-link" href="${app}/orders">取消编辑</a></c:if>
                </div>
                <form class="entry" method="post" action="${app}/orders/save">
                    <c:if test="${not empty entry.id}"><input type="hidden" name="id" value="${entry.id}"></c:if>
                    <label>下单用户<select name="userId" required>
    <option value="">请选择</option>
    <c:forEach var="option" items="${users}">
        <option value="${option.id}" ${entry.userId eq option.id ? 'selected' : ''}><c:out value="${option.username}"/></option>
    </c:forEach>
</select></label>
                    <label>下单日期<input name="orderDate" type="date" required value="<c:out value="${entry.orderDate}"/>"></label>
                    <button class="primary" type="submit">${empty entry.id ? '添加订单' : '保存修改'}</button>
                </form>
            </section>
        </div>
    </c:when>
    <c:when test="${active eq 'details'}">
        <div class="heading"><h1>订单明细管理</h1><p>记录各订单购买的商品与数量。</p></div>
        <div class="workspace">
            <section class="panel listing" aria-labelledby="list-title">
                <div class="section-head"><h2 id="list-title">订单明细列表</h2><span class="count">${fn:length(rows)} 条记录</span></div>
                <div class="table-wrap"><table>
                    <thead><tr><th scope="col">编号</th><th scope="col">订单</th><th scope="col">商品</th><th scope="col">购买数量</th><th scope="col">操作</th></tr></thead>
                    <tbody>
                    <c:forEach var="row" items="${rows}">
                        <tr data-row-id="${row.id}">
                            <td class="record-id">#<c:out value="${row.id}"/></td>
                            <td><a href="${app}/orders?trace=${row.orderId}">订单 #<c:out value="${row.orderId}"/></a></td>
                            <td><c:forEach var="product" items="${products}"><c:if test="${product.id eq row.productId}"><c:out value="${product.name}"/></c:if></c:forEach></td>
                            <td><c:out value="${row.quantity}"/> 册</td>
                            <td class="actions">
                                
                                <a href="${app}/details?edit=${row.id}">编辑</a>
                                <form method="post" action="${app}/details/${row.id}/delete"
                                      data-confirm="确定删除此记录？">
                                    <button class="delete" type="submit">删除</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty rows}"><tr><td colspan="5" class="empty">暂无订单明细记录。</td></tr></c:if>
                    </tbody>
                </table></div>
            </section>
            <section class="panel editor" aria-labelledby="editor-title">
                <div class="section-head"><h2 id="editor-title">${empty entry.id ? '新增' : '编辑'}订单明细</h2>
                    <c:if test="${not empty entry.id}"><a class="muted-link" href="${app}/details">取消编辑</a></c:if>
                </div>
                <form class="entry" method="post" action="${app}/details/save">
                    <c:if test="${not empty entry.id}"><input type="hidden" name="id" value="${entry.id}"></c:if>
                    <label>所属订单<select name="orderId" required>
    <option value="">请选择</option>
    <c:forEach var="option" items="${orders}">
        <option value="${option.id}" ${entry.orderId eq option.id ? 'selected' : ''}>订单 #<c:out value="${option.id}"/> · <c:out value="${option.orderDate}"/></option>
    </c:forEach>
</select></label>
                    <label>商品<select name="productId" required>
    <option value="">请选择</option>
    <c:forEach var="option" items="${products}">
        <option value="${option.id}" ${entry.productId eq option.id ? 'selected' : ''}><c:out value="${option.name}"/></option>
    </c:forEach>
</select></label>
                    <label>购买数量（册）<input name="quantity" type="number" min="1" required value="<c:out value="${entry.quantity}"/>"></label>
                    <button class="primary" type="submit">${empty entry.id ? '添加订单明细' : '保存修改'}</button>
                </form>
            </section>
        </div>
    </c:when>
    </c:choose>
</main>
<script src="${app}/assets/store.js"></script>
</body>
</html>
