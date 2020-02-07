tableextension 50001 "SCSJIFSales Line" extends "Sales Line"
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

