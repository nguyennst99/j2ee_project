package humber.ca.project.model;

import java.util.List;
import java.util.Map;

public class UserReportDetail {
    private User user;
    // List of products registered by this user
    private List<RegisteredProduct> registeredProducts;
    // Map of claims for each registered product (Key: registeredProductId
    private Map<Integer, List<Claim>> productClaimsMap;

    public UserReportDetail(User user, List<RegisteredProduct> registeredProducts, Map<Integer, List<Claim>> productClaimsMap) {
        this.user = user;
        this.registeredProducts = registeredProducts;
        this.productClaimsMap = productClaimsMap;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<RegisteredProduct> getRegisteredProducts() {
        return registeredProducts;
    }

    public void setRegisteredProducts(List<RegisteredProduct> registeredProducts) {
        this.registeredProducts = registeredProducts;
    }

    public Map<Integer, List<Claim>> getProductClaimsMap() {
        return productClaimsMap;
    }

    public void setProductClaimsMap(Map<Integer, List<Claim>> productClaimsMap) {
        this.productClaimsMap = productClaimsMap;
    }
}
