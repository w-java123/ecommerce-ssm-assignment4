package com.wangzhoujun17.mapper;

import com.wangzhoujun17.po.Orders;
import org.apache.ibatis.annotations.*;

import java.util.List;

public interface OrdersMapper {
    @Select("select id, user_id, order_date from orders order by id")
    List<Orders> findAll();

    @Select("select id, user_id, order_date from orders where id = #{id}")
    Orders findById(int id);

    @Insert("insert into orders (user_id, order_date) values (#{userId}, #{orderDate})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Orders value);

    @Update("update orders set user_id = #{userId}, order_date = #{orderDate} where id = #{id}")
    int update(Orders value);

    @Delete("delete from orders where id = #{id}")
    int delete(int id);

    Orders findOrdersWithProductByJoin(@Param("id") int id);
}
