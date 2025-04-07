-- Remove the CREATE DATABASE and USE statements if using SQLite

-- Table to store user information
CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    currency TEXT DEFAULT 'USD' -- Preferred currency
);

-- Table for expense and budget categories
CREATE TABLE Categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name TEXT UNIQUE NOT NULL,
    description TEXT,
    default_limit DECIMAL(10, 2) DEFAULT NULL -- Optional default limit if user-specific budget not set
);

-- Table to store user-specific monthly budget limits
CREATE TABLE Budgets (
    budget_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    monthly_limit DECIMAL(10, 2) NOT NULL CHECK (monthly_limit >= 0), -- Must be non-negative
    start_date DATE NOT NULL,
    end_date DATE DEFAULT NULL, -- Optional: Allows temporary budgets
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE CASCADE
);

-- Table to record income entries for each user
CREATE TABLE Incomes (
    income_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount >= 0), -- Non-negative value
    source TEXT,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Table to record expense entries for each user, linked to categories
CREATE TABLE Expenses (
    expense_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount >= 0), -- Non-negative value
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE CASCADE
);

-- Table to store alerts for each user, triggered by budget limits or other conditions
CREATE TABLE Alerts (
    alert_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    alert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    type TEXT NOT NULL, -- Replace ENUM with TEXT in SQLite
    message TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE CASCADE
);

-- Insert some sample categories
INSERT INTO Categories (category_name, description, default_limit) VALUES
('Food', 'Expenses related to food and dining', 500.00),
('Entertainment', 'Expenses for entertainment and leisure', 300.00),
('Utilities', 'Monthly utilities like electricity, water, etc.', 200.00),
('Transport', 'Transportation expenses', 150.00);

-- Sample data for testing purposes (can be removed in production)
INSERT INTO Users (name, email, password_hash, currency) VALUES
('Alice Smith', 'alice@example.com', 'passwordhash1', 'USD'),
('Bob Johnson', 'bob@example.com', 'passwordhash2', 'EUR');

INSERT INTO Budgets (user_id, category_id, monthly_limit, start_date) VALUES
(1, 1, 400.00, '2024-01-01'), -- User 1, Food category
(1, 2, 250.00, '2024-01-01'), -- User 1, Entertainment category
(2, 1, 500.00, '2024-01-01'); -- User 2, Food category
