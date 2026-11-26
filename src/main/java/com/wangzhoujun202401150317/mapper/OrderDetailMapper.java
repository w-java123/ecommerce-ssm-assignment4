package com.wangzhoujun202401150317.mapper;

import com.wangzhoujun202401150317.po.OrderDetails;
import org.apache.ibatis.annotations.*;

import java.util.List;

public interface OrderDetailMapper {
    @Select("select id, order_id, product_id, quantity from orderdetails order by id")
    List<OrderDetails> findAll();

    @Select("select id, order_id, product_id, quantity from orderdetails where id = #{id}")
    OrderDetails findById(int id);

    @Insert("insert into orderdetails (order_id, product_id, quantity) values (#{orderId}, #{productId}, #{quantity})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(OrderDetails value);

    @Update("update orderdetails set order_id = #{orderId}, product_id = #{productId}, quantity = #{quantity} where id = #{id}")
    int update(OrderDetails value);

    @Delete("delete from orderdetails where id = #{id}")
    int delete(int id);

    List<OrderDetails> findDetailWithOrderAndProduct(@Param("orderId") int orderId);

    @Delete("delete from orderdetails where order_id = #{orderId}")
    int deleteByOrderId(int orderId);
}
