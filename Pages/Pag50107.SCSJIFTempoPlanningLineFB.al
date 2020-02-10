page 50107 "SCSJIFTempo - Planning Line FB"
{

    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Job Planning Line";
    Caption = 'Tempo - Planning Line FB';
    layout
    {
        area(content)
        {
            field(Description; Description)
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
                MultiLine = true;
            }
            field(JiraIssueKey; "Jira Issue Key")
            {
                ApplicationArea = All;
            }
            field(JiraIssueSummary; JiraIssueSummary)
            {
                ApplicationArea = All;
                MultiLine = true;
            }
            field(JIRATempoStaffId; "JIRA/Tempo Staff Id")
            {
                ApplicationArea = All;
            }
            field(JIRATempoStaffIdPrev; "JIRA/Tempo Staff Id Prev.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(JIRATempoWorkdate; "JIRA/Tempo Workdate")
            {
                ApplicationArea = All;
            }
            field(JIRATempoWorkdatePrev; "JIRA/Tempo Workdate Prev.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(JIRATempoBilledHours; "JIRA/Tempo Billed Hours")
            {
                ApplicationArea = All;
            }
            field(JIRATempoBilledHoursPrev; "JIRA/Tempo Billed Hours Prev.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(JIRATempoWorkedHours; "JIRA/Tempo Worked Hours")
            {
                ApplicationArea = All;
            }
            field(JIRATempoWorkedHoursPrev; "JIRA/Tempo Worked Hours Prev.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(MemoText; MemoText)
            {
                ApplicationArea = All;
                MultiLine = true;
            }
            field(RequestedBy; "Requested By")
            {
                ApplicationArea = All;
            }
            field(AppliesTo; "Applies To")
            {
                ApplicationArea = All;
            }
            field(JIRATaskNo; "JIRA Task No.")
            {
                ApplicationArea = All;
            }
            field(JIRATaskNoPrev; "JIRATask No. Prev.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(TempoWorklogId; "Tempo Worklog Id")
            {
                ApplicationArea = All;
            }
            field(JIRATempoSyncStatus; "JIRA/Tempo Sync Status")
            {
                ApplicationArea = All;
            }
            field(JIRATempoSyncDateTime; "JIRA/Tempo Sync DateTime")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        TempoIntegration: Codeunit "SCSJIF TEMPO Integration";
    begin
        CalcFields("JIRA/Tempo Work Description");
        if not "JIRA/Tempo Work Description".HasValue then
            MemoText := ''

        else begin
            "JIRA/Tempo Work Description".CreateInStream(MemoReader);
            MemoReader.Read(MemoText, MaxStrLen(MemoText));

            MemoText := TempoIntegration.UnescapeCRLFForDisplay(MemoText);

        end;

        JiraIssueSummary := "Jira Issue Summary";
    end;

    var
        MemoReader: InStream;
        MemoText: Text[1024];
        JiraIssueSummary: Text;
}

