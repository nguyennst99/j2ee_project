# Checklist: ABC Insurance Protection Plan Web App (Jakarta EE)

## Phase 1: User Authentication & Account Management (Req 1, 3)

-   [x] **Model:** Create `User.java` bean matching finalized `users` table schema  (Role enum `user`/`admin`, handle potential split name).
-   [x] **DAO Interface:** Define `UserDAO.java` (methods: `create`, `findByUsername`, `findByUsername`, `findById`, `findAll`, `search`).
-   [x] **DAO Implementation:** Implement `UserDAOImpl.java`.
    -   [x] Implement `createUser` (handle duplicate errors based on *actual* unique constraints).
    -   [x] Implement `findUserByUsername`.
    -   [x] Implement `findUserByEmail`.
    -   [x] Implement `findUserById`.
    -   [x] Implement `findAllUsers`.
    -   [x] Implement `searchUsers`.
-   [x] **Registration View:** Create `register.jsp`.
    -   [x] Include fields matching finalized `users` schema
    -   [x] Use JSTL for errors/repopulation.
-   [x] **Registration Controller:** Implement `RegisterServlet.java` (`@WebServlet("/register")`).
    -   [x] `init`: Load `UserDaoImpl`.
    -   [x] `doPost`:
        -   [x] Get parameters.
        -   [x] **Server-side validation** (required, length constraints based on *actual* schema, format, password match).
        -   [x] Handle validation failure (forward back to `register.jsp`).
        -   [x] Create `User` object (set role to `USER`).
        -   [x] Call `userDAO.createUser`.
        -   [x] Handle success (redirect to login).
        -   [x] Handle failure (duplicate user - forward back).
        -   [x] Handle `SQLException`.
-   [x] **Login View:** Create `login.jsp`.
    -   [x] Fields for username, password. Display errors/success messages.
-   [x] **Login Controller:** Implement `LoginServlet.java` (`@WebServlet("/login")`).
    -   [x] `doPost`:
        -   [x] Get/validate parameters.
        -   [x] Call `userDAO.findUserByUsernameAndPassword`.
        -   [x] Handle success: Create `HttpSession`, store user info (id, username, role enum), redirect to `/dashboard`.
        -   [x] Handle failure: Forward back to `login.jsp` with error.
-   [x] **Logout Controller:** Implement `LogoutServlet.java` (`@WebServlet("/logout")`). Invalidate session, redirect.
-   [x] **Basic Welcome Page:** Create `index.jsp`.
-   [x] **Basic Dashboard View:** Create `dashboard.jsp`.

## Phase 2: Dashboard & Security Filter (Req 3)
-   [x] **Dashboard Controller:** Implement `DashboardServlet.java`. (`@WebServlet("/dashboard")`).
-   [x] **Authentication Filter:** Implement `AuthenticationFilter.java`.
    -   [x] Map to protected URL patterns (`/dashboard/*`, `/registerProduct`, `/addClaim`, `/admin/*`).
    -   [x] Check session for user object. Redirect if null.
    -   [x] Allow public pages.
-   [x] **Configure Filter:** Use `@WebFilter`.

## Phase 3: Product Catalog Management (Admin - Req 4)

-   [x] **Model:** Create `Product.java` bean matching finalized `products` schema (incl. `description` if added).
-   [x] **DAO Interface:** Define `ProductDAO.java` (methods: `create`, `findById`, `findByName`, `findAll`, `update`, `delete`, `search`).
-   [x] **DAO Implementation:** Implement `ProductDAOImpl.java` (handle unique constraint on `product_name`).
-   [x] **Admin Authorization:** Update `AuthenticationFilter` or create `AdminFilter` checking `user.getRole() == Role.ADMIN` for `/admin/*` paths.
-   [x] **List Products View:** Create `admin/listProducts.jsp`. Display products, add/edit/delete links.
-   [x] **Edit Product View:** Create `admin/editProduct.jsp`. Form for `product_name`, `model` (and `description` if added). Handle add/update.
-   [x] **Admin Product Controller:** Implement `AdminProductServlet.java` (`@WebServlet("/admin/products")`). Handle GET (list, add form, edit form), POST (create, update, delete). Validate input.

## Phase 4: Product Registration (User - Req 1)

-   [x] **Model:** Create `RegisteredProduct.java` bean matching schema.
-   [x] **DAO Interface:** Define `RegisteredProductDAO.java` (methods: `register`, `findByUserId`, `findById`, `search`).
-   [x] **DAO Implementation:** Implement `RegisteredProductDAOImpl.java` (handle unique key `(product_id, serial_number)`).
-   [x] **Register Product View:** Create `registerProduct.jsp` (`/WEB-INF/views/`).
    -   [x] Dynamic `<select>` for "Product Name" (`productDAO.findAll`).
    -   [x] Fields for `serial_number`, `purchase_date`.
