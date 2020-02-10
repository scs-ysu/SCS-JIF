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

}

