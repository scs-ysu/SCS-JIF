page 50100 "JIRA/Tempo-Accounts work"
{

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "JIRA/Tempo-Accounts workfile";
    Caption = 'JIRA/Tempo-Accounts work';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(JIRATempoAccountID; "JIRA/Tempo Account ID")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(SynchronizationError; "Synchronization Error")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = true;

                    trigger OnDrillDown()
                    begin
                        Message("Synchronization Error");
                    end;
                }
                field(JIRATempoProjectKeyList; "JIRA/Tempo Project Key List")
                {
                    ApplicationArea = All;
                }
                field(JIRATempoCustomerNo; "JIRA/Tempo Customer No.")
                {
                    ApplicationArea = All;
                }
                field(JIRATempoCustomerName; "JIRA/Tempo Customer Name")
                {
                    ApplicationArea = All;
                }
                field(PersonResponsible; "Person Responsible")
                {
                    ApplicationArea = All;
                }
                field(PersonResponsibleName; "Person Responsible Name")
                {
                    ApplicationArea = All;
                }
                field(ProjectOwner; "Project Owner")
                {
                    ApplicationArea = All;
                }
                field(CategoryCode; "Category Code")
                {
                    ApplicationArea = All;
                }
                field(CategoryDescription; "Category Description")
                {
                    ApplicationArea = All;
                }
                field(JIRATempoStatus; "JIRA/Tempo Status")
                {
                    ApplicationArea = All;
                }
                field(CustomerNo; "Customer No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(WorkLogsInError)
            {
                Caption = 'WorkLogs In Error';
                Image = ErrorLog;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                RunObject = Page "JIRA/Tempo-Worklogs work";
                RunPageLink = "TEMPO Account ID" = field("JIRA/Tempo Account ID");
                RunPageMode = View;
                ApplicationArea = All;
                trigger OnAction()
                var
                    JiraIntegration: Codeunit "SCSJIF TEMPO Integration";
                begin
                end;
            }
        }
    }
}

