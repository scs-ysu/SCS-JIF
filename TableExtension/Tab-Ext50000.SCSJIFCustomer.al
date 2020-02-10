tableextension 50000 "SCSJIFCustomer" extends Customer
{

    fields
    {

        field(50010; "JIRA/Tempo Customer No."; Text[20])
        {
            Caption = 'JIRA/Tempo Customer No.';
            DataClassification = CustomerContent;

        }
        field(50020; "Job Template Code"; Code[20])
        {
            Caption = 'Job Template Code';
            DataClassification = CustomerContent;

            TableRelation = "Config. Template Header";

            trigger OnValidate()
            var
                ConfigTemplateHdr: Record "Config. Template Header";
            begin
                ConfigTemplateHdr.Get("Job Template Code");
            end;
        }
        field(50040; "Auto-Create Job Task"; Option)
        {
            Caption = 'Auto-Create Job Task';
            DataClassification = CustomerContent;

            OptionCaption = 'Never,For Dummy Task Only,For JIRA Parent Issue or Dummy Task,For JIRA Issue';
            OptionMembers = Never,"For Dummy Task Only","For Parent Issue or Dummy Task","For Issue";

            trigger OnValidate()
            begin
                Validate("ID for Dummy Job Task");
                Validate("Job Task Template Code");
            end;
        }
        field(50050; "ID for Dummy Job Task"; Code[20])
        {
            Caption = 'ID for Dummy Job Task';
            DataClassification = CustomerContent;

        }
        field(50060; "Prohibit Dummy Task lines inv."; Boolean)
        {
            Caption = 'Prohibit Dummy Task lines inv.';
            DataClassification = CustomerContent;

        }
        field(50070; "Job Task Template Code"; Code[20])
        {
            Caption = 'Job Task Template Code';
            DataClassification = CustomerContent;

            TableRelation = "Config. Template Header";

            trigger OnValidate()
            var
                ConfigTemplateHdr: Record "Config. Template Header";
            begin
                ConfigTemplateHdr.Get("Job Task Template Code");
            end;
        }
        field(50080; "Desc. for Dummy Job Task"; Text[50])
        {
            Caption = 'Description for Dummy Job Task';
            DataClassification = CustomerContent;

        }
        field(50090; "Auto-Assign to Issues Job Task"; Boolean)
        {
            Caption = 'Auto-Assign to Issues Job Task';
            DataClassification = CustomerContent;

        }
        field(50100; "Sync From Date"; Date)
        {
            Caption = 'Sync From Date';
            DataClassification = CustomerContent;

        }
        field(50170; "G/L Account for Expenses"; Code[20])
        {
            Caption = 'G/L Account for Expenses';
            DataClassification = CustomerContent;

            TableRelation = "G/L Account";
        }
        field(50180; "Unit for Expenses"; Code[10])
        {
            Caption = 'Unit for Expenses';
            DataClassification = CustomerContent;

            TableRelation = "Unit of Measure";
        }

        field(50110; "Qty. (Base) Fraction (min)"; Integer)
        {
            Caption = 'Qty. (Base) Fraction (min)';
            DataClassification = CustomerContent;

            MaxValue = 60;
            MinValue = 0;
        }

    }

    keys
    {
    }

    fieldgroups
    {
    }
}

