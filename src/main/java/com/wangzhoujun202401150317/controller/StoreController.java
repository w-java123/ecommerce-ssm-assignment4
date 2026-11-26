package com.wangzhoujun202401150317.controller;

import com.wangzhoujun202401150317.mapper.OrderDetailMapper;
import com.wangzhoujun202401150317.mapper.OrdersMapper;
import com.wangzhoujun202401150317.mapper.ProductMapper;
import com.wangzhoujun202401150317.mapper.UserMapper;
import com.wangzhoujun202401150317.po.OrderDetails;
import com.wangzhoujun202401150317.po.Orders;
import com.wangzhoujun202401150317.po.Products;
import com.wangzhoujun202401150317.po.Users;
import com.wangzhoujun202401150317.service.OrdersService;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.function.BooleanSupplier;

@Controller
public class StoreController {
    private final ProductMapper products;
    private final UserMapper users;
    private final OrdersMapper orders;
    private final OrderDetailMapper details;
    private final OrdersService orderService;

    public StoreController(ProductMapper products, UserMapper users, OrdersMapper orders,
                           OrderDetailMapper details, OrdersService orderService) {
        this.products = products;
        this.users = users;
        this.orders = orders;
        this.details = details;
        this.orderService = orderService;
    }

    @InitBinder("entry")
    void bindFields(WebDataBinder binder) {
        binder.setAllowedFields("id", "name", "price", "stock", "username", "email", "password",
                "userId", "orderDate", "orderId", "productId", "quantity");
    }

    @GetMapping("/")
    public String home() {
        return "redirect:/products";
    }

    @GetMapping("/products")
    public String products(@RequestParam(required = false) Integer edit, Model model) {
        model.addAttribute("active", "products");
        model.addAttribute("title", "商品管理");
        model.addAttribute("rows", products.findAll());
        model.addAttribute("entry", edit == null ? new Products() : required(products.findById(edit)));
        return "store";
    }

    @PostMapping("/products/save")
    public String saveProducts(@ModelAttribute("entry") Products value, BindingResult result, RedirectAttributes flash) {
        if (result.hasErrors() || value.getName() == null || value.getName().isBlank() || value.getName().length() > 100
                || value.getPrice() == null || value.getPrice().signum() < 0
                || value.getPrice().compareTo(new BigDecimal("99999999.99")) > 0
                || value.getPrice().stripTrailingZeros().scale() > 2
                || value.getStock() == null || value.getStock() < 0) {
            flash.addFlashAttribute("error", "请填写商品名称、最多两位小数的非负价格及非负库存。");
            return "redirect:/products" + (value.getId() == null ? "" : "?edit=" + value.getId());
        }
        return change("products", value.getId() == null ? "新增商品成功" : "修改商品成功", flash,
                () -> (value.getId() == null ? products.insert(value) : products.update(value)) == 1);
    }

    @PostMapping("/products/{id}/delete")
    public String deleteProducts(@PathVariable int id, RedirectAttributes flash) {
        return change("products", "删除商品成功", flash, () -> products.delete(id) == 1);
    }

    @GetMapping("/users")
    public String users(@RequestParam(required = false) Integer edit, Model model, @RequestParam(required = false) Integer trace) {
        model.addAttribute("active", "users");
        model.addAttribute("title", "用户管理");
        model.addAttribute("rows", users.findAll());
        model.addAttribute("entry", edit == null ? new Users() : required(users.findById(edit)));
        if (trace != null) {
            model.addAttribute("relation", required(users.findUserWithOrders(trace)));
        }
        return "store";
    }

    @PostMapping("/users/save")
    public String saveUsers(@ModelAttribute("entry") Users value, BindingResult result, RedirectAttributes flash) {
        if (result.hasErrors() || value.getUsername() == null || value.getUsername().isBlank() || value.getUsername().length() > 50
                || (value.getEmail() != null && (value.getEmail().length() > 100
                    || (!value.getEmail().isBlank() && !value.getEmail().matches("[^@\\s]+@[^@\\s]+\\.[^@\\s]+"))))
                || (value.getId() == null && (value.getPassword() == null || value.getPassword().isBlank()))
                || (value.getPassword() != null && value.getPassword().length() > 64)) {
            flash.addFlashAttribute("error", "请检查用户名、邮箱和密码。新增用户时须设置密码。");
            return "redirect:/users" + (value.getId() == null ? "" : "?edit=" + value.getId());
        }
        return change("users", value.getId() == null ? "新增用户成功" : "修改用户成功", flash,
                () -> (value.getId() == null ? users.insert(value) : users.update(value)) == 1);
    }

