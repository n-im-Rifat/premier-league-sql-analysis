# ⚽ Premier League Analysis: The Christmas Curse & The "Hunter" Mentality

### 📌 Project Overview
**"Does being top of the league at Christmas guarantee the title?"**

This project analyzes 30 years of English Premier League data (1993–2022) to test the "Christmas Number One" myth. Beyond simple win rates, I developed a behavioral profile for major teams to identify which clubs crumble under pressure ("Bottlers") and which thrive on the chase ("Hunters").

### ❓ The Business Questions
1.  **The Myth:** What is the statistical probability of winning the league if you are 1st on Dec 25th?
2.  **The Safe Zone:** Is there a specific rank threshold where champions usually come from?
3.  **The Personality Test:** Which teams statistically recover best from points deficits, and which surrender leads most often?

### 🛠️ Tech Stack & Skills
* **Database:** PostgreSQL (via DataGrip)
* **Advanced SQL Techniques:**
    * **CTEs (Common Table Expressions):** To structure complex logical steps.
    * **Window Functions (`RANK`, `PARTITION`):** To calculate historical standings at specific dates.
    * **Temporal Logic:** Filtering data dynamically using `MAKE_DATE`.
    * **Views:** Created persistent data structures (`champions_at_xmas`) for efficient querying.

---

### 📊 Key Findings

#### 1. The "Coin Flip" Reality
Leading the league at Christmas is **not** a guarantee. Historical data shows a conversion rate of only **53.3%**. Effectively, being "The Hunted" is a coin flip.

#### 2. The "Safe Zone" Rule
If you aren't 1st, you must be 2nd. A staggering **77%** of all Premier League champions came from the Top 2 spots at Christmas. Teams ranked 3rd or lower rely on statistical anomalies (outliers) to win.

#### 3. The "Hunter vs. Bottler" Twist
By isolating data from the modern era (2000–Present) and manually factoring in the 2022/23 and 2023/24 seasons, a clear psychological divide emerges:
* **🔵 The Ultimate Hunter:** **Man City** has perfected the art of winning from behind, often overcoming Christmas deficits to lift the trophy.
* **🔴 The Statistical Bottler:** **Arsenal** has the highest rate of surrendering 1st-place Christmas leads in the modern era.

*(See `Premier_League_Slides.pdf` for the visual breakdown of these trends.)*

---

### 📂 Repository Structure
* `sql_scripts/`: Contains the full SQL script used to clean, transform, and analyze the raw match data.
* `Premier_League_Slides.pdf`: The executive summary and data storytelling presentation.

---

### ⚠️ Analyst's Note
*Football success is complex.*
While this analysis reveals compelling historical trends, it relies on standings data. A robust predictive model would require external variables such as **Expected Goals (xG)**, **Squad Depth**, **Injury Lists**, and **Financial Data**.

This project serves as a technical showcase to demonstrate **Advanced SQL manipulation**—transforming raw match logs into actionable data narratives.

---

### 📬 Contact
* **Created by:** MD Nowroz Imtiaz Rifat
* **LinkedIn:** (https://www.linkedin.com/in/md-nowroz-imtiaz-rifat-2623a3215/)
