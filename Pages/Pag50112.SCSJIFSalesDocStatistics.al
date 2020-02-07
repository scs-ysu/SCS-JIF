page 50112 "SCSJIFSales Doc. Statistics"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    ShowFilter = false;
    SourceTable = "Sales Line";
    SourceTableTemporary = true;
    Caption = 'Sales Doc. Statistics';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentType; "Document Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(DocumentNo; "Document No.")
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
                }
                field(VariantCode; "Variant Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
                field(UnitOfMeasureCode; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field(AmountIncludingVAT; "Amount Including VAT")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Count"; "Quantity Invoiced")
                {
                    ApplicationArea = All;
                    CaptionML = DEU = 'Anzahl',
                                ENU = 'Count';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        FillTempTable;
        exit(true);
    end;

    var
        SalesDocStatistics: Query "SCSJIFSales Doc. Statistics";

    local procedure FillTempTable()
    var
        SalesHeader: Record "Sales Header";
        LineNo: Integer;
        RecRef: RecordRef;
    begin

        if Count > 0 then
            exit;

        SalesDocStatistics.SetRange(DocumentType, GetRangeMin("Document Type"));
        SalesDocStatistics.SetRange(DocumentNo, GetRangeMin("Document No."));
        SalesDocStatistics.Open;

        /*
        Reset;
        if Count > 0 then begin
            RecRef.GetTable(Rec);
            if not RecRef.IsTemporary then
                // prevent deletion of all lines...
                exit;
            DeleteAll;
        end;
        */
        LineNo := 10000;

        while SalesDocStatistics.Read do begin
            Init;
            "Document Type" := SalesDocStatistics.DocumentType;
            "Document No." := SalesDocStatistics.DocumentNo;
            "Line No." := LineNo;

            Type := SalesDocStatistics.Type;
            "No." := SalesDocStatistics.No;
            "Variant Code" := SalesDocStatistics.VariantCode;
            Quantity := SalesDocStatistics.SumQuantity;
            "Unit of Measure Code" := SalesDocStatistics.UnitOfMeasureCode;
            "Quantity Invoiced" := SalesDocStatistics.Count;

            Amount := SalesDocStatistics.SumAmount;
            "Amount Including VAT" := SalesDocStatistics.SumAmountIncludingVAT;

            Insert;
            LineNo += 10000;

        end;

        SalesDocStatistics.Close;
    end;
}

