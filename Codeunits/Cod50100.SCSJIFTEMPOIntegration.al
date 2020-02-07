codeunit 50100 "SCSJIF TEMPO Integration"
{
    // version SCS1.00,TEMP FIX due to Tempo issue

    trigger OnRun()
    begin
    end;

    var
        xmlResponse: DotNet DOMDocumentClass;
        FileMgt: Codeunit "File Management";
        ServerFile: DotNet File;
        TxtAccountMissing: TextConst DEU = 'Tempo Account key is empty.', ENU = 'Jira Account key is missing.';
        TxtTempoCustMissing: TextConst DEU = 'Tempo Customer is empty.', ENU = 'Jira Customer is missing.';
        TxtTempoRespPersonMissing: TextConst DEU = 'Tempo Responsible Person is empty.', ENU = 'Jira Responsible Person is missing.';
        TxtNAVJobTskMissing: TextConst DEU = 'NAV Job Task is missing.', ENU = 'Job Task is missing.';
        TxtNAVJobNotExist: TextConst DEU = 'NAV Job "%1" does not exist.', ENU = 'Job "%1" does not exist.';
        TxtNAVJobTskNotExist: TextConst DEU = 'NAV Job Task "%2" does not exist for Job "%1".', ENU = 'Job Task "%2" does not exist for Job "%1".';
        TxtDOMParseError: Label 'Illegal XML response received from TEMPO-Servlet. Parse error details: %1: %2 in line %3, position %4, file position %5. Try URL in browser: %6';
        TxtParseError: TextConst DEU = 'Illegal XML response received from TEMPO-Servlet. Try URL in browser: %1', ENU = 'Illegal XML response received from TEMPO-Servlet. Try URL in browser: %1';
        TxtSendRequestError: TextConst DEU = 'Send request ended with error code %1, description %2.', ENU = 'Send request ended with error code %1, description %2.';
        TxtAccountSynched: TextConst DEU = 'Tempo account %2 for customer %1 passed the filter, adding to accounts workfile. ', ENU = 'Tempo account %2 for customer %1 passed the filter, adding to accounts workfile. ';
        gLog: Record "SCSJIFJIRA/Tempo-Snyc Log file";
        TxtGETtingURL: TextConst DEU = 'Getting URL: %1', ENU = 'Getting URL: %1';
        TxtLoadingTempoAccounts: TextConst DEU = 'Loading Tempo accounts to workfile...', ENU = 'Loading Tempo accounts to workfile...';
        TxtLoadingTempoWorklogs: TextConst DEU = 'Loading Tempo worklogs to workfile...', ENU = 'Loading Tempo worklogs to workfile...';
        TxtTempoAccountsFilter: TextConst DEU = 'Tempo Accounts are filtered to: %1.', ENU = 'Tempo Accounts are filtered to: %1.';
        TxtCustomersFilterAndKey: Label 'Customers are filtered to: %1. Current key is: %2.';
        TxtJobFilter: Label 'Jobs are filtered to: %1';
        TxtNodesReceived: TextConst DEU = '%1 detail nodes received.', ENU = '%1 detail nodes received.';
        TxtUpdatingJobs: TextConst DEU = 'Updating Accounts -> Jobs...', ENU = 'Updating Accounts -> Jobs...';
        TxtUpdatingJobTaskLine: TextConst DEU = 'Updating Worklog -> Job Task Line...', ENU = 'Updating Worklog -> Job Task Line...';
        TxtUpdatingJobPlanningLines: TextConst DEU = 'Updating Worklogs -> Job Planning Lines (contract)...', ENU = 'Updating Worklogs -> Job Planning Lines (contract)...';
        TxtWorkLogAlreadyAssigned: TextConst DEU = 'Worklog %1 for %2 already assigned to planning line %3/%4/%5. Updating.', ENU = 'Worklog %1 for %2 already assigned to planning line %3/%4/%5. Updating.';
        TxtWorkLogNotYetAssigned: TextConst DEU = 'Worklog %1 for %2 not yet assigned to any line.', ENU = 'Worklog %1 for %2 not yet assigned to any line.';
        TxtWorkLogAssignedMultiple: TextConst DEU = 'Worklog %1 for %2 assigned to multiple planning lines.', ENU = 'Worklog %1 for %2 assigned to multiple planning lines.';
        TxtJobTaskAdded: TextConst DEU = 'Task %2 (%3) has been added to job %1.', ENU = 'Task %2 (%3) has been added to job %1.';
        TxtJobTaskFoundByIssue: TextConst DEU = 'Task %1/%2 (%3) found for issue %4. Adopting.', ENU = 'Task %1/%2 (%3) found for issue %4. Adopting.';
        TxtNAVJobTskIDNotFound: Label 'No Job Task ID could be found. Check Setup.';
        TxtWorkLogAssigned: TextConst DEU = 'Worklog %1 for %2 assigned to planning line %3/%4/%5.', ENU = 'Worklog %1 for %2 assigned to planning line %3/%4/%5.';
        TxtPlanningLinesResetFilter: TextConst DEU = 'Resetting Planning Lines. Filtered to: %1', ENU = 'Resetting Planning Lines. Filtered to: %1';
        TxtPlanningLinesDeleteFilter: Label 'Deleting orphaned Planning Lines (deleted or reassigned in Tempo). Filtered to: %1';
        TxtJobPlanningLineAlreadyInvoiced: TextConst DEU = 'Worklog %1 for %2 already assigned to planning line %3/%4/%5. Values were changed in Tempo but  line is already invoiced. Update NOT possible.', ENU = 'Worklog %1 for %2 already assigned to planning line %3/%4/%5. Values were changed in Tempo but  line is already invoiced. Update NOT possible.';
        TxtWorkLogNotChanged: TextConst DEU = 'Worklog %1 for %2 already assigned to planning line %3/%4/%5. Values were not changed in Tempo, update skipped.', ENU = 'Worklog %1 for %2 already assigned to planning line %3/%4/%5. Values were not changed in Tempo, update skipped.';
        TxtMovedToOtherAccount: Label 'Worklog %1 for %2 was previously assigned to planning line %3/%4/%5. Issue has been assigned to a different account in Tempo. Planning Line has been deleted.';
        TxtAccountNotSelected: Label 'Account %1 is not inside filters and has been ignored.';
        gTempoIntegrationController: Codeunit "SCSJIFTEMPO Int. - Controller";
        TxtPostprocessingJob: Label 'Post-processing Job...';
        TxtMultipleCustomers: Label 'Tempo Customer ID %1 is assigned to multiple customers.';
        TxtCustomFieldsNOTUpdated: Label 'Custom fields changed but update of Planning Line is not allowed. Changes were not applied.';
        TxtCustomFieldsUpdated: Label 'Custom fields were updated in Planning Line.';
        TxtCustomFieldUpdated: Label 'Field %1 has been changed from %2 to %3 due to custom field mapping.';
        TxtJobTaskNoChanged: Label 'Job Task number according to Tempo interface rules should be %2  instead of %1. Trying to reassign line...';
        TxtNowAssignedToJobTask: Label 'Line is now assiigned to task %1.';

    procedure GetNAVJobTasks(p_Str: Text[50]): Text
    var
        JobTask: Record "Job Task";
        JobTaskList: Text;
    begin
        // Used as web-service method to be called from Jira
        JobTask.SetRange("Job No.", p_Str);
        JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::Posting);
        if JobTask.FindSet then begin
            repeat
                JobTaskList := JobTaskList + '|' + JobTask."Job Task No." + '|' + JobTask.Description;
            until JobTask.Next = 0;
            //JobTaskList := CONVERTSTR(JobTaskList, '/', '%2F');
            exit(CopyStr(JobTaskList, 2));
        end;
        exit('');
    end;

    procedure LoadTempoAccounts(var pTempoAccount: Record "SCSJIFJIRA/Tempo-Accounts work"; pCustomerFilter: Text; pJobFilter: Text)
    var
        Job: Record Job;
        TempoSetup: Record "SCSJIFJIRA/Tempo-Setup";
        TempoServletUrl: Text;
        TempFileName: Text;
        xmlNodeList: DotNet IXMLDOMNodeList;
        xmlNode: DotNet IXMLDOMNode;
        NoNodes: Integer;
        i: Integer;
        valtxt: Text;
        httpRequest: DotNet XMLHTTPRequestClass;
        Customer: Record Customer;
        AccountSelected: Boolean;
    begin
        Log(gLog.Severity::Debug, TxtLoadingTempoAccounts);
        gTempoIntegrationController.UpdateProgressWindowPhase(TxtLoadingTempoAccounts);

        // filter customer setup according to customer filter
        Customer.Reset;
        if pCustomerFilter <> '' then
            // select only customers within filter
            Customer.SetFilter("No.", pCustomerFilter);

        Customer.SetCurrentKey("JIRA/Tempo Customer No.");

        Log(gLog.Severity::Debug, StrSubstNo(TxtCustomersFilterAndKey, Customer.GetFilters, Customer.CurrentKey));

        if pJobFilter <> '' then
            // select only jobs within filter
            Job.SetFilter("No.", pJobFilter);

        Log(gLog.Severity::Debug, StrSubstNo(TxtJobFilter, Job.GetFilters));

        // get global setup
        TempoSetup.Get;
        TempoSetup.TestField("Tempo Servlet Base URL");
        TempoSetup.TestField("Tempo Security Token");
        TempoSetup.TestField("Jira User for Sync");
        TempoSetup.TestField("Jira Password for Sync");

        // generate Tempo servlet URL
        TempoServletUrl := TempoSetup."Tempo Servlet Base URL" + 'plugins/servlet/tempo-billingKeyList/?tempoApiToken=' + TempoSetup."Tempo Security Token"
                                                    + '&os_username=' + TempoSetup."Jira User for Sync"
                                                    + '&os_password=' + TempoSetup."Jira Password for Sync"
                                                    ;

        Log(gLog.Severity::Debug, StrSubstNo(TxtGETtingURL, TempoServletUrl));

        // Create/Send HTTP request
        httpRequest := httpRequest.XMLHTTPRequestClass;
        httpRequest.Open('GET', TempoServletUrl, false, '', '');
        httpRequest.setRequestHeader('Content-Type', 'text/xml; utf-8');
        httpRequest.Send('');
        if httpRequest.status <> 200 then
            Log(gLog.Severity::Error, StrSubstNo(TxtSendRequestError, httpRequest.status, httpRequest.statusText));

        // Load the response stream
        TempFileName := FileMgt.ServerTempFileName('txt');
        ServerFile.WriteAllText(TempFileName, httpRequest.responseText);
        xmlResponse := xmlResponse.DOMDocumentClass;

        if not xmlResponse.load(TempFileName) then begin
            ServerFile.Delete(TempFileName);
            TempFileName := 'C:\temp\tempoerror.txt';
            ServerFile.WriteAllText(TempFileName, httpRequest.responseText);
            HandleXMLLoadError(TempoServletUrl);
        end
        else
            ServerFile.Delete(TempFileName);

        // Process the response XML
        xmlNodeList := xmlResponse.childNodes;
        NoNodes := xmlNodeList.Length - 1;
        for i := 0 to NoNodes do begin
            xmlNode := xmlNodeList.Item(i);
            case xmlNode.nodeName of
                'billing_keys':
                    begin
                        xmlNodeList := xmlNode.childNodes;
                        NoNodes := xmlNodeList.Length - 1;
                        for i := 0 to NoNodes do begin
                            xmlNode := xmlNodeList.Item(i);
                            with pTempoAccount do begin

                                Init;

                                "JIRA/Tempo Customer No." := GetAttributByName(xmlNode, 'client');

                                Customer.SetRange("JIRA/Tempo Customer No.", "JIRA/Tempo Customer No.");
                                case Customer.Count of
                                    0:
                                        begin
                                        end;

                                    1:
                                        begin
                                            // customer is within filter, check account (job)
                                            Customer.FindFirst;
                                            "JIRA/Tempo Account ID" := GetAttributByName(xmlNode, 'key');

                                            gTempoIntegrationController.UpdateProgressWindow("JIRA/Tempo Customer No.", "JIRA/Tempo Account ID");

                                            AccountSelected := false;

                                            if (pJobFilter = '') then begin
                                                // no filter, select all
                                                AccountSelected := true;
                                                // but provide a valid job id
                                                Job.Validate("No.", "JIRA/Tempo Account ID");
                                            end
                                            else begin
                                                Job.SetRange("JIRA/Tempo Account ID", "JIRA/Tempo Account ID");
                                                AccountSelected := Job.FindFirst;
                                                if not AccountSelected then begin
                                                    // retry with capitalized account id as key
                                                    Job.SetRange("JIRA/Tempo Account ID");
                                                    Validate("Job No.", "JIRA/Tempo Account ID");
                                                    Job.SetRange("No.", "Job No.");
                                                    AccountSelected := Job.FindFirst;
                                                end;

                                            end;

                                            if AccountSelected then begin
                                                // all filters passed, set remaining fields and save
                                                Log(gLog.Severity::Debug, StrSubstNo(TxtAccountSynched, "JIRA/Tempo Customer No.", "JIRA/Tempo Account ID"));

                                                "JIRA/Tempo Customer Name" := GetAttributByName(xmlNode, 'client_name');

                                                Description := GetAttributByName(xmlNode, 'name');
                                                "JIRA/Tempo Project Key List" := GetAttributByName(xmlNode, 'project_key_list');

                                                "Person Responsible" := GetAttributByName(xmlNode, 'responsable_initials');
                                                "Person Responsible Name" := GetAttributByName(xmlNode, 'responsable');
                                                "Project Owner" := GetAttributByName(xmlNode, 'project_owner');
                                                "Category Code" := GetAttributByName(xmlNode, 'category_code');
                                                "Category Description" := GetAttributByName(xmlNode, 'category');
                                                Evaluate("JIRA/Tempo Status", GetAttributByName(xmlNode, 'enabled'));

                                                // Store NAV customer and job number
                                                pTempoAccount."Customer No." := Customer."No.";
                                                pTempoAccount."Job No." := Job."No.";

                                                Insert

                                            end else
                                                Log(gLog.Severity::Debug, StrSubstNo(TxtAccountNotSelected, "JIRA/Tempo Account ID"));
                                        end;

                                    else
                                        // multiple customers match
                                        Log(gLog.Severity::Error, StrSubstNo(TxtMultipleCustomers, "JIRA/Tempo Customer No."));

                                end;
                            end;
                        end;
                    end;
            end;
        end;
    end;

    procedure LoadTempoWorkLogs(var pTempoAccounts: Record "SCSJIFJIRA/Tempo-Accounts work"; var pTempoWorklogs: Record "SCSJIFJIRA/Tempo-Worklogs work"; var pTempoCustomFields: Record "SCSJIFJIRA/Tempo-Wrklgs,Cstfld"; pCustomerFilter: Text; pJobFilter: Text; pFromDate: Date; pToDate: Date)
    var
        JiraSetup: Record "SCSJIFJIRA/Tempo-Setup";
        httpRequest: DotNet XMLHTTPRequestClass;
        Url: Text;
        TempFileName: Text;
        xmlNodeList1: DotNet IXMLDOMNodeList;
        xmlNodeList2: DotNet IXMLDOMNodeList;
        xmlNodeList3: DotNet IXMLDOMNodeList;
        xmlNodeList4: DotNet IXMLDOMNodeList;
        xmlNode1: DotNet IXMLDOMNode;
        xmlNode2: DotNet IXMLDOMNode;
        xmlNode3: DotNet IXMLDOMNode;
        xmlNode4: DotNet IXMLDOMNode;
        NoNodes1: Integer;
        NoNodes2: Integer;
        NoNodes3: Integer;
        NoNodes4: Integer;
        i: Integer;
        j: Integer;
        k: Integer;
        l: Integer;
        ValTxt: Text;
        Pos: Integer;
        TempoAccountInError: Record "SCSJIFJIRA/Tempo-Accounts work";
        TempoWorkLogInError: Record "SCSJIFJIRA/Tempo-Worklogs work";
        MemoText: BigText;
        OStream: OutStream;
        TempoWorkLog: Record "SCSJIFJIRA/Tempo-Worklogs work";
        WorkDescription: Text;
    begin
        Log(gLog.Severity::Debug, TxtLoadingTempoWorklogs);
        gTempoIntegrationController.UpdateProgressWindowPhase(TxtLoadingTempoWorklogs);

        // Initialization
        pTempoWorklogs.Reset;
        pTempoWorklogs.DeleteAll;

        JiraSetup.Get;
        JiraSetup.TestField("Tempo Servlet Base URL");
        JiraSetup.TestField("Tempo Security Token");
        JiraSetup.TestField("Jira User for Sync");
        JiraSetup.TestField("Jira Password for Sync");

        pTempoAccounts.Reset;
        pTempoAccounts.SetRange("JIRA/Tempo Status", pTempoAccounts."JIRA/Tempo Status"::Open);

        if pCustomerFilter <> '' then
            pTempoAccounts.SetFilter("Customer No.", pCustomerFilter);

        if pJobFilter <> '' then
            pTempoAccounts.SetFilter("Job No.", pJobFilter);

        Log(gLog.Severity::Debug, StrSubstNo(TxtTempoAccountsFilter, pTempoAccounts.GetFilters));

        if pTempoAccounts.FindSet then
            repeat

                gTempoIntegrationController.UpdateProgressWindow(pTempoAccounts."Customer No.", pTempoAccounts."Job No.");

                // remove old records in error from accounts work file
                TempoAccountInError.Reset;
                TempoAccountInError.SetRange("JIRA/Tempo Account ID", pTempoAccounts."JIRA/Tempo Account ID");
                TempoAccountInError.DeleteAll;

                // remove old records in error from worklog work file
                TempoWorkLogInError.Reset;
                TempoWorkLogInError.SetRange("TEMPO Account ID", pTempoAccounts."JIRA/Tempo Account ID");
                TempoWorkLogInError.DeleteAll;

                // Create/Send HTTP request
                Url := JiraSetup."Tempo Servlet Base URL" + 'plugins/servlet/tempo-getWorklog/'
                                                        + '?billingKey=' + pTempoAccounts."JIRA/Tempo Account ID"
                                                        + '&dateFrom=' + Format(pFromDate, 0, 9)
                                                        + '&dateTo=' + Format(pToDate, 0, 9)
                                                        + '&format=xml&diffOnly=false&addIssueSummary=true&addParentIssue=true'
                                                        + '&tempoApiToken=' + JiraSetup."Tempo Security Token"
                                                        + '&os_username=' + JiraSetup."Jira User for Sync"
                                                        + '&os_password=' + JiraSetup."Jira Password for Sync"
                                                        ;

                Log(gLog.Severity::Debug, StrSubstNo(TxtGETtingURL, Url));

                httpRequest := httpRequest.XMLHTTPRequestClass;
                httpRequest.Open('GET', Url, false, '', '');
                httpRequest.setRequestHeader('Content-Type', 'text/xml; utf-8');
                httpRequest.Send('');
                if httpRequest.status <> 200 then
                    Log(gLog.Severity::Error, StrSubstNo(TxtSendRequestError, httpRequest.status, httpRequest.statusText));

                // Load the response stream
                TempFileName := FileMgt.ServerTempFileName('txt');
                ServerFile.WriteAllText(TempFileName, httpRequest.responseText);
                xmlResponse := xmlResponse.DOMDocumentClass;

                if not xmlResponse.load(TempFileName) then begin
                    ServerFile.Delete(TempFileName);
                    HandleXMLLoadError(Url);
                end
                else
                    ServerFile.Delete(TempFileName);

                if not xmlResponse.parsed then
                    Log(gLog.Severity::Error, StrSubstNo(TxtParseError, Url));

                // Process the response XML
                with pTempoWorklogs do begin

                    xmlNodeList1 := xmlResponse.childNodes;
                    NoNodes1 := xmlNodeList1.Length - 1;

                    for i := 0 to NoNodes1 do begin

                        xmlNode1 := xmlNodeList1.Item(i);
                        case xmlNode1.nodeName of
                            'worklogs':
                                begin
                                    xmlNodeList2 := xmlNode1.childNodes;
                                    NoNodes2 := xmlNodeList2.Length;
                                    Log(gLog.Severity::Debug, StrSubstNo(TxtNodesReceived, NoNodes2));

                                    for j := 0 to NoNodes2 - 1 do begin

                                        xmlNode2 := xmlNodeList2.Item(j);
                                        case xmlNode2.nodeName of
                                            'worklog':
                                                begin
                                                    xmlNodeList3 := xmlNode2.childNodes;
                                                    NoNodes3 := xmlNodeList3.Length - 1;

                                                    Init;

                                                    for k := 0 to NoNodes3 do begin

                                                        xmlNode3 := xmlNodeList3.Item(k);
                                                        if "Work Log ID" <> '' then
                                                            // primary key is known, custom field mapping is possible
                                                            StoreCustomField(pTempoAccounts, pTempoCustomFields, "Work Log ID", xmlNode3.nodeName, CopyStr(xmlNode3.text, 1, 30));

                                                        case xmlNode3.nodeName of
                                                            'worklog_id':
                                                                "Work Log ID" := xmlNode3.text;
                                                            'issue_id':
                                                                "Issue ID" := xmlNode3.text;
                                                            'issue_key':
                                                                "Issue Key" := xmlNode3.text;
                                                            'hours':
                                                                "Worked Hours" := xmlNode3.text;
                                                            'billed_hours':
                                                                "Billed Hours" := xmlNode3.text;

                                                            'work_date':
                                                                "Work Date" := xmlNode3.text;
                                                            'work_date_time':
                                                                "Work DateTime" := xmlNode3.text;
                                                            'username':
                                                                User := xmlNode3.text;
                                                            'staff_id':
                                                                "Staff ID" := xmlNode3.text;
                                                            'billing_key':
                                                                "TEMPO Account ID" := xmlNode3.text;

                                                            'activity_id':
                                                                "Activity ID" := xmlNode3.text;
                                                            'activity_name':
                                                                "Activity Name" := xmlNode3.text;
                                                            'billing_attributes':
                                                                "Billing Attributes" := xmlNode3.text;
                                                            'work_description':
                                                                begin
                                                                    WorkDescription := EscapeCRLF(xmlNode3.text);
                                                                    "Work Description 1" := CopyStr(WorkDescription, 1, 250);
                                                                    "Work Description 2" := CopyStr(WorkDescription, 251, 250);
                                                                    "Work Description 3" := CopyStr(WorkDescription, 501, 250);
                                                                    "Work Description 4" := CopyStr(WorkDescription, 751, 250);
                                                                    "Work Description 5" := CopyStr(WorkDescription, 1001, 250);
                                                                    "Work Description 6" := CopyStr(WorkDescription, 1251, 250);
                                                                    "Work Description 7" := CopyStr(WorkDescription, 1501, 250);
                                                                    "Work Description 8" := CopyStr(WorkDescription, 1751, 250);

                                                                    //                            pTempoWorklogs."Work Description".CREATEOUTSTREAM(OStream);
                                                                    //                            OStream.WRITE(xmlNode3.text);
                                                                    //                            OStream.WRITE('chdcuhswuwuwuwuwuwuiucahisuchiuwqhciqwhuciqwhc');

                                                                end;
                                                            'parent_key':
                                                                "Parent Key" := xmlNode3.text;

                                                            'parent_issue':
                                                                begin
                                                                    xmlNodeList4 := xmlNode3.childNodes;
                                                                    NoNodes4 := xmlNodeList4.Length - 1;
                                                                    for l := 0 to NoNodes4 do begin
                                                                        xmlNode4 := xmlNodeList4.Item(l);
                                                                        case xmlNode4.nodeName of
                                                                            'issue_key':
                                                                                "Parent Issue Key" := xmlNode4.text;
                                                                            'issue_summary':
                                                                                "Parent Issue Summary" := xmlNode4.text;

                                                                        end;
                                                                    end;
                                                                end;

                                                            'reporter':
                                                                Reporter := xmlNode3.text;
                                                            'external_id':
                                                                "External ID" := xmlNode3.text;
                                                            'external_tstamp':
                                                                "External Timestamp" := xmlNode3.text;
                                                            'external_hours':
                                                                "External Hours" := xmlNode3.text;
                                                            'external_result':
                                                                "External Result" := xmlNode3.text;
                                                            'hash_value':
                                                                "Hash Value" := xmlNode3.text;
                                                            'issue_summary':
                                                                "Issue Summary" := xmlNode3.text;
                                                        end;
                                                    end;

                                                    Insert;

                                                    //                 TempoWorkLog := pTempoWorklogs;
                                                    //                 TempoWorkLog.INSERT;

                                                end;
                                        end;
                                    end;
                                end;
                        end;
                    end;
                end;

            until pTempoAccounts.Next = 0;
    end;

    procedure UpdateNAVJob(var pTempoAccount: Record "SCSJIFJIRA/Tempo-Accounts work"; pFromDate: Date; pToDate: Date)
    var
        Job: Record Job;
        JobTask: Record "Job Task";
        TempoAccountInError: Record "SCSJIFJIRA/Tempo-Accounts work";
        Changed: Boolean;
        JobExists: Boolean;
        ConfigTemplateHdr: Record "Config. Template Header";
        ConfigTemplateMgt: Codeunit "Config. Template Management";
        RecRef: RecordRef;
        Customer: Record Customer;
    begin
        Log(gLog.Severity::Debug, TxtUpdatingJobs);
        gTempoIntegrationController.UpdateProgressWindowPhase(TxtUpdatingJobs);
        gTempoIntegrationController.UpdateProgressWindow(pTempoAccount."JIRA/Tempo Customer No.", pTempoAccount."JIRA/Tempo Account ID");

        // Check required fields
        if pTempoAccount."JIRA/Tempo Account ID" = '' then
            Log(gLog.Severity::Error, TxtAccountMissing);

        if pTempoAccount."JIRA/Tempo Customer No." = '' then
            Log(gLog.Severity::Error, TxtTempoCustMissing);

        //IF pTempoAccount."Person Responsible" = '' THEN
        //  Log(gLog.Severity::Error, TxtTempoRespPersonMissing);

        JobExists := Job.Get(pTempoAccount."Job No.");

        if JobExists and (pTempoAccount."JIRA/Tempo Status" <> pTempoAccount."JIRA/Tempo Status"::Open) then begin
            // ==================================
            // Job is no longer open in Tempo
            // ==================================
            if Job."JIRA/Tempo Sync Status" <> Job."JIRA/Tempo Sync Status"::Closed then begin
                // set sync status
                Job."JIRA/Tempo Sync Status" := Job."JIRA/Tempo Sync Status"::Closed;
                Job.Modify;
            end;

        end
        else
            if JobExists then begin
                // ==================================
                // Update job
                // ==================================
                if Job.Description <> pTempoAccount.Description then begin
                    Job.Validate(Description, pTempoAccount.Description);
                end;

                if (pTempoAccount."Person Responsible" <> '') and (Job."Person Responsible" <> pTempoAccount."Person Responsible") then begin
                    Job.Validate("Person Responsible", pTempoAccount."Person Responsible");
                end;

                Job.Validate("JIRA/Tempo Sync Status", Job."JIRA/Tempo Sync Status"::Synchronized);
                Job.Validate("JIRA/Tempo Account ID", pTempoAccount."JIRA/Tempo Account ID"); // temporary

                Job.Modify(true);

                // set line status to "deleted" to indicate lines that were not adressed during this run
                ResetPlanningLinesStatus(Job, pFromDate, pToDate);

            end
            else
                if not JobExists and (pTempoAccount."JIRA/Tempo Status" = pTempoAccount."JIRA/Tempo Status"::Open) then begin
                    // ==================================
                    // create job
                    // ==================================
                    Job.Init;
                    Job.Validate("No.", pTempoAccount."JIRA/Tempo Account ID");
                    Job.Insert(true);
                    Job.Get(Job."No.");

                    // Apply template
                    GetCustomerByTempoID(pTempoAccount."JIRA/Tempo Customer No.", Customer);

                    Job.Validate("Bill-to Customer No.", Customer."No.");

                    // Apply configuration template
                    ConfigTemplateHdr.Get(Customer."Job Template Code");
                    ConfigTemplateHdr.TestField("Table ID", Database::Job);

                    RecRef.GetTable(Job);
                    ConfigTemplateMgt.UpdateRecord(ConfigTemplateHdr, RecRef);

                    Job.Validate(Description, pTempoAccount.Description);
                    Job.Validate("Person Responsible", pTempoAccount."Person Responsible");
                    Job.Validate("JIRA/Tempo Sync Status", Job."JIRA/Tempo Sync Status"::Synchronized);
                    Job.Validate("JIRA/Tempo Account ID", pTempoAccount."JIRA/Tempo Account ID");

                    Job.Modify(true);

                    //IF Customer."Auto-Create Job Task" = Customer."Auto-Create Job Task"::"For Dummy Task Only"  THEN
                    // add an automatic task line to the job
                    //  AddJobTask(Job, Customer, Customer."ID for Dummy Job Task", '');

                end;

        // Remove entry if project was in error
        if TempoAccountInError.Get(Job."No.") then
            TempoAccountInError.Delete;
    end;

    procedure PostprocessNavJob(var pTempoAccount: Record "SCSJIFJIRA/Tempo-Accounts work"; pFromDate: Date; pToDate: Date)
    var
        Job: Record Job;
    begin
        Log(gLog.Severity::Debug, TxtPostprocessingJob);
        gTempoIntegrationController.UpdateProgressWindowPhase(TxtPostprocessingJob);
        gTempoIntegrationController.UpdateProgressWindow(pTempoAccount."JIRA/Tempo Customer No.", pTempoAccount."JIRA/Tempo Account ID");

        Job.Get(pTempoAccount."Job No.");

        // delete all lines that have been removed in Tempo
        DeleteOrphanedPlanningLines(Job, pFromDate, pToDate);
    end;

    procedure ResetPlanningLinesStatus(var pJob: Record Job; pFromDate: Date; pToDate: Date)
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        with JobPlanningLine do begin

            Reset;
            SetRange("Job No.", pJob."No.");
            SetRange("Line Type", "Line Type"::Billable);
            SetFilter("Tempo Worklog Id", '<>%1', '0');
            SetFilter("Planning Date", '%1..%2', pFromDate, pToDate);
            SetRange("JIRA/Tempo Sync Status", "JIRA/Tempo Sync Status"::"In Sync");

            Log(gLog.Severity::Debug, StrSubstNo(TxtPlanningLinesResetFilter, GetFilters));

            ModifyAll("JIRA/Tempo Sync Status", "JIRA/Tempo Sync Status"::"Deleted in Tempo");

        end;
    end;

    procedure DeleteOrphanedPlanningLines(var pJob: Record Job; pFromDate: Date; pToDate: Date)
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        with JobPlanningLine do begin

            Reset;
            SetRange("Job No.", pJob."No.");
            SetRange("Line Type", "Line Type"::Billable);
            SetFilter("Tempo Worklog Id", '<>%1', '0');
            SetFilter("Planning Date", '%1..%2', pFromDate, pToDate);
            SetRange("JIRA/Tempo Sync Status", "JIRA/Tempo Sync Status"::"Deleted in Tempo");
            SetRange("Qty. Transferred to Invoice", 0);

            Log(gLog.Severity::Debug, StrSubstNo(TxtPlanningLinesDeleteFilter, GetFilters));

            DeleteAll(true);

        end;
    end;

    procedure UpdateNAVJobPlanningLine(var pTempoAccount: Record "SCSJIFJIRA/Tempo-Accounts work"; var pTempoWorklogs: Record "SCSJIFJIRA/Tempo-Worklogs work"; var pTempoCustomFields: Record "SCSJIFJIRA/Tempo-Wrklgs,Cstfld")
    var
        TempoWorkLogInError: Record "SCSJIFJIRA/Tempo-Worklogs work";
    begin
        Log(gLog.Severity::Debug, TxtUpdatingJobPlanningLines);
        gTempoIntegrationController.UpdateProgressWindowPhase(TxtUpdatingJobPlanningLines);
        gTempoIntegrationController.UpdateProgressWindow(pTempoAccount."JIRA/Tempo Customer No.", pTempoAccount."JIRA/Tempo Account ID");

        UpdateNAVJobPlanningLine2(pTempoAccount, pTempoWorklogs, pTempoCustomFields, false);

        if ExtractAttribute(pTempoWorklogs."Billing Attributes", 'Travelexpenses') <> '' then
            // add/update additional line for expenses
            UpdateNAVJobPlanningLine2(pTempoAccount, pTempoWorklogs, pTempoCustomFields, true);

        // Remove entry from work file (if it was in error before)
        TempoWorkLogInError.SetRange("Work Log ID", pTempoWorklogs."Work Log ID");
        if TempoWorkLogInError.FindFirst then
            TempoWorkLogInError.Delete;
    end;

    procedure UpdateNAVJobPlanningLine2(var pTempoAccount: Record "SCSJIFJIRA/Tempo-Accounts work"; var pTempoWorklogs: Record "SCSJIFJIRA/Tempo-Worklogs work"; var pTempoCustomFields: Record "SCSJIFJIRA/Tempo-Wrklgs,Cstfld"; pProcessExpenses: Boolean)
    var
        Job: Record Job;
        JobTask: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
        Changed: Boolean;
        TempoWorkedHours: Decimal;
        TempoBilledHours: Decimal;
        DD: Integer;
        MM: Integer;
        YYYY: Integer;
        TempoWorkdate: Date;
        ChangePending: Boolean;
        TempoDescription1: Text[50];
        TempoDescription2: Text[50];
        MemoWriter: OutStream;
        MemoText: BigText;
        AddPlanningLine: Boolean;
        TempoWorklogId: Text[20];
        WorkTypeOverrideCode: Code[10];
        ExpenseText: Text[30];
        Expense: Decimal;
        Customer: Record Customer;
        Editable: Boolean;
        JobTaskNo: Code[20];
    begin

        with JobPlanningLine do begin

            // Check required fields
            if pTempoWorklogs."TEMPO Account ID" = '' then
                Log(gLog.Severity::Error, TxtAccountMissing)
            else
                if not Job.Get(pTempoWorklogs."TEMPO Account ID") then
                    Log(gLog.Severity::Error, StrSubstNo(TxtNAVJobNotExist, pTempoWorklogs."TEMPO Account ID"));

            if pProcessExpenses then
                // process additional planning line for expenses
                TempoWorklogId := pTempoWorklogs."Work Log ID" + '.expense'
            else
                // process planning line
                TempoWorklogId := pTempoWorklogs."Work Log ID";

            // Update
            SetRange("Tempo Worklog Id", TempoWorklogId);
            if Count > 1 then
                Log(gLog.Severity::Error, StrSubstNo(TxtWorkLogAssignedMultiple, TempoWorklogId, pTempoWorklogs."Issue Key"));

            GetCustomerByTempoID(pTempoAccount."JIRA/Tempo Customer No.", Customer);
            AddPlanningLine := false;

            if not FindFirst then
                // ================
                // not yet assigned
                // ================
                AddPlanningLine := true

            else begin
                // ================
                // already assigned
                // ================
                Log(gLog.Severity::Debug, StrSubstNo(TxtWorkLogAlreadyAssigned, pTempoWorklogs."Work Log ID", pTempoWorklogs."Issue Key", "Job No.", "Job Task No.", "Line No."));

                Job.Get(JobPlanningLine."Job No.");

                if (Job."JIRA/Tempo Account ID" <> pTempoWorklogs."TEMPO Account ID")
                    or ((Customer."Auto-Create Job Task" = Customer."Auto-Create Job Task"::"For Parent Issue or Dummy Task")
                        and (pTempoWorklogs."Parent Issue Key" <> JobPlanningLine."Parent Issue Key")) then begin
                    // ================
                    // moved to another account in Tempo
                    // OR job task is created based on parent issue and parent issue has been changed
                    // ================

                    CalcFields("Qty. Transferred to Invoice");
                    if "Qty. Transferred to Invoice" = 0 then begin
                        // not yet invoiced, continue

                        Delete(true);

                        // record was allowed to be deleted, move can continue
                        Log(gLog.Severity::Warning, StrSubstNo(TxtMovedToOtherAccount, pTempoWorklogs."Work Log ID", pTempoWorklogs."Issue Key", "Job No.", "Job Task No.", "Line No."));
                        AddPlanningLine := true;

                    end;

                end;
            end;

            JobTaskNo := ComputeJobTaskNo(pTempoAccount, pTempoWorklogs, pTempoCustomFields);

            if AddPlanningLine then begin
                // ================
                // not yet assigned
                // ================
                Log(gLog.Severity::Debug, StrSubstNo(TxtWorkLogNotYetAssigned, pTempoWorklogs."Work Log ID", pTempoWorklogs."Issue Key"));

                Init;
                Validate("Job No.", pTempoWorklogs."TEMPO Account ID");

                // (indirectly) set job task line
                Validate("JIRA Task No.", JobTaskNo);

                Validate("Line No.", GetNextWorkLogLineNo(JobPlanningLine));
                Log(gLog.Severity::Debug, StrSubstNo(TxtWorkLogAssigned, pTempoWorklogs."Work Log ID", pTempoWorklogs."Issue Key", "Job No.", "Job Task No.", "Line No."));

                Insert(true);

                Get("Job No.", "Job Task No.", "Line No.");

                Validate("Line Type", "Line Type"::Billable);
                if pProcessExpenses then
                    Validate(Type, Type::"G/L Account")
                else
                    Validate(Type, Type::Resource);

                Validate("Tempo Worklog Id", TempoWorklogId);

            end;

            CalcFields("Qty. Transferred to Invoice");
            Editable := ("Qty. Transferred to Invoice" = 0);

            Evaluate(TempoBilledHours, ConvertString(pTempoWorklogs."Billed Hours", 'Decimal'));
            Changed := ("Tempo Hash Value" <> pTempoWorklogs."Hash Value")
                                    or ("JIRA/Tempo Billed Hours" <> TempoBilledHours); // Billed hours obviously not included in Hash

            if Changed then begin

                if not Editable then begin
                    // already invoiced lines cannot be modified
                    Validate("JIRA/Tempo Sync Status", "JIRA/Tempo Sync Status"::"Update After Invoice");
                    Validate("Tempo Hash Value", pTempoWorklogs."Hash Value");
                    Modify(true);
                    Commit;
                    Log(gLog.Severity::Error, StrSubstNo(TxtJobPlanningLineAlreadyInvoiced, pTempoWorklogs."Work Log ID", pTempoWorklogs."Issue Key", "Job No.", "Job Task No.", "Line No."));
                end;

                Evaluate(YYYY, CopyStr(pTempoWorklogs."Work Date", 1, 4));
                Evaluate(MM, CopyStr(pTempoWorklogs."Work Date", 6, 2));
                Evaluate(DD, CopyStr(pTempoWorklogs."Work Date", 9, 2));
                TempoWorkdate := DMY2Date(DD, MM, YYYY);

                Validate("JIRA/Tempo Workdate", TempoWorkdate);

                if pProcessExpenses then begin
                    // process additional planning line for expenses
                    Validate("No.", Customer."G/L Account for Expenses");

                    Validate("JIRA/Tempo Billed Hours", 0);
                    Validate("JIRA/Tempo Worked Hours", 0);
                    ExpenseText := ExtractAttribute(pTempoWorklogs."Billing Attributes", 'Travelexpenses');
                    ExpenseText := ConvertStr(ExpenseText, '.', ',');
                    Evaluate(Expense, ExpenseText);
                    Validate("Unit of Measure Code", Customer."Unit for Expenses");
                    Validate(Quantity, Expense);
                    Validate("Unit Price", 1);

                end else begin
                    Validate("JIRA/Tempo Staff Id", pTempoWorklogs."Staff ID");

                    WorkTypeOverrideCode := ExtractAttribute(pTempoWorklogs."Billing Attributes", 'WorkTypeOverride');
                    if WorkTypeOverrideCode <> '' then
                        Validate(JobPlanningLine."Work Type Code", WorkTypeOverrideCode);

                    Evaluate(TempoWorkedHours, ConvertString(pTempoWorklogs."Worked Hours", 'Decimal'));
                    Evaluate(TempoBilledHours, ConvertString(pTempoWorklogs."Billed Hours", 'Decimal'));

                    Validate("JIRA/Tempo Billed Hours", TempoBilledHours);
                    Validate("JIRA/Tempo Worked Hours", TempoWorkedHours);
                end;

                Validate("Jira Issue Key", pTempoWorklogs."Issue Key");
                Validate("Jira Issue Summary", pTempoWorklogs."Issue Summary");

                Validate("Parent Issue Key", pTempoWorklogs."Parent Issue Key");
                Validate("Parent Issue Summary", pTempoWorklogs."Parent Issue Summary");

                TempoDescription1 := CleanString(CopyStr(pTempoWorklogs."Work Description 1", 1, 50));
                TempoDescription2 := CleanString(CopyStr(pTempoWorklogs."Work Description 1", 51, 50));

                Validate(Description, TempoDescription1);
                Validate("Description 2", TempoDescription2);

                "JIRA/Tempo Work Description".CreateOutStream(MemoWriter);
                MemoWriter.Write(pTempoWorklogs."Work Description 1");
                MemoWriter.Write(pTempoWorklogs."Work Description 2");
                MemoWriter.Write(pTempoWorklogs."Work Description 3");
                MemoWriter.Write(pTempoWorklogs."Work Description 4");
                MemoWriter.Write(pTempoWorklogs."Work Description 5");
                MemoWriter.Write(pTempoWorklogs."Work Description 6");
                MemoWriter.Write(pTempoWorklogs."Work Description 7");
                MemoWriter.Write(pTempoWorklogs."Work Description 8");

                Validate("Tempo Hash Value", pTempoWorklogs."Hash Value");

            end else
                Log(gLog.Severity::Debug, StrSubstNo(TxtWorkLogNotChanged, pTempoWorklogs."Work Log ID", pTempoWorklogs."Issue Key", "Job No.", "Job Task No.", "Line No."));

            // Unfortunately, the hash value does not consider the custom fields, so this part has to be executed always
            if ApplyCustomFields(JobPlanningLine, pTempoCustomFields, Editable) then
                Validate("JIRA/Tempo Sync Status", "JIRA/Tempo Sync Status"::"In Sync")
            else
                // only in sync if all pending changes to custom fields could be applied as well
                Validate("JIRA/Tempo Sync Status", "JIRA/Tempo Sync Status"::"Update After Invoice");

            Validate(JobPlanningLine."JIRA/Tempo Sync DateTime", CurrentDateTime);

            Modify(true);

            if Editable and (JobTaskNo <> "Job Task No.") then begin
                // (indirectly) set job task line
                Log(gLog.Severity::Debug, StrSubstNo(TxtJobTaskNoChanged, "Job Task No.", JobTaskNo));
                Validate("JIRA Task No.", JobTaskNo);
                Log(gLog.Severity::Debug, StrSubstNo(TxtNowAssignedToJobTask, "Job Task No."));
            end;
        end;
    end;

    procedure SetAccountInError(var pTempoAccount: Record "SCSJIFJIRA/Tempo-Accounts work"; ErrorMessage: Text)
    var
        TempoAccountInError: Record "SCSJIFJIRA/Tempo-Accounts work";
        Job: Record Job;
    begin
        if TempoAccountInError.Get(pTempoAccount."JIRA/Tempo Account ID") then begin
            TempoAccountInError := pTempoAccount;
            TempoAccountInError."Synchronization Error" := CopyStr(ErrorMessage, 1, 250);
            TempoAccountInError.Modify;
        end else begin
            TempoAccountInError := pTempoAccount;
            TempoAccountInError."Synchronization Error" := CopyStr(ErrorMessage, 1, 250);
            TempoAccountInError.Insert;
        end;
        if Job.Get(pTempoAccount."JIRA/Tempo Account ID") then begin
            Job."JIRA/Tempo Sync Status" := Job."JIRA/Tempo Sync Status"::Error;
            Job.Modify;
        end;
        Commit;

        Log(gLog.Severity::Warning, ErrorMessage);
    end;

    procedure SetWorkLogInError(var pTempoWorklog: Record "SCSJIFJIRA/Tempo-Worklogs work"; ErrorMessage: Text)
    var
        TempoWorkLogInError: Record "SCSJIFJIRA/Tempo-Worklogs work";
        Job: Record Job;
        JobPlanningLine: Record "Job Planning Line";
    begin
        TempoWorkLogInError.SetRange("TEMPO Account ID", pTempoWorklog."TEMPO Account ID");
        TempoWorkLogInError.SetRange("Job Task ID", pTempoWorklog."Job Task ID");
        TempoWorkLogInError.SetRange("Work Log ID", pTempoWorklog."Work Log ID");
        if TempoWorkLogInError.FindFirst then begin
            TempoWorkLogInError := pTempoWorklog;
            TempoWorkLogInError."Synchronization Error" := CopyStr(ErrorMessage, 1, 250);
            TempoWorkLogInError.Modify;
        end else begin
            TempoWorkLogInError := pTempoWorklog;
            TempoWorkLogInError."Synchronization Error" := CopyStr(ErrorMessage, 1, 250);
            TempoWorkLogInError.Insert;
        end;

        JobPlanningLine.SetRange("Job No.", pTempoWorklog."TEMPO Account ID");
        JobPlanningLine.SetRange("Job Task No.", pTempoWorklog."Job Task ID");
        JobPlanningLine.SetRange("Tempo Worklog Id", pTempoWorklog."Work Log ID");
        if JobPlanningLine.FindFirst then begin
            JobPlanningLine."JIRA/Tempo Sync Status" := JobPlanningLine."JIRA/Tempo Sync Status"::Error;
            JobPlanningLine.Modify;
        end;

        if Job.Get(pTempoWorklog."TEMPO Account ID") then begin
            Job."JIRA/Tempo Sync Status" := Job."JIRA/Tempo Sync Status"::Error;
            Job.Modify;
        end;

        Commit;

        Log(gLog.Severity::Warning, ErrorMessage);
    end;

    local procedure GetAttributByName(pxmlNode: DotNet IXMLDOMNode; pAttributeName: Text[30]) pAttributeValue: Text
    var
        xmlAttributeList: DotNet IXMLDOMNamedNodeMap;
        xmlNode: DotNet IXMLDOMNode;
    begin
        xmlAttributeList := pxmlNode.attributes;
        xmlNode := xmlAttributeList.getNamedItem(pAttributeName);
        if IsNull(xmlNode) then
            pAttributeValue := ''
        else
            pAttributeValue := xmlNode.nodeValue;
    end;

    local procedure GetNextWorkLogLineNo(var pJobPlanningLine: Record "Job Planning Line"): Integer
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        JobPlanningLine.SetRange("Job No.", pJobPlanningLine."Job No.");
        JobPlanningLine.SetRange("Job Task No.", pJobPlanningLine."Job Task No.");
        if JobPlanningLine.FindLast then
            exit(JobPlanningLine."Line No." + 10000);
        exit(10000);
    end;

    local procedure GetLocalSeparators(var ThousandSep: Text[1]; var DecimalSep: Text[1])
    var
        TxtVal: Text;
        Pos: array[4] of Integer;
    begin
        ThousandSep := '';
        DecimalSep := '';

        TxtVal := Format(123456 / 100);
        Pos[1] := StrPos(TxtVal, '1');
        Pos[2] := StrPos(TxtVal, '2');
        Pos[3] := StrPos(TxtVal, '4');
        Pos[4] := StrPos(TxtVal, '5');

        if Pos[2] - Pos[1] > 1 then
            ThousandSep := CopyStr(TxtVal, Pos[1] + 1, 1);
        if Pos[4] - Pos[3] > 1 then
            DecimalSep := CopyStr(TxtVal, Pos[3] + 1, 1);
    end;

    local procedure ConvertString(FromString: Text; DataType: Text) ToString: Text
    var
        ThousandSep: Text[1];
        DecimalSep: Text[1];
        DayInt: Integer;
        MonthInt: Integer;
        YearInt: Integer;
    begin
        // Convert the string considering user locale
        case DataType of
            'Decimal':
                begin
                    ToString := FromString;

                    if (StrPos(ToString, ',') = 0) and (StrPos(ToString, '.') = 0) then // no saparators in source
                        exit(ToString);

                    GetLocalSeparators(ThousandSep, DecimalSep);
                    if (ThousandSep = ',') and (DecimalSep = '.') then // no conversion (same locale)
                        exit(ToString);

                    if (ThousandSep = '') and (StrPos(ToString, ',') <> 0) then // no separator expected, delete
                        ToString := DelChr(ToString, '=', ',');
                    if (DecimalSep = '') and (StrPos(ToString, '.') <> 0) then  // no separator expected, delete
                        ToString := DelChr(ToString, '=', '.');

                    // Exchange the separators
                    if DecimalSep = '.' then
                        exit(ToString);
                    if (ThousandSep <> '') and (DecimalSep <> '') then begin
                        ToString := ConvertStr(ToString, '.', '$');
                        ToString := ConvertStr(ToString, ',', ThousandSep);
                        ToString := ConvertStr(ToString, '$', DecimalSep);
                    end;
                    if (ThousandSep = '') and (DecimalSep <> '') then
                        ToString := ConvertStr(ToString, '.', DecimalSep);
                    if (ThousandSep <> '') and (DecimalSep = '') then
                        ToString := ConvertStr(ToString, ',', ThousandSep);
                end;
            'Date':
                begin
                    if (FromString = '') or (FromString = '0') then
                        ToString := Format(0D)
                    else begin
                        Evaluate(YearInt, CopyStr(FromString, 1, 4));
                        Evaluate(MonthInt, CopyStr(FromString, 5, 2));
                        Evaluate(DayInt, CopyStr(FromString, 7, 2));
                        ToString := Format(DMY2Date(DayInt, MonthInt, YearInt));
                    end;
                end;
            else
                exit(FromString);
        end;
    end;

    procedure Log(Severity: Option; Message: Text)
    begin

        gTempoIntegrationController.Log(Severity, Message);
        if Severity >= gLog.Severity::Error then
            Error(Message);
    end;

    procedure ComputeJobTaskNo(var pTempoAccount: Record "SCSJIFJIRA/Tempo-Accounts work"; var pTempoWorklogs: Record "SCSJIFJIRA/Tempo-Worklogs work"; var pTempoCustomFields: Record "SCSJIFJIRA/Tempo-Wrklgs,Cstfld"): Code[20]
    var
        Customer: Record Customer;
        Job: Record Job;
        JobTask: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
        JobTaskNo: Code[20];
        JobTaskDescription: Text[100];
    begin

        //IF pTempoWorklogs."Job Task ID" <> '' THEN BEGIN
        // use directly, if given
        //  EXIT(AddJobTask(Job, Customer, pTempoWorklogs."Job Task ID", ''));
        //END;

        GetCustomerByTempoID(pTempoAccount."JIRA/Tempo Customer No.", Customer);

        JobTaskNo := GetCustomField(pTempoWorklogs, pTempoCustomFields, 1000);

        if JobTaskNo = '' then
            // task no not explicitly give, try to find via affinity
            if Customer."Auto-Assign to Issues Job Task" then begin

                // check if already assigned to any task line. If so, use the same
                with JobPlanningLine do begin
                    SetRange("Job No.", pTempoWorklogs."TEMPO Account ID");
                    SetRange("Jira Issue Key", pTempoWorklogs."Issue Key");
                    if FindFirst then begin
                        // another task line for this issue found, use the same
                        TestField("Job Task No.");
                        Log(gLog.Severity::Debug, StrSubstNo(TxtJobTaskFoundByIssue, "Job No.", "Job Task No.", Description, pTempoWorklogs."Issue Key"));
                        exit("Job Task No.");
                    end;
                end;
            end;

        Job.Get(pTempoWorklogs."TEMPO Account ID");

        with JobTask do begin

            if JobTaskNo = '' then begin
                // preset with dummy task values
                JobTaskNo := Customer."ID for Dummy Job Task";
                JobTaskDescription := Customer."Desc. for Dummy Job Task";
            end;

            case Customer."Auto-Create Job Task" of

                Customer."Auto-Create Job Task"::"For Parent Issue or Dummy Task":
                    if pTempoWorklogs."Parent Issue Key" <> '' then begin
                        // parent issue exists
                        JobTaskNo := pTempoWorklogs."Parent Issue Key";
                        JobTaskDescription := CopyStr(pTempoWorklogs."Parent Issue Summary", 1, 100);
                    end;

                Customer."Auto-Create Job Task"::"For Issue":
                    begin
                        // create job task per issue
                        pTempoWorklogs.TestField("Issue Key");
                        JobTaskNo := pTempoWorklogs."Issue Key";
                        JobTaskDescription := CopyStr(pTempoWorklogs."Issue Summary", 1, 100);
                    end;
            end;

            if JobTaskNo = '' then
                // No task found
                Log(gLog.Severity::Error, StrSubstNo(TxtNAVJobTskIDNotFound, Job."No.", JobTaskNo));

            if Get(Job."No.", JobTaskNo) then begin
                // Job tasks exists
                exit(JobTaskNo);
            end;

        end;

        if Customer."Auto-Create Job Task" = Customer."Auto-Create Job Task"::Never then
            // Auto-Creation is not allowed
            Log(gLog.Severity::Error, StrSubstNo(TxtNAVJobTskNotExist, Job."No.", pTempoWorklogs."Job Task ID"));

        AddJobTask(Job, JobTaskNo, JobTaskDescription, Customer);

        if JobTaskNo = pTempoWorklogs."Parent Issue Key" then begin
            // parent task has been created, move this issues worklogs to this new task
            JobPlanningLine.SetRange("Job No.", Job."No.");
            JobPlanningLine.SetRange("Jira Issue Key", JobTaskNo);
            JobPlanningLine.SetFilter("Job Task No.", '<> %1', JobTaskNo);
            if JobPlanningLine.FindSet then
                MoveLinesToJobTask(JobPlanningLine, JobTaskNo);
        end;

        exit(JobTaskNo);
    end;

    procedure AddJobTask(var Job: Record Job; JobTaskNo: Code[20]; JobTaskDescription: Text[100]; var Customer: Record Customer)
    var
        JobTask: Record "Job Task";
        ConfigTemplateHdr: Record "Config. Template Header";
        ConfigTemplateMgt: Codeunit "Config. Template Management";
        RecRef: RecordRef;
        JobPlanningLine: Record "Job Planning Line";
    begin
        with JobTask do begin

            Init;
            Validate("Job No.", Job."No.");
            Validate("Job Task No.", JobTaskNo);
            Insert(true);

            Get("Job No.", "Job Task No.");

            // Apply configuration template
            ConfigTemplateHdr.Get(Customer."Job Task Template Code");
            ConfigTemplateHdr.TestField("Table ID", Database::"Job Task");

            RecRef.GetTable(JobTask);
            ConfigTemplateMgt.UpdateRecord(ConfigTemplateHdr, RecRef);

            if JobTaskDescription <> '' then
                JobTask.Description := JobTaskDescription;

            Modify(true);

            Log(gLog.Severity::Debug, StrSubstNo(TxtJobTaskAdded, Job."No.", JobTaskNo, Description));

        end;

        exit;
    end;

    procedure CleanString(pText: Text): Text
    var
        Char: Text[3];
        Replace: Text[3];
    begin
        Char[1] := 13;
        Char[2] := 10;
        Char[3] := 9;

        Replace := '   ';

        exit(ConvertStr(pText, Char, Replace));
    end;

    procedure EscapeCRLF(String: Text): Text
    var
        CRLF: Text;
        CRLFEscaped: Text;
    begin
        CRLFEscaped := '\n';

        CRLF := 'XX';
        CRLF[1] := 13;
        CRLF[2] := 10;

        String := ReplaceString(String, CRLF, CRLFEscaped);

        CRLF := 'XX';
        CRLF[1] := 10;
        CRLF[2] := 10;

        exit(ReplaceString(String, CRLF, CRLFEscaped));
    end;

    procedure UnescapeCRLFForDisplay(String: Text): Text
    var
        LF: Text;
        CRLFEscaped: Text;
    begin
        CRLFEscaped := '\n';
        LF := '\';

        exit(ReplaceString(String, CRLFEscaped, LF));
    end;

    procedure ReplaceString(String: Text; Find: Text[250]; Replace: Text[250]): Text
    begin
        while StrPos(String, Find) > 0 do
            String := DelStr(String, StrPos(String, Find)) + Replace + CopyStr(String, StrPos(String, Find) + StrLen(Find));

        exit(String);
    end;

    procedure ExtractAttribute(String: Text[250]; Attribute: Text[250]): Text
    var
        Pos: Integer;
    begin
        Pos := StrPos(String, Attribute);
        if Pos = 0 then
            exit('');

        String := CopyStr(String, Pos + StrLen(Attribute) + 1);
        Pos := StrPos(String, ',');

        if Pos > 0 then
            String := CopyStr(String, 1, Pos - 1);

        String := DelChr(String, '<>', ' ');

        exit(String);
    end;

    procedure MoveLinesToJobTask(var JobPlanningLine: Record "Job Planning Line"; ToJobTask: Code[20])
    var
        JobPlanningLine2: Record "Job Planning Line";
    begin
        repeat

            JobPlanningLine2.Copy(JobPlanningLine);

            JobPlanningLine2.Validate("Job Task No.", ToJobTask);

        until JobPlanningLine.Next = 0;

        Commit;
    end;

    procedure GetCustomerByTempoID(pTempoCustomerID: Text[30]; var Customer: Record Customer)
    begin

        Customer.SetRange("JIRA/Tempo Customer No.", pTempoCustomerID);
        Customer.FindFirst;
    end;

    procedure StoreCustomField(var pTempoAccounts: Record "SCSJIFJIRA/Tempo-Accounts work"; var pTempoCustomFields: Record "SCSJIFJIRA/Tempo-Wrklgs,Cstfld"; WorkLogID: Text[30]; FromFieldName: Text[30]; FromValue: Text[30])
    var
        TempoCustomFieldMapping: Record "SCSJIFJIRA/Tempo-Cst Fld Map";
    begin

        with TempoCustomFieldMapping do begin
            SetRange(Customer, pTempoAccounts."Customer No.");
            SetRange("From Field Name", FromFieldName);
            SetRange("Job No.", pTempoAccounts."JIRA/Tempo Account ID");

            if IsEmpty then
                SetRange("Job No.");

            if IsEmpty then
                exit;

            pTempoCustomFields.Init;

            SetRange("Mapping Type", "Mapping Type"::"Pass-Thru");
            if FindFirst then
                // directly pass value
                pTempoCustomFields."To Value" := FromValue

            else begin
                // from value to value mapping?
                SetRange("Mapping Type", "Mapping Type"::"Map from/to");
                SetRange("From Value", FromValue);
                if FindFirst then
                    pTempoCustomFields."To Value" := "To Value"

                else begin
                    // default value defined?
                    SetRange("Mapping Type", "Mapping Type"::"From/to Default");
                    if FindFirst then
                        pTempoCustomFields."To Value" := "To Value"

                    else
                        // no match
                        exit;
                end;
            end;

            pTempoCustomFields."Work Log ID" := WorkLogID;
            pTempoCustomFields."From  Field Name" := "From Field Name";
            pTempoCustomFields."From Value" := FromValue;
            pTempoCustomFields."To Field No." := "To Field No.";

            pTempoCustomFields.Insert;

        end;
    end;

    procedure ApplyCustomFields(var pJobPlanningLine: Record "Job Planning Line"; var pTempoCustomFields: Record "SCSJIFJIRA/Tempo-Wrklgs,Cstfld"; pEditable: Boolean): Boolean
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        OldValue: Text;
        Changed: Boolean;
    begin
        RecRef.GetTable(pJobPlanningLine);

        with pTempoCustomFields do begin

            SetRange("Work Log ID", pJobPlanningLine."Tempo Worklog Id");
            SetFilter("To Field No.", '<>1&<>2&<>1000'); // Key fields must not be overwritten

            if FindSet then begin
                repeat

                    FldRef := RecRef.Field("To Field No.");
                    OldValue := Format(FldRef);
                    FldRef.Validate(pTempoCustomFields."To Value");
                    Changed := Changed or (Format(FldRef) <> OldValue);
                    if Changed then
                        Log(gLog.Severity::Debug, StrSubstNo(TxtCustomFieldUpdated, FldRef.Caption, OldValue, Format(FldRef)));

                until Next() = 0;

                if Changed then
                    if pEditable then begin
                        RecRef.SetTable(pJobPlanningLine);
                        Log(gLog.Severity::Debug, TxtCustomFieldsUpdated);
                        exit(true);

                    end
                    else begin
                        Log(gLog.Severity::Warning, TxtCustomFieldsNOTUpdated);
                        exit(false);
                    end;

            end;
        end;

        exit(true);
    end;

    procedure GetCustomField(var pTempoWorkLogs: Record "SCSJIFJIRA/Tempo-Worklogs work"; var pTempoCustomFields: Record "SCSJIFJIRA/Tempo-Wrklgs,Cstfld"; pToFieldNo: Integer): Text[30]
    begin

        with pTempoCustomFields do begin
            SetRange("Work Log ID", pTempoWorkLogs."Work Log ID");
            SetRange("To Field No.", pToFieldNo);
            if not FindFirst then
                exit('');

            exit("To Value");
        end;
    end;

    procedure HandleXMLLoadError(URL: Text)
    var
        ParseError: DotNet IXMLDOMParseError;
    begin
        ParseError := xmlResponse.parseError;
        Log(gLog.Severity::Error, StrSubstNo(TxtDOMParseError, ParseError.errorCode, ParseError.reason, ParseError.line, ParseError.linepos, ParseError.filepos, Url));
    end;

    // Events not supported
    // event xmlResponse::XMLDOMDocumentEvents_Event_ondataavailable(()

    // Events not supported
    // event xmlResponse::XMLDOMDocumentEvents_Event_onreadystatechange(()
}

