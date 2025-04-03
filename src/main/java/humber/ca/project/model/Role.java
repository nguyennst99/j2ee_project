package humber.ca.project.model;

public enum Role {
    user,
    admin;

    public static Role fromString(String text) {
        if (text != null) {
            for (Role role : Role.values()) {
                if (text.equalsIgnoreCase(role.name())) {
                    return role;
                }
            }
        }
        System.out.println("Invalid role: " + text);
        return user;
    }
}
