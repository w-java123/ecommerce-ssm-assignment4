package com.wangzhoujun202401150317.po;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 商品实体类，对应数据库表 products。
 */
public class Products implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 商品ID，主键 */
    private Integer id;
    /** 商品名称 */
    private String name;
    /** 商品单价 */
    private BigDecimal price;
    /** 库存数量 */
    private Integer stock;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    /** 订单关联查询返回的购买数量。 */
    private Integer orderedQuantity;

    public Integer getOrderedQuantity() {
        return orderedQuantity;
    }

    public void setOrderedQuantity(Integer orderedQuantity) {
        this.orderedQuantity = orderedQuantity;
    }

    @Override
    public String toString() {
        return "Products [id=" + id + ", name=" + name
                + ", price=" + price + ", stock=" + stock + "]";
    }
}
