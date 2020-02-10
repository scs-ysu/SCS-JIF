table 50102 "JIRA/Tempo-Setup"
{
    // version SCS1.00

    // Tag       Project     When      Who     What
    // ---------------------------------------------------------------------------------------------------------------------
    // SCS1.00               07.04.14  CBO     New table

    DataClassification = CustomerContent;
    Caption = 'JIRA/Tempo - Setup';

    fields
    {
        field(10; "Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(20; "Tempo Servlet Base URL"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Tempo Servlet Base URL';
        }
        field(30; "Tempo Security Token"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Tempo Security Token';
        }
        field(40; "Clear Log Before Sync-Start"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Clear Log Before Sync-Start';
        }
        field(50; "Consolidate Ressources on Inv."; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Consolidate Ressources on Inv.';
        }
        field(60; "G/L Account No. for Cons."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'G/L Account No. for Cons.';
            TableRelation = "G/L Account";
        }
        field(70; "Sync From Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Sync From Date';
        }
        field(80; "Jira User for Sync"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(90; "Jira Password for Sync"; Text[20])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

