page 50103 "Tempo - Processing Log"
{

    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "JIRA/Tempo-Sync Log file";
    Caption = 'Tempo - Processing Log';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; Id)
                {
                    ApplicationArea = All;
                }
                field(LogTimestamp; "Log Timestamp")
                {
                    ApplicationArea = All;
                }
                field(Severity; Severity)
                {
                    ApplicationArea = All;
                }
                field("Message"; Message)
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

