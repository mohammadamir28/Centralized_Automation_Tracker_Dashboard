# Microsoft List Schema - Project Index (Control Table)

## Overview
The **Project Index** is a master list that serves as a registry of all project ROI tracker lists. Power BI uses this list to dynamically discover and load all project data without manual configuration changes.

**Key Benefit:** Adding a new project only requires adding a single row to this list - no Power BI modifications needed.

## Column Specifications

| Column Name | Data Type | Required? | Description |
|------------|-----------|-----------|-------------|
| Title | Single Line of Text | Y | Project unique identifier (e.g., "ProjectA", "WebPortal") - matches ROI list name suffix |
| Status | Choice | Y | Project status (Active, Inactive) |
| ListURL | Hyperlink | N | Full URL to the project's Microsoft List (optional) |

## Purpose & Architecture

### Why This List Exists
- **Dynamic Discovery:** Power Query reads this list to identify all project lists
- **No Code Changes:** New projects don't require Power BI republishing
- **Centralized Control:** Single source of truth for active projects
- **Easy Maintenance:** Deactivate projects without deleting data

### How Power BI Uses This List
1. Power Query connects to Project Index list
2. Filters for `Status = "Active"`
3. Reads `ProjectName` for each active project
4. Dynamically loads data from `ROI_[ProjectName]` lists
5. Appends `ProjectName` to each row for identification
6. Consolidates all data into single table

## List Creation Instructions

### Step 1: Create the Project Index List
1. Navigate to your SharePoint site (same site as project lists)
2. Click **+ New** → **List**
3. Select **Blank list**
4. List name: `ProjectIndex`
5. Description: "Master registry of all automation ROI project tracking lists"
6. Click **Create**

### Step 2: Configure Title Column

**Title Column (Default SharePoint Column):**
- Already exists - no need to create
- This will store the project unique identifier
- Go to **List settings** → **Columns** → **Title**
- Edit column settings:
  - Description: "Project unique identifier (e.g., ProjectA, WebPortal)"
  - Make required: **Yes** (should already be)
  - Click **OK**

### Step 3: Add Custom Columns

**Column 1: Status**
- Click **+ Add column** → **Choice**
- Column name: `Status`
- Choices (one per line):
  ```
  Active
  Inactive
  ```
- Default value: **Active**
- Display choices using: **Dropdown menu**
- Make required: **Yes**
- Click **Save**

**Column 2: ListURL (Optional)**
- Click **+ Add column** → **Hyperlink**
- Column name: `ListURL`
- Format URL as: **Hyperlink**
- Make required: **No**
- Click **Save**

### Step 4: Configure List View

1. Click **All items** view → **Edit current view**
2. Select columns to display (in order):
   - Title
   - Status
   - ListURL (if using)
3. Sort by: **Title** (ascending)
4. Filter: Show items only when `Status = Active` (optional)
5. Click **OK**

## Adding a New Project

When a new project needs ROI tracking:

### Step 1: Create the Project's ROI List
1. Follow instructions in `01_Microsoft_List_Schema.md`
2. Create list with name: `ROI_[ProjectName]`
3. Example: `ROI_MobileApp`

### Step 2: Register Project in Index
1. Open **ProjectIndex** list
2. Click **+ New**
3. Fill in fields:
   - **Title:** Enter project name (match the list name suffix)
     - Example: `MobileApp` (for list `ROI_MobileApp`)
   - **Status:** Select **Active**
   - **ListURL:** (Optional) Paste the full URL to the project list
4. Click **Save**

### Step 3: Verify in Power BI
1. Open Power BI Desktop
2. Refresh data source
3. Verify new project appears in data model
4. Publish changes (if using Power BI Service)

**That's it!** No M code or DAX changes required.

## Getting a List's URL

**From the List:**
1. Navigate to the project list (e.g., `ROI_ProjectA`)
2. Copy URL from browser address bar
3. URL format: `https://[tenant].sharepoint.com/sites/[site]/Lists/[ListName]`

## Deactivating a Project

To stop tracking a project without deleting historical data:

1. Open **ProjectIndex** list
2. Find the project row
3. Click to edit
4. Change **Status** to **Inactive**
5. Click **Save**

The project's data remains in its list, but Power BI will no longer load it on refresh.

## Sample Data

Example entries for Project Index:

| Title | Status | ListURL |
|-------|--------|---------|
| ProjectA | Active | `https://your-site.sharepoint.com/.../ROI_ProjectA` |
| ProjectB | Active | `https://your-site.sharepoint.com/.../ROI_ProjectB` |
| WebPortal | Active | `https://your-site.sharepoint.com/.../ROI_WebPortal` |
| LegacyProject | Inactive | `https://your-site.sharepoint.com/.../ROI_LegacyProject` |

## Naming Conventions

### ProjectName Guidelines
- Use PascalCase (e.g., `WebPortal`, not `web-portal`)
- No spaces (use camelCase or underscores if needed)
- Match the suffix of your list name:
  - List: `ROI_WebPortal`
  - Title in ProjectIndex: `WebPortal`
- Keep names concise but descriptive

### Why Naming Matters
Power Query will use `ProjectName` to add a project identifier column to each data row, enabling:
- Filtering by project in Power BI
- Per-project aggregations
- Cross-project comparisons

## Troubleshooting

**Issue:** Power BI doesn't load new project
- **Check:** Is Status = "Active"?
- **Check:** Does list `ROI_[ProjectName]` exist?
- **Check:** Has Power BI been refreshed since adding the project?
- **Check:** Does Power BI service account have Read access to the list?

**Issue:** Duplicate project data
- **Check:** Are there duplicate entries in Project Index?
- **Check:** Is the ProjectName unique?

**Issue:** "List not found" error in Power Query
- **Check:** Was the project list renamed or deleted?
- **Check:** Does list name match `ROI_[ProjectName]` format?

## Next Steps

After creating Project Index:
1. Add initial project entries (at least 2-3 for testing)
2. Verify project lists exist and have data
3. Proceed to Power Query configuration (see main README)
4. Test dynamic project loading
5. Validate data consolidation in Power BI
