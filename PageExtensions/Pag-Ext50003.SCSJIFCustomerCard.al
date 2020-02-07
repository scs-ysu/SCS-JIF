pageextension 50003 "SCSJIF Customer Card" extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sales This Year")
        {
            group(SCSJIRATempoIntegration)
            {
                Caption = 'JIRA/Tempo  Integration';
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
                field(AutoCreateJobTask; "Auto-Create Job Task")
                {
                    ApplicationArea = All;
                }
                field(IDForDummyJobTask; "ID for Dummy Job Task")
                {
                    ApplicationArea = All;
                }
                field(ProhibitDummyTaskLinesInv; "Prohibit Dummy Task lines inv.")
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
                field(SyncFromDate; "Sync From Date")
                {
                    ApplicationArea = All;
                }
                field(GLAccountForExpenses; "G/L Account for Expenses")
                {
                    ApplicationArea = All;
                }
                field(UnitForExpenses; "Unit for Expenses")
                {
                    ApplicationArea = All;
                }
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}