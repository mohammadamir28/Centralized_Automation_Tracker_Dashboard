# Setup Guide - Automation ROI Tracker

This guide will help you set up the ROI Tracker Dashboard from scratch. Follow these steps in order.

## What You'll Need

- Microsoft 365 account (with SharePoint and Power BI access)
- Power BI Desktop (free download from Microsoft)
- About 2-3 hours for initial setup
- Basic understanding of SharePoint lists

## Step 1: Create SharePoint Lists (30 minutes)

### Create the Project Index List

This is your master list of all projects.

1. Go to your SharePoint site
2. Click **New** → **List**
3. Name it: `ProjectIndex`
4. Add these columns:
   - **Title** (rename to "ProjectName") - Single line of text
   - **Status** - Choice (Active, Inactive)
   - **ListURL** - Hyperlink

5. Add your projects (one row per project):
   - ProjectName: "ProjectA", Status: Active
   - ProjectName: "ProjectB", Status: Active
   - etc.

### Create Individual Project Lists

For each project, create a separate list.

1. Click **New** → **List**
2. Name it: `ROI_ProjectA` (use exact project name from index)
3. Add these columns (type: Number, unless noted):
   - Release (Single line of text) - format: "January-2026"
   - AutomatedTC
   - ManualTC
   - ThirdPartyTC
   - AutoFuncTC
   - ManFuncTC
   - ThirdParFuncTC
   - TFuncTC
   - AutoRegTC
   - ManRegTC
   - ThirdParRegTC
   - TRegTC
   - Critical Defects
   - High Defects
   - Medium Defects
   - Low Defects
   - Scenario Count
   - Failed TC
   - Negative TC
   - US/Epics count
   - Deferred TC
   - Deferred TC reason (Multiple lines of text)
   - Coordinated systems list (Multiple lines of text)

4. Repeat for each project

**Tip:** Create one list, then use "Save as template" to quickly create others.

## Step 2: Set Up Power BI Desktop (15 minutes)

### Install Power BI Desktop

1. Download from: https://powerbi.microsoft.com/desktop/
2. Install and open Power BI Desktop

### Get Your SharePoint Site URL

1. Go to your SharePoint site
2. Copy the URL from browser
3. Remove everything after `/sites/your-site-name`
4. Example: `https://yourdomain.sharepoint.com/sites/your-team-site`

## Step 3: Import Power Query Code (45 minutes)

### Create the fnLoadProjectList Function

1. In Power BI Desktop, click **Transform data**
2. Click **New Source** → **Blank Query**
3. Right-click the query → **Advanced Editor**
4. Copy the code from `queries/PowerQuery/fnLoadProjectList.m`
5. **Important:** Replace the SharePoint URL with yours
6. Click **Done**
7. Rename query to: `fnLoadProjectList`

### Create the ProjectIndex Query

1. **New Source** → **SharePoint Online List**
2. Enter your SharePoint site URL
3. Select the ProjectIndex table
4. Click **Transform Data**
5. Remove unnecessary columns, keep: ProjectName, Status, ListURL
6. Filter Status = "Active"
7. Rename query to: `ProjectIndex`

### Create ConsolidatedProjectData Query

1. **New Source** → **Blank Query**
2. **Advanced Editor**
3. Copy code from `queries/PowerQuery/ConsolidatedProjectData.m`
4. Click **Done**
5. Rename to: `ConsolidatedProjectData`

### Create FactROI Query

1. **New Source** → **Blank Query**
2. **Advanced Editor**
3. Copy code from `queries/PowerQuery/FactROI.m`
4. Click **Done**
5. Rename to: `FactROI`

### Close & Apply

1. Click **Close & Apply** (top left)
2. Wait for data to load
3. Check for any errors

## Step 4: Create DAX Measures (30 minutes)

### Create a Measures Table (Optional but Recommended)

1. Go to **Model** view
2. Click **New table**
3. Enter: `Measures = {1}`
4. This creates a clean place to store all measures

### Add Each Measure

For each DAX file in `queries/DAX/`:

1. Click **New Measure**
2. Copy the code from the file
3. Paste into formula bar
4. Press Enter
5. Repeat for all measures

### Format Percentage Measures

1. Select each percentage measure
2. **Measure tools** → **Format** → **Percentage**
3. Set decimal places: 1 or 2

## Step 5: Build Dashboard Visuals (30 minutes)

### Create Report Pages

1. **Home** tab → **New Page**
2. Rename pages:
   - Overview
   - ROI Analysis
   - Test Metrics
   - Defect Tracking

### Add Common Slicers (on each page)

- Year (from FactROI[ReleaseYear])
- Quarter (from FactROI[Quarter])
- Month (from FactROI[ReleaseMonth])
- ProjectName (from FactROI[ProjectName])

### Sample Visuals

**Overview Page:**
- Card: Total Test Cases
- Card: Automation Percent
- Table: Projects with key metrics
- Line chart: Automation % trend

**ROI Analysis Page:**
- Table: ReleaseMonth, Projected ROI, Actual ROI, YTD ROI
- Line chart: Projected vs Actual ROI
- Card: YTD ROI

**Test Metrics Page:**
- Stacked bar: Automated vs Manual vs Third Party
- Pie chart: Functional vs Regression
- Gauges: AutomationFunctionalPercent, AutomationRegressionPercent, InternalAutoPercent

**Defect Tracking Page:**
- Pie chart: Defects by severity
- Table: Projects with defect counts
- Line chart: Defect trends over time

## Step 6: Test Everything (15 minutes)

### Data Refresh Test

1. Add a row to one of your SharePoint lists
2. In Power BI, click **Refresh**
3. Verify new data appears

### Filter Test

1. Select different slicers
2. Verify all visuals update correctly
3. Check that totals make sense

### Calculation Test

1. Check a few percentage calculations manually
2. Verify ROI formulas are working
3. Ensure YTD accumulates correctly

## Step 7: Publish to Power BI Service (Optional)

If you want to share with others:

1. Click **Publish** (in Power BI Desktop)
2. Select workspace
3. Configure scheduled refresh in Power BI Service
4. Share with team members

## Troubleshooting

### "Column not found" errors

- Check SharePoint column names match exactly
- Remember: column names are case-sensitive
- Verify all columns exist in all project lists

### Data not loading

- Check SharePoint site URL is correct
- Verify you have permissions to access lists
- Try refreshing credentials (File → Options → Data source settings)

### Calculations showing wrong values

- Verify numeric columns are typed as numbers (not text)
- Check for nulls in data
- Review DAX measure formulas

### Performance is slow

- Reduce number of projects in ProjectIndex
- Limit data to recent releases only
- Check if any visual has millions of rows

## Next Steps

Once everything is working:

1. Train your team on data entry
2. Set up a regular refresh schedule
3. Create additional visuals as needed
4. Customize calculations for your needs

## Need Help?

- Check the `docs/` folder for detailed documentation
- Open an issue on GitHub
- Review the code comments in query files

---

Congratulations! Your ROI Tracker Dashboard is ready to use.
