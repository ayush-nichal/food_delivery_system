USE zomato;

CREATE TABLE users (
    user_id INT NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(50),
    phone_number INT NOT NULL,
    user_address VARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    PRIMARY KEY (user_id)
);

CREATE TABLE restaurant_table (
    res_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    owner_id INT NOT NULL,
    food_category VARCHAR(50) NOT NULL,
    address VARCHAR(100),
    phone_number INT NOT NULL,
    rating FLOAT,
    description VARCHAR(100),
    created_at DATETIME,
    updated_at DATETIME,
    PRIMARY KEY (res_id),
    FOREIGN KEY (owner_id) REFERENCES users(user_id)
);

CREATE TABLE Menus (
    menu_item_id INT AUTO_INCREMENT PRIMARY KEY,
    res_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(250),
    price FLOAT NOT NULL,
    availability BOOLEAN DEFAULT TRUE,
    category VARCHAR(100),
    FOREIGN KEY (res_id) REFERENCES restaurant_table(res_id)
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    res_id INT NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    total_price DECIMAL(10, 2) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivery_date TIMESTAMP,
    delivery_address VARCHAR(255) NOT NULL,
    payment_status VARCHAR(50) DEFAULT 'pending',
    payment_method VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant_table(res_id)
);

CREATE TABLE Deliveries (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    delivery_person_id INT NOT NULL,
    pickup_time TIMESTAMP,
    delivery_time TIMESTAMP,
    status VARCHAR(50) DEFAULT 'out for delivery',
    delivery_address VARCHAR(255) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (delivery_person_id) REFERENCES users(user_id)
);

CREATE TABLE Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    res_id INT NOT NULL,
    rating INT NOT NULL,
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant_table(res_id)
);

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(50) DEFAULT 'pending',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_time_of_order DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (menu_item_id) REFERENCES Menus(menu_item_id)
);

CREATE TABLE Admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    role VARCHAR(50) DEFAULT 'admin',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert Sample Data
INSERT INTO Users (user_id, user_name, email, phone_number, user_address, created_at, updated_at) VALUES
(1, 'John Doe', 'john.doe@example.com', 55512, '123 Main St, City', NOW(), NOW()),
(2, 'Jane Smith', 'jane.smith@example.com', 55523, '456 Oak St, City', NOW(), NOW());

INSERT INTO restaurant_table (res_id, name, owner_id, food_category, address, phone_number, rating, description, created_at, updated_at) VALUES
(1, 'Pizza Palace', 1, 'Italian', '123 Main St, City', 55512, 4.5, 'Best pizzas in town!', NOW(), NOW());

-- Sample Queries
SELECT o.order_id, u.user_name, r.name AS restaurant_name, o.total_price, o.order_date, o.delivery_date, o.payment_status
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
JOIN restaurant_table r ON o.res_id = r.res_id
WHERE o.payment_status = 'paid' AND o.status = 'delivered';

SELECT m.menu_item_id, m.name AS menu_item_name, m.price, r.name AS restaurant_name
FROM Menus m
JOIN restaurant_table r ON m.res_id = r.res_id
WHERE m.price > 5 AND m.availability = TRUE;

COMMIT;
