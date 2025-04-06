package humber.ca.project.dao;

import humber.ca.project.model.Product;
import humber.ca.project.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ProductImpl implements ProductDAO{
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    private void closeConnection() {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing connection: " + e.getMessage());
            }
        }
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing prepare statement: " + e.getMessage());
            }
        }
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing result set: " + e.getMessage());

            }
        }
    }

    @Override
    public boolean createProduct(Product product) {
        int row = 0;
        try {
            con = DBUtil.getConnection();
            String insert_product_sql =
                            "INSERT INTO products (product_name, model, description) " +
                            "VALUES (?, ?, ?)";
            ps = con.prepareStatement(insert_product_sql);

            ps.setString(1, product.getProductName());
            ps.setString(2, product.getModel());
            ps.setString(3, product.getDescription());

            row =  ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("SQL Exception creating new product: " + e.getMessage());
        } finally {
            closeConnection();
        }
        return row > 0;
    }

    @Override
    public Optional<Product> findProductById(int id) {
        Product product = null;
        try {
            con = DBUtil.getConnection();
            String find_product_by_id_sql =
                            "SELECT id, product_name, model, description " +
                            "FROM products " +
                            "WHERE id = ?";
            ps = con.prepareStatement(find_product_by_id_sql);

            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                product = mapResultSetToProduct(rs);
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception finding product by id: " + e.getMessage());
        } finally {
            closeConnection();
        }
        return Optional.ofNullable(product);
    }

    @Override
    public Optional<Product> findProductByProductName(String productName) {
        Product product = null;
        try {
            con = DBUtil.getConnection();
            String find_product_by_name_sql =
                            "SELECT id, product_name, model, description " +
                            "FROM products " +
                            "WHERE product_name = ?";
            ps = con.prepareStatement(find_product_by_name_sql);

            ps.setString(1, productName);
            rs = ps.executeQuery();

            if (rs.next()) {
                product = mapResultSetToProduct(rs);
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception finding product by product name: " + e.getMessage());
        } finally {
            closeConnection();
        }
        return Optional.of(product);
    }

    @Override
    public List<Product> findAllProducts() {
        List<Product> products = new ArrayList<>();
        try {
            con = DBUtil.getConnection();
            String find_all_products_sql =
                            "SELECT id, product_name, model, description " +
                            "FROM products";
            ps = con.prepareStatement(find_all_products_sql);

            rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception finding all products: " + e.getMessage());
        } finally {
            closeConnection();
        }
        return products;
    }

    @Override
    public boolean updateProduct(Product product) {
        int row = 0;
        try {
            con = DBUtil.getConnection();
            String update_product_sql =
                            "UPDATE products " +
                            "SET product_name = ?, model = ?, description = ? " +
                            "WHERE id = ?";
            ps = con.prepareStatement(update_product_sql);

            ps.setString(1, product.getProductName());
            ps.setString(2, product.getModel());
            ps.setString(3, product.getDescription());
            ps.setInt(4, product.getId());
            row = ps.executeUpdate();
        } catch (SQLException e) {
            if (e.getMessage().contains("duplicate")) {
                System.out.println("Duplicate product name");
            } else {
                System.out.println("SQL Exception updating product: " + e.getMessage());
            }
        } finally {
            closeConnection();
        }
        return row > 0;
    }

    @Override
    public boolean deleteProduct(int id) {
        int row = 0;
        try {
            con = DBUtil.getConnection();
            String delete_product_sql =
                            "DELETE FROM products " +
                            "WHERE id = ?";
            ps = con.prepareStatement(delete_product_sql);

            ps.setInt(1, id);

            row = ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("SQL Exception deleting product: " + e.getMessage());
        } finally {
            closeConnection();
        }
        return row > 0;
    }

    @Override
    public List<Product> searchProducts(String searchTerm) {
        List<Product> products = new ArrayList<>();
        try {
            con = DBUtil.getConnection();
            String find_product_by_name_sql =
                            "SELECT id, product_name, model, description " +
                            "FROM products " +
                            "WHERE product_name LIKE ?";
            ps = con.prepareStatement(find_product_by_name_sql);

            ps.setString(1, searchTerm);
            rs = ps.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception searching products: " + e.getMessage());
        }
        return products;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setProductName(rs.getString("product_name"));
        product.setModel(rs.getString("model"));
        product.setDescription(rs.getString("description"));

        return product;
    }
}
