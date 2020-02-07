pageextension 50004 "SCSJIF Resource Commision Data" extends "Resource Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field(DefaultWorkTypeCode; "Default Work Type Code")
            {
                ApplicationArea = All;
            }
            field(DefaultWorkTypeCodeInt; "Default Work Type Code Int.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Personal Data")
        {
            group("Commission Data")
            {
                Caption = 'Commission Data';
                field("Base Salary"; "Base Salary")
                {
                    ApplicationArea = All;
                    CaptionML = DEU = 'Grundgehalt',
                                ENU = 'Base Salary';

                }
                field("Turnover Factor"; "Turnover Factor")
                {
                    ApplicationArea = All;
                    CaptionML = DEU = 'Faktor für Mindestumsatz',
                                ENU = 'Turnover Factor';

                }
                field("Commission Percentage"; "Commission Percentage")
                {
                    ApplicationArea = All;
                    CaptionML = DEU = 'Prozentsatz Provision',
                                ENU = 'Commission Percentage';

                }
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Resource - Cost Breakdown")
        {
            action(ResourceCommissionStatement)
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "SCSJIFRes Commission Statement";
                CaptionML = DEU = 'Provisionsabrechnung',
                            ENU = 'Resource Commission Statement';
            }
        }
    }

    var
        myInt: Integer;
}