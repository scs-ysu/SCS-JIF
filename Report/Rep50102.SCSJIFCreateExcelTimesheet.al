report 50102 "SCSJIFCreate Excel Timesheet"
{
    // version SCS1.00

    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Create Excel Timesheet';
    dataset
    {
        dataitem("Job Planning Line"; "Job Planning Line")
        {
            DataItemTableView = sorting("Job No.", "Job Task No.", "Planning Date");
            RequestFilterFields = "Bill-to Customer No.", "Job Posting Group";
        }
    }

    requestpage
    {

        SaveValues = true;
        SourceTable = "Job Planning Line";

        layout
        {
            area(content)
            {
                field(DateRange; gDateRange)
                {
                    CaptionML = DEU = 'Datumsbereich',
                                ENU = 'Date Range';
                    OptionCaptionML = DEU = 'Nur Vormonat,Dieses Jahr,Dieses Jahr bis Vormonat,Dieses Jahr bis Vorwoche,Manuell',
                                      ENU = 'Previous Month only,Year to Date,Year to Previous Month,Year to Previous Week,Manual';

                    trigger OnValidate()
                    begin
                        SetPlanningDateFilter;
                    end;
                }
                field(PlanningDateFilter; gPlanningDateFilter)
                {
                    CaptionML = DEU = 'Planungsdatum',
                                ENU = 'Planning Date';

                    trigger OnValidate()
                    begin
                        SetPlanningDateFilter;
                    end;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            SetPlanningDateFilter;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        Customer: Record Customer;
        ExcelAppClass: DotNet Application_Class;
        ExcelApp: DotNet Application;
        NullObject: DotNet Type;
        Workbooks: DotNet Workbooks;
        Workbook: DotNet Work_book;
        ExcelBuffer: Record "Excel Buffer";
        DotNetMissing: DotNet Type;
        Missing: DotNet Type;
        FromDate: Text;
        ToDate: Text;
    begin

        SetPlanningDateFilter;

        FromDate := Format("Job Planning Line".GetRangeMin("Planning Date"), 0, 9);
        ToDate := Format("Job Planning Line".GetRangeMax("Planning Date"), 0, 9);

        if (FromDate = Format(0D, 0, 9)) or (ToDate < FromDate) then
            Error(TxtDateRangeInvalid, FromDate, ToDate);

        Customer.Get("Job Planning Line".GetFilter("Bill-to Customer No."));

        Customer.TestField("Template Workbook");
        Customer.TestField("Target Folder");
        Customer.TestField("Filename Template");

        TemplateFilename := Customer."Template Workbook";
        SaveToFolder := Customer."Target Folder";
        FileNamePattern := Customer."Filename Template";

        Missing := DotNetMissing;

        ExcelApp := ExcelAppClass.ApplicationClass;
        ExcelApp.Visible := true;

        Workbooks := ExcelApp.Workbooks;
        Workbook := Workbooks.Add(TemplateFilename);
        // Workbooks.Open(Filename, Missing,  Missing, Missing, Missing, Missing, Missing, Missing, Missing, Missing, Missing, Missing, Missing, Missing, Missing
        //);

        ExcelApp.Run('LoadData', "Job Planning Line".GetFilter("Bill-to Customer No."), Customer.Name
                                                            , FromDate, ToDate, "Job Planning Line".GetFilter("Job Posting Group")
                                                            , SaveToFolder, FileNamePattern
                                                            , Missing, Missing, Missing
                                                            , Missing, Missing, Missing, Missing, Missing, Missing, Missing, Missing, Missing, Missing
                                                            , Missing, Missing, Missing, Missing, Missing, Missing, Missing, Missing, Missing, Missing
                                );
    end;

    var
        TxtFileNamePatternHelp: Label 'You can use variables: &CUSTOMER, &CUSTOMER_NAME, &JOB_POSTING_GROUP, &FROM_DATE, &TO_DATE';
        TemplateFilename: Text;
        SaveToFolder: Text;
        FileNamePattern: Text;
        gDateRange: Option "Previous Month only","Year to Date","Year to Previous Month","Year to Previous Week",Manual;
        gPlanningDateFilter: Text;
        TxtDateRangeInvalid: TextConst DEU = 'Datumsbereich %1 .. %2 ist ungültig.', ENU = 'Date range %1 .. %2 is invalid.';

    local procedure SetPlanningDateFilter()
    var
        SelectFromDate: Date;
        SelectToDate: Date;
    begin

        case gDateRange of

            gDateRange::"Previous Month only":
                begin
                    SelectFromDate := CalcDate('-LM-1M', WorkDate);
                    SelectToDate := CalcDate('+1M-1T', SelectFromDate);
                    "Job Planning Line".SetRange("Planning Date", SelectFromDate, SelectToDate);
                    gPlanningDateFilter := "Job Planning Line".GetFilter("Planning Date");
                end;

            gDateRange::"Year to Date":
                begin
                    SelectFromDate := CalcDate('-LJ', WorkDate);
                    SelectToDate := WorkDate;
                    "Job Planning Line".SetRange("Planning Date", SelectFromDate, SelectToDate);
                    gPlanningDateFilter := "Job Planning Line".GetFilter("Planning Date");
                end;

            gDateRange::"Year to Previous Month":
                begin
                    SelectFromDate := CalcDate('-LJ', WorkDate);
                    SelectToDate := CalcDate('-LM-1M', WorkDate);
                    SelectToDate := CalcDate('+1M-1T', SelectToDate);
                    "Job Planning Line".SetRange("Planning Date", SelectFromDate, SelectToDate);
                    gPlanningDateFilter := "Job Planning Line".GetFilter("Planning Date");
                end;

            gDateRange::"Year to Previous Week":
                begin
                    SelectFromDate := CalcDate('-LJ', WorkDate);
                    SelectToDate := CalcDate('LW-1W', WorkDate);
                    "Job Planning Line".SetRange("Planning Date", SelectFromDate, SelectToDate);
                    gPlanningDateFilter := "Job Planning Line".GetFilter("Planning Date");
                end;

            else
                "Job Planning Line".SetFilter("Planning Date", gPlanningDateFilter);
        end;
    end;
}

