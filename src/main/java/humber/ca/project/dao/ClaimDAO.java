package humber.ca.project.dao;

import humber.ca.project.model.Claim;
import humber.ca.project.model.ClaimStatus;

import java.sql.Date;
import java.util.List;
import java.util.Optional;

public interface ClaimDAO {
    /**
     * Create a new claim
     * @param claim object
     * @return true if creation was successful, false otherwise
     */
    boolean createClaim(Claim claim);


    /**
     * Find a specific claim by its `id`
     * @param id the ID of the claim
     * @return an optional containing the Claim if found
     */
    Optional<Claim> findById(int id);


    /**
     * Find all claims by a specific registered product id
     * @param rpId The ID of the registered product
     * @return a list of claim
     */
    List<Claim> findByRegisteredProductId(int rpId);


    /**
     * Counts the number of claims for a specific registered product
     * @param rpInt The ID of the registered product
     * @param purchaseDate The purchase date of the registered product
     * @return The number of eligible claims
     */
    int countClaimsInWindow(int rpInt, Date purchaseDate);

    /**
     * Find all claims for Admin view
     * @return a list of all claims
     */
    List<Claim> findAllClaims();


    /**
     * For Admin update
     */
    boolean updateClaimStatus(int claimId, ClaimStatus newStatus);


    /**
     * Filter claims by claim status
     * For Admin view
     */
    List<Claim> findClaimByClaimStatus(ClaimStatus claimStatus);
}
