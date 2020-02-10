tableextension 50002 "SCSJIFResource" extends Resource
{

    fields
    {
        field(50000; "Default Work Type Code"; Code[10])
        {
            Caption = 'Default Work Type Code';
            DataClassification = CustomerContent;
            TableRelation = "Work Type";
        }
        field(50010; "Default Work Type Code Int."; Code[10])
        {
            Caption = 'Default Work Type Code - Internal Tasks';
            DataClassification = CustomerContent;
            TableRelation = "Work Type";
        }
        field(50100; "Base Salary"; Decimal)
        {
            Caption = 'Base Salary';
            DataClassification = CustomerContent;

        }
        field(50110; "Turnover Factor"; Decimal)
        {
            Caption = 'Turnover Factor';
            DataClassification = CustomerContent;

        }
        field(50120; "Commission Percentage"; Decimal)
        {
            Caption = 'Commission Percentage';
            DataClassification = CustomerContent;

        }
    }

    keys
    {
    }

    fieldgroups
    {
    }
}

