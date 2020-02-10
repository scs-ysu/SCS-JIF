page 50103 "SCSJIF Tempo - Processing Log"
{

    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SCSJIFJIRA/Tempo-Snyc Log file";
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

