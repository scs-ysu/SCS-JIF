page 50102 "SCSJIFTEMPO- Integration Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "SCSJIFJIRA/Tempo-Setup";
    Caption = 'TEMPO- Integration Setup';
    layout
    {
        area(content)
        {
            group(Allgemein)
            {
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field(TempoServletBaseURL; "Tempo Servlet Base URL")
                {
                    ApplicationArea = All;
                }
                field(TempoSecurityToken; "Tempo Security Token")
                {
                    ApplicationArea = All;
                }
                field(ClearLogBeforeSyncStart; "Clear Log Before Sync-Start")
                {
                    ApplicationArea = All;
                }
                field(SyncFromDate; "Sync From Date")
                {
                    ApplicationArea = All;
                }
                field(ConsolidateRessourcesOnInv; "Consolidate Ressources on Inv.")
                {
                    ApplicationArea = All;
                }
                field(GLAccountNoForCons; "G/L Account No. for Cons.")
                {
                    ApplicationArea = All;
                }
                field(JiraUserForSync; "Jira User for Sync")
                {
                    ApplicationArea = All;
                }
                field(JiraPasswordForSync; "Jira Password for Sync")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

