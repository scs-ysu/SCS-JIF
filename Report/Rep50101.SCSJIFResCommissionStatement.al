report 50101 "SCSJIFRes Commission Statement"
{

    Caption = 'Resource Commission Statement';
    DefaultLayout = RDLC;
    RDLCLayout = './ResourceCommissionStatement.rdl';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Resource; Resource)
        {
            RequestFilterFields = "No.";
            column(Name; Resource.Name)
            {
            }
            column(BaseSalary; Resource."Base Salary")
            {
            }
            column(TurnoverFactor; Resource."Turnover Factor")
            {
            }
            column(CommissionPercentage; Resource."Commission Percentage")
            {
            }
            column(Period; Period)
            {
            }
            column(Turnover; Turnover)
            {
            }
            column(MinimumTurnover; MinimumTurnover)
            {
            }
            column(BaseAmount; BaseAmount)
            {
            }
            column(CommissionAmount; CommissionAmount)
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CurrencyText; CurrencyText)
            {
            }
            column(PrintDate; PrintDate)
            {
            }
            column(DocumentHeader; DocumentHeader)
            {
            }
            column(EmployeeLbl; EmployeeLbl)
            {
            }
            column(PeriodLbl; PeriodLbl)
            {
            }
            column(BaseSalaryLbl; BaseSalaryLbl)
            {
            }
            column(TurnoverLbl; TurnoverLbl)
            {
            }
            column(MinimumTurnoverLbl; MinimumTurnoverLbl)
            {
            }
            column(BaseAmountLbl; BaseAmountLbl)
            {
            }
            column(CommissionAmountLbl; CommissionAmountLbl)
            {
            }
            column(TurnoverText; TurnoverText)
            {
            }
            column(MinimumTurnoverTxt; MinimumTurnoverTxt)
            {
            }
            column(BaseAmountText; BaseAmountText)
            {
            }
            column(CommissionAmountTxt; CommissionAmountTxt)
            {
            }
            column(TextLine3; TextLine3)
            {
            }
            column(EmployeeLine; EmployeeLine)
            {
            }
            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemLink = "No." = field("No.");

                trigger OnAfterGetRecord()
                begin
                    Turnover += "Line Amount (LCY)";
                end;

                trigger OnPostDataItem()
                begin
                    BaseAmount := Turnover - MinimumTurnover;
                    CommissionAmount := (BaseAmount * Resource."Commission Percentage") / 100;
                end;

                trigger OnPreDataItem()
                begin
                    SetCurrentKey(Type, "No.");
                    SetRange(Type, Type::Resource);
                    SetRange("Planning Date", PeriodStart, PeriodEnd);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Period := Format(PeriodStart, 0, '<Month Text> <Year4>');
                PrintDate := Today;

                Turnover := 0;
                MinimumTurnover := 0;
                BaseAmount := 0;
                CommissionAmount := 0;

                MinimumTurnover := "Base Salary" * "Turnover Factor";

                MinimumTurnoverTxt := StrSubstNo(MinimumTurnoverText, "Turnover Factor");
                CommissionAmountTxt := StrSubstNo(CommissionAmountText, "Commission Percentage");
            end;
        }
    }

    requestpage
    {

        CaptionML = DEU = 'Provisionsabrechnung',
                    ENU = 'Commssion Statement';
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PeriodStart; PeriodStart)
                    {
                        CaptionML = DEU = 'Von Datum',
                                    ENU = 'Period Start';
                    }
                    field(PeriodEnd; PeriodEnd)
                    {
                        CaptionML = DEU = 'Bis Datum',
                                    ENU = 'Period End';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        GLSetup.TestField("LCY Code");
        CurrencyText := StrSubstNo(GLSetup."LCY Code");

        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        FormatAddr.Company(CompanyAddr, CompanyInfo);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        PeriodStart: Date;
        PeriodEnd: Date;
        Period: Text[20];
        CompanyAddr: array[8] of Text[50];
        CurrencyText: Text[3];
        MinimumTurnover: Decimal;
        BaseAmount: Decimal;
        CommissionAmount: Decimal;
        Turnover: Decimal;
        PrintDate: Date;
        DocumentHeader: TextConst DEU = 'Provisionsabrechnung', ENU = 'Commission Statement';
        EmployeeLbl: TextConst DEU = 'Mitarbeiter:', ENU = 'Employee:';
        PeriodLbl: TextConst DEU = 'Zeitraum:', ENU = 'Period:';
        BaseSalaryLbl: TextConst DEU = 'Grundgehalt:', ENU = 'Base Salary:';
        TurnoverLbl: TextConst DEU = 'Umsatz:', ENU = 'Turnover:';
        MinimumTurnoverLbl: TextConst DEU = 'Mindestumsatz:', ENU = 'Minimum Turnover:';
        BaseAmountLbl: TextConst DEU = 'Basisbetrag:', ENU = 'Base Amount:';
        CommissionAmountLbl: TextConst DEU = 'Provision:', ENU = 'Commission Amount:';
        TurnoverText: TextConst DEU = '(vom Mitarbeiter persönlich erzielter Umsatz)', ENU = '(personally by employee achieved turnover)';
        MinimumTurnoverText: TextConst DEU = '(Grundgehalt * %1)', ENU = '(base salary * %1)';
        BaseAmountText: TextConst DEU = '(Umsatz - Mindestumsatz)', ENU = '(turnover - minimum turnover)';
        CommissionAmountText: TextConst DEU = '(%1 % vom Basisbetrag)', ENU = '(%1 % of base amount)';
        TextLine3: Label 'Der Provisionsbetrag wird mit der nächstmöglichen Gehaltsabrechnung ausgezahlt.';
        EmployeeLine: TextConst DEU = 'Mitarbeiter', ENU = 'Employee';
        MinimumTurnoverTxt: Text;
        CommissionAmountTxt: Text;
        TextLine2Txt: Text;
}

