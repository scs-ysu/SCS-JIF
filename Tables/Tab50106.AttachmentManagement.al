table 50106 "Attachment Management"
{

    DataClassification = CustomerContent;

    fields
    {
        field(10; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(20; "Attached to Record Id"; RecordID)
        {
            DataClassification = CustomerContent;
            Caption = 'Attached to Record Id';
        }
        field(30; Attachment; BLOB)
        {
            DataClassification = CustomerContent;
            Caption = 'Attachment';
        }
        field(50; FileName; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'File';
        }
        field(60; Added; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Added';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Attached to Record Id", FileName)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Txt_AttachmentDataMissing: Label 'No attachment data found.';
        Txt_BigFile: Label 'The file you are trying to import is larger than %1. Are you sure?';
        Txt_ConfirmDuplicate: Label 'An attachment named %1 already exists. Do you want to add a second instance?';
        Txt_Import: Label 'Import Attachment.';

    procedure ImportAttachment(RecIDToImport: RecordID)
    var
        AttachRecordRef: RecordRef;
        LongFileName: Text[1024];
        FileMgmt: Codeunit "File Management";
        //TempBlob: Record TempBlob;
        TempBlob: Codeunit "Temp Blob"; // to do
        Rec1: Record "Attachment Management";
        Rec2: Record "Attachment Management";
        BlobInStream: InStream;
        BlobOutStream: OutStream;
        BytesRead: Integer;
        Length: Integer;
        Buffer: Text[1024];
        Limit: Integer;
        LimitText: Text;
    begin

        with Rec1 do begin

            LongFileName := FileMgmt.BLOBImportWithFilter(TempBlob, Txt_Import, '', '*.*|', '*.*');

            if LongFileName = '' then
                exit;

            Limit := 3 * 1048576;// 3 MB
            LimitText := '3 MB';
            TempBlob.CreateInStream(BlobInStream);
            repeat
                BytesRead := BlobInStream.Read(Buffer);
                Length += BytesRead;
            until BytesRead = 0;

            if Length > Limit then
                if not Confirm(Txt_BigFile, true, LimitText, BytesRead) then
                    exit;

            Init;
            // since Tempbolb record is missing and instead used "temp blob" code unit, added below 2 lines.
            // Attachment := TempBlob.Blob; 
            Attachment.CreateOutStream(BlobOutStream);
            CopyStream(BlobOutStream, BlobInStream);

            FileName := CopyStr(FileMgmt.GetFileName(LongFileName), 1, 250);

            Rec2.SetCurrentKey("Attached to Record Id", FileName);
            Rec2.SetRange("Attached to Record Id", RecIDToImport);
            Rec2.SetRange(FileName, FileName);
            if Rec2.FindFirst then
                if not Confirm(Txt_ConfirmDuplicate, false, FileName) then
                    exit;

            "Attached to Record Id" := RecIDToImport;
            Added := CurrentDateTime;

            Insert;

        end;
    end;

    procedure ExportAttachment()
    var
        FileMgmt: Codeunit "File Management";
        //TempBlob: Record TempBlob temporary;
        TempBlob: Codeunit "Temp Blob";
        BlobInStream: InStream;
        BlobOutStream: OutStream;
    begin

        CalcFields(Attachment);

        if not Attachment.HasValue then
            Error(Txt_AttachmentDataMissing);
        // since Tempbolb record is missing and instead used "temp blob" code unit, added below 3 lines.
        //TempBlob.Blob := Attachment; 
        Attachment.CreateInStream(BlobInStream);
        TempBlob.CreateOutStream(BlobOutStream);
        CopyStream(BlobOutStream, BlobInStream);

        FileMgmt.BLOBExport(TempBlob, FileName, true);
    end;
}

