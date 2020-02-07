tableextension 50002 "SCSJIFResource" extends Resource
{

    fields
    {
        field(50000; "Default Work Type Code"; Code[10])
        {
            Caption = 'Default Work Type Code';
            DataClassification = CustomerContent;
            Description = 'SCS1.00';
            TableRelation = "Work Type";
        }
        field(50010; "Default Work Type Code Int."; Code[10])
        {
            Caption = 'Default Work Type Code - Internal Tasks';
            DataClassification = CustomerContent;
            Description = 'SCS1.00';
            TableRelation = "Work Type";
        }
        field(50100; "Base Salary"; Decimal)
        {
            Caption = 'Base Salary';
            DataClassification = CustomerContent;
            Description = 'SCS1.00';
        }
        field(50110; "Turnover Factor"; Decimal)
        {
            Caption = 'Turnover Factor';
            DataClassification = CustomerContent;
            Description = 'SCS1.00';
        }
        field(50120; "Commission Percentage"; Decimal)
        {
            Caption = 'Commission Percentage';
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

