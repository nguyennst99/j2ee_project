package humber.ca.project.model;

public enum ClaimStatus {
    Submitted,
    Processing,
    Approved,
    Rejected;

    public static ClaimStatus fromString(String text) {
        if (text != null) {
            for (ClaimStatus cs : ClaimStatus.values()) {
                if (text.equalsIgnoreCase(cs.name())) {
                    return cs;
                }
            }
        }
        return Submitted;
    }
}
