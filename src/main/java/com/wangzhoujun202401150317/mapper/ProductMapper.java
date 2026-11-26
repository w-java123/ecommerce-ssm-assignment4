package com.wangzhoujun202401150317.mapper;

import com.wangzhoujun202401150317.po.Products;
import org.apache.ibatis.annotations.*;

import java.util.List;

public interface ProductMapper {
    @Select("select id, name, price, stock from products order by id")
    List<Products> findAll();

    @Select("select id, name, price, stock from products where id = #{id}")
    Products findById(int id);

    @Insert("insert into products (name, price, stock) values (#{name}, #{price}, #{stock})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Products value);

    @Update("update products set name = #{name}, price = #{price}, stock = #{stock} where id = #{id}")
    int update(Products value);

    @Delete("delete from products where id = #{id}")
    int delete(int id);
}
