package humber.ca.project.dao;

import humber.ca.project.model.Claim;
import humber.ca.project.model.ClaimStatus;
import humber.ca.project.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ClaimDAOImpl implements ClaimDAO{
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    private void closeConnection() throws SQLException {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }

    @Override
    public boolean createClaim(Claim claim) {
        boolean success = false;
        try {
            con = DBUtil.getConnection();
            String insert_claim_sql =
                            "INSERT INTO claims (registered_product_id, date_of_claim, description, claim_status) " +
                            "VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(insert_claim_sql);

            ps.setInt(1, claim.getregisteredProductId());
            ps.setDate(2, claim.getDateOfClaim());
            ps.setString(3, claim.getDescription());
            ps.setString(4, claim.getClaimStatus().name());

            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("SQL Exception creating new claim: " + e.getMessage());
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing connection " + e.getMessage());
            }
        }
        return success;
    }

    @Override
    public Optional<Claim> findById(int id) {
        Claim claim = null;
        try {
            con = DBUtil.getConnection();
            String select_claim_by_id_sql =
                            "SELECT id, registered_product_id, date_of_claim, description, claim_status, created_at " +
                            "FROM claims " +
                            "WHERE id = ?";
            ps = con.prepareStatement(select_claim_by_id_sql);

            ps.setInt(1, id);

            if (rs.next()) {
                claim = mapResultSetToClaim(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing connection " + e.getMessage());
            }
        }
        return Optional.ofNullable(claim);
    }

    @Override
    public List<Claim> findByRegisteredProductId(int rpId) {
        List<Claim> claimList = new ArrayList<>();
        try {
            con = DBUtil.getConnection();
            String select_claims_by_rp_id_sql =
                            "SELECT id, registered_product_id, date_of_claim, description, claim_status, created_at " +
                            "FROM claims " +
                            "WHERE registered_product_id = ? " +
                            "ORDER BY date_of_claim DESC";
            ps = con.prepareStatement(select_claims_by_rp_id_sql);
            ps.setInt(1, rpId);
            rs = ps.executeQuery();
            while (rs.next()) {
                claimList.add(mapResultSetToClaim(rs));
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception finding claims by registered product id " + e.getMessage());
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing connection " + e.getMessage());
            }
        }
        return claimList;
    }

    @Override
    public int countClaimsInWindow(int rpInt, Date purchaseDate) {
        int count = -1;
        if (purchaseDate == null) {
            System.out.println("Purchase date is null.");
            return -1;
        }

        try {
            con = DBUtil.getConnection();
            String count_claims_sql =
                            "SELECT COUNT(*) " +
                            "FROM claims " +
                            "WHERE registered_product_id = ? AND date_of_claim BETWEEN ? AND DATE_ADD(?, INTERVAL 5 YEAR)";
            ps = con.prepareStatement(count_claims_sql);

            ps.setInt(1, rpInt);
            ps.setDate(2, purchaseDate);
            ps.setDate(3, purchaseDate);

            rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception counting claims in window");
            return -1;
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing connection " + e.getMessage());
            }
        }
        return count;
    }

    @Override
    public List<Claim> findAllClaims() {
        List<Claim> claimList = new ArrayList<>();
        try {
            con = DBUtil.getConnection();
            String select_all_claims_sql =
                            "SELECT id, registered_product_id, date_of_claim, description, claim_status, created_at " +
                            "FROM claims " +
                            "ORDER BY created_at DESC";
            ps = con.prepareStatement(select_all_claims_sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                claimList.add(mapResultSetToClaim(rs));
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception finding all claims " + e.getMessage());
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing connection " + e.getMessage());
            }
        }
        return claimList;
    }

    @Override
    public boolean updateClaimStatus(int claimId, ClaimStatus newStatus) {
        boolean success = false;
        try {
            con = DBUtil.getConnection();
            String update_claim_status_sql =
                            "UPDATE claims " +
                            "SET claim_status = ? " +
                            "WHERE id = ?";
            ps = con.prepareStatement(update_claim_status_sql);

            ps.setString(1, newStatus.name());
            ps.setInt(2, claimId);

            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("SQL Exception updating claims status " + e.getMessage());
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing connection " + e.getMessage());
            }
        }
        return success;
    }

    @Override
    public List<Claim> findClaimByClaimStatus(ClaimStatus claimStatus) {
        return null;
    }

    private Claim mapResultSetToClaim(ResultSet rs) throws SQLException {
        Claim claim = new Claim();
        claim.setId(rs.getInt("id"));
        claim.setregisteredProductId(rs.getInt("registered_product_id"));
        claim.setDateOfClaim(rs.getDate("date_of_claim"));
        claim.setDescription(rs.getString("description"));
        claim.setClaimStatusFromString(rs.getString("claim_status"));
        claim.setCreatedAt(rs.getTimestamp("created_at"));

        return claim;

    }
}
