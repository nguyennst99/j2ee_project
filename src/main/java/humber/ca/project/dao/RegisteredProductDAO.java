package humber.ca.project.dao;

import humber.ca.project.model.RegisteredProduct;

import java.util.List;
import java.util.Optional;

public interface RegisteredProductDAO {
    /**
     * Register a new product for a user
     * @param registeredProduct object
     * @return true if registration was successfully, false otherwise
     */
    boolean registerProduct(RegisteredProduct registeredProduct);

    /**
     * Find all products registered by a specific user
     * @param userId (The Id of the user)
     * @return a list of registered products
     */
    List<RegisteredProduct> findByUserId(int userId);

    /**
     * Find a specific registered product by its ID
     * @param id (The ID of the registered product)
     * @return an optional containing the Registered Product if found
     */
    Optional<RegisteredProduct> findById(int id);

    /**
     * Find a specific registered product with detail by its ID
     * @param id (The ID of the registered product)
     * @return an optional containing the Registered Product if found
     */
    Optional<RegisteredProduct> findByIdWithDetail(int id);

    List<RegisteredProduct> searchRegisteredProducts(String searchTerm);
}
