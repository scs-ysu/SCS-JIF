codeunit 50101 "SCSJIFTEMPO Int. - Controller"
{

    SingleInstance = true;
    TableNo = "Name/Value Buffer";

    trigger OnRun()
    begin
        //
        // distribute functions from recursive call by RunSyncProcess
        //
        // Note: this is a single instance CU, information is made persistent and shared among recursions using global variables (esp. temporary tables)

        case Name of
            'LOAD TEMPO-ACCOUNTS':
                gTempoIntegration.LoadTempoAccounts(gTempTempoAccounts, gCustomerFilter, gJobFilter);

            'LOAD TEMPO-WORKLOGS':
                gTempoIntegration.LoadTempoWorkLogs(gTempTempoAccounts, gTempTempoWorklogs, gTempTempoCustomFields, gCustomerFilter, gJobFilter, gFromDate, gToDate);

            'UPDATE NAV':
                // special handling due to next level recursive call
                UpdateNAV(gCustomerFilter, gJobFilter);

            'UPDATE NAV-JOB':
                // called from UpdateNav()
                gTempoIntegration.UpdateNAVJob(gCurrTempoAccounts, gFromDate, gToDate);

            'UPDATE NAV-JOB-PLANNING-LINE':
                // called from UpdateNav()
                gTempoIntegration.UpdateNAVJobPlanningLine(gCurrTempoAccounts, gCurrTempoWorklogs, gTempTempoCustomFields);

            'POST-PROCESS NAV-JOB':
                // called from UpdateNav()
                gTempoIntegration.PostprocessNavJob(gCurrTempoAccounts, gFromDate, gToDate);

        end;
    end;

    var
        gTempTempoAccounts: Record "SCSJIFJIRA/Tempo-Accounts work" temporary;
        gCurrTempoAccounts: Record "SCSJIFJIRA/Tempo-Accounts work";
        gTempTempoWorklogs: Record "SCSJIFJIRA/Tempo-Worklogs work" temporary;
        gCurrTempoWorklogs: Record "SCSJIFJIRA/Tempo-Worklogs work";
        TxtErrOnWorkLogLvl: Label 'Error occured on Work Log level.';
        TxtSyncErr: Label 'NAV <-> Jira synchronization failed. Action: "%1". Error message: %2';
        TxtDsplPrjInErr: Label 'NAV <-> Jira synchronization failed for some projects. Do you want to display projects in error?';
        gTempTempoCustomFields: Record "SCSJIFJIRA/Tempo-Wrklgs,Cstfld" temporary;
        gCustomerFilter: Text;
        gJobFilter: Text;
        gFromDate: Date;
        gToDate: Date;
        gTempLog: Record "SCSJIFJIRA/Tempo-Sync Log file" temporary;
        gTempoIntegration: Codeunit "SCSJIF TEMPO Integration";
        TxtSyncStarted: TextConst DEU = 'Tempo Sync started. Filter values are: Customer=%1, Account (job)=%2, Date range=%3..%4.', ENU = 'Tempo Sync started. Filter values are: Customer=%1, Account (job)=%2, Date range=%3..%4.';
        TxtSyncEnded: TextConst DEU = 'Tempo Sync ended.', ENU = 'Tempo Sync ended.';
        TxtTempoAccountsFilter: TextConst DEU = 'Tempo Accounts are filtered to: %1.', ENU = 'Tempo Accounts are filtered to: %1.';
        gProgressWindow: Dialog;
        TxtProgressWindow: Label 'Synchronizing...\\Phase: #1######################################################################################################\\Customer #2####################\\Account: #3####################''';

    procedure RunSyncProcess(pCustomerFilter: Text; pJobFilter: Text; pFromDate: Date; pToDate: Date)
    var
        ParmFunction: Record "Name/Value Buffer";
        TempoAccountsInError: Record "SCSJIFJIRA/Tempo-Accounts work";
        TempoIntegrationSetup: Record "SCSJIFJIRA/Tempo-Setup";
    begin
        //
        // load data from JIRA/TEMPO and update to NAV jobs, tasks, and planning lines
        //
        // executed e.g. from selection - report
        OpenProgressWindow;

        TempoIntegrationSetup.Get;
        if TempoIntegrationSetup."Clear Log Before Sync-Start" then begin
            ClearLog;
            Commit;
        end;

        gCustomerFilter := pCustomerFilter;
        gJobFilter := pJobFilter;
        gFromDate := pFromDate;
        gToDate := pToDate;
        Log(gTempLog.Severity::Info, StrSubstNo(TxtSyncStarted, gCustomerFilter, gJobFilter, gFromDate, gToDate));

        ClearTempTables;

        // recursively call ourself (OnRun()) in order to catch processing errors

        ParmFunction.Name := 'LOAD TEMPO-ACCOUNTS';
        if not Codeunit.Run(Codeunit::"SCSJIFTEMPO Int. - Controller", ParmFunction) then begin
            EndInError(StrSubstNo(TxtSyncErr, ParmFunction.Name, GetLastErrorText));
        end;

        ParmFunction.Name := 'LOAD TEMPO-WORKLOGS';
        if not Codeunit.Run(Codeunit::"SCSJIFTEMPO Int. - Controller", ParmFunction) then begin
            EndInError(StrSubstNo(TxtSyncErr, ParmFunction.Name, GetLastErrorText));
        end;

        ParmFunction.Name := 'UPDATE NAV';
        if not Codeunit.Run(Codeunit::"SCSJIFTEMPO Int. - Controller", ParmFunction) then begin
            EndInError(StrSubstNo(TxtSyncErr, ParmFunction.Name, GetLastErrorText));
        end;

        Log(gTempLog.Severity::Info, TxtSyncEnded);
        FlushLog();
        Commit;

        CloseProgressWindow;

        if GuiAllowed then
            if not TempoAccountsInError.IsEmpty then
                if Confirm(TxtDsplPrjInErr) then
                    Page.Run(Page::"SCSJIFJIRA/Tempo-Accounts work");
    end;

    local procedure UpdateNAV(pCustomerFilter: Text; pJobFilter: Text)
    var
        ParmFunction: Record "Name/Value Buffer";
        JiraIntegration: Codeunit "SCSJIF TEMPO Integration";
    begin
        //
        // Handle Job-wise update via additional recursive call (to be able to catch errors and continue with next account/job)
        //
        gTempTempoAccounts.Reset;
        if pCustomerFilter <> '' then
            gTempTempoAccounts.SetFilter("Customer No.", pCustomerFilter);

        if pJobFilter <> '' then
            gTempTempoAccounts.SetFilter("Job No.", pJobFilter);

        Log(gTempLog.Severity::Debug, StrSubstNo(TxtTempoAccountsFilter, gTempTempoAccounts.GetFilters));

        if gTempTempoAccounts.FindSet then
            repeat

                gCurrTempoAccounts := gTempTempoAccounts;
                ParmFunction.Name := 'UPDATE NAV-JOB';
                if not Codeunit.Run(Codeunit::"SCSJIFTEMPO Int. - Controller", ParmFunction) then
                    // error during job update
                    gTempoIntegration.SetAccountInError(gCurrTempoAccounts, GetLastErrorText)

                else
                    if gCurrTempoAccounts."JIRA/Tempo Status" = gCurrTempoAccounts."JIRA/Tempo Status"::Open then begin
                        // job update was successful and account is open in Tempo
                        ParmFunction.Name := 'UPDATE NAV-JOB-PLANNING-LINE';

                        // limit processing to current job only
                        gTempTempoWorklogs.Reset;
                        gTempTempoWorklogs.SetRange("TEMPO Account ID", gCurrTempoAccounts."JIRA/Tempo Account ID");
                        if gTempTempoWorklogs.FindSet then
                            repeat

                                //
                                gCurrTempoWorklogs := gTempTempoWorklogs;
                                if not Codeunit.Run(Codeunit::"SCSJIFTEMPO Int. - Controller", ParmFunction) then begin
                                    // error during update of job planning lines
                                    gTempoIntegration.SetAccountInError(gCurrTempoAccounts, TxtErrOnWorkLogLvl);
                                    gTempoIntegration.SetWorkLogInError(gCurrTempoWorklogs, GetLastErrorText);
                                end;

                                gTempTempoWorklogs.Delete;

                            until gTempTempoWorklogs.Next = 0;

                        // perform job post-processing
                        ParmFunction.Name := 'POST-PROCESS NAV-JOB';
                        if not Codeunit.Run(Codeunit::"SCSJIFTEMPO Int. - Controller", ParmFunction) then
                            // error during job Post-processing
                            gTempoIntegration.SetAccountInError(gCurrTempoAccounts, GetLastErrorText)

                    end;

                gTempTempoAccounts.Delete;

            until gTempTempoAccounts.Next = 0;
    end;

    procedure ClearTempTables()
    begin
        gTempTempoAccounts.Reset;
        gTempTempoAccounts.DeleteAll;

        gTempTempoWorklogs.Reset;
        gTempTempoWorklogs.DeleteAll;

        gTempTempoCustomFields.Reset;
        gTempTempoCustomFields.DeleteAll;
    end;

    procedure EndInError(Message: Text)
    begin
        Log(gTempLog.Severity::Error, Message);
        FlushLog();
        Commit;

        CloseProgressWindow;
        Error(Message);
    end;

    procedure Log(Severity: Option; Message: Text)
    var
        Log: Record "SCSJIFJIRA/Tempo-Sync Log file";
        i: Integer;
        NextId: Integer;
    begin

        gTempLog.Init;
        NextId := GetNextLogId(gTempLog);

        gTempLog."Log Timestamp" := CurrentDateTime;
        gTempLog.Severity := Severity;

        i := 1;

        while i <= StrLen(Message) do begin

            gTempLog.Message := CopyStr(Message, i, MaxStrLen(gTempLog.Message));
            gTempLog.Id := NextId;
            NextId += 1;

            gTempLog.Insert;

            i += MaxStrLen(gTempLog.Message);
        end;
    end;

    procedure FlushLog()
    var
        Log: Record "SCSJIFJIRA/Tempo-Sync Log file";
        NextId: Integer;
    begin
        if not gTempLog.FindSet then exit;

        NextId := GetNextLogId(Log);

        repeat
            Log.Copy(gTempLog);
            Log.Id := NextId;
            NextId += 1;
            Log.Insert;

        until gTempLog.Next() = 0;

        gTempLog.DeleteAll; // single instance CU
    end;

    procedure GetNextLogId(var Log: Record "SCSJIFJIRA/Tempo-Sync Log file"): Integer
    begin
        if Log.FindLast then
            exit(Log.Id + 1)
        else
            exit(1);
    end;

    procedure ClearLog()
    var
        Log: Record "SCSJIFJIRA/Tempo-Sync Log file";
    begin
        Log.DeleteAll;
    end;

    procedure OpenProgressWindow()
    begin
        if not GuiAllowed then
            exit;

        gProgressWindow.Open(TxtProgressWindow);
    end;

    procedure UpdateProgressWindowPhase(Phase: Text[100])
    begin
        if not GuiAllowed then
            exit;

        gProgressWindow.Update(1, Phase);
        gProgressWindow.Update(2, '');
        gProgressWindow.Update(3, '');
    end;

    procedure UpdateProgressWindow(Customer: Text[20]; Account: Text[20])
    begin
        if not GuiAllowed then
            exit;

        gProgressWindow.Update(2, Customer);
        gProgressWindow.Update(3, Account);
    end;

    procedure CloseProgressWindow()
    begin
        if not GuiAllowed then
            exit;

        gProgressWindow.Close;
    end;
}

