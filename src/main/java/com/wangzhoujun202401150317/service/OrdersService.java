package com.wangzhoujun202401150317.service;

import com.wangzhoujun202401150317.mapper.OrderDetailMapper;
import com.wangzhoujun202401150317.mapper.OrdersMapper;
import com.wangzhoujun202401150317.po.Orders;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class OrdersService {
    private final OrdersMapper orders;
    private final OrderDetailMapper details;

    public OrdersService(OrdersMapper orders, OrderDetailMapper details) {
        this.orders = orders;
        this.details = details;
    }

    @Transactional
    public boolean deleteWithDetails(int id) {
        details.deleteByOrderId(id);
        return orders.delete(id) == 1;
    }

    public boolean save(Orders order) {
        return (order.getId() == null ? orders.insert(order) : orders.update(order)) == 1;
    }
}
