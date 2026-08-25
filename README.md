# 🚚 Supply Chain & Logistics Performance Analytics

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=power-bi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-Data_Analysis_Expressions-00758F?style=for-the-badge)
![Domain](https://img.shields.io/badge/Domain-Supply_Chain_%26_Logistics-blue?style=for-the-badge)

## 📌 Executive Summary
This project delivers an interactive, 3-page **Executive Power BI Dashboard** built on the DataCo Global Supply Chain dataset (~180K line items across 66K unique orders). It addresses critical operational bottlenecks, analyzes profitability, and provides data-driven inventory optimization strategies using Pareto (80/20) ABC classification.

---

## 🖼️ Dashboard Pages Overview

### Page 1: Financial Overview
* **Focus:** High-level revenue performance, profitability, and customer segmentation.
* **Key Visuals:** Executive KPI Cards (Total Revenue, Net Profit, Gross Margin %), Line & Clustered Column Chart for Sales & Profit Trends, Customer Segment Distribution, and Regional Sales Performance.
* **Preview Placeholder:** `![Page 1 Financial Overview](overview/Page1.png)`

### Page 2: Logistics & Shipping Efficiency
* **Focus:** Delivery speed, delay bottleneck identification, and SLA risk tracking.
* **Key Visuals:** Shipping Performance KPIs, Actual vs. Scheduled Shipping Days by Mode (Bar Chart), Regional Late Delivery Risk Matrix (Heatmap), and Preferred Shipping Mode Distribution (Treemap).
* **Preview Placeholder:** `![Page 2 Logistics Efficiency](assets/page2.png)`

### Page 3: Category & Inventory Strategy (Pareto ABC Analysis)
* **Focus:** Inventory classification, 80/20 revenue drivers, and profit-bleeding categories.
* **Key Visuals:** Pareto Analysis (Line & Stacked Column Chart), Category-wise Sales & Profit Matrix, Bottom 10 Least Profitable Categories (Bar Chart), and Dynamic Class A Count KPI Card.
* **Preview Placeholder:** `![Page 3 Inventory Strategy]()`

---

## 📊 Business Insights & Key Takeaways

* **Financial Performance:** Generated **$36.78M** in total revenue with a net profit of **$3.97M** across 50 distinct product categories.
* **Logistics Bottlenecks:** Identified a high **57.33% Late Delivery Rate** (38K late orders out of 66K total orders).
  * *Critical Failure:* **First Class Shipping** exhibited a **100% late delivery rate** across all regions globally.
* **Inventory Optimization (Pareto 80/20 Rule):** Just **7 out of 50 categories** (Class A) drive **~80% of overall revenue** (led by *Fishing*, *Cleats*, and *Camping & Hiking*).
* **Profitability Bleeders:** Identified *Strength Training* as the least profitable category ($332.31 net profit), making it a prime candidate for cost optimization or portfolio restructuring.

---

## 🛠️ Data Modeling & DAX Engineering Highlights

### 1. Granularity Alignment (Order-Level vs. Line Item Level)
Fixed data granularity issues where raw row counts (~180K line items) diluted unique order counts (~66K):

    -- 1. Total Unique Orders
    Total Orders = DISTINCTCOUNT('public supply_chain_clean'[order_id])

    -- 2. Aligned Late Orders Count
    Late Orders Count = 
    CALCULATE(
        DISTINCTCOUNT('public supply_chain_clean'[order_id]),
        'public supply_chain_clean'[delivery_status] = "Late delivery"
    )

    -- 3. Late Delivery Rate %
    Late Delivery Rate % = DIVIDE([Late Orders Count], [Total Orders], 0)

### 2. Dynamic Pareto 80/20 Class A Calculation
Calculated dynamic cumulative revenue percentages without hardcoding static thresholds:

    Class A Count = 
    COUNTROWS(
        FILTER(
            VALUES('public supply_chain_clean'[category_name]),
            [cummulative sales %] <= 0.80
        )
    )

### 3. Iterative Table Filtering for Category Status
Overcame DAX boolean filter restrictions on measures inside CALCULATE using table iterators:

    loss_category = 
    COALESCE(
        COUNTROWS(
            FILTER(
                VALUES('public supply_chain_clean'[category_name]),
                [total_profit] < 0
            )
        ),
        0
    )

---

## 💡 Strategic Business Recommendations

1. **Carrier SLA Audit for First Class:** Re-evaluate SLA agreements with third-party logistics (3PL) carriers for First Class shipments due to severe global delay rates.
2. **Class A Inventory Prioritization:** Allocate warehouse fulfillment resources primarily to the Top 7 Class A categories to ensure zero stockouts on high-margin drivers.
3. **Product Line Rationalization:** Review cost-of-goods-sold (COGS) and marketing spends for low-margin tail items (*Strength Training*, *CDs*, *As Seen on TV!*).

---

## 🚀 How to Explore

1. Download the `.pbix` file from this repository.
2. Open in **Power BI Desktop**.
3. Use the interactive slicers (*Region*, *Shipping Mode*, *Category*) on the right sidebar to filter metrics dynamically across all three pages.
