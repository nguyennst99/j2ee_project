package humber.ca.project.dao;

import humber.ca.project.model.Product;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface ProductDAO {
    boolean createProduct(Product product) ;
    Optional<Product> findProductById(int id) ;
    Optional<Product> findProductByProductName(String productName) ;
    List<Product> findAllProducts() ;
    boolean updateProduct(Product product) ;
    boolean deleteProduct(int id) ;
    List<Product> searchProducts(String searchTerm);
}
