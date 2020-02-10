page 50104 "SCSJIFJIRA/Tempo-Custom Field"
{
    DelayedInsert = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "SCSJIFJIRA/Tempo-Cst Fld Map";
    ApplicationArea = All;
    Caption = 'JIRA/Tempo-Custom Field';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(JobNo; "Job No.")
                {
                    ApplicationArea = All;
                    Visible = JobNoVisible;
                }
                field(FromFieldName; "From Field Name")
                {
                    ApplicationArea = All;
                }
                field(ToFieldNo; "To Field No.")
                {
                    ApplicationArea = All;
                }
                field(FieldName; "Field Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(MappingType; "Mapping Type")
                {
                    ApplicationArea = All;
                }
                field(FromValue; "From Value")
                {
                    ApplicationArea = All;
                }
                field(ToValue; "To Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        JobNoVisible := GetFilter("Job No.") = '';
    end;

    var
        JobNoVisible: Boolean;
}

