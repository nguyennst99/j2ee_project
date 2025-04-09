package humber.ca.project.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Claim {
    private int id;
    private int registeredProductId;
    private Date dateOfClaim;
    private String description;

    private ClaimStatus claimStatus;
    private Timestamp createdAt;

    private RegisteredProduct regProduct;

    public Claim() {
        this.claimStatus = ClaimStatus.Submitted;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getregisteredProductId() {
        return registeredProductId;
    }

    public void setregisteredProductId(int registeredProductId) {
        this.registeredProductId = registeredProductId;
    }

    public Date getDateOfClaim() {
        return dateOfClaim;
    }

    public void setDateOfClaim(Date dateOfClaim) {
        this.dateOfClaim = dateOfClaim;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public ClaimStatus getClaimStatus() {
        return claimStatus;
    }

    public void setClaimStatus(ClaimStatus claimStatus) {
        this.claimStatus = claimStatus;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public RegisteredProduct getRegProduct() {
        return regProduct;
    }

    public void setRegProduct(RegisteredProduct regProduct) {
        this.regProduct = regProduct;
    }

    public void setClaimStatusFromString(String statusString) {
        this.claimStatus = ClaimStatus.fromString(statusString);
    }
}
