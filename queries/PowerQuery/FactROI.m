/*
 * Query: FactROI
 * Purpose: Main fact table for the dashboard with all calculations
 * 
 * What it does:
 * 1. Takes consolidated data from all projects
 * 2. Ensures correct data types
 * 3. Replaces nulls with zeros
 * 4. Calculates total functional and regression test counts
 * 5. Calculates total defects
 * 6. Parses Release field into month/year components
 * 7. Adds unique_project specific effort calculations
 * 8. Calculates unique_project ROI
 * 9. Sorts by release date
 * 
 * This is your main data table that feeds the dashboard!
 */

let
    // Source is the consolidated data from all projects
    Source = ConsolidatedProjectData,
    
    // Change column types to ensure data consistency
    #"Changed Type" = Table.TransformColumnTypes(Source,{
        {"AutomatedTC", type number},
        {"ManualTC", type number},
        {"ThirdPartyTC", type number},
        {"AutoFuncTC", type number},
        {"ManFuncTC", type number},
        {"ThirdParFuncTC", type number},
        {"TFuncTC", type number},
        {"AutoRegTC", type number},
        {"ManRegTC", type number},
        {"ThirdParRegTC", type number},
        {"TRegTC", type number},
        {"CriticalDefects", type number},
        {"HighDefects", type number},
        {"MediumDefects", type number},
        {"LowDefects", type number},
        {"ScenarioCount", type number},
        {"FailedTC", type number},
        {"NewTestCases", type number},
        {"NegativeTC", type number},
        {"USEpicsCount", type number},
        {"DeferredTC", type number},
        {"DeferredTCReason", type text},
        {"CoordinatedSystemsList", type text},
        {"UpdatedOn", type datetime}
    }),
    
    // Replace nulls in numeric columns with 0
    // This prevents errors in calculations and makes filtering easier
    NumericColumns = {
        "AutomatedTC", "ManualTC", "ThirdPartyTC",
        "AutoFuncTC", "ManFuncTC", "ThirdParFuncTC", "TFuncTC",
        "AutoRegTC", "ManRegTC", "ThirdParRegTC", "TRegTC",
        "CriticalDefects", "HighDefects", "MediumDefects", "LowDefects",
        "ScenarioCount", "FailedTC", "NewTestCases", "NegativeTC", "USEpicsCount", "DeferredTC"
    },
    #"Replaced Nulls" = Table.ReplaceValue(
        #"Changed Type", 
        null, 
        0, 
        Replacer.ReplaceValue, 
        NumericColumns
    ),
    
    // Remove old TFuncTC column (coming from SharePoint)
    #"Removed TFuncTC" = Table.RemoveColumns(#"Replaced Nulls", {"TFuncTC"}),
    
    // Add calculated TFuncTC (sum of all functional test categories)
    #"Added TFuncTC" = Table.AddColumn(
        #"Removed TFuncTC",
        "TFuncTC",
        each [AutoFuncTC] + [ManFuncTC] + [ThirdParFuncTC],
        type number
    ),
    
    // Remove old TRegTC column (coming from SharePoint)
    #"Removed TRegTC" = Table.RemoveColumns(#"Added TFuncTC", {"TRegTC"}),
    
    // Add calculated TRegTC (sum of all regression test categories)
    #"Added TRegTC" = Table.AddColumn(
        #"Removed TRegTC",
        "TRegTC",
        each [AutoRegTC] + [ManRegTC] + [ThirdParRegTC],
        type number
    ),
    
    // Add Total Defects calculation (sum of all severity levels)
    #"Added TotalDefects" = Table.AddColumn(
        #"Added TRegTC",
        "TotalDefects",
        each [CriticalDefects] + [HighDefects] + [MediumDefects] + [LowDefects],
        type number
    ),
    
    // Parse Release field (format: "January-2026")
    // Split into components for month and year extraction
    #"Split Release" = Table.AddColumn(
        #"Added TotalDefects", 
        "ReleaseComponents", 
        each try Text.Split([Release], "-") otherwise {"", ""}
    ),
    
    // Extract month name from Release (e.g., "January")
    #"Added ReleaseMonth" = Table.AddColumn(
        #"Split Release", 
        "ReleaseMonth", 
        each try Text.Proper([ReleaseComponents]{0}) otherwise ""
    ),
    
    // Extract year from Release (e.g., 2026)
    #"Added ReleaseYear" = Table.AddColumn(
        #"Added ReleaseMonth", 
        "ReleaseYear", 
        each try Number.From([ReleaseComponents]{1}) otherwise null,
        Int64.Type
    ),
    
    // Convert month name to month number (January = 1, February = 2, etc.)
    #"Added MonthNumber" = Table.AddColumn(
        #"Added ReleaseYear",
        "MonthNumber",
        each 
            let
                MonthList = {"January","February","March","April","May","June",
                            "July","August","September","October","November","December"}
            in
                try List.PositionOf(MonthList, [ReleaseMonth]) + 1 otherwise null,
        Int64.Type
    ),
    
    // Create ReleaseDate as first day of month (needed for time intelligence in DAX)
    #"Added ReleaseDate" = Table.AddColumn(
        #"Added MonthNumber",
        "ReleaseDate",
        each try #date([ReleaseYear], [MonthNumber], 1) otherwise null,
        type date
    ),
    
    // Remove helper column (we don't need ReleaseComponents anymore)
    #"Removed Helper" = Table.RemoveColumns(#"Added ReleaseDate", {"ReleaseComponents"}),
    
    // Add TotalTC calculation (sum of all test case types)
    #"Added TotalTC" = Table.AddColumn(
        #"Removed Helper", 
        "TotalTC", 
        each [AutomatedTC] + [ManualTC] + [ThirdPartyTC], 
        type number
    ),
    
    // Add Validation per Scenario (average test cases per scenario)
    #"Added ValidationPerScenario" = Table.AddColumn(
        #"Added TotalTC",
        "ValidationPerScenario",
        each if [ScenarioCount] = 0 then null else [TotalTC] / [ScenarioCount],
        type number
    ),
    
    // ===== SPECIALIZED PROJECT CALCULATIONS =====
    // These calculations only apply to specific project types (conditional logic)
    // Replace "ProjectB" with your project name as needed
    
    // Step 1: Automation Plan & Design Efforts
    #"Added AutomationPlanDesignEffortsinHr" = Table.AddColumn(
        #"Added ValidationPerScenario",
        "AutomationPlanDesignEfforrojectsinHr",
        each if [ProjectName] = "unique_project" 
             then Number.Round(if [NewTestCases] = 0 then 1 else [NewTestCases] / 3, 0)
             else 0,
        type number
    ),
    
    // Step 2: Automation Maintenance hours
    #"Added AutomationMaintenanceinHR" = Table.AddColumn(
        #"Added AutomationPlanDesignEffortsinHr",
        "AutomationMaintenanceinHRroject,
        each if [ProjectName] = "unique_project" 
             then Number.Round([TotalTC] / 110, 0)
             else 0,
        type number
    ),
    
    // Step 3: Automation Execution Efforts
    #"Added AutomationExecutionEffortsinHr" = Table.AddColumn(
        #"Added AutomationMaintenanceinHR",
        "AutomationExecutionEffortrojectinHr",
        each if [ProjectName] = "unique_project" 
             then Number.Round([TotalTC] / 26, 0)
             else 0,
        type number
    ),
    
    // Step 4: Automation Misc Efforts
    #"Added AutomationMiscEffortsinHr" = Table.AddColumn(
        #"Added AutomationExecutionEffortsinHr",
        "AutomationMiscEffortsinHrroject,
        each if [ProjectName] = "unique_project" 
             then Number.Round([TotalTC] / 90, 0)
             else 0,
        type number
    ),
    
    // Step 5: Manual Plan Efforts
    #"Added ManualPlanEffortsinHr" = Table.AddColumn(
        #"Added AutomationMiscEffortsinHr",
        "ManualPlanEffortsinHr",roject
        each if [ProjectName] = "unique_project" 
             then Number.Round(if [NewTestCases] = 0 then 1 else [NewTestCases] / 3, 0)
             else 0,
        type number
    ),
    
    // Step 6: Manual Execution Efforts
    #"Added ManualExecutionEffortsinHr" = Table.AddColumn(
        #"Added ManualPlanEffortsinHr",
        "ManualExecutionEffortsinHroject",
        each if [ProjectName] = "unique_project" 
             then Number.Round([TotalTC] / 4, 0)
             else 0,
        type number
    ),
    
    // Step 7: Total Automation Efforts (sum of all automation efforts)
    #"Added TotalAutoEffortsinHr" = Table.AddColumn(
        #"Added ManualExecutionEffortsinHr",
        "TotalAutoEffortsinHr",roject
        each if [ProjectName] = "unique_project" 
             then Number.Round(
                 [AutomationPlanDesignEffortsinHr] + 
                 [AutomationMaintenanceinHR] + 
                 [AutomationExecutionEffortsinHr] + 
                 [AutomationMiscEffortsinHr],
                 0
             )
             else 0,
        type number
    ),
    
    // Step 8: Total Manual Efforts (sum of all manual efforts)
    #"Added TotalManualEffortsinHr" = Table.AddColumn(
        #"Added TotalAutoEffortsinHr",
        "TotalManualEffortsinHr",roject
        each if [ProjectName] = "unique_project" 
             then Number.Round(
                 [ManualPlanEffortsinHr] + 
                 [ManualExecutionEffortsinHr],
                 0
             )
             else 0,
        type number
    ),
    Effort-based
    // Define your hourly rate here
    RatePerHour = 23,  // Adjust this value based on your organization's rate
    
    // Step Effort asedunique_project ROI calculation (manual effort savings × hourly rate)
    #"Added unique_projectROI" = Table.AddColumn(
        #Effortdasedded TotalManualEffortsinHr",
        "unique_projectROI",roject
        each if [ProjectName] = "unique_project" 
             then Number.Round(RatePerHour
                 ([TotalManualEffortsinHr] - [TotalAutoEffortsinHr]) * 23,
                 0
             )
             else 0,
        type numberEffortased
    ),
    
    // Sort by release date (descending) and project name (ascending)
    #"Sorted Rows" = Table.Sort(#"Added unique_projectROI",{
        {"ReleaseDate", Order.Descending}, 
        {"ProjectName", Order.Ascending}
    })
in
    #"Sorted Rows"
