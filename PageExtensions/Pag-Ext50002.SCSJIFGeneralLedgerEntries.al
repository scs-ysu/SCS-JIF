pageextension 50002 "SCSJIF General Ledger Entries" extends "General Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Posting Date")
        {

            field(DocumentDate; "Document Date")
            {
                ApplicationArea = All;
            }
        }

    }

    actions
    {
        // Add changes to page actions here


    }

    var
        myInt: Integer;
}