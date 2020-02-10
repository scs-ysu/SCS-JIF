codeunit 50102 "SCSJIFEvent Subscribers"
{
    // version SCS1.00
    // Tag         Project   When      Who     What
    // ---------------------------------------------------------------------------------------------------------------------
    // SCS1.00               12.08.19   YSU     added event subscriber onAfterValidation on field TYpe



    trigger OnRun()
    begin
    end;

    var
        Txt_Posting_ConfirmDateBeforeWorkDate: TextConst DEU = '%1 (%2) liegt vor dem Arbeitsdatum (%3). Wollen Sie dies wirklich buchen?', ENU = '%1 (%2) is earlier than Work Date (%3). Are you sure you want to post this?';
        Txt_Posting_ErrorDateBeforeWorkDate: TextConst DEU = '%1 (%2) liegt vor dem Arbeitsdatum (%3). Buchung abgebrochen.', ENU = '%1 (%2) is earlier than Work Date (%3). Posting aborted.';
        Text_Releasing_ConfirmExpiryDateEarly: TextConst DEU = 'Das %1 (%2) liegt vor dem Firmen-Vorgabewert (%3). Dennoch benutzen?', ENU = '%1 (%2) is earlier than company default (%3). Are you sure you want to use this date?';
        Text_Releasing_ErrorExpiryDateEarly: TextConst DEU = 'Das %1 (%2) liegt vor dem Firmen-Vorgabewert (%3). Freigabe abgebrochen.', ENU = '%1 (%2) is earlier than company default (%3). Release aborted.';
        Txt_Releasing_ConfirmDateBeforeWorkDate: TextConst DEU = '%1 (%2) liegt vor dem Arbeitsdatum (%3). Wollen Sie dies wirklich freigeben?', ENU = '%1 (%2) is earlier than Work Date (%3). Are you sure you want to release this?';
        Txt_Releasing_ErrorDateBeforeWorkDate: TextConst DEU = '%1 (%2) liegt vor dem Arbeitsdatum (%3). Freigabe abgebrochen.', ENU = '%1 (%2) is earlier than Work Date (%3). Release aborted.';
        Txt_Releasing_Confirm_EstimationPrecisionClassMissing: TextConst DEU = 'Nicht alle relevanten Zeilen sind einer %1 zugeordnet. Wollen Sie dies wirklich freigeben?', ENU = 'Not all relevant lines have a %1 assigned. Are you sure that you want to continue?';
        Txt_Releasing_Error_EstimationPrecisionClassMissing: TextConst DEU = 'Nicht alle relevanten Zeilen sind einer %1 zugeordnet. Freigabe abgebrochen.', ENU = 'Not all relevant lines have a %1 assigned. Release aborted.';
        Txt_Posting_ConfirmNoExtDocNumber: TextConst DEU = '%1 ist nicht angegeben, wollen Sie wirklich buchen?', ENU = '%1 does not have a value. Are you sure you want to post this?';
        Txt_Posting_ErrorNoExtDocNumber: TextConst DEU = '%1 ist nicht angegeben. Buchung abgebrochen.', ENU = '%1 does not have a value. Posting aborted.';
        //SCS Migration chnages
        Txt_FiledCaptionChange: TextConst DEU = '%1 und %2 dieses Elements vom Typ %3 k”nnen nicht ge„ndert werden.', ENU = 'You cannot change the %1 or %2 of this %3.';
        TxtDocumentTypeNotSupported: Label 'Type of sales document (%1) is not supported.';
        TxtPlanningLineTypeNotSupported: Label 'Type of Planning Line (%1) is not supported.';
        TxtLinkedSalesLine: TextConst DEU = 'Die Verkaufszeile kann nicht geändert werden, weil sie verknüpft ist mit\', ENU = 'You cannot change the sales line because it is linked to\';
        TxtPlannLineEr: TextConst DEU = ' %1: %2= %3, %4= %5.', ENU = ' %1: %2= %3, %4= %5.';
        TxtJobTaskDesc: Label 'Job %1, task %2';
        Txt_SalesDocIsNotReleased: TextConst DEU = '%1 %2 ist nicht freigegeben. Sind Sie sicher, dass Sie fortsetzen wollen?', ENU = '%1 %2 has not been released. Are you sure that you want to continue?';
        Txt_Error_SalesDocIsNotReleased: TextConst DEU = '%1 %2 ist nicht freigegeben. Druck abgebrochen.', ENU = '%1 %2 has not been released. Printing aborted.';


        TempJobPlanningLine: Record "Job Planning Line" temporary;
        CompanyInfo: Record "Company Information";
        gTempoSetup: Record "SCSJIFJIRA/Tempo-Setup";
        gRepricingMode: Boolean;



    // table "Job Planning Line"
    /* [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnAfterValidateEvent', 'No.', false, false)]
     local procedure OnAfterValidateJPLNo(var Rec: Record "Job Planning Line"; var xRec: Record "Job Planning Line"; CurrFieldNo: Integer)
     var
         Customer: Record "Customer";
         Job: Record Job;
         Res: Record Resource;
     begin

         case Rec.Type of
             Rec.Type::Resource:
                 begin
                     // SCS1.00 +++
                     Rec.GetCustomer(Job."Bill-to Customer No.");
                     if Customer."Use Default Work Type" then
                         Rec.Validate("Work Type Code", Customer."Default Work Type")
                     else
                         if Job."Internal Job" then begin
                             Res.TestField("Default Work Type Code Int.");
                             Rec.Validate("Work Type Code", Res."Default Work Type Code Int.")
                         end else begin
                             Res.TestField("Default Work Type Code");
                             Rec.Validate("Work Type Code", Res."Default Work Type Code");
                         end;
                     // SCS1.00 ---
                     Rec.Validate("Unit of Measure Code", Res."Base Unit of Measure");
                 end;
         end;
         // SCSMIGNAV20162BC 12.08.19 YSU  ---
     end;
 */
    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateEventJPLQty(var Rec: Record "Job Planning Line"; var xRec: Record "Job Planning Line"; CurrFieldNo: Integer)
    begin
        // 21.04.14 SCS1.00 CBO  +++
        IF Rec.Type = Rec.Type::Resource THEN
            Rec.checkQuantityFraction(Rec."Quantity (Base)");
        // 21.04.14 SCS1.00 CBO ---

        //job planning line table PROCEDURE UpdateQtyToTransfer modifications
        IF Rec."Contract Line" THEN BEGIN
            // +++ SCS1.00 04.06.14 CBO
            IF Rec."Hold From Invoicing" THEN BEGIN
                Rec.VALIDATE("Qty. to Transfer to Invoice", 0);
                Rec.VALIDATE("Qty. to Invoice", 0); //job planning line table PROCEDURE UpdateQtyToInvoice modifications
                EXIT;
            END;
            // +++ SCS1.00 04.06.14 CBO

        end;
    END;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnBeforeValidateEvent', 'Qty. to Transfer to Invoice', false, false)]
    local procedure SubToOnBeforeValEvtQtyToTransferToInv(var Rec: Record "Job Planning Line"; var xRec: Record "Job Planning Line"; CurrFieldNo: Integer)
    begin
        // +++ SCS1.00 04.06.14 CBO
        IF Rec."Contract Line" THEN BEGIN
            IF Rec."Hold From Invoicing" THEN BEGIN
                Rec.VALIDATE("Qty. to Transfer to Invoice", 0);
                EXIT;
            END;
            // +++ SCS1.00 04.06.14 CBO
        END;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnBeforeValidateEvent', 'Qty. to Invoice', false, false)]
    local procedure SubToOnBeforeValEvtQtyToInv(var Rec: Record "Job Planning Line"; var xRec: Record "Job Planning Line"; CurrFieldNo: Integer)
    begin
        // +++ SCS1.00 04.06.14 CBO
        IF Rec."Contract Line" THEN BEGIN
            IF Rec."Hold From Invoicing" THEN BEGIN
                Rec.VALIDATE("Qty. to Invoice", 0);
                EXIT;
            END;
            // +++ SCS1.00 04.06.14 CBO
        END;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnBeforeRenameEvent', '', false, false)]
    local procedure OnBeforeRenameJPL(var Rec: Record "Job Planning Line"; var xRec: Record "Job Planning Line")
    begin
        IF xRec."Job No." <> Rec."Job No." THEN // 21.04.14 SCS1.00 CBO  +++
            Error(Txt_FiledCaptionChange, Rec.FieldCaption(Rec."Job No."), Rec.FieldCaption(Rec."Job Task No."), Rec.TableCaption);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnAfterInitJobPlanningLine', '', false, false)]
    local procedure OnAfterInitJobPlanningLine(var JobPlanningLine: Record "Job Planning Line")
    begin
        JobPlanningLine."JIRA/Tempo Workdate Prev." := JobPlanningLine."Planning Date"; // SCS1.00 15.04.14 CBO  +++
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnAfterValidateEvent', 'Job Task No.', false, false)]
    local procedure OnAfterValidateEventJPLJobTaskNo(var Rec: Record "Job Planning Line"; var xRec: Record "Job Planning Line"; CurrFieldNo: Integer)
    var
        JobPlanningLine: Record "Job Planning Line";
        ToJobTaskNo: Code[20];
        ToLineNo: Integer;
        JobTask: Record "Job Task";
    begin
        // 06.05.14 SCS1.00 CBO +++
        if (xRec."Job Task No." = '') or (xRec."Job Task No." = Rec."Job Task No.") then
            exit;

        ToJobTaskNo := Rec."Job Task No.";
        Rec."Job Task No." := xRec."Job Task No."; // Restore primary keys (for proper function of rename, calcfields)

        // SCSMIGNAV20162BC 09.08.19 YSU  +++
        //ValidateModification();
        Rec."ValidateModification(Global)"();
        // SCSMIGNAV20162BC 09.08.19 YSU  ---
        JobTask.SetRange("Job No.", Rec."Job No.");
        JobTask.SetRange("Job Task No.", ToJobTaskNo);
        JobTask.FindFirst;
        JobTask.TestField("Job Task Type", JobTask."Job Task Type"::Posting);

        JobPlanningLine.SetRange("Job No.", Rec."Job No.");
        JobPlanningLine.SetRange("Job Task No.", ToJobTaskNo);

        if JobPlanningLine.FindLast then
            ToLineNo := JobPlanningLine."Line No." + 10000
        else
            ToLineNo := 10000;

        Rec.CalcFields(Rec."JIRA/Tempo Work Description");

        // to do rename create pb as modifcation on renmae trigger cannot be moved to extension
        Rec.Rename(Rec."Job No.", ToJobTaskNo, ToLineNo);

        // 06.05.14 SCS1.00 CBO ---
    end;

    //codeunit 80 "Sale-Post" updated
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnBeforeInsertShipmentLine', '', false, false)]
    local procedure OnPostSalesLineOnBeforeInsertShipmentLineExt(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; VAR IsHandled: Boolean; SalesLineACY: Record "Sales Line"; DocType: Option; DocNo: Code[20]; ExtDocNo: Code[35])
    var
        GLAcc: Record "G/L Account";
        SalesPost: Codeunit "Sales-Post";
        SourceCodeSetup: Record "Source Code Setup";
        SrcCode: Code[10];
        GenJnlLineExtDocNo: Code[35];
        GenJnlLineDocNo: Code[20];
    begin
        case SalesLine.Type of
            SalesLine.Type::"G/L Account":
                if (SalesLine."No." <> '') and not SalesLine."System-Created Entry" then begin
                    GLAcc.Get(SalesLine."No.");
                    GLAcc.TestField("Direct Posting", true);
                    SourceCodeSetup.GET;
                    SrcCode := SourceCodeSetup.Sales;
                    GenJnlLineDocNo := DocNo;
                    GenJnlLineExtDocNo := ExtDocNo;
                    PostRelatedRessourceAndContractLines(SalesLine, SalesHeader, SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."Reason Code", GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, SalesHeader."Posting No. Series"); // SCS1.00 10.05.14 CBO +++
                end;
        end;
    End;

    Local procedure PostRelatedRessourceAndContractLines(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; PostingDate: Date; DocumentDate: Date; ReasonCode: Code[10]; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[20]; SrcCode: Code[20]; PostingNoSeries: Code[10])
    var
        JobPlanningLineInvoice: Record "Job Planning Line Invoice";
        JobPlanningLine: Record "Job Planning Line";
        SalesLine2: Record "Sales Line";
        ResJnlLine: Record "Res. Journal Line";
        ResJnlPostLine: codeunit "Res. Jnl.-Post Line";
        JobPostLine: Codeunit "Job Post-Line";
    begin
        if SalesLine."Job Contract Entry No." <> 0 then
            // already handled by standard
            exit;

        with JobPlanningLineInvoice do begin

            case SalesLine."Document Type" of
                SalesLine."Document Type"::Invoice:
                    SetRange("Document Type", "Document Type"::Invoice);
                SalesLine."Document Type"::"Credit Memo":
                    SetRange("Document Type", "Document Type"::"Credit Memo");
                else
                    exit;
            end;

            SetRange("Document No.", SalesLine."Document No.");
            SetRange("Line No.", SalesLine."Line No.");

            if FindFirst then
                repeat

                    if "Quantity Transferred" <> 0 then begin
                        JobPlanningLine.Get("Job No.", "Job Task No.", "Job Planning Line No.");

                        if JobPlanningLine.Type = JobPlanningLine.Type::Resource then begin

                            ResJnlLine.Init;
                            ResJnlLine."Posting Date" := PostingDate;
                            ResJnlLine."Document Date" := DocumentDate;
                            ResJnlLine."Reason Code" := ReasonCode;
                            ResJnlLine."Resource No." := JobPlanningLine."No.";
                            ResJnlLine.Description := JobPlanningLine.Description;
                            ResJnlLine."Source Type" := ResJnlLine."Source Type"::Customer;
                            ResJnlLine."Source No." := SalesLine."Sell-to Customer No.";
                            ResJnlLine."Work Type Code" := JobPlanningLine."Work Type Code";

                            ResJnlLine."Job No." := SalesLine."Job No.";
                            ResJnlLine."Unit of Measure Code" := JobPlanningLine."Unit of Measure Code";

                            ResJnlLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
                            ResJnlLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
                            ResJnlLine."Dimension Set ID" := SalesLine."Dimension Set ID";

                            ResJnlLine."Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
                            ResJnlLine."Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";

                            ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Sale;
                            ResJnlLine."Document No." := GenJnlLineDocNo;
                            ResJnlLine."External Document No." := GenJnlLineExtDocNo;

                            ResJnlLine.Quantity := "Quantity Transferred" / JobPlanningLine."Qty. per Unit of Measure";
                            ResJnlLine."Unit Cost" := JobPlanningLine."Unit Cost (LCY)";
                            ResJnlLine."Total Cost" := JobPlanningLine."Unit Cost (LCY)" * ResJnlLine.Quantity;

                            ResJnlLine."Unit Price" := JobPlanningLine."Unit Price (LCY)";
                            ResJnlLine."Total Price" := JobPlanningLine."Line Amount (LCY)";

                            ResJnlLine."Source Code" := SrcCode;
                            ResJnlLine."Posting No. Series" := PostingNoSeries;

                            ResJnlLine."Qty. per Unit of Measure" := JobPlanningLine."Qty. per Unit of Measure";

                            ResJnlPostLine.RunWithCheck(ResJnlLine);

                        end;

                        with SalesLine2 do begin
                            // adopt certain values for contract line posting
                            Copy(SalesLine);

                            case JobPlanningLine.Type of
                                JobPlanningLine.Type::Resource:
                                    Validate(Type, Type::Resource);

                                JobPlanningLine.Type::"G/L Account":
                                    Validate(Type, Type::"G/L Account");

                                else
                                    Error(TxtPlanningLineTypeNotSupported, JobPlanningLine.Type);
                            end;

                            Validate("No.", JobPlanningLine."No.");

                            Validate("Work Type Code", JobPlanningLine."Work Type Code");
                            Validate("Unit of Measure Code", JobPlanningLine."Unit of Measure Code");

                            Validate(Quantity, "Quantity Transferred" / JobPlanningLine."Qty. per Unit of Measure");

                            "Qty. per Unit of Measure" := JobPlanningLine."Qty. per Unit of Measure";

                            Validate("Unit Cost", JobPlanningLine."Unit Cost");
                            Validate("Unit Cost (LCY)", JobPlanningLine."Unit Cost (LCY)");

                            "Unit Price" := JobPlanningLine."Unit Price";

                            case SalesHeader."Document Type" of
                                SalesHeader."Document Type"::Invoice:
                                    // 14.08.19 YSU++++
                                    //"Document No." := SalesInvHeader."No.";
                                    "Document No." := GenJnlLineDocNo;
                                // 14.08.19 YSU----
                                SalesHeader."Document Type"::"Credit Memo":
                                    // 14.08.19 YSU++++
                                    //"Document No." := SalesCrMemoHeader."No.";
                                    "Document No." := GenJnlLineDocNo;
                                // 14.08.19 YSU----

                                else
                                    Error(TxtDocumentTypeNotSupported, SalesHeader."Document Type");
                            end;

                            "Job Contract Entry No." := JobPlanningLine."Job Contract Entry No.";

                            Description := JobPlanningLine.Description;
                            "Description 2" := JobPlanningLine."Description 2";

                        end;

                        JobPostLine.PostInvoiceContractLine(SalesHeader, SalesLine2);

                    end;

                until Next = 0;

        end;
    end;

    //codeunit 1001 "Job post-line"
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeTestJobPlanningLine', '', false, false)]
    local procedure OnBeforeTestJobPlanningLineOnSalesLine(VAR SalesLine: Record "Sales Line"; VAR IsHandled: Boolean)
    var
        JobTask: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
        JobPlanningLineInvoice: record "Job Planning Line Invoice";
        Txt: Text;
    begin
        IsHandled := TRUE;
        IF SalesLine."Job Contract Entry No." = 0 THEN
            EXIT;

        // code to hande changes from CU 1001 and fun TestSalesLine(Rec) ;   
        IF SalesLine."Job Contract Entry No." <> 0 THEN BEGIN
            // contract entry given, check if related job planning line exists
            JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
            JobPlanningLine.SETRANGE("Job Contract Entry No.", SalesLine."Job Contract Entry No.");
            IF JobPlanningLine.ISEMPTY THEN
                EXIT;
            JobTask.GET(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.");
        END ELSE BEGIN
            // no entry given, check via planning line invoices
            WITH JobPlanningLineInvoice DO BEGIN
                CASE SalesLine."Document Type" OF
                    SalesLine."Document Type"::Invoice:
                        SETRANGE("Document Type", "Document Type"::Invoice);
                    SalesLine."Document Type"::"Credit Memo":
                        SETRANGE("Document Type", "Document Type"::"Credit Memo");
                    ELSE
                        EXIT;
                END;

                SETRANGE("Document No.", SalesLine."Document No.");
                SETRANGE("Line No.", SalesLine."Line No.");
                IF ISEMPTY THEN
                    EXIT;

                JobTask.GET(SalesLine."Job No.", SalesLine."Job Task No.");
            END;
        END;

        // related planning line found, error
        Txt := TxtLinkedSalesLine + STRSUBSTNO(TxtPlannLineEr,
            JobTask.TABLECAPTION, JobTask.FIELDCAPTION("Job No."), JobTask."Job No.",
            JobTask.FIELDCAPTION("Job Task No."), JobTask."Job Task No.");
        ERROR(Txt);
    end;

    //Codeunit 1002 "Job Create-Invoice"

    //CU 229
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", 'OnBeforeCalcSalesDisc', '', false, false)]
    local procedure SubToOnBeforeCalcSalesDiscEvt(VAR SalesHeader: Record "Sales Header"; VAR IsHandled: Boolean)
    begin
        IsHandled := false; //14.08.19 YSU
        if SalesHeader.Status <> SalesHeader.Status::Released then
            if not Confirm(Txt_SalesDocIsNotReleased, true, Format(SalesHeader."Document Type"), SalesHeader."No.") then
                Error(Txt_Error_SalesDocIsNotReleased, Format(SalesHeader."Document Type"), SalesHeader."No.");
    end;

    // function FindPriceAndDiscount changes table 1003
    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnBeforeRetrieveCostPrice', '', false, false)]
    local procedure SubToOnBeforeRetrieveCostPriceEvt(VAR JobPlanningLine: Record "Job Planning Line"; xJobPlanningLine: Record "Job Planning Line"; VAR ShouldRetrieveCostPrice: Boolean; VAR IsHandled: Boolean)
    begin
        if gRepricingMode then
            ShouldRetrieveCostPrice := TRUE;
    end;

    procedure SetRepricingMode()
    begin
        // 10.4.14 SCS1.00 CBO +++
        gRepricingMode := true;
        // 10.4.14 SCS1.00 CBO ---
    end;

}