    @PostMapping("/users/{id}/delete")
    public String deleteUsers(@PathVariable int id, RedirectAttributes flash) {
        return change("users", "删除用户成功", flash, () -> users.delete(id) == 1);
    }

    @GetMapping("/orders")
    public String orders(@RequestParam(required = false) Integer edit, Model model, @RequestParam(required = false) Integer trace) {
        model.addAttribute("active", "orders");
        model.addAttribute("title", "订单管理");
        model.addAttribute("rows", orders.findAll());
        model.addAttribute("entry", edit == null ? new Orders() : required(orders.findById(edit)));
        model.addAttribute("users", users.findAll());
        if (trace != null) {
            model.addAttribute("relation", required(orders.findOrdersWithProductByJoin(trace)));
        }
        return "store";
    }

    @PostMapping("/orders/save")
    public String saveOrders(@ModelAttribute("entry") Orders value, BindingResult result, RedirectAttributes flash) {
        if (result.hasErrors() || value.getUserId() == null || value.getUserId() < 1 || value.getOrderDate() == null
                || value.getOrderDate().getYear() < 1000 || value.getOrderDate().getYear() > 9999) {
            flash.addFlashAttribute("error", "请选择用户并填写有效的下单日期。");
            return "redirect:/orders" + (value.getId() == null ? "" : "?edit=" + value.getId());
        }
        return change("orders", value.getId() == null ? "新增订单成功" : "修改订单成功", flash,
                () -> orderService.save(value));
    }

    @PostMapping("/orders/{id}/delete")
    public String deleteOrders(@PathVariable int id, RedirectAttributes flash) {
        return change("orders", "删除订单成功", flash, () -> orderService.deleteWithDetails(id));
    }

    @GetMapping("/details")
    public String details(@RequestParam(required = false) Integer edit, Model model) {
        model.addAttribute("active", "details");
        model.addAttribute("title", "订单明细管理");
        model.addAttribute("rows", details.findAll());
        model.addAttribute("entry", edit == null ? new OrderDetails() : required(details.findById(edit)));
        model.addAttribute("orders", orders.findAll());
        model.addAttribute("products", products.findAll());
        return "store";
    }

    @PostMapping("/details/save")
    public String saveOrderDetails(@ModelAttribute("entry") OrderDetails value, BindingResult result, RedirectAttributes flash) {
        if (result.hasErrors() || value.getOrderId() == null || value.getOrderId() < 1
                || value.getProductId() == null || value.getProductId() < 1
                || value.getQuantity() == null || value.getQuantity() < 1) {
            flash.addFlashAttribute("error", "请选择订单、商品，并填写大于零的购买数量。");
            return "redirect:/details" + (value.getId() == null ? "" : "?edit=" + value.getId());
        }
        return change("details", value.getId() == null ? "新增订单明细成功" : "修改订单明细成功", flash,
                () -> (value.getId() == null ? details.insert(value) : details.update(value)) == 1);
    }

    @PostMapping("/details/{id}/delete")
    public String deleteOrderDetails(@PathVariable int id, RedirectAttributes flash) {
        return change("details", "删除订单明细成功", flash, () -> details.delete(id) == 1);
    }

    private String change(String page, String success, RedirectAttributes flash, BooleanSupplier action) {
        try {
            if (action.getAsBoolean()) {
                flash.addFlashAttribute("notice", success);
            } else {
                flash.addFlashAttribute("error", "记录已不存在，请刷新页面后再试。");
            }
        } catch (DataIntegrityViolationException e) {
            flash.addFlashAttribute("error", "操作未保存。请检查重复记录或其他表中的关联记录。");
        }
        return "redirect:/" + page;
    }

    private <T> T required(T value) {
        if (value == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "记录不存在");
        }
        return value;
    }
}
