pageextension 50006 "SCSJIF Job Card" extends "Job Card"
{

    layout
    {
        // Add changes to page layout here
        addafter(Blocked)
        {
            field(InternalJob; "Internal Job")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Online Map")

        {
            action("Tempo Custom Field Mapping")
            {
                ApplicationArea = All;
                Caption = 'Tempo Custom Field Mapping';
                Description = 'SCS1.00';
                RunObject = Page "SCSJIFJIRA/Tempo-Custom Field";
                RunPageLink = Customer = field("Bill-to Customer No."),
                                  "Job No." = field("No.");
            }
        }
    }

    var
        myInt: Integer;
}