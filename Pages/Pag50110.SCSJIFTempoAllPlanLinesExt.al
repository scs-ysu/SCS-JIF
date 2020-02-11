page 50110 "SCSJIFTempo-All Plan Lines Ext"
{

    Caption = 'Tempo - All Planning Lines (External information only)';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Job Planning Line";
    SourceTableView = sorting("Job No.", "Job Task No.", "Line No.")
                      where("Line Type" = filter(<> Budget),
                            "Hold From Invoicing" = filter(<> true));

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
                    StyleExpr = gStyleNo;
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
                    ApplicationArea = All;
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
                field(InvoiceList; InvoiceList)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice(s)';
                }
                field(TaskType; "Task Type")
                {
                    ApplicationArea = All;
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

        InvoiceList := '';

        JobPlanningLineInvoice.SetRange("Job No.", "Job No.");
        JobPlanningLineInvoice.SetRange("Job Task No.", "Job Task No.");
        JobPlanningLineInvoice.SetRange("Job Planning Line No.", "Line No.");
        JobPlanningLineInvoice.SetRange("Document Type", JobPlanningLineInvoice."Document Type"::"Posted Invoice");
        if JobPlanningLineInvoice.FindSet then begin
            repeat
                InvoiceList += ', ' + JobPlanningLineInvoice."Document No.";
            until JobPlanningLineInvoice.Next = 0;

            InvoiceList := CopyStr(InvoiceList, 3);
        end;
    end;

    var
        TempoWorkDescription: Text[1024];
        InStr: InStream;
        InvoiceList: Text;
        JobPlanningLineInvoice: Record "Job Planning Line Invoice";
        gStyleTaskNo: Text;
        [InDataSet]
        gStyleQuantity: Text;
        [InDataSet]
        gStyleWorkDate: Text;
        [InDataSet]
        gStyleNo: Text;
}

