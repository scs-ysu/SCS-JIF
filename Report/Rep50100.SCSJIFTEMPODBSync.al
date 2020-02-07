report 50100 "SCSJIFTEMPO - DB Sync"
{
    // version SCS1.00

    ProcessingOnly = true;
    ShowPrintStatus = false;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'TEMPO - DB Sync';
    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "Bill-to Customer No.", "No.";
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Parameters)
                {
                    CaptionML = DEU = 'Parameter',
                                ENU = 'Parameters';
                    field(FromDate; FromDate)
                    {
                        CaptionML = DEU = 'Von Datum',
                                    ENU = 'From Date';
                        NotBlank = true;
                    }
                    field(ToDate; ToDate)
                    {
                        CaptionML = DEU = 'Bis Datum',
                                    ENU = 'To Date';
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
        FromDate := CalcDate('-LM-1M', WorkDate);
        ToDate := WorkDate;
    end;

    trigger OnPreReport()
    var
        TempoIntegrationController: Codeunit "SCSJIFTEMPO Int. - Controller";
    begin
        TempoIntegrationController.RunSyncProcess(Job.GetFilter("Bill-to Customer No.")
                                                                                            , Job.GetFilter("No.")
                                                                                            , FromDate
                                                                                            , ToDate);
        CurrReport.Quit;
    end;

    var
        Customer: Code[20];
        FromDate: Date;
        ToDate: Date;
}

