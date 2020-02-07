pageextension 50007 "SCSJIF Job Task Lines" extends "Job Task Lines"
{

    layout
    {
        // Add changes to page layout here
        addafter("Contract (Invoiced Price)")
        {
            field("Available Value (Total Price)"; AvailableValueTotalPrice)
            {
                ApplicationArea = All;
                BlankZero = true;
                CaptionML = DEU = 'Verfügbar (VK)',
                                ENU = 'Available Value (Total Price)';
                Description = 'SCS1.00';
                Editable = false;
                StyleExpr = ConsumedPercentageTotalPriceStyle;
            }
            field("Amount held from Invoicing"; "Amount held from Invoicing")
            {
                ApplicationArea = All;
                BlankZero = true;
            }
            field(ConsumedPercentageTotalPrice; ConsumedPercentageTotalPrice)
            {
                ApplicationArea = All;
                BlankZero = true;
                CaptionML = DEU = '% Verbraucht (VK)',
                                ENU = '% Consumed (Total Price)';

                Editable = false;
                StyleExpr = ConsumedPercentageTotalPriceStyle;
            }
        }
        addlast(Control1)
        {
            field(TotalQtyContrDInTempo; "Total Qty. Contr'd (in Tempo)")
            {
                ApplicationArea = All;

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord()
    begin
        if "Schedule (Total Price)" > 0 then begin
            AvailableValueTotalPrice := "Schedule (Total Price)" - "Contract (Total Price)";
            ConsumedPercentageTotalPrice := 100 - AvailableValueTotalPrice / "Schedule (Total Price)" * 100;

            case ConsumedPercentageTotalPrice of
                90 .. 100:
                    ConsumedPercentageTotalPriceStyle := 'Ambigous';

                100 .. 9999999999.0:
                    ConsumedPercentageTotalPriceStyle := 'Unfavorable';
                else
                    ConsumedPercentageTotalPriceStyle := 'Standard';
            end;

        end else begin
            AvailableValueTotalPrice := 0;
            ConsumedPercentageTotalPrice := 0;
            ConsumedPercentageTotalPriceStyle := 'Standard';
        end;
    end;

    var
        AvailableValueTotalPrice: Decimal;
        ConsumedPercentageTotalPrice: Decimal;
        ConsumedPercentageTotalPriceStyle: Text;
}