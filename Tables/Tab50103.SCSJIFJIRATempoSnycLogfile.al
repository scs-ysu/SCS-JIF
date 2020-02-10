table 50103 "SCSJIFJIRA/Tempo-Snyc Log file"
{
    DataClassification = CustomerContent;
    Caption = 'JIRA/Tempo Integration - Sync Log file';

    fields
    {
        field(10; Id; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Caption = 'Id';
        }
        field(20; "Log Timestamp"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Log Timestamp';
        }
        field(40; "Message"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Message';
        }
        field(50; Severity; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Severity';
            OptionCaption = 'Debug,Info,Warning,Error,Fatal';
            OptionMembers = Debug,Info,Warning,Error,Fatal;
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

