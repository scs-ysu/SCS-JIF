page 50101 "SCSJIFJIRA/Tempo-Worklogs work"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SCSJIFJIRA/Tempo-Worklogs work";
    //Image = Attachment;
    Caption = 'JIRA/Tempo-Worklogs work';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TEMPOAccountID; "TEMPO Account ID")
                {
                    ApplicationArea = All;
                }
                field(JobTaskID; "Job Task ID")
                {
                    ApplicationArea = All;
                }
                field(SynchronizationError; "Synchronization Error")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = true;
                }
                field(IssueKey; "Issue Key")
                {
                    ApplicationArea = All;
                }
                field(IssueSummary; "Issue Summary")
                {
                    ApplicationArea = All;
                }
                field(WorkedHours; "Worked Hours")
                {
                    ApplicationArea = All;
                }
                field(BilledHours; "Billed Hours")
                {
                    ApplicationArea = All;
                }
                field(WorkDate; "Work Date")
                {
                    ApplicationArea = All;
                }
                field(WorkDateTime; "Work DateTime")
                {
                    ApplicationArea = All;
                }
                field(WorkDescription1; "Work Description 1")
                {
                    ApplicationArea = All;
                }
                field(StaffID; "Staff ID")
                {
                    ApplicationArea = All;
                }
                field(ParentIssueKey; "Parent Issue Key")
                {
                    ApplicationArea = All;
                }
                field(ParentIssueSummary; "Parent Issue Summary")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

