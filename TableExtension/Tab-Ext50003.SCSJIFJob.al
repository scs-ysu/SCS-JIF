tableextension 50003 "SCSJIFJob" extends Job
{

    fields
    {
        field(50000; "Internal Job"; Boolean)
        {
            Caption = 'Internal Job';
            DataClassification = CustomerContent;
            Description = 'SCS1.00';
        }
        field(50030; "JIRA/Tempo Sync Status"; Option)
        {
            Caption = 'JIRA/Tempo Sync Status';
            DataClassification = CustomerContent;
            Description = 'SCS1.00';
            OptionCaption = ' ,Synchronized,Manually Changed,Error,Closed';
            OptionMembers = " ",Synchronized,"Manually Changed",Error,Closed;
        }
        field(50040; "JIRA/Tempo Account ID"; Text[20])
        {
            Caption = 'JIRA/Tempo Account ID';
            DataClassification = CustomerContent;
            Description = 'SCS1.00';
        }
        field(50100; "Total Amount Scheduled"; Decimal)
        {
            CalcFormula = sum ("Job Planning Line"."Line Amount" where("Job No." = field("No."),
                                                                       "Schedule Line" = const(true)));
            Caption = 'Total Amount Scheduled';
            Description = 'SCS1.00';
            FieldClass = FlowField;
        }
        field(50110; "Total Amount Contracted"; Decimal)
        {
            CalcFormula = sum ("Job Planning Line"."Line Amount" where("Job No." = field("No."),
                                                                       "Contract Line" = const(true),
                                                                       "Planning Date" = field("Planning Date Filter"),
                                                                       "Resource Group No." = field("Resource Gr. Filter"),
                                                                       "No." = field("Resource Filter")));
            Caption = 'Total Amount Contracted';
            Description = 'SCS1.00';
            FieldClass = FlowField;
        }
        field(50120; "Total Qty. Contr'd (in Tempo)"; Decimal)
        {
            CalcFormula = sum ("Job Planning Line".Quantity where("Job No." = field("No."),
                                                                  "Tempo Worklog Id" = filter(<> ''),
                                                                  "Planning Date" = field("Planning Date Filter"),
                                                                  "Resource Group No." = field("Resource Gr. Filter"),
                                                                  "No." = field("Resource Filter")));
            Caption = 'Total Qty. Contr''d (in Tempo)';
            Description = 'SCS1.00';
            FieldClass = FlowField;
        }
        field(50130; "Earliest Entry Date"; Date)
        {
            CalcFormula = min ("Job Planning Line"."Planning Date" where("Job No." = field("No.")));
            Caption = 'Earliest Entry Date';
            Description = 'SCS1.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50140; "Latest Entry Date"; Date)
        {
            CalcFormula = max ("Job Planning Line"."Planning Date" where("Job No." = field("No.")));
            Caption = 'Latest Entry Date';
            Description = 'SCS1.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50150; "Amount held from Invoicing"; Decimal)
        {
            CalcFormula = sum ("Job Planning Line"."Line Amount (LCY)" where("Job No." = field("No."),
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

