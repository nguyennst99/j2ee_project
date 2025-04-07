package humber.ca.project.dao;

import humber.ca.project.model.Product;
import humber.ca.project.model.RegisteredProduct;
import humber.ca.project.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class RegisteredProductDAOImpl implements RegisteredProductDAO{
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    private void closeConnection() throws SQLException {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }

    @Override
    public boolean registerProduct(RegisteredProduct registeredProduct) {
        int row = 0;
        try {
            con = DBUtil.getConnection();
            String insert_reg_product_sql =
                            "INSERT INTO registered_products (user_id, product_id, serial_number, purchase_date) " +
                            "VALUES (?,?,?,?)";
            ps = con.prepareStatement(insert_reg_product_sql);

            ps.setInt(1, registeredProduct.getUserId());
            ps.setInt(2, registeredProduct.getProductId());
            ps.setString(3, registeredProduct.getSerialNumber());
            ps.setDate(4, registeredProduct.getPurchaseDate());

            row = ps.executeUpdate();
        } catch (SQLException e) {
            if (e.getMessage().contains("duplicate")) {
                System.out.println("Duplicate registration (product_id and serial_number exists");
            } else {
                System.out.println("SQL Exception registering product" + e.getMessage());
            }
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
        return row > 0;
    }

    @Override
    public List<RegisteredProduct> findByUserId(int userId) {
        List<RegisteredProduct> regProductList = new ArrayList<>();
        try {
            con = DBUtil.getConnection();
            String find_by_user_id_sql =
                            "SELECT rp.id, rp.user_id, rp.product_id, rp.serial_number, rp.purchase_date, " +
                            "p.product_name, p.model, p.description " +
                            "FROM registered_products rp " +
                            "JOIN products p ON rp.product_id = p.id " +
                            "WHERE rp.user_id = ? " +
                            "ORDER BY rp.purchase_date DESC";
            ps = con.prepareStatement(find_by_user_id_sql);

            ps.setInt(1, userId);

            rs = ps.executeQuery();
            while (rs.next()) {
                regProductList.add(mapResultSetToRegProductWithProductDetail(rs));
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception finding by user id: " + e.getMessage());
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
        return regProductList;
    }

    @Override
    public Optional<RegisteredProduct> findById(int id) {
        RegisteredProduct registeredProduct = null;
        try {
            con = DBUtil.getConnection();
            String find_by_id_sql =
                            "SELECT id, user_id, product_id, serial_number, purchase_date " +
                            "FROM registered_products WHERE id = ?";
            ps = con.prepareStatement(find_by_id_sql);

            ps.setInt(1, id);
            if (rs.next()) {
                registeredProduct = mapResultSetToRegProduct(rs);
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception finding by id: " + e.getMessage());
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
        return Optional.ofNullable(registeredProduct);
    }

    private RegisteredProduct mapResultSetToRegProduct(ResultSet rs) throws SQLException {
        RegisteredProduct regProduct = new RegisteredProduct();
        regProduct.setId(rs.getInt("id"));
        regProduct.setProductId(rs.getInt("product_id"));
        regProduct.setUserId(rs.getInt("user_id"));
        regProduct.setSerialNumber(rs.getString("serial_number"));
        regProduct.setPurchaseDate(rs.getDate("purchase_date"));

        return regProduct;
    }

    private RegisteredProduct mapResultSetToRegProductWithProductDetail(ResultSet rs) throws SQLException {
        RegisteredProduct regProduct = mapResultSetToRegProduct(rs);
        Product product = new Product();

        product.setId(regProduct.getId());
        product.setProductName(rs.getString("product_name"));
        product.setModel(rs.getString("model"));
        product.setDescription("description");

        regProduct.setProduct(product);

        return regProduct;
    }
}
