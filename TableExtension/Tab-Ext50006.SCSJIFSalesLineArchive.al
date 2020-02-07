tableextension 50006 "SCSJIFSales Line Archive" extends "Sales Line Archive"
{

    fields
    {
        field(50000; BasedOnMultipleJobPlanningLns; Boolean)
        {
            Caption = 'Based On Multiple Job Planning Lines';
            DataClassification = CustomerContent;
            Description = 'SCS1.00';
        }
    }
    keys
    {
    }

    fieldgroups
    {
    }
}

