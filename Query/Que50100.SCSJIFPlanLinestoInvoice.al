query 50100 "SCSJIF Plan. Lines to Invoice"
{
    // version SCS1.00

    elements
    {
        dataitem(JobPlanningLine; "Job Planning Line")
        {
            // SCSMIGNAV20162BC 13.08.19 YSU  +++
            //DataItemTableFilter = "Qty. to Transfer to Invoice" = filter(>0), "Line Type" = filter(<>Schedule), "Hold From Invoicing" = const(false);
            DataItemTableFilter = "Qty. to Transfer to Invoice" = filter(> 0), "Line Type" = filter(<> Budget), "Hold From Invoicing" = const(false);
            // SCSMIGNAV20162BC 13.08.19 YSU  ---
            column(MonthPlanningDate; "Planning Date")
            {
                Method = Month;
            }
            column(BilltoCustomerNo; "Bill-to Customer No.")
            {
            }
            column(SumLineAmountLCY; "Line Amount (LCY)")
            {
                Method = Sum;
            }
        }
    }
}

