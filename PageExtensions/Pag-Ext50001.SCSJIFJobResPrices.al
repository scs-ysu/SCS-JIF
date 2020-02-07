pageextension 50001 "SCSJIF Job Res Prices" extends "Job Resource Prices"
{
    layout
    {
        // Add changes to page layout here
        modify(Description)
        {
            ApplicationArea = All;
            Editable = true;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
