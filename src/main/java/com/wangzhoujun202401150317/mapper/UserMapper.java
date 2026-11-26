package com.wangzhoujun202401150317.mapper;

import com.wangzhoujun202401150317.po.Users;
import org.apache.ibatis.annotations.*;

import java.util.List;

public interface UserMapper {
    @Select("select id, username, email from users order by id")
    List<Users> findAll();

    @Select("select id, username, email from users where id = #{id}")
    Users findById(int id);

    @Insert("insert into users (username, password, email) values (#{username}, sha2(#{password}, 256), #{email})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Users value);

    @Update("update users set username = #{username}, email = #{email}, password = coalesce(sha2(nullif(#{password}, ''), 256), password) where id = #{id}")
    int update(Users value);

    @Delete("delete from users where id = #{id}")
    int delete(int id);

    Users findUserWithOrders(@Param("id") int id);
}
