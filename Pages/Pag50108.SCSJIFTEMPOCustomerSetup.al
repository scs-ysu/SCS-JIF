page 50108 "SCSJIFTEMPO - Customer Setup"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Customer;
    CaptionML = ENU = 'Temp Customer Setup',
                DEU = 'Tempo Kunden -  Konfiguration';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; "No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field(JIRATempoCustomerNo; "JIRA/Tempo Customer No.")
                {
                    ApplicationArea = All;
                }
                field(JobTemplateCode; "Job Template Code")
                {
                    ApplicationArea = All;
                }
                field(JobTaskTemplateCode; "Job Task Template Code")
                {
                    ApplicationArea = All;
                }
                field(SyncFromDate; "Sync From Date")
                {
                    ApplicationArea = All;
                }
                field(AutoCreateJobTask; "Auto-Create Job Task")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        TestField("ID for Dummy Job Task");
                    end;
                }
                field(IDForDummyJobTask; "ID for Dummy Job Task")
                {
                    ApplicationArea = All;
                }
                field(DescForDummyJobTask; "Desc. for Dummy Job Task")
                {
                    ApplicationArea = All;
                }
                field(AutoAssignToIssuesJobTask; "Auto-Assign to Issues Job Task")
                {
                    ApplicationArea = All;
                }
                field(ProhibitDummyTaskLinesInv; "Prohibit Dummy Task lines inv.")
                {
                    ApplicationArea = All;
                    Caption = 'Prohibit invoicing of  Auto-Created task''s lines';
                }

                field(TemplateWorkbook; "Template Workbook")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FileMgmt: Codeunit "File Management";
                        Filename: Text;
                    begin
                        FileName := FileMgmt.OpenFileDialog(TextSelectWorkbook, '', '');

                        if "Filename Template" = '' then
                            Error('');

                        "Template Workbook" := FileName;
                    end;

                    trigger OnValidate()
                    var
                        FileMgmt: Codeunit "File Management";
                    begin
                        if not FileMgmt.ClientFileExists("Template Workbook") then
                            Error(TextWorkbookNotFound);

                    end;
                }
                field(TargetFolder; "Target Folder")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(BrowseFolder(Text, "Target Folder", FieldCaption("Target Folder")));
                    end;
                }
                field(FilenameTemplate; "Filename Template")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1000000025)
            {
                action(TempoCustomMapping)
                {
                    ApplicationArea = All;
                    Caption = 'Tempo Custom Mapping';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "SCSJIFJIRA/Tempo-Custom Field";
                    RunPageLink = Customer = field("No.");
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetFilter("JIRA/Tempo Customer No.", '<>''''');
    end;

    var
        TextWorkbookNotFound: TextConst DEU = 'Die Vorlagenarbeitsmappe %1 konnte nicht gefunden werden.', ENU = 'The template workbook %1 could not be found.';
        TextSelectFolder: TextConst DEU = 'Bitte ein Verzeichnis auswählen', ENU = 'Please select a folder.';
        TextSelectWorkbook: TextConst DEU = 'Bitte eine Vorgabe-Arbeitsmappe auswählen.', ENU = 'Please select a template workbook.';

    local procedure BrowseFolder(var FolderName: Text; CurrentValue: Text; FieldCaption: Text): Boolean
    var
        FileMgt: Codeunit "File Management";
    begin
        if not CurrPage.Editable then
            exit;

        FolderName := FileMgt.BrowseForFolderDialog(StrSubstNo(TextSelectFolder, FieldCaption), CurrentValue, true);
        exit(FolderName <> '');
    end;
}

