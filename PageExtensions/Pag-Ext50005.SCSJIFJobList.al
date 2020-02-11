pageextension 50005 "SCSJIF Job List" extends "Job List"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(TotalAmountScheduled; "Total Amount Scheduled")
            {
                ApplicationArea = All;

            }
            field(TotalAmountContracted; "Total Amount Contracted")
            {
                ApplicationArea = All;

            }
            field("Available Value (Total Price)"; AvailableValueTotalPrice)
            {
                ApplicationArea = All;
                BlankZero = true;
                Caption = 'Available Value (Total Price)';
                Editable = false;
                StyleExpr = ConsumedPercentageTotalPriceStyle;
            }
            field(ConsumedPercentageTotalPrice; ConsumedPercentageTotalPrice)
            {
                ApplicationArea = All;
                BlankZero = true;
                Caption = '% Consumed (Total Price)';
                Editable = false;
                StyleExpr = ConsumedPercentageTotalPriceStyle;
            }
            field("Amount held from Invoicing"; "Amount held from Invoicing")
            {
                ApplicationArea = All;

            }
            field(TotalQtyContrDInTempo; "Total Qty. Contr'd (in Tempo)")
            {
                ApplicationArea = All;

            }
            field(JIRATempoSyncStatus; "JIRA/Tempo Sync Status")
            {
                ApplicationArea = All;

                StyleExpr = gSyncStatusStyle;
            }
            field(EarliestEntryDate; "Earliest Entry Date")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(LatestEntryDate; "Latest Entry Date")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }

        addlast(FactBoxes)
        {
            part(AttachmentsFB; "SCSJIFAttachments")
            {
                ApplicationArea = All;
            }
        }


    }

    actions
    {
        // Add changes to page actions here        
        addlast(Processing)
        {
            group(Details)
            {
                action(Action1000000012)
                {
                    ApplicationArea = All;
                    Caption = 'Job Task &Lines';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Job Task Lines";
                    RunPageLink = "Job No." = field("No.");
                    ShortCutKey = 'Shift+Ctrl+T';
                }
            }
        }
        addafter("Create Job &Sales Invoice")
        {
            action("SCS_CreateJobSalesInvoice")
            {
                ApplicationArea = All;
                Caption = 'SCS Create Job &Sales Invoice';
                Description = 'SCS1.00: moved action to C/AL';
                Image = CreateJobSalesInvoice;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    JobTask: Record "Job Task";
                begin
                    TestField("Bill-to Customer No.");
                    TestField("No.");
                    JobTask.SetRange("Job No.", "No.");
                    JobTask.SetRange("Bill-to Customer No.", "Bill-to Customer No.");
                    Report.RunModal(Report::"Job Create Sales Invoice", true, false, JobTask);

                end;
            }

        }
        addlast(Processing)
        {
            group("JIRA/Tempo")
            {
                Caption = 'JIRA/Tempo';
                Image = "Report";
                action(SynchronizeJob)
                {
                    ApplicationArea = All;
                    Caption = 'Synchronize Job';
                    Image = ImportDatabase;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        TempoDBSync: Report "SCSJIFTEMPO - DB Sync";
                        Job: Record Job;
                        NoFilter: Text;
                        CustFilter: Text;
                    begin

                        CurrPage.SetSelectionFilter(Job); // fetch the marks
                        // internally property Marked is set to true at the selected records
                        // the loop will fetch only these records
                        if Job.FindFirst then begin
                            repeat
                                if NoFilter <> '' then
                                    NoFilter := NoFilter + '|';
                                NoFilter := NoFilter + Job."No."; // create filter expr.
                                if StrPos(CustFilter, Job."Bill-to Customer No.") = 0 then begin
                                    if CustFilter <> '' then
                                        CustFilter := CustFilter + '|';
                                    CustFilter := CustFilter + Job."Bill-to Customer No."; // create filter expr.
                                end;
                            until Job.Next = 0;

                            Clear(Job);
                            Job.SetFilter("No.", NoFilter); // create the filter
                            Job.SetFilter("Bill-to Customer No.", CustFilter);
                        end;

                        if Job.GetFilter("No.") = '' then
                            // filter by customer if no job selected
                            Job.SetRange("Bill-to Customer No.", "Bill-to Customer No.");

                        Report.RunModal(Report::"SCSJIFTEMPO - DB Sync", true, false, Job);

                    end;
                }
                action(AccountsIinError)
                {
                    ApplicationArea = All;
                    Caption = 'Accounts In Error';
                    Image = ErrorLog;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "SCSJIFJIRA/Tempo-Accounts work";
                    RunPageMode = View;

                    trigger OnAction()
                    var
                        JiraIntegration: Codeunit "SCSJIF TEMPO Integration";
                    begin
                    end;
                }
                action(ProcessingLog)
                {
                    ApplicationArea = All;
                    Caption = 'Synchronization Log';
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "SCSJIF Tempo - Processing Log";
                }
                action(OpenJira)
                {
                    ApplicationArea = All;
                    Caption = 'Go to JIRA';
                    Image = LaunchWeb;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        JiraSetup: Record "SCSJIFJIRA/Tempo-Setup";
                    begin
                        JiraSetup.Get;
                        HyperLink(JiraSetup."Tempo Servlet Base URL");
                    end;
                }
                action(TempoCustomerSetup)
                {
                    ApplicationArea = All;
                    Caption = 'Tempo Customer Setup';
                    Image = Setup;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = false;
                    RunObject = Page "SCSJIFTEMPO - Customer Setup";
                }
                action(TempoIntegrationSetup)
                {
                    ApplicationArea = All;
                    Caption = 'Tempo Integration Setup';
                    Image = Setup;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = false;
                    RunObject = Page "SCSJIFTEMPO- Integration Setup";
                }
            }
            group("JIRA/Tempo Lines")
            {
                action(PlanningLines2InvoiceExt)
                {
                    ApplicationArea = All;
                    Caption = 'Planning Lines to be invoiced (External View)';
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = Page "SCSJIFTempo-Pln Lns 2Inv(ext)";
                }
                action(AllPlanningLinesExt)
                {
                    ApplicationArea = All;
                    Caption = 'Planning Lines (External View)';
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = Page "SCSJIFTempo-All Plan Lines Ext";
                }
                action(AllPlanningLinesInt)
                {
                    ApplicationArea = All;
                    Caption = 'Planning Lines (Internal View)';
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = Page "SCSJIFTempo All Plan Lines Int";
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        CurrPage.AttachmentsFB.Page.SetParentRecRef(RecRef);

    end;

    trigger OnAfterGetRecord()
    begin

        SetSyncStatusStyle();
        if "Total Amount Scheduled" > 0 then begin
            AvailableValueTotalPrice := "Total Amount Scheduled" - "Total Amount Contracted";
            ConsumedPercentageTotalPrice := 100 - AvailableValueTotalPrice / "Total Amount Scheduled" * 100;

            case ConsumedPercentageTotalPrice of
                90 .. 100:
                    ConsumedPercentageTotalPriceStyle := 'Ambiguous';

                100 .. 9999999999.0:
                    ConsumedPercentageTotalPriceStyle := 'Unfavorable';
                else
                    ConsumedPercentageTotalPriceStyle := 'Standard';
            end;

        end else begin
            AvailableValueTotalPrice := 0;
            ConsumedPercentageTotalPrice := 0;
            ConsumedPercentageTotalPriceStyle := 'Standard';
        end;
    end;

    var
        gSyncStatusStyle: Text;
        AvailableValueTotalPrice: Decimal;
        ConsumedPercentageTotalPrice: Decimal;
        ConsumedPercentageTotalPriceStyle: Text;

    local procedure SetSyncStatusStyle()
    begin
        case "JIRA/Tempo Sync Status" of
            "JIRA/Tempo Sync Status"::Error:
                gSyncStatusStyle := 'Unfavorable';
            "JIRA/Tempo Sync Status"::Synchronized:
                gSyncStatusStyle := 'Favorable';
            "JIRA/Tempo Sync Status"::"Manually Changed":
                gSyncStatusStyle := 'Ambiguous';
            "JIRA/Tempo Sync Status"::Closed:
                gSyncStatusStyle := 'Subordinate';

            else
                gSyncStatusStyle := 'Standard';
        end;
    end;
}