page 50109 "Tempo - Move Plan Lines"
{


    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Job Planning Line";
    Caption = 'Tempo - Move Planning Lines';
    layout
    {
        area(content)
        {
            group(Allgemein)
            {
                field(JobTaskJobNo; JobTask."Job No.")
                {
                    ApplicationArea = All;
                    CaptionML = DEU = 'Projekt',
                                ENU = 'Job';
                    Editable = false;
                }
                field(JobTaskJobTaskNo; JobTask."Job Task No.")
                {
                    ApplicationArea = All;
                    CaptionML = DEU = 'Aufgabe',
                                ENU = 'Job Task';
                    Editable = false;
                }
                field(JobTaskDescription; JobTask.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Move to Job Task"; MoveToJobTask)
                {
                    ApplicationArea = All;
                    CaptionML = DEU = 'Verschieben zu Aufgabe',
                                ENU = 'Move to Job Task';
                    TableRelation = "Job Task"."Job Task No." WHERE("Job No." = field("Job No."),
                                                                     "Job Task Type" = const(Posting));

                    trigger OnValidate()
                    var
                        MoveLineSub: Page "Tempo - Planning Line FB";
                    begin
                    end;
                }
            }
            repeater(Control1000000005)
            {
                Editable = false;
                field(PlanningDate; "Planning Date")
                {
                    ApplicationArea = All;
                }
                field(No; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(JiraIssueKey; "Jira Issue Key")
                {
                    ApplicationArea = All;
                }
                field(JiraIssueSummary; "Jira Issue Summary")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
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
            action(MoveLinesToJobTask)
            {
                ApplicationArea = All;
                CaptionML = DEU = 'Zeilen verschieben',
                            ENU = 'Move Lines';
                Image = MovementWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    MoveLinesSub: Page "Tempo - Planning Line FB";
                begin
                    if not FindFirst then
                        Error(TxtNoLinesSelected);

                    JobTask.Get("Job No.", MoveToJobTask);

                    MoveSelected(MoveToJobTask);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if JobTask."Job No." = '' then
            JobTask.Get("Job No.", "Job Task No.");
    end;

    trigger OnClosePage()
    begin
        if FindFirst and JobTask.Get("Job No.", MoveToJobTask) then
            MoveSelected(MoveToJobTask);
    end;

    trigger OnOpenPage()
    begin
        if not FindFirst then
            Error(TxtNoLinesSelected);
    end;

    var
        MoveToJobTask: Code[20];
        JobTask: Record "Job Task";
        TxtConfirmMovement: TextConst DEU = 'Ausgewählte Zeilen zu Aufgabe %1 verschieben?', ENU = 'Move selected lines to Job Task %1?';
        TxtNoLinesSelected: TextConst DEU = 'Sie müssen für diese Funktion Zeilen auswählen.', ENU = 'You have to select lines for this function.';
        TxtMoveNotPossible: TextConst DEU = 'Zeilen können nicht von %1 nach %2 verschoben werden', ENU = 'You cannot move from %1 to %2';

    procedure MoveSelected(ToJobTask: Code[20])
    var
        TempoIntegration: Codeunit "SCSJIF TEMPO Integration";
    begin
        if "Job Task No." = ToJobTask then
            Error(TxtMoveNotPossible, "Job Task No.", ToJobTask);

        if not Confirm(TxtConfirmMovement, false, ToJobTask) then exit;

        if FindSet(true) then
            repeat

                TempoIntegration.MoveLinesToJobTask(Rec, ToJobTask);

            until Next = 0;

        CurrPage.Close;
    end;
}

