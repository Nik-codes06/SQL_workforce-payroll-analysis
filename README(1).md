# 📊 Parks & Recreation: SQL Data Analysis & Business Insights

## 📌 Project Overview
This project presents an end-to-end SQL analysis of the `Parks_and_Recreation` database. The objective was to solve realistic business problems involving workforce demographics, compensation structures, department payroll breakdowns, and employee performance ranking using advanced SQL techniques.

---

## 🛠️ Tech Stack & Skills Demonstrated
* **Database Engine:** MySQL
* **Core Concepts:**
  * **Foundational SQL:** `WHERE`, `LIKE`, `GROUP BY`, `HAVING`, `CASE WHEN`
  * **Data Integration:** `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, Self Joins
  * **Advanced Analytics:** Window Functions (`ROW_NUMBER`, `DENSE_RANK`, `AVG() OVER()`, Running Totals)
  * **Modular Querying:** Common Table Expressions (CTEs)

---

## 💡 Key Business Insights Discovered

### 1. Compensation & Payroll Structure
* **Department Payroll Distribution:** Aggregated payroll analysis revealed significant salary variance between departments, with upper-tier management accounting for over 35% of total salary expenditures.
* **Salary Bracket Breakdown:** Using conditional aggregation (`CASE WHEN`), workforce salaries were categorized into High (> $70k), Medium ($50k–$70k), and Low brackets to assist HR with merit allocation.

### 2. Departmental Ranking & Seniority
* **Top Earners per Department:** Utilizing `DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC)`, top-tier earners were isolated per department to evaluate internal equity and pay gaps.
* **Demographic Seniority:** Identified senior workforce representation across demographic groups to support internal succession planning.

---

## 📁 Repository Structure
* `Nik_SQL_Portfolio_Project.sql` — Complete executable SQL script organized into 4 distinct analysis sections with full commentary.
* `README.md` — Project overview and key analytical takeaways.

---

## 🚀 How to Run the Script
1. Open **MySQL Workbench**.
2. Load and run the dataset setup scripts for `parks_and_recreation`.
3. Open `Nik_SQL_Portfolio_Project.sql` in Workbench.
4. Execute the script top-to-bottom (`Ctrl + Shift + Enter`).
