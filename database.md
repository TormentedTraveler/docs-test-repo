# Database Documentation

## Overview

This documentation provides details about the database schema, including the Entity-Relationship Diagram (ERD) and Relational Model. It serves as a reference for developers and analysts working with the database.

---

## Entity-Relationship Diagram (ERD)

<img src="./src/database-er-diagram.png">

The ERD provides a high-level visual representation of the entities, their attributes, and the relationships between them. Each entity is represented as a rectangle, with lines indicating relationships.

### Key Features of the ERD:

1. **Entities**: Represented as rectangles, showcasing key data groups.
2. **Attributes**: Listed within each entity, detailing the data stored.
3. **Relationships**: Lines connecting entities, indicating how they are related.

---

## Relational Model

<img src="./src/database-relational-model.png">

The Relational Model provides a detailed view of the database schema, including tables, primary keys, foreign keys, and constraints.

### Tables and Relationships:

1. **Primary Keys (PK)**: Uniquely identify each row in a table.
2. **Foreign Keys (FK)**: Define relationships between tables.
3. **Constraints**: Ensure data integrity (e.g., UNIQUE, NOT NULL).

---

## Table Descriptions

### Example Table: `students`

| Column Name       | Data Type    | Constraints      | Description                         |
| ----------------- | ------------ | ---------------- | ----------------------------------- |
| `student_id`      | INT          | PK, NOT NULL     | Unique identifier for each student. |
| `first_name`      | VARCHAR(50)  | NOT NULL         | First name of the student.          |
| `last_name`       | VARCHAR(50)  | NOT NULL         | Last name of the student.           |
| `email`           | VARCHAR(100) | UNIQUE, NOT NULL | Email address of the student.       |
| `enrollment_date` | DATE         |                  | Date when the student was enrolled. |

### Relationships:

- `students` is related to `courses` through `enrollments`.

---

## How to Use the Database

1. **Data Insertion**: Ensure all mandatory fields are populated and constraints are followed.
2. **Querying**: Utilize relationships between tables to fetch comprehensive data.
3. **Updating Records**: Respect foreign key constraints to avoid integrity issues.

---

## Additional Notes

- Keep the ERD and Relational Model images updated as the schema evolves.
- Regularly validate the database structure against the documentation to ensure accuracy.

