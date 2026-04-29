/*
 * Function: fnLoadProjectList
 * Purpose: Dynamically loads data from individual project SharePoint lists
 * Input: ProjectName (text) - Name of the project to load
 * Output: Table with all project metrics
 * 
 * How it works:
 * 1. Connects to SharePoint and looks for a list named "ROI_{ProjectName}"
 * 2. Adds missing columns with default values (handles different list schemas)
 * 3. Renames columns to Power BI friendly names (no spaces)
 * 4. Extracts POC display name from Author field
 * 
 * Usage: fnLoadProjectList("ProjectA")
 */

let
    // Main function that takes project name as parameter
    LoadProjectList = (ProjectName as text) as table =>
    let
        // SharePoint site URL - REPLACE THIS with your SharePoint site
        SiteURL = "https://your-sharepoint-site.com/sites/your-team-site",
        
        // Connect to SharePoint tables
        Source = SharePoint.Tables(SiteURL, [Implementation="2.0"]),
        
        // Construct list name dynamically (ROI_ProjectName)
        ListName = "ROI_" & ProjectName,
        
        // Try to get the specific list, if not found return empty table
        ProjectList = try Source{[Title=ListName]}[Items] otherwise #table({}, {}),
        
        // Add ProjectName column to identify which project this data belongs to
        #"Added ProjectName" = Table.AddColumn(ProjectList, "ProjectName", each ProjectName, type text),
        
        // Add missing columns with default values (error handling for different schemas)
        // This ensures the query doesn't break if a list is missing certain columns
        
        #"Added Release" = if Table.HasColumns(#"Added ProjectName", "Release") 
            then #"Added ProjectName" 
            else Table.AddColumn(#"Added ProjectName", "Release", each null, type text),
            
        #"Added AutomatedTC" = if Table.HasColumns(#"Added Release", "AutomatedTC") 
            then #"Added Release" 
            else Table.AddColumn(#"Added Release", "AutomatedTC", each 0, type number),
            
        #"Added ManualTC" = if Table.HasColumns(#"Added AutomatedTC", "ManualTC") 
            then #"Added AutomatedTC" 
            else Table.AddColumn(#"Added AutomatedTC", "ManualTC", each 0, type number),
            
        #"Added ThirdPartyTC" = if Table.HasColumns(#"Added ManualTC", "ThirdPartyTC") 
            then #"Added ManualTC" 
            else Table.AddColumn(#"Added ManualTC", "ThirdPartyTC", each 0, type number),
            
        #"Added AutoFuncTC" = if Table.HasColumns(#"Added ThirdPartyTC", "AutoFuncTC") 
            then #"Added ThirdPartyTC" 
            else Table.AddColumn(#"Added ThirdPartyTC", "AutoFuncTC", each 0, type number),
            
        #"Added ManFuncTC" = if Table.HasColumns(#"Added AutoFuncTC", "ManFuncTC") 
            then #"Added AutoFuncTC" 
            else Table.AddColumn(#"Added AutoFuncTC", "ManFuncTC", each 0, type number),
            
        #"Added ThirdParFuncTC" = if Table.HasColumns(#"Added ManFuncTC", "ThirdParFuncTC") 
            then #"Added ManFuncTC" 
            else Table.AddColumn(#"Added ManFuncTC", "ThirdParFuncTC", each 0, type number),
            
        #"Added TFuncTC" = if Table.HasColumns(#"Added ThirdParFuncTC", "TFuncTC") 
            then #"Added ThirdParFuncTC" 
            else Table.AddColumn(#"Added ThirdParFuncTC", "TFuncTC", each 0, type number),
            
        #"Added AutoRegTC" = if Table.HasColumns(#"Added TFuncTC", "AutoRegTC") 
            then #"Added TFuncTC" 
            else Table.AddColumn(#"Added TFuncTC", "AutoRegTC", each 0, type number),
            
        #"Added ManRegTC" = if Table.HasColumns(#"Added AutoRegTC", "ManRegTC") 
            then #"Added AutoRegTC" 
            else Table.AddColumn(#"Added AutoRegTC", "ManRegTC", each 0, type number),
            
        #"Added ThirdParRegTC" = if Table.HasColumns(#"Added ManRegTC", "ThirdParRegTC") 
            then #"Added ManRegTC" 
            else Table.AddColumn(#"Added ManRegTC", "ThirdParRegTC", each 0, type number),
            
        #"Added TRegTC" = if Table.HasColumns(#"Added ThirdParRegTC", "TRegTC") 
            then #"Added ThirdParRegTC" 
            else Table.AddColumn(#"Added ThirdParRegTC", "TRegTC", each 0, type number),
            
        // Defect severity columns
        #"Added Critical Defects" = if Table.HasColumns(#"Added TRegTC", "Critical Defects") 
            then #"Added TRegTC" 
            else Table.AddColumn(#"Added TRegTC", "Critical Defects", each 0, type number),
            
        #"Added High Defects" = if Table.HasColumns(#"Added Critical Defects", "High Defects") 
            then #"Added Critical Defects" 
            else Table.AddColumn(#"Added Critical Defects", "High Defects", each 0, type number),
            
        #"Added Medium Defects" = if Table.HasColumns(#"Added High Defects", "Medium Defects") 
            then #"Added High Defects" 
            else Table.AddColumn(#"Added High Defects", "Medium Defects", each 0, type number),
            
        #"Added Low Defects" = if Table.HasColumns(#"Added Medium Defects", "Low Defects") 
            then #"Added Medium Defects" 
            else Table.AddColumn(#"Added Medium Defects", "Low Defects", each 0, type number),
            
        // Additional metrics
        #"Added Scenario Count" = if Table.HasColumns(#"Added Low Defects", "Scenario Count") 
            then #"Added Low Defects" 
            else Table.AddColumn(#"Added Low Defects", "Scenario Count", each 0, type number),
            
        #"Added Failed TC" = if Table.HasColumns(#"Added Scenario Count", "Failed TC") 
            then #"Added Scenario Count" 
            else Table.AddColumn(#"Added Scenario Count", "Failed TC", each 0, type number),
            
        // Specialized project field - may only exist in certain project lists
        #"Added New Test cases" = if Table.HasColumns(#"Added Failed TC", "New Test cases") 
            then #"Added Failed TC" 
            else Table.AddColumn(#"Added Failed TC", "New Test cases", each 0, type number),
            
        #"Added Negative TC" = if Table.HasColumns(#"Added New Test cases", "Negative TC") 
            then #"Added New Test cases" 
            else Table.AddColumn(#"Added New Test cases", "Negative TC", each 0, type number),
            
        #"Added US/Epics count" = if Table.HasColumns(#"Added Negative TC", "US/Epics count") 
            then #"Added Negative TC" 
            else Table.AddColumn(#"Added Negative TC", "US/Epics count", each 0, type number),
            
        #"Added Deferred TC" = if Table.HasColumns(#"Added US/Epics count", "Deferred TC") 
            then #"Added US/Epics count" 
            else Table.AddColumn(#"Added US/Epics count", "Deferred TC", each 0, type number),
            
        #"Added Deferred TC reason" = if Table.HasColumns(#"Added Deferred TC", "Deferred TC reason") 
            then #"Added Deferred TC" 
            else Table.AddColumn(#"Added Deferred TC", "Deferred TC reason", each null, type text),
            
        #"Added Coordinated systems list" = if Table.HasColumns(#"Added Deferred TC reason", "Coordinated systems list") 
            then #"Added Deferred TC reason" 
            else Table.AddColumn(#"Added Deferred TC reason", "Coordinated systems list", each null, type text),
            
        #"Added Modified" = if Table.HasColumns(#"Added Coordinated systems list", "Modified") 
            then #"Added Coordinated systems list" 
            else Table.AddColumn(#"Added Coordinated systems list", "Modified", each DateTime.LocalNow(), type datetime),
            
        #"Added POC" = if Table.HasColumns(#"Added Modified", "POC") 
            then #"Added Modified" 
            else Table.AddColumn(#"Added Modified", "POC", each null, type text),
        
        // Select only the columns we need (using SharePoint column names)
        #"Selected Columns" = Table.SelectColumns(#"Added POC",{
            "ProjectName",
            "Release",
            "AutomatedTC",
            "ManualTC",
            "ThirdPartyTC",
            "AutoFuncTC",
            "ManFuncTC",
            "ThirdParFuncTC",
            "TFuncTC",
            "AutoRegTC",
            "ManRegTC",
            "ThirdParRegTC",
            "TRegTC",
            "Critical Defects",
            "High Defects",
            "Medium Defects",
            "Low Defects",
            "Scenario Count",
            "Failed TC",
            "New Test cases",
            "Negative TC",
            "US/Epics count",
            "Deferred TC",
            "Deferred TC reason",
            "Coordinated systems list",
            "Modified",
            "POC"
        }),
        
        // Rename columns to Power BI friendly names (no spaces)
        #"Renamed Columns" = Table.RenameColumns(#"Selected Columns",{
            {"Modified", "UpdatedOn"},
            {"Critical Defects", "CriticalDefects"},
            {"High Defects", "HighDefects"},
            {"Medium Defects", "MediumDefects"},
            {"Low Defects", "LowDefects"},
            {"Scenario Count", "ScenarioCount"},
            {"Failed TC", "FailedTC"},
            {"New Test cases", "NewTestCases"},
            {"Negative TC", "NegativeTC"},
            {"US/Epics count", "USEpicsCount"},
            {"Deferred TC", "DeferredTC"},
            {"Deferred TC reason", "DeferredTCReason"},
            {"Coordinated systems list", "CoordinatedSystemsList"}
        }),
        
        // Extract POC display name from Author field (SharePoint person field)
        #"Extracted POC" = Table.TransformColumns(#"Renamed Columns", {
            {"POC", each try _[DisplayName] otherwise Text.From(_), type text}
        })
    in
        #"Extracted POC"
in
    LoadProjectList
