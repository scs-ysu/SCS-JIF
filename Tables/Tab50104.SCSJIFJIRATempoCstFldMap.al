table 50104 "SCSJIFJIRA/Tempo-Cst Fld Map"
{
    // version SCS1.00

    // Tag       Project     When      Who     What
    // ---------------------------------------------------------------------------------------------------------------------
    // SCS1.00               07.04.14  CBO     New table

    DataClassification = CustomerContent;
    Caption = 'JIRA/Tempo - Zuordnung von Kundenspezifischen Feldern';

    fields
    {
        field(10; Customer; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer';
            TableRelation = Customer where("JIRA/Tempo Customer No." = filter(<> ''));
        }
        field(15; "Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No.';
            TableRelation = Job where("No." = field("Job No."));
        }
        field(20; "From Field Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'From Field Name';
            NotBlank = true;
        }
        field(30; "To Field No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'To Field No.';
            TableRelation = Field."No." where(TableNo = const(1003));

            trigger OnLookup()
            var
                "Field": Record "Field";
                FieldsLookup: Page "Fields Lookup";
            begin
                Field.SetRange(TableNo, 1003);
                FieldsLookup.SetTableView(Field);
                FieldsLookup.LookupMode := true;
                if FieldsLookup.RunModal = Action::LookupOK then begin
                    FieldsLookup.GetRecord(Field);
                    "To Field No." := Field."No.";
                end;
            end;
        }
        field(35; "Field Name"; Text[30])
        {
            CalcFormula = lookup (Field.FieldName where(TableNo = const(1003),
                                                        "No." = field("To Field No.")));
            Caption = 'Field Name';
            FieldClass = FlowField;
        }
        field(40; "Mapping Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Mapping Type';
            OptionCaption = 'Pass-Thru,Map from/to,From/to Default';
            OptionMembers = "Pass-Thru","Map from/to","From/to Default";
        }
        field(50; "From Value"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'From Value';

            trigger OnValidate()
            begin
                case "Mapping Type" of

                    "Mapping Type"::"Pass-Thru":
                        TestField("From Value", '');

                    "Mapping Type"::"Map from/to":
                        TestField("From Value");

                    "Mapping Type"::"From/to Default":
                        TestField("From Value", '');

                end;
            end;
        }
        field(60; "To Value"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'To Value';

            trigger OnValidate()
            begin
                case "Mapping Type" of

                    "Mapping Type"::"Pass-Thru":
                        TestField("To Value", '');

                    "Mapping Type"::"Map from/to":
                        TestField("To Value");

                    "Mapping Type"::"From/to Default":
                        TestField("To Value");

                end;
            end;
        }
    }

    keys
    {
        key(Key1; Customer, "Job No.", "From Field Name", "To Field No.", "Mapping Type", "From Value")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        ValidateRec();
    end;

    trigger OnModify()
    begin
        ValidateRec();
    end;

    trigger OnRename()
    begin
        ValidateRec();
    end;

    var
        TextPassThruOverrides: Label 'At least one entry of mapping type "Passthrough"  exists. This entry overrides all other types.';

    procedure ValidateRec()
    var
        Rec2: Record "SCSJIFJIRA/Tempo-Cst Fld Map";
    begin
        if "Mapping Type" <> xRec."Mapping Type" then begin
            Validate("From Value");
            Validate("To Value");
        end;

        if "Mapping Type" <> "Mapping Type"::"Pass-Thru" then begin
            Rec2.SetRange(Customer, Customer);
            Rec2.SetRange("From Field Name", "From Field Name");
            Rec2.SetRange("To Field No.", "To Field No.");
            Rec2.SetRange("Mapping Type", "Mapping Type"::"Pass-Thru");
            if not Rec2.IsEmpty then
                Message(TextPassThruOverrides);
        end;
    end;
}

