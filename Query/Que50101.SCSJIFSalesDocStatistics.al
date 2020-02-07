query 50101 "SCSJIFSales Doc. Statistics"
{
    // version SCS1.00

    OrderBy = ascending(DocumentType), ascending(DocumentNo), ascending(Type), ascending(No), ascending(VariantCode);

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableFilter = Type = filter(<> " ");
            column(DocumentType; "Document Type")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(Type; Type)
            {
            }
            column(No; "No.")
            {
            }
            column(VariantCode; "Variant Code")
            {
            }
            column(SumQuantity; Quantity)
            {
                Method = Sum;
            }
            column(UnitOfMeasureCode; "Unit of Measure Code")
            {
            }
            column(SumAmount; Amount)
            {
                Method = Sum;
            }
            column(SumAmountIncludingVAT; "Amount Including VAT")
            {
                Method = Sum;
            }
            column("Count")
            {
                CaptionML = DEU = 'Anzahl',
                            ENU = 'Count';
                Method = Count;
            }
        }
    }
}

