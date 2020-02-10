pageextension 50008 "SCSJIF Job Planning Lines" extends "Job Planning Lines"
{
    layout
    {
        // Add changes to page layout here
        modify("Planning Date")
        {
            trigger OnAssistEdit()
            begin

                if "JIRA/Tempo Sync Status" <> "JIRA/Tempo Sync Status"::" " then
                    if ReplaceByTempoValue(Format("Planning Date"), Format("JIRA/Tempo Workdate")) then
                        Validate("Planning Date", "JIRA/Tempo Workdate");
            end;
        }

        modify("No.")
        {
            trigger OnAssistEdit()
            begin

                if "JIRA/Tempo Sync Status" <> "JIRA/Tempo Sync Status"::" " then
                    if ReplaceByTempoValue(Format("No."), UpperCase(Format("JIRA/Tempo Staff Id"))) then
                        Validate("No.", "JIRA/Tempo Staff Id");

            end;
        }
        modify(Quantity)
        {
            trigger OnAssistEdit()
            begin

                if "JIRA/Tempo Sync Status" <> "JIRA/Tempo Sync Status"::" " then
                    if ReplaceByTempoValue(Format(Quantity), Format("JIRA/Tempo Billed Hours")) then
                        Validate(Quantity, "JIRA/Tempo Billed Hours");

            end;
        }
        addafter(Description)
        {
            field(HoldFromInvoicing; "Hold From Invoicing")
            {
                ApplicationArea = All;

            }
        }
        addlast(Control1)
        {
            field(JIRATempoSyncStatus; "JIRA/Tempo Sync Status")
            {
                ApplicationArea = All;

                StyleExpr = gSyncStatusStyle;
            }
            field(TempoWorklogId; "Tempo Worklog Id")
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
            field(ResourceGroupNo; "Resource Group No.")
            {
                ApplicationArea = All;

            }
            field(RequestedBy; "Requested By")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(JIRATaskNo; "JIRA Task No.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(Description2; "Description 2")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(TaskType; "Task Type")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        addfirst(FactBoxes)
        {
            part(Control1000000017; "SCSJIFTempo - Planning Line FB")
            {
                ApplicationArea = All;
                SubPageLink = "Job No." = field("Job No."),
                              "Job Task No." = field("Job Task No."),
                              "Line No." = field("Line No.");
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(CreateJobJournalLines)
        {
            action("Move Planning Lines")
            {
                ApplicationArea = All;
                CaptionML = DEU = 'Planzeilen verschieben',
                                ENU = 'Move Lines';
                Image = MovementWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    MovePlanningLines: Page "SCSJIFTempo - Move Plan Lines";
                    Rec2: Record "Job Planning Line";
                begin

                    CurrPage.SetSelectionFilter(Rec2);

                    MovePlanningLines.SetTableView(Rec2);
                    MovePlanningLines.RunModal;
                end;
            }
            action("Re-Price Planning Lines")
            {
                ApplicationArea = All;
                CaptionML = DEU = 'Preise berechnen',
                                ENU = 'Reprice Lines';
                Image = PriceAdjustment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Rec2: Record "Job Planning Line";
                    TempQuantity: Decimal;
                    SCSINVEvtSub: Codeunit "SCSJIFEvent Subscribers";
                begin

                    CurrPage.SetSelectionFilter(Rec2);

                    if not Rec2.FindFirst then
                        Error(TxtNoLinesSelected);

                    if not Confirm(TxtConfirmReprice, false) then exit;

                    if Rec2.FindSet(true) then begin

                        repeat
                            SCSINVEvtSub.SetRepricingMode(); // +++ysu
                            Rec2.Validate(Quantity);
                            Rec2.Modify;
                        until Rec2.Next = 0;
                    end;

                    Commit;

                end;
            }
        }
        addafter(DemandOverview)
        {
            action("Selected Lines Only")
            {
                ApplicationArea = All;
                CaptionML = DEU = 'Nach Auswahl filtern',
                                ENU = 'Filter to selected';
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Rec2: Record "Job Planning Line";
                    LineNos: Text[1024];
                begin
                    CurrPage.SetSelectionFilter(Rec2);

                    if Rec2.FindSet then begin
                        if (GetFilter("Job No.") = '') or (GetFilter("Job Task No.") = '') then
                            Error(TxtRequiredFiltersMissing, FieldCaption("Job No."), FieldCaption("Job Task No."));

                        repeat
                            LineNos += '|' + Format(Rec2."Line No.");
                        until Rec2.Next() = 0;
                        LineNos := CopyStr(LineNos, 2);
                    end;

                    SetFilter("Line No.", LineNos);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalculateTotals(TotalQuantityBase, TotalQuantityTempo, TotalValue, TotalOpenValue, TotalCostValue, TotalOpenCostValue);
    end;

    trigger OnAfterGetRecord()
    begin
        SetSyncStatusStyle();
        gStyleTaskNo := GetStyleTaskNo;
        gStyleQuantity := GetStyleQuantity;
        gStyleWorkDate := GetStyleWorkDate;
        gStyleNo := GetStyleNo;
    end;


    var
        gStyleTaskNo: Text;
        [InDataSet]
        gStyleQuantity: Text;
        [InDataSet]
        gStyleWorkDate: Text;
        [InDataSet]
        gStyleNo: Text;
        gSyncStatusStyle: Text;
        gForceRepricing: Boolean;
        TotalQuantityBase: Decimal;
        TotalQuantityTempo: Decimal;
        TotalValue: Decimal;
        TotalOpenValue: Decimal;
        TotalCostValue: Decimal;
        TotalOpenCostValue: Decimal;
        TxtNoLinesSelected: TextConst DEU = 'Bitte mindestens eine Zeile auswählen.', ENU = 'Please select at least one line for repricing.';
        TxtConfirmReprice: TextConst DEU = 'Preis für ausgewählte Zeilen neu berechnen?', ENU = 'Reprice selected lines?';
        TxtConfirmReplace: TextConst DEU = 'Wert %1 mit Wert aus Tempo (%2) ersetzen?', ENU = 'Replace current value %1 with Tempo value %2?';
        TxtRequiredFiltersMissing: TextConst DEU = 'Die Spalten %1 und %2 müssen gefiltert sein, damit diese Funktion benutzt werden kann.', ENU = 'Columns %1 and %2 must be filtered in order to use this function.';

    local procedure SetSyncStatusStyle()
    begin
        case "JIRA/Tempo Sync Status" of
            "JIRA/Tempo Sync Status"::Error:
                gSyncStatusStyle := 'Unfavorable';
            "JIRA/Tempo Sync Status"::"In Sync":
                gSyncStatusStyle := 'Favorable';
            "JIRA/Tempo Sync Status"::"Deleted in Tempo", "JIRA/Tempo Sync Status"::"Update After Invoice":
                gSyncStatusStyle := 'Ambiguous';
            else
                gSyncStatusStyle := 'Standard';
        end;
    end;

    procedure ReplaceByTempoValue(CurrentValue: Text; NewValue: Text): Boolean
    begin
        if CurrentValue <> NewValue then
            exit(Confirm(TxtConfirmReplace, true, CurrentValue, NewValue));

        exit(false);
    end;
}