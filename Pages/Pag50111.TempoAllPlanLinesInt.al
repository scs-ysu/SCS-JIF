page 50111 "Tempo All Plan Lines Int"
{

    Caption = 'Tempo - All Planning Lines (including internal information)';
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Job Planning Line";
    SourceTableView = sorting("Job No.", "Job Task No.", "Line No.")
                      where("Line Type" = filter(<> Budget));

    layout
    {
        area(content)
        {
            repeater(Control1000000098)
            {
                field(BillToCustomerNo; "Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field(JobPostingGroup; "Job Posting Group")
                {
                    ApplicationArea = All;
                }
                field(JobNo; "Job No.")
                {
                    ApplicationArea = All;
                }
                field(JobTaskNo; "Job Task No.")
                {
                    ApplicationArea = All;
                    StyleExpr = gStyleTaskNo;
                }
                field(PlanningDate; "Planning Date")
                {
                    ApplicationArea = All;
                    StyleExpr = gStyleWorkDate;
                }
                field(LineNo; "Line No.")
                {
                    ApplicationArea = All;
                }
                field(JobDescription; "Job Description")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field(No; "No.")
                {
                    ApplicationArea = All;
                    StyleExpr = gStyleNo;
                }
                field(WorkTypeCode; "Work Type Code")
                {
                    ApplicationArea = All;
                }
                field(HoldFromInvoicing; "Hold From Invoicing")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    StyleExpr = gStyleQuantity;
                }
                field(UnitOfMeasureCode; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field(UnitPrice; "Unit Price")
                {
                    ApplicationArea = All;
                }
                field(TotalPrice; "Total Price")
                {
                    ApplicationArea = All;
                }
                field(JIRATempoSyncStatus; "JIRA/Tempo Sync Status")
                {
                    ApplicationArea = All;
                }
                field(JiraIssueKey; "Jira Issue Key")
                {
                    ApplicationArea = All;
                }
                field(JobTaskDescription; "Job Task Description")
                {
                    ApplicationArea = All;
                }
                field(JiraIssueSummary; "Jira Issue Summary")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(RequestedBy; "Requested By")
                {
                    ApplicationArea = All;
                }
                field(TempoWorklogId; "Tempo Worklog Id")
                {
                    ApplicationArea = All;
                }
                field(QtyPerUnitOfMeasure; "Qty. per Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(QuantityBase; "Quantity (Base)")
                {
                    ApplicationArea = All;
                }
                field(LastDateModified; "Last Date Modified")
                {
                    ApplicationArea = All;
                }
                field(UnitCostLCY; "Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                }
                field(TotalCostLCY; "Total Cost (LCY)")
                {
                    ApplicationArea = All;
                }
                field(UnitPriceLCY; "Unit Price (LCY)")
                {
                    ApplicationArea = All;
                }
                field(TotalPriceLCY; "Total Price (LCY)")
                {
                    ApplicationArea = All;
                }
                field(ResourceGroupNo; "Resource Group No.")
                {
                    ApplicationArea = All;
                }
                field(QtyTransferredToInvoice; "Qty. Transferred to Invoice")
                {
                    ApplicationArea = All;
                }
                field(QtyToTransferToInvoice; "Qty. to Transfer to Invoice")
                {
                    ApplicationArea = All;
                }
                field(QtyInvoiced; "Qty. Invoiced")
                {
                    ApplicationArea = All;
                }
                field(QtyToInvoice; "Qty. to Invoice")
                {
                    ApplicationArea = All;
                }
                field(InvoicedAmountLCY; "Invoiced Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field(InvoicedCostAmountLCY; "Invoiced Cost Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field(TaskType; "Task Type")
                {
                    ApplicationArea = All;
                }
            }
            grid(Totals)
            {
                Caption = 'Totals';
                GridLayout = Rows;
                group(TTLsValue)
                {
                    CaptionML = DEU = 'Wert',
                                ENU = 'Value';
                    field(TotalValue; TotalValue)
                    {
                        ApplicationArea = All;
                        CaptionML = DEU = 'Summe',
                                    ENU = 'Total';
                    }
                    field(TotalOpenValue; TotalOpenValue)
                    {
                        ApplicationArea = All;
                        CaptionML = DEU = 'Offen',
                                    ENU = 'Open';
                    }
                }
                group(TTLsCostValue)
                {
                    CaptionML = DEU = 'Kosten',
                                ENU = 'Cost Value';
                    field(TotalCostValue; TotalCostValue)
                    {
                        ApplicationArea = All;
                        CaptionML = DEU = 'Summe',
                                    ENU = 'Total';
                    }
                    field(TotalOpenCostValue; TotalOpenCostValue)
                    {
                        ApplicationArea = All;
                        CaptionML = DEU = 'Offen',
                                    ENU = 'Open';
                    }
                }
                group(TTLsQuantity)
                {
                    CaptionML = DEU = 'Menge',
                                ENU = 'Quantity';
                    //The GridLayout property is only supported on controls of type Grid
                    //GridLayout = Columns;
                    field(TotalQuantityBase; TotalQuantityBase)
                    {
                        ApplicationArea = All;
                        CaptionML = DEU = 'Menge (Basis)',
                                    ENU = 'Quantity (Base)';
                        RowSpan = 2;
                    }
                    field(TotalQuantityTempo; TotalQuantityTempo)
                    {
                        ApplicationArea = All;
                        CaptionML = DEU = 'Menge (aus Tempo)',
                                    ENU = 'Quantity (from Tempo)';
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000100; "Tempo - Planning Line FB")
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
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalculateTotals(TotalQuantityBase, TotalQuantityTempo, TotalValue, TotalOpenValue, TotalCostValue, TotalOpenCostValue);
    end;

    trigger OnAfterGetRecord()
    begin
        gStyleTaskNo := GetStyleTaskNo;
        gStyleQuantity := GetStyleQuantity;
        gStyleWorkDate := GetStyleWorkDate;
        gStyleNo := GetStyleNo;
    end;

    var
        TotalQuantityBase: Decimal;
        TotalQuantityTempo: Decimal;
        TotalValue: Decimal;
        TotalOpenValue: Decimal;
        TotalCostValue: Decimal;
        TotalOpenCostValue: Decimal;
        gStyleTaskNo: Text;
        [InDataSet]
        gStyleQuantity: Text;
        [InDataSet]
        gStyleWorkDate: Text;
        [InDataSet]
        gStyleNo: Text;
}

