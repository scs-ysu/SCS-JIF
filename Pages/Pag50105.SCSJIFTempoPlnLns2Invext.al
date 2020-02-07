page 50105 "SCSJIFTempo-Pln Lns 2Inv(ext)"
{
    Caption = 'Tempo - Planning Lines to Invoice (External information only)';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Job Planning Line";
    SourceTableView = sorting("Job No.", "Job Task No.", "Line No.")
                      where("Line Type" = filter(<> Budget),
                            "Hold From Invoicing" = filter(<> true),
                            "Qty. to Invoice" = filter(> 0));

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
                field(JobDescription; "Job Description")
                {
                    ApplicationArea = All;
                }
                field(JobTaskNo; "Job Task No.")
                {
                    ApplicationArea = All;
                    StyleExpr = gStyleTaskNo;
                }
                field(JobTaskDescription; "Job Task Description")
                {
                    ApplicationArea = All;
                }
                field(LineNo; "Line No.")
                {
                    ApplicationArea = All;
                }
                field(PlanningDate; "Planning Date")
                {
                    ApplicationArea = All;
                    StyleExpr = gStyleWorkdate;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field(No; "No.")
                {
                    ApplicationArea = All;
                }
                field(WorkTypeCode; "Work Type Code")
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
                field(Description; Description)
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
                field(QtyPerUnitOfMeasure; "Qty. per Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(QuantityBase; "Quantity (Base)")
                {
                    ApplicationArea = All;
                }
                field(UnitPrice; "Unit Price")
                {
                }
                field(TotalPrice; "Total Price")
                {
                    ApplicationArea = All;
                }
                field(RequestedBy; "Requested By")
                {
                    ApplicationArea = All;
                }
                field(AppliesTo; "Applies To")
                {
                    ApplicationArea = All;
                }
                field(TempoWorklogId; "Tempo Worklog Id")
                {
                    ApplicationArea = All;
                }
                field(JIRATempoSyncStatus; "JIRA/Tempo Sync Status")
                {
                    ApplicationArea = All;
                }
                field(TempoWorkDescription; TempoWorkDescription)
                {
                    ApplicationArea = All;
                }
                field(LastDateModified; "Last Date Modified")
                {
                    ApplicationArea = All;
                }
                field(TaskType; "Task Type")
                {
                    ApplicationArea = All;
                }
            }
            group(Control1000000035)
            {
                Caption = 'Details'; // to do caption not mentioned
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
        }
        area(factboxes)
        {
            part(Control1000000100; "SCSJIFTempo - Planning Line FB")
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
    var
        TempString: Text[250];
    begin

        gStyleTaskNo := GetStyleTaskNo;
        gStyleQuantity := GetStyleQuantity;
        gStyleWorkDate := GetStyleWorkDate;
        gStyleNo := GetStyleNo;

        CalcFields("JIRA/Tempo Work Description");
        "JIRA/Tempo Work Description".CreateInStream(InStr);

        TempoWorkDescription := '';

        while not InStr.EOS do begin

            InStr.Read(TempString);
            if (StrLen(TempoWorkDescription) + StrLen(TempString) < MaxStrLen(TempoWorkDescription)) then
                TempoWorkDescription += TempString;
        end;

        if "Jira Issue Summary" = '' then
            "Jira Issue Summary" := Description;
    end;

    var
        TempoWorkDescription: Text[1024];
        InStr: InStream;
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

