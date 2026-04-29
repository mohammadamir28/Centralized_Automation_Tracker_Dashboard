# Centralized_Automation_Tracker_Dashboard
Power BI dashboard for tracking automation testing ROI across multiple projects using SharePoint Lists

# Hey there!
This is a Power BI dashboard I built to track Return on Investment (ROI) from our automation testing efforts across multiple projects. Instead of juggling Excel sheets and manual reports, this solution brings everything together in one place.

## What Problem Does This Solve?

If you've ever worked with automation testing, you know the struggle:
- Multiple Excel files scattered across different projects
- Manual consolidation every week/month
- Version control nightmares ("Which file is the latest?")
- Hours spent on copy-paste and formula debugging
- No easy way to see the big picture across all projects

This dashboard fixes all that.

## What's Inside?

### The Tech Stack
- **SharePoint Lists**: For storing project data (think of it as a structured database, but easier)
- **Power BI**: For creating interactive dashboards and visualizations
- **Power Query (M Language)**: For data transformation and cleanup
- **DAX**: For calculations and measures

### Key Features
- **Multi-project tracking**: Add as many projects as you want
- **Automated data refresh**: Connect once, refresh anytime
- **Interactive filters**: Slice and dice by project, release, quarter, year
- **ROI calculations**: See actual vs projected returns
- **Test metrics**: Automation %, functional vs regression breakdown
- **Defect tracking**: By severity (Critical, High, Medium, Low)
- **Effort analysis**: Separate calculations for specialized testing (like unique_projects)

## How It Works (Simple Version)

1. **Data Entry**: Teams update SharePoint lists with their test metrics
2. **Power Query**: Pulls data from all project lists automatically
3. **Data Model**: Combines everything into one clean table
4. **Power BI**: Creates charts, tables, and insights
5. **Refresh**: One click to update everything

No manual work. No copy-paste. No version conflicts.

## The Dashboard Includes

### Pages & Visuals
- **Project Overview**: See all projects at a glance
- **ROI Analysis**: Projected vs Actual ROI with YTD tracking
- **Test Coverage**: Automated vs Manual breakdown
- **Defect Tracking**: Severity-wise defect distribution
- **Release Metrics**: Month-over-month trends

### Key Metrics
- Total Test Cases (Automated + Manual + Third Party)
- Automation Percentage (Overall and E2E)
- Functional vs Regression split
- Defect counts by severity
- Validation per Scenario ratio
- Effort hours and ROI calculations

## Why SharePoint + Power BI Instead of Excel?

Good question! Here's why this approach works better:

**Collaboration**
- Multiple people can update at the same time
- No file locking issues
- Everyone sees the same data

**Data Quality**
- Built-in validation rules
- Change history and audit trails
- No accidental formula breaks

**Scalability**
- Add new projects in minutes
- Add new metrics without rebuilding
- Works for 5 projects or 50 projects

**Insights**
- Interactive filtering and drill-down
- Professional visualizations
- Mobile access via Power BI app

## Getting Started

### Prerequisites
- Microsoft 365 access (SharePoint + Power BI)
- Power BI Desktop (free download)
- Basic understanding of SharePoint lists

### Setup Steps
1. Create SharePoint lists for each project (see `docs/01_Microsoft_List_Schema.md`)
2. Create the ProjectIndex list (see `docs/02_Project_Index_Schema.md`)
3. Import Power Query transformations (see `queries/PowerQuery/`)
4. Create DAX measures (see `queries/DAX/`)
5. Build your visuals (see `docs/06_PowerBI_Visualizations.md`)

Detailed step-by-step instructions are in the `docs/` folder.

## Repository Structure

```
automation-roi-tracker/
├── README.md                    (You are here!)
├── LICENSE                      (MIT License)
├── .gitignore
├── docs/                        (Detailed documentation)
├── queries/
│   ├── PowerQuery/             (M language code)
│   └── DAX/                    (Measure formulas)
└── screenshots/                (Dashboard images)
```

## Sample Data Structure

Each project list tracks:
- Release (e.g., "January-2026")
- Test case counts (Automated, Manual, Third Party)
- Functional vs Regression breakdown
- Defect counts by severity
- Scenario count and other metrics

The dashboard consolidates all this automatically.

## Technical Highlights

### Dynamic Data Loading
- One function (`fnLoadProjectList`) handles all projects
- Automatic error handling for missing columns
- Smart defaults when data doesn't exist

### Specialized Project Calculations
- Conditional ROI calculation for specific project types
- Effort hours breakdown (Automation vs Manual)
- Integrated with standard project ROI

### Advanced Measures
- YTD ROI with annual reset
- Context-aware Actual ROI (handles different project types)
- Percentage calculations that work at any aggregation level

## Who Is This For?

- **QA Managers**: Track automation ROI across teams
- **Test Leads**: Monitor individual project metrics
- **Business Leaders**: See automation value and trends
- **Power BI Developers**: Learn dynamic data loading patterns
- **Anyone** dealing with scattered Excel-based reporting

## Want to Use This?

Feel free to adapt this for your organization! The code is open source (MIT License).

**What you'll need to customize:**
- SharePoint site URL
- Project names
- Field names (if different)
- ROI calculation logic (if you have different formulas)

All the code is in the `queries/` folder with comments explaining what each part does.

## Lessons Learned

Building this taught me:
- Power Query's `Table.HasColumns` is a lifesaver for error handling
- DAX context matters more than you think (learned this the hard way!)
- Conditional logic in measures can get tricky - plan it out first
- SharePoint Lists are underrated for structured data storage
- Documentation saves time (future you will thank present you)

## Contributing

Found a bug? Have a better way to calculate something? Want to add new features?

Feel free to open an issue or submit a pull request. I'm always learning and would love to see improvements!

## Questions?

If you're trying to implement something similar and get stuck, feel free to reach out. I've been through the debugging already, so I might be able to save you some time.

## License

MIT License - use it, modify it, share it. Just give credit where it's due.

---

Built with a constant pot of coffee and lots of trial-and-error debugging.

Happy automating!
