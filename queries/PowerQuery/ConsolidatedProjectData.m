/*
 * Query: ConsolidatedProjectData
 * Purpose: Consolidates data from all active projects into one table
 * 
 * How it works:
 * 1. Gets list of active projects from ProjectIndex
 * 2. Calls fnLoadProjectList for each project
 * 3. Expands the returned data
 * 4. Removes unnecessary index columns
 * 
 * This is the magic that combines all your separate project lists into one dataset!
 */

let
    // Get list of active projects from Project Index
    ActiveProjects = ProjectIndex,
    
    // Add custom column that calls the function for each project
    // This is where the magic happens - one function call per project row
    #"Loaded Project Data" = Table.AddColumn(
        ActiveProjects, 
        "ProjectData", 
        each fnLoadProjectList([ProjectName]),
        type table
    ),
    
    // Expand ALL columns from the ProjectData tables into main table
    // This flattens the nested tables into regular columns
    #"Expanded Project Data" = Table.ExpandTableColumn(
        #"Loaded Project Data", 
        "ProjectData", 
        {
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
            "CriticalDefects",
            "HighDefects",
            "MediumDefects",
            "LowDefects",
            "ScenarioCount",
            "FailedTC",
            "NewTestCases",
            "NegativeTC",
            "USEpicsCount",
            "DeferredTC",
            "DeferredTCReason",
            "CoordinatedSystemsList",
            "UpdatedOn",
            "POC"
        }
    ),
    
    // Remove Project Index columns we don't need anymore
    // We already have ProjectName from the expanded data
    #"Removed Index Columns" = Table.RemoveColumns(#"Expanded Project Data",{
        "Status", 
        "ListURL"
    })
in
    #"Removed Index Columns"
