package humber.ca.project.model;

public class Product {
    private int id;
    private String productName;
    private String model;
    private String description;

    public Product() {
    }

    public Product(int id, String productName, String model, String description) {
        this.id = id;
        this.productName = productName;
        this.model = model;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
