import Foundation

open class CSV {
    // CSV parser.
    
    open var headers: [String] = []
    open var rows: [Dictionary<String, String>] = []
    open var columns = Dictionary<String, [String]>()
    var delimiter = CharacterSet(charactersIn: ",")
    var i = 0
    
    public init(content: String?, delimiter: CharacterSet, encoding: UInt) throws{
        if let csvStringToParse = content{
            self.delimiter = delimiter
            
            let newline = CharacterSet.newlines
            var lines: [String] = []
            csvStringToParse.trimmingCharacters(in: newline).enumerateLines { line, stop in lines.append(line) }
            
            self.headers = self.parseHeaders(fromLines: lines)
            self.rows = self.parseRows(fromLines: lines)
            self.columns = self.parseColumns(fromLines: lines)
        }
    }
    
    public convenience init(contentsOfURL url: String) throws {
        //  Na tento init se odkazuju externe jako csv((contentsOfURL: path!), path musim vytvorit a zadat tam cestu k csv souboru.
        let comma = CharacterSet(charactersIn: ",")
        let csvString: String?
        do {
            csvString = try String(contentsOfFile: url, encoding: String.Encoding.utf8)
        } catch _ {
            csvString = nil
        };
        try self.init(content: csvString,delimiter:comma, encoding:String.Encoding.utf8.rawValue)
    }
    
    
    func parseHeaders(fromLines lines: [String]) -> [String] {
        return lines[0].components(separatedBy: self.delimiter)
    }
    
    func parseRows(fromLines lines: [String]) -> [Dictionary<String, String>] {
        var rows: [Dictionary<String, String>] = []
        
        for (lineNumber, line) in lines.enumerated() {
            if lineNumber == 0 {
                continue
            }
            
            var row = Dictionary<String, String>()
            let values = line.components(separatedBy: self.delimiter)
            //  Tady rozpojí metodou components každou lajnu delimeterem = středník
            
            for (index, header) in self.headers.enumerated() {
                
                i += 1
                print(i)
                if index < values.count {
                    row[header] = values[index]
                } else {
                    row[header] = ""
                }
            }
            rows.append(row)
        }
        return rows
    }
    
    func parseColumns(fromLines lines: [String]) -> Dictionary<String, [String]> {
        var columns = Dictionary<String, [String]>()
        
        for header in self.headers {
            let column = self.rows.map { row in row[header] != nil ? row[header]! : "" }
            columns[header] = column
        }
        
        return columns
    }
}
