table 50100 "SCSJIFJIRA/Tempo-Accounts work"
{

    DataClassification = CustomerContent;

    fields
    {
        field(10; "JIRA/Tempo Account ID"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'JIRA/Tempo Account ID';
        }
        field(20; Description; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(30; "JIRA/Tempo Project Key List"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'JIRA/Tempo Project Key List';
        }
        field(40; "JIRA/Tempo Customer No."; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'JIRA/Tempo Customer No.';
        }
        field(50; "JIRA/Tempo Customer Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'JIRA/TEMPO Customer Name';
        }
        field(60; "Person Responsible"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Person Responsible';
        }
        field(70; "Person Responsible Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Person Responsible Name';
        }
        field(80; "Project Owner"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Project Owner';
        }
        field(90; "Category Code"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Category Code';
        }
        field(100; "Category Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Category Description';
        }
        field(110; "JIRA/Tempo Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'JIRA/Tempo Status';
            OptionCaption = ' ,External Close,JIRA Close,Open,External Project Not Found,Archived';
            OptionMembers = " ","External Close","JIRA Close",Open,"External Project Not Found",Archived;
        }
        field(120; "Synchronization Error"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Synchronization Error';
        }
        field(130; "Synchronization Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Synchronization Status';
            OptionCaption = 'Pending,Error,Processed';
            OptionMembers = Pending,Error,Processed;
        }
        field(140; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.';
        }
        field(150; "JIRA/Tempo Customer Number"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'JIRA/Tempo Customer Number';
        }
        field(160; "Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No.';
        }
    }

    keys
    {
        key(Key1; "JIRA/Tempo Account ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

