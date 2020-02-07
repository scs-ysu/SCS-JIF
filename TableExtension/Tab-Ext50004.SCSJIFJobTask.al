tableextension 50004 "SCSJIFJob Task" extends "Job Task"
{

    fields
    {
        field(50110; "Bill-to Customer No."; Code[20])
        {
            CalcFormula = lookup (Job."Bill-to Customer No." where("No." = field("Job No.")));
            Caption = 'Bill-to Customer No.';
            Description = 'SCS1.00';
            FieldClass = FlowField;
        }
        field(50120; "Total Qty. Contr'd (in Tempo)"; Decimal)
        {
            CalcFormula = sum ("Job Planning Line".Quantity where("Job No." = field("Job No."),
                                                                  "Job Task No." = field("Job Task No."),
                                                                  "Job Task No." = field(filter(Totaling)),
                                                                  "Tempo Worklog Id" = filter(<> ''),
                                                                  "Planning Date" = field("Planning Date Filter"),
                                                                  "Document Date" = field("Posting Date Filter")));
            Caption = 'Total Qty. Contr''d (in Tempo)';
            Description = 'SCS1.00';
            FieldClass = FlowField;
        }
        field(50130; "Amount held from Invoicing"; Decimal)
        {
            CalcFormula = sum ("Job Planning Line"."Line Amount (LCY)" where("Job No." = field("Job No."),
                                                                             "Job Task No." = field("Job Task No."),
                                                                             "Job Task No." = field(filter(Totaling)),
                                                                             "Contract Line" = const(true),
                                                                             "Planning Date" = field("Planning Date Filter"),
                                                                             "Hold From Invoicing" = const(true)));
            Caption = 'Amount held from Invoicing';
            Description = 'SCS1.00';
            FieldClass = FlowField;
        }
    }

    keys
    {
    }

    fieldgroups
    {
    }
}

