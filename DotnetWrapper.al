dotnet
{

    assembly(mscorlib)
    {
        type(System.DateTime; MyDateTime) { }

    }
    assembly(Microsoft.Office.Interop.Excel)
    {
        type(Microsoft.Office.Interop.Excel.ApplicationClass; Application_Class) { }
        type(Microsoft.Office.Interop.Excel.Application; Application) { }
        type(Microsoft.Office.Interop.Excel.Workbook; Work_book) { }
        type(Microsoft.Office.Interop.Excel.Workbooks; Workbooks) { }
    }
    assembly(PdfSharp)
    {
        Version = '1.0.898.0';
        Culture = 'neutral';
        PublicKeyToken = 'f94615aa0424f9eb';

        type(PdfSharp.Pdf.PdfDocument; PdfDocument) { }
        type(PdfSharp.Pdf.IO.PdfReader; PdfReader) { }
        type(PdfSharp.Pdf.PdfPage; PdfPage) { }
        type(PdfSharp.Pdf.IO.PdfDocumentOpenMode; PdfDocumentOpenMode) { }
    }


    assembly(Microsoft.MSXML)
    {
        type(MSXML.DOMDocumentClass; DOMDocumentClass) { }
        type(MSXML.IXMLDOMNodeList; IXMLDOMNodeList) { }
        type(MSXML.IXMLDOMNode; IXMLDOMNode) { }
        type(MSXML.XMLHTTPRequestClass; XMLHTTPRequestClass) { }
        type(MSXML.IXMLDOMNamedNodeMap; IXMLDOMNamedNodeMap) { }
        type(MSXML.IXMLDOMParseError; IXMLDOMParseError) { }
    }
}