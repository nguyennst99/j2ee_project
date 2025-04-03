package humber.ca.project.model;

public class User {
    private int id;
    private String username;
    private String password;
    private String cellphone;
    private String email;
    private String name;
    private String address;
    private Role role;

    public User() {
    }

    public User(int id, String username, String password, String cellphone, String email, String name, String address, Role role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.cellphone = cellphone;
        this.email = email;
        this.name = name;
        this.address = address;
        this.role = role;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getCellphone() {
        return cellphone;
    }

    public void setCellphone(String cellphone) {
        this.cellphone = cellphone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public void setRoleFromString(String roleString) {
        this.role = Role.fromString(roleString);
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