-   [x] **Register Product Controller:** Implement `ProductRegistrationServlet.java` (`@WebServlet("/registerProduct")`).
    -   [x] `doGet`: Fetch product list, show form.
    -   [x] `doPost`: Validate input, get `user_id` from session, call DAO, handle success/failure (incl. duplicate error).
-   [x] **Update Dashboard View:** Modify `dashboard.jsp`. List user's products (`registeredProductDAO.findByUserId`). Link to `/registerProduct`.

## Phase 5: Claim Management (User & Admin - Req 2, 4)

-   [ ] **Model:** Create `Claim.java` bean (with `ClaimStatus` enum matching schema `Submitted`, `Processing`, `Approved`, `Rejected`).
-   [ ] **DAO Interface:** Define `ClaimDAO.java` (methods: `create`, `findByRegisteredProductId`, `findById`, `updateStatus`, `getCountForProductInWindow`, `findAll`, `findByStatus`, `findClaimsForUserReport`).
-   [ ] **DAO Implementation:** Implement `ClaimDAOImpl.java`. Implement `getCountForProductInWindow` (check count within 5 years of purchase date - needs join or fetch `purchase_date`).
-   [ ] **Add Claim View:** Create `addClaim.jsp` (`/WEB-INF/views/`). Pass `registered_product_id`. Fields for `date_of_claim`, `description`.
-   [ ] **User Claim Controller:** Implement `ClaimServlet.java` (`@WebServlet("/addClaim")`).
    -   [ ] `doGet`: Show form.
    -   [ ] `doPost`: Validate input. **Business Logic:** Verify ownership, check claim count < 3 within 5 years (`claimDAO.getCountForProductInWindow`). Handle validation failure. Call `claimDAO.createClaim`. Redirect.
-   [ ] **Update Dashboard View:** Modify `dashboard.jsp`. Below each product, list its claims (`claimDAO.findByRegisteredProductId`). Show status. Add "Add Claim" button (pass `registered_product_id`).
-   [ ] **Admin List Claims View:** Create `admin/listClaims.jsp`. Display claims. Allow status change.
-   [ ] **Admin Claim Controller:** Implement `AdminClaimServlet.java` (`@WebServlet("/admin/claims")`). GET (list claims), POST (update status via `claimDAO.updateStatus`).

## Phase 6: Admin Reporting & Search (Req 4)

-   [ ] **Admin Dashboard View:** Create `admin/dashboard.jsp`. Links to admin sections.
-   [ ] **Admin User Search/List View:** Create `admin/listUsers.jsp`. Search form. Display results (`userDAO`).
-   [ ] **Admin User Controller:** Implement `AdminUserServlet.java` (`@WebServlet("/admin/users")`).
-   [ ] **Admin Registered Product Search/List View:** Create `admin/listRegisteredProducts.jsp`. Search form. Display results (`RegisteredProductDAO`).
-   [ ] **Admin Registered Product Controller:** Implement `AdminRegisteredProductServlet.java` (`@WebServlet("/admin/registeredProducts")`).
-   [ ] **Admin Report View:** Create `admin/reportAll.jsp`.
-   [ ] **Admin Report Controller:** Implement `AdminReportServlet.java` (`@WebServlet("/admin/reports/all")`). Fetch data for "Users, Registered Products, Claims" report (using JOINs or multiple DAO calls). Pass data to JSP.

## Phase 7: New Unique Functionality (Req 5 - E.g., Warranty Expiry Notification)

-   [ ] **Add Dependency:** Add JavaMail API.
-   [ ] **Configure Mail:** Securely store mail server settings.
-   [ ] **Email Utility:** Create `EmailUtil.java`.
-   [ ] **DAO Method:** Add `findExpiringSoon(int days)` to `RegisteredProductDAO`.
-   [ ] **Scheduler:** Implement `ServletContextListener` (start/stop `ScheduledExecutorService`). Schedule task: call DAO, send emails via `EmailUtil`.

## Phase 8: Final Touches & Deployment (Guideline)

-   [ ] **UI Refinement:** Apply CSS. Improve layout.
-   [ ] **Client-Side Validation:** Add basic JS validation (optional).
-   [ ] **Error Handling:** User-friendly error pages (404, 500). Graceful `SQLException` handling.
-   [ ] **Security Review:** Double-check validation, password hashing, filters, JSTL escaping (`c:out`), credential handling.
-   [ ] **Testing:** Thorough manual testing (user/admin flows, edge cases, validation, security).
-   [ ] **Deployment Preparation:** Build `.war`. Choose host (Heroku free tier changes, Render, Fly.io, etc.). Configure DB/mail connection details for host environment.
-   [ ] **Deploy Application.**
-   [ ] **Post-Deployment Testing.**