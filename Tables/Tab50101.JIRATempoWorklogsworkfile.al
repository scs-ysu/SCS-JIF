table 50101 "JIRA/Tempo-Worklogs workfile"
{
    // version SCS1.00

    // Tag       Project     When      Who     What
    // ---------------------------------------------------------------------------------------------------------------------
    // SCS1.00               07.04.14  CBO     New table

    DataClassification = CustomerContent;

    fields
    {
        field(10; "TEMPO Account ID"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Job Task ID"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Work Log ID"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(40; "Issue ID"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50; "Issue Key"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(55; "Issue Summary"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(57; "Parent Issue Key"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(58; "Parent Issue Summary"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(59; "Is Parent Issue"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Worked Hours"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(65; "Billed Hours"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(66; "Billing Attributes"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(70; "Work Date"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(80; "Work DateTime"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(90; User; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(100; "Staff ID"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(110; "Activity ID"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(120; "Activity Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(130; "Work Description 1"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(131; "Work Description 2"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(132; "Work Description 3"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(133; "Work Description 4"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(134; "Work Description 5"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(135; "Work Description 6"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(136; "Work Description 7"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(137; "Work Description 8"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(140; "Parent Key"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(150; Reporter; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(160; "External ID"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(170; "External Timestamp"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(180; "External Hours"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(190; "External Result"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(200; "Hash Value"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(210; "Synchronization Error"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(220; "Synchronization Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Pending,Error,Processed;
        }
    }

    keys
    {
        key(Key1; "TEMPO Account ID", "Job Task ID", "Work Log ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

