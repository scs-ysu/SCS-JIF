table 50105 "JIRA/Tempo-Wrklgs, Cstom fld"
{
    // version SCS1.00

    // Tag       Project     When      Who     What
    // ---------------------------------------------------------------------------------------------------------------------
    // SCS1.00               07.04.14  CBO     New table

    DataClassification = CustomerContent;
    Caption = 'JIRA/Tempo - Worklogs, Custom fields';

    fields
    {
        field(30; "Work Log ID"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Work Log ID';
        }
        field(40; "To Field No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'To Field No.';
        }
        field(50; "To Value"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'To Value;DEU=Nach Wert';
        }
        field(60; "From  Field Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'From  Field Name';
        }
        field(70; "From Value"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'From Value';
        }
    }

    keys
    {
        key(Key1; "Work Log ID", "To Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

