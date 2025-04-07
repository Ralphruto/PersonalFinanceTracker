# Personal Finance Tracker - SQLite

A relational database designed to track personal finances, including income, expenses, budgets, and alerts, using SQLite.

## Overview

This project is a database schema for a personal finance tracking application. It allows users to manage their income, expenses, budgets, and categories, with features to set monthly budget limits and store alerts. The database is designed with normalization principles and foreign key constraints to ensure data integrity and scalability, making it a robust foundation for a finance tracking application.

## Features

- **User Management**:
  - Stores user information (name, email, password hash, preferred currency).
- **Categories**:
  - Defines expense categories (e.g., Food, Entertainment) with optional default budget limits.
- **Budgets**:
  - Sets user-specific monthly budget limits for each category.
  - Supports start and end dates for temporary budgets.
- **Income Tracking**:
  - Records income entries with amount, source, and date.
- **Expense Tracking**:
  - Tracks expenses linked to users and categories, with amount, date, and description.
- **Alerts**:
  - Stores alerts for budget limits or other conditions, linked to users and categories.
- **Data Integrity**:
  - Uses foreign key constraints to maintain referential integrity.
  - Applies normalization principles to reduce redundancy.
- **Sample Data**:
  - Includes sample users, categories, and budgets for testing purposes.

## Project Structure

- `schema.sql`: SQL file containing the database schema (table definitions) and sample data.
- `queries.sql` *(optional)*: Example SQL queries for financial summaries, monthly reports, and budget insights.

## Technologies Used

- **SQLite**: For the relational database management system.
- **SQL**: For defining the schema, constraints, and sample data.

## Usage

To use this database:
1. Install SQLite on your system (e.g., `brew install sqlite` on macOS).
2. Create a new SQLite database: `sqlite3 finance_tracker.db`.
3. Run the schema: `sqlite3 finance_tracker.db < schema.sql`.
4. Query the database using SQLite commands or integrate it into an application.

## Example Queries *(if you added `queries.sql`)*

Here are some example queries to generate financial insights:
- **Total Expenses per Category**:
  ```sql
  SELECT c.category_name, SUM(e.amount) as total_expenses
  FROM Expenses e
  JOIN Categories c ON e.category_id = c.category_id
  WHERE e.user_id = 1
  GROUP BY e.category_id, c.category_name;
  ```
- **Monthly Report (Expenses vs Budget)**:
  ```sql
  SELECT c.category_name, b.monthly_limit, 
         COALESCE(SUM(e.amount), 0) as total_spent,
         (b.monthly_limit - COALESCE(SUM(e.amount), 0)) as remaining_budget
  FROM Budgets b
  JOIN Categories c ON b.category_id = c.category_id
  LEFT JOIN Expenses e ON e.category_id = b.category_id 
      AND e.user_id = b.user_id 
      AND strftime('%Y-%m', e.date) = '2024-01'
  WHERE b.user_id = 1
  GROUP BY c.category_name, b.monthly_limit;
  ```

## Future Improvements

- Add more complex SQL queries for advanced financial analysis.
- Implement triggers to automatically generate alerts when budget limits are exceeded.
- Integrate with a front-end application for user interaction and visualization.
