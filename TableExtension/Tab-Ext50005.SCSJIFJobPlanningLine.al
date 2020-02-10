tableextension 50005 "SCSJIFJob Planning Line" extends "Job Planning Line"
{

    fields
    {
        field(50000; "Tempo Worklog Id"; Text[20])
        {
            Caption = 'Tempo Worklog Id';
            DataClassification = CustomerContent;

            Editable = false;
        }
        field(50010; "Jira Issue Key"; Text[30])
        {
            Caption = 'Jira Issue Key';
            DataClassification = CustomerContent;


            trigger OnLookup()
            var
                JIRASetup: Record "SCSJIFJIRA/Tempo-Setup";
            begin
                if "Jira Issue Key" <> '' then begin
                    JIRASetup.Get;
                    HyperLink(JIRASetup."Tempo Servlet Base URL" + 'browse/' + "Jira Issue Key");
                end;
            end;
        }
        field(50020; "Jira Issue Summary"; Text[250])
        {
            Caption = 'Jira Issue Summary';
            DataClassification = CustomerContent;

        }
        field(50025; "Parent Issue Key"; Text[30])
        {
            Caption = 'Parent Issue Key';
            DataClassification = CustomerContent;

        }
        field(50026; "Parent Issue Summary"; Text[250])
        {
            Caption = 'Parent Issue Summary';
            DataClassification = CustomerContent;

        }
        field(50030; "JIRA/Tempo Sync Status"; Option)
        {
            Caption = 'JIRA/Tempo Sync Status';
            DataClassification = CustomerContent;

            OptionCaption = '  ,Synchronized,Deleted in Tempo,Error,Update After Invoice,Moved to Other Account';
            OptionMembers = " ","In Sync","Deleted in Tempo",Error,"Update After Invoice","Moved to Other Account";
        }
        field(50035; "JIRA/Tempo Sync DateTime"; DateTime)
        {
            Caption = 'JIRA/Tempo Sync DateTime';
            DataClassification = CustomerContent;

        }
        field(50040; "JIRA/Tempo Billed Hours"; Decimal)
        {
            Caption = 'JIRA/Tempo Billed Hours';
            DataClassification = CustomerContent;


            trigger OnValidate()
            begin
                // 10.4.14 SCS1.00 CBO +++
                if "JIRA/Tempo Billed Hours Prev." <> "JIRA/Tempo Billed Hours" then
                    // value changed
                    if Quantity = "JIRA/Tempo Billed Hours Prev." then begin
                        // quantity not changed manually, update
                        Validate(Quantity, "JIRA/Tempo Billed Hours");
                        "JIRA/Tempo Billed Hours Prev." := "JIRA/Tempo Billed Hours";
                    end
                // 10.4.14 SCS1.00 CBO ---
            end;
        }
        field(50045; "JIRA/Tempo Billed Hours Prev."; Decimal)
        {
            Caption = 'JIRA/Tempo Billed Hours Prev.';
            DataClassification = CustomerContent;

        }
        field(50050; "JIRA/Tempo Workdate"; Date)
        {
            Caption = 'JIRA/Tempo Workdate';
            DataClassification = CustomerContent;


            trigger OnValidate()
            begin
                // 10.4.14 SCS1.00 CBO +++
                if "JIRA/Tempo Workdate Prev." <> "JIRA/Tempo Workdate" then
                    // value changed
                    if "Planning Date" = "JIRA/Tempo Workdate Prev." then begin
                        // not changed manually, update
                        Validate("Planning Date", "JIRA/Tempo Workdate");
                        "JIRA/Tempo Workdate Prev." := "JIRA/Tempo Workdate";
                    end
                // 10.4.14 SCS1.00 CBO ---
            end;
        }
        field(50055; "JIRA/Tempo Workdate Prev."; Date)
        {
            Caption = 'JIRA/Tempo Workdate Prev.';
            DataClassification = CustomerContent;

        }
        field(50060; "JIRA/Tempo Work Description"; BLOB)
        {
            Caption = 'JIRA/Tempo Work Description';
            DataClassification = CustomerContent;

            SubType = UserDefined;
        }
        field(50070; "JIRA/Tempo Staff Id"; Text[20])
        {
            Caption = 'JIRA/Tempo Staff Id';
            DataClassification = CustomerContent;


            trigger OnValidate()
            begin
                // 10.4.14 SCS1.00 CBO +++
                if "JIRA/Tempo Staff Id Prev." <> "JIRA/Tempo Staff Id" then
                    // value changed
                    if "No." = "JIRA/Tempo Staff Id Prev." then begin
                        // not changed manually, update
                        Validate("No.", "JIRA/Tempo Staff Id");
                        "JIRA/Tempo Staff Id Prev." := "JIRA/Tempo Staff Id";
                    end
                // 10.4.14 SCS1.00 CBO ---
            end;
        }
        field(50075; "JIRA/Tempo Staff Id Prev."; Text[20])
        {
            Caption = 'JIRA/Tempo Staff Id Prev.';
            DataClassification = CustomerContent;

        }
        field(50080; "JIRA Task No."; Text[30])
        {
            Caption = 'JIRA Task No.';
            DataClassification = CustomerContent;


            trigger OnValidate()
            begin
                // 10.4.14 SCS1.00 CBO +++
                if "JIRATask No. Prev." <> "JIRA Task No." then
                    // value changed
                    if "Job Task No." = "JIRATask No. Prev." then begin
                        // not changed manually, update
                        Validate("Job Task No.", "JIRA Task No.");
                        "JIRATask No. Prev." := "JIRA Task No.";
                    end
                // 10.4.14 SCS1.00 CBO ---
            end;
        }
        field(50085; "JIRATask No. Prev."; Text[30])
        {
            Caption = 'JIRA Task No. Prev.';
            DataClassification = CustomerContent;

        }
        field(50090; "Job Description"; Text[50])
        {
            CalcFormula = lookup (Job.Description where("No." = field("Job No.")));
            Caption = 'Job Description';

            FieldClass = FlowField;
        }
        field(50095; "Job Posting Group"; Code[10])
        {
            CalcFormula = lookup (Job."Job Posting Group" where("No." = field("Job No.")));
            Caption = 'Job Posting Group';

            FieldClass = FlowField;
        }
        field(50100; "Job Task Description"; Text[100])
        {
            CalcFormula = lookup ("Job Task".Description where("Job No." = field("Job No."),
                                                               "Job Task No." = field("Job Task No.")));
            Caption = 'Job Task Description';

            FieldClass = FlowField;
        }
        field(50110; "Bill-to Customer No."; Code[20])
        {
            CalcFormula = lookup (Job."Bill-to Customer No." where("No." = field("Job No.")));
            Caption = 'Bill-to Customer No.';

            FieldClass = FlowField;
        }
        field(50120; "JIRA/Tempo Worked Hours"; Decimal)
        {
            Caption = 'JIRA/Tempo Worked Hours';
            DataClassification = CustomerContent;

        }
        field(50130; "JIRA/Tempo Worked Hours Prev."; Decimal)
        {
            Caption = 'JIRA/Tempo Worked Hours Prev.';
            DataClassification = CustomerContent;

        }
        field(50140; "Tempo Hash Value"; Text[50])
        {
            Caption = 'Tempo Hash Value';
            DataClassification = CustomerContent;

        }
        field(50150; "Requested By"; Text[30])
        {
            Caption = 'Requested By';
            DataClassification = CustomerContent;

        }
        field(50160; "Applies To"; Text[30])
        {
            Caption = 'Applies To';
            DataClassification = CustomerContent;

        }
        field(50170; "Task Type"; Text[30])
        {
            DataClassification = CustomerContent;

        }
        field(50200; "Hold From Invoicing"; Boolean)
        {
            Caption = 'Hold From Invoicing';
            DataClassification = CustomerContent;


            trigger OnValidate()
            begin
                if xRec."Hold From Invoicing" = "Hold From Invoicing" then
                    exit;

                if not xRec."Hold From Invoicing" and "Hold From Invoicing" and ("Qty. to Invoice" = 0) then
                    Error(TxtAllInvoicedCannotHold);

                UpdateQtyToTransfer;
                UpdateQtyToInvoice;
            end;
        }
    }

    keys
    {
    }

    fieldgroups
    {
    }

    var
        "*** SCS1.00 Constants": TextConst;
        gRepricingMode: Boolean;
        gCustomer: Record Customer;
        gJobPlaningLine: Record "Job Planning Line";
        TxtAllInvoicedCannotHold: Label 'There is nothing (left) to invoice, line cannot be held.';
        TxtQtyNotMultiple: Label 'Resulting base quantity of %1 is not a whole numbered multiple of %2 minutes.';

    procedure ComputeChgIndStyle(pTarget: Text; pSourceOld: Text; pSourceNew: Text): Text
    var
        Style: Text;
    begin
        // 10.4.14 SCS1.00 CBO +++
        if "JIRA/Tempo Sync Status" <> "JIRA/Tempo Sync Status"::" " then
            if pSourceOld <> pSourceNew then begin
                // Source value has been changed
                if pTarget <> UpperCase(pSourceOld) then begin
                    // Target was changed manually and source has now been changed
                    exit('Attention');
                end;
            end else
                // Source value has not changed
                if pTarget <> UpperCase(pSourceOld) then begin
                    // Target was changed manually
                    exit('StandardAccent');
                end;

        exit('Standard');

        // 10.4.14 SCS1.00 CBO ---
    end;

    procedure GetStyleQuantity(): Text
    begin
        // 10.4.14 SCS1.00 CBO +++
        exit(ComputeChgIndStyle(Format(Quantity), Format("JIRA/Tempo Billed Hours"), Format("JIRA/Tempo Billed Hours Prev.")));
        // 10.4.14 SCS1.00 CBO ---
    end;

    procedure GetStyleWorkDate(): Text
    begin
        // 10.4.14 SCS1.00 CBO +++
        exit(ComputeChgIndStyle(Format("Planning Date"), Format("JIRA/Tempo Workdate"), Format("JIRA/Tempo Workdate Prev.")));
        // 10.4.14 SCS1.00 CBO ---
    end;

    procedure GetStyleNo(): Text
    begin
        // 10.4.14 SCS1.00 CBO +++
        exit(ComputeChgIndStyle(Format("No."), Format("JIRA/Tempo Staff Id"), Format("JIRA/Tempo Staff Id Prev.")));
        // 10.4.14 SCS1.00 CBO ---
    end;

    procedure GetStyleTaskNo(): Text
    begin
        // 10.4.14 SCS1.00 CBO +++
        exit(ComputeChgIndStyle(Format("Job Task No."), Format("JIRA Task No."), Format("JIRATask No. Prev.")));
        // 10.4.14 SCS1.00 CBO ---
    end;

    procedure CheckQuantityFraction(pQuantity: Decimal)  // to do
    var
        QuantityInt: BigInteger;
        Multiple: Decimal;
    begin
        // 21.4.14 SCS1.00 CBO +++
        CalcFields("Bill-to Customer No.");
        GetCustomer("Bill-to Customer No.");

        if gCustomer."Qty. (Base) Fraction (min)" <> 0 then begin
            Multiple := pQuantity * 60 / gCustomer."Qty. (Base) Fraction (min)";
            if Multiple mod 1 <> 0 then
                Error(TxtQtyNotMultiple, pQuantity, gCustomer."Qty. (Base) Fraction (min)");
        end;
        // 21.4.14 SCS1.00 CBO ---
    end;

    procedure CalculateTotals(var TotalQuantityBase: Decimal; var TotalQuantityTempo: Decimal; var TotalValue: Decimal; var TotalOpenValue: Decimal; var TotalCostValue: Decimal; var TotalOpenCostValue: Decimal)
    var
        TotalJPL: Record "Job Planning Line";
    begin
        // 06.05.14 SCS1.00 CBO +++
        if GetFilters = '' then begin
            // Skip calculation if no filters are applied (for performance reasons)
            TotalQuantityBase := 0;
            TotalQuantityTempo := 0;
            TotalValue := 0;
            TotalOpenValue := 0;
            TotalCostValue := 0;
            TotalOpenCostValue := 0;
            exit;
        end;

        TotalJPL.CopyFilters(Rec);
        TotalJPL.SetRange("Contract Line", true);
        TotalJPL.CalcSums("Quantity (Base)", "JIRA/Tempo Billed Hours", "Line Amount (LCY)", "Posted Line Amount (LCY)", TotalJPL."Total Cost (LCY)", "Posted Total Cost (LCY)");

        TotalQuantityBase := TotalJPL."Quantity (Base)";
        TotalQuantityTempo := TotalJPL."JIRA/Tempo Billed Hours";

        TotalValue := TotalJPL."Line Amount (LCY)";
        TotalOpenValue := TotalJPL."Line Amount (LCY)" - TotalJPL."Posted Line Amount (LCY)";

        TotalCostValue := TotalJPL."Total Cost (LCY)";
        TotalOpenCostValue := TotalJPL."Total Cost (LCY)" - TotalJPL."Posted Total Cost (LCY)";
        // 06.05.14 SCS1.00 CBO ---
    end;

    procedure "ValidateModification(Global)"()
    begin
        // 10.4.14 SCS1.00 CBO +++
        // 09.08.19 SCS1.00 YSU +++
        //ValidateModification();
        CALCFIELDS("Qty. Transferred to Invoice");
        TESTFIELD("Qty. Transferred to Invoice", 0);
        // 09.08.19 SCS1.00 YSU ---
        // 10.4.14 SCS1.00 CBO ---
    end;

    procedure GetCustomer(pCustomer: Code[20])
    begin
        // 10.4.14 SCS1.00 CBO +++
        if (pCustomer <> '') and (gCustomer."No." <> pCustomer) then
            gCustomer.Get(pCustomer);
        // 10.4.14 SCS1.00 CBO ---
    end;
}

