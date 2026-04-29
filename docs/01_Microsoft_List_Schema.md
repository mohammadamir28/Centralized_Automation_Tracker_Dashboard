# Microsoft List Schema - Project ROI Tracker

## Overview
Each project will have its own Microsoft List with identical columns. This standardized schema enables dynamic consolidation across all project lists in Power BI.

## Column Specifications

| Column Name | Data Type | Required? | Description |
|------------|-----------|-----------|-------------|
| Title | Single Line of Text | Y | Release month and year (format: "MonthName-YYYY", e.g., "January-2026", "February-2026") |
| AutomatedTC | Number | N | Count of automated test cases |
| ManualTC | Number | N | Count of manual test cases |
| ThirdPartyTC | Number | N | Count of third-party test cases |
| Author | Person or Group | Auto | POC (Point of Contact) - person who created the record (SharePoint auto-field) |
| AutoFuncTC | Number | N | Count of automated functional test cases |
| ManFuncTC | Number | N | Count of manual functional test cases |
| ThirdParFuncTC | Number | N | Count of third-party functional test cases |
| TFuncTC | Number | N | Total functional test cases (calculated or entered) |
| AutoRegTC | Number | N | Count of automated regression test cases |
| ManRegTC | Number | N | Count of manual regression test cases |
| ThirdParRegTC | Number | N | Count of third-party regression test cases |
| TRegTC | Number | N | Total regression test cases (calculated or entered) |
| Critical Defects | Number | N | Count of critical severity defects |
| High Defects | Number | N | Count of high severity defects |
| Medium Defects | Number | N | Count of medium severity defects |
| Low Defects | Number | N | Count of low severity defects |
| Scenario Count | Number | N | Number of test scenarios |
| Failed TC | Number | N | Number of failed test cases |
| New Test cases | Number | N | New test cases added (for specialized projects) |
| Negative TC | Number | N | Count of negative test cases |
| US/Epics count | Number | N | Count of user stories or epics |
| Deferred TC | Number | N | Count of deferred test cases |
| Deferred TC reason | Multiple Lines of Text | N | Reason for deferring test cases |
| Coordinated systems list | Multiple Lines of Text | N | List of coordinated/integrated systems |
| Modified | Date and Time | Auto | Last modified timestamp (SharePoint auto-field) |
| POC | Person or Group | N | Point of contact for the release |

## List Creation Instructions

### Step 1: Create New List
1. Navigate to your SharePoint site
2. Click **+ New** → **List**
3. Select **Blank list**
4. Enter list name: `ROI_[ProjectName]` (e.g., "ROI_ProjectA")
5. Enter description: "Automation ROI tracker for [ProjectName]"
6. Click **Create**

### Step 2: Configure Title Column

**Title Column (Default SharePoint Column):**
- Already exists - no need to create
- This will store release month and year
- Format: **MonthName-YYYY** (e.g., "January-2026", "February-2026")
- Go to **List settings** → **Columns** → **Title**
- Edit column settings:
  - Description: "Enter release month and year (format: MonthName-YYYY, e.g., January-2026)"
  - Make required: **Yes** (should already be)
  - Click **OK**

**Important:** Title field format must be **MonthName-YYYY** (e.g., "January-2026", "February-2026", "December-2025")

### Step 3: Add Number Columns

For each number column, use these steps:
- Click **+ Add column** → **Number**
- Column name: [use exact name from table]
- Number of decimal places: **0**
- Default value: (leave blank)
- Make required: **No**

Add these columns in order:
1. `AutomatedTC`
2. `ManualTC`
3. `ThirdPartyTC`
4. `AutoFuncTC`
5. `ManFuncTC`
6. `ThirdParFuncTC`
7. `TFuncTC`
8. `AutoRegTC`
9. `ManRegTC`
10. `ThirdParRegTC`
11. `TRegTC`
12. `Critical Defects` (with space)
13. `High Defects` (with space)
14. `Medium Defects` (with space)
15. `Low Defects` (with space)
16. `Scenario Count` (with space)
17. `Failed TC` (with space)
18. `New Test cases` (with space)
19. `Negative TC` (with space)
20. `US/Epics count` (with space)
21. `Deferred TC` (with space)

### Step 4: Add Text Columns

**Deferred TC reason:**
- Click **+ Add column** → **Multiple lines of text**
- Column name: `Deferred TC reason`
- Type of text: **Plain text**
- Make required: **No**

**Coordinated systems list:**
- Click **+ Add column** → **Multiple lines of text**
- Column name: `Coordinated systems list`
- Type of text: **Plain text**
- Make required: **No**

**POC (optional, if not using Author):**
- Click **+ Add column** → **Person**
- Column name: `POC`
- Allow selection of: **People only**
- Allow multiple selections: **No**
- Make required: **No**

### Step 5: Configure List Settings

1. Click **⚙️ (Settings)** → **List settings**
2. Under **General Settings** → **Versioning settings**:
   - Set **Require content approval**: No
   - Set **Create a version each time**: Yes (recommended for audit trail)
3. Under **Permissions and Management**:
   - Configure permissions as needed for your team

### Step 6: Export List Template (Recommended)

To quickly create new project lists:
1. Go to **List settings**
2. Click **Save list as template**
3. Template name: `ROI_Tracker_Template`
4. Include content: **No** (unless you want sample data)
5. Click **OK**

For subsequent projects, create new list from this template.

## Naming Convention

Use consistent naming for all project lists:
- Format: `ROI_[ProjectName]`
- Examples:
  - `ROI_ProjectA`
  - `ROI_ProjectB`
  - `ROI_MobileApp`
  - `ROI_WebPortal`

This naming convention is critical for Power Query dynamic discovery.

## Data Entry Guidelines

### When Creating a New Release Record:
1. Click **+ New** in the list
2. Enter **Title** in format: **MonthName-YYYY** (e.g., "January-2026", "February-2026")
   - Use full month name (January, February, March, etc.)
   - Use hyphen (-) as separator
   - Use 4-digit year
3. Enter test counts in relevant fields
4. **Author** (POC) and **Modified** (timestamp) will auto-populate
5. Click **Save**

**Title Format Examples:**
- ✅ "January-2026"
- ✅ "February-2026"
- ✅ "December-2025"
- ❌ "Jan-2026" (use full month name)
- ❌ "January 2026" (use hyphen, not space)
- ❌ "01-2026" (use month name, not number)

### Calculated vs. Entered Fields:
- **TFuncTC** (Total Functional): Can be entered OR calculated in Power BI as:
  - `AutoFuncTC + ManFuncTC + ThirdParFuncTC`
- **TRegTC** (Total Regression): Can be entered OR calculated in Power BI as:
  - `AutoRegTC + ManRegTC + ThirdParRegTC`

**Recommendation:** Let Power BI calculate these totals for accuracy.

## Multi-User Considerations

- Multiple users can enter data simultaneously
- Each record represents one release
- Use **Modified** field to track when changes were made
- Use **Author** field to track who created the record
- Enable versioning for change history
- Consider using SharePoint alerts for change notifications

## Next Steps

After creating lists:
1. Create at least 2-3 project lists for testing
2. Add sample data to each list
3. Create the ProjectIndex list (see next doc)
4. Proceed to Power Query configuration
