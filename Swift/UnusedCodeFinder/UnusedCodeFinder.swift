import Foundation

extension String {
    var red: String { "\u{001B}[31m\(self)\u{001B}[0m" }
    
    var green: String { "\u{001B}[32m\(self)\u{001B}[0m" }
    
    var blue: String { "\u{001B}[34m\(self)\u{001B}[0m" }
    
    var magenta: String { "\u{001B}[35m\(self)\u{001B}[0m" }
    
    var cyan: String { "\u{001B}[36m\(self)\u{001B}[0m" }
    
    var bold: String { "\u{001B}[1m\(self)\u{001B}[22m" }
    
    var italic: String { "\u{001B}[3m\(self)\u{001B}[23m" }
}

class Item: Hashable {
    let file: String
    let line: String
    let at: Int
    var type: String?
    var name: String?
    
    init(file: String, line: String, at: Int) {
        self.file = file
        self.line = line
        self.at = at + 1
        extractTypeAndName()
    }
    
    private func extractTypeAndName() {
        if let match = line.range(of: #"(class|enum|struct|protocol)\s+(\w+)"#, options: .regularExpression) {
            let typeRange = match.lowerBound..<match.upperBound
            let typeAndName = line[typeRange]
            let components = typeAndName.split(separator: " ")
            if components.count == 2 {
                type = String(components[0])
                name = String(components[1])
            }
        }
    }
    
    var modifiers: [String] {
        guard let match = line.range(of: "(.*?)\(type ?? "")", options: .regularExpression) else { return [] }
        let modifiersRange = line.startIndex..<match.lowerBound
        let modifiersString = line[modifiersRange]
        return modifiersString.split(separator: " ").map { String($0) }
    }
    
    func serialize() -> String {
        "\(type?.magenta.italic ?? "") --- \(name?.cyan ?? "") => \("<".green)Path: \(file)\(",".green) Line: \(at)\(">".green)"
    }
    
    func toXcode() -> String {
        "\(file):\(at):0: warning: \(type ?? "") \(name ?? "") is unused"
    }
}

extension Item {
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.name == rhs.name && lhs.file == rhs.file && lhs.line == rhs.line
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(file)
        hasher.combine(line)
    }
}


class Unused {
    
    func find() {
        var items: [Item] = []
        let allFiles = FileManager.default.enumerator(atPath: FileManager.default.currentDirectoryPath)?
            .compactMap { $0 as? String }
            .filter { $0.hasSuffix(".swift") && !$0.hasPrefix(".") }
        
        allFiles?.forEach { myTextFile in
            if let fileItems = grabItems(file: myTextFile) {
                let filteredItems = filterItems(items: fileItems)
                let (nonPrivateItems, privateItems) = partitionItems(items: filteredItems)
                items += nonPrivateItems
                
                if !privateItems.isEmpty {
                    findUsagesInFiles(files: [myTextFile], xibs: [], items: privateItems)
                }
            }
        }
        
        print("Total items to be checked \(String(items.count).magenta.italic)")
        
        items = Array(Set(items))
        print("Total unique items to be checked \(String(items.count).magenta.italic)")
        
        print("Starting searching globally it can take a while".green)
        
        let xibs = FileManager.default.enumerator(atPath: FileManager.default.currentDirectoryPath)?
            .compactMap { $0 as? String }
            .filter { $0.hasSuffix(".xib") || $0.hasSuffix(".storyboard") }
        
        findUsagesInFiles(files: allFiles ?? [], xibs: xibs ?? [], items: items)
    }
    
    func partitionItems(items: [Item]) -> ([Item], [Item]) {
        (nonPrivateItems: items.filter { !$0.modifiers.contains("private") && !$0.modifiers.contains("fileprivate") },
         privateItems: items.filter { $0.modifiers.contains("private") || $0.modifiers.contains("fileprivate") })
    }
    
    func ignoreFiles(with regexps: [String], from files: [Item]) -> [Item] {
        files.filter { file in
            regexps.allSatisfy { regexp in
                file.file.range(of: regexp, options: .regularExpression) == nil
            }
        }
    }
    
    func ignoringRegexpsFromCommandLineArgs() -> [String] {
        var regexps: [String] = []
        var shouldSkipPredefinedIgnores = false
        var arguments = CommandLine.arguments
        
        while !arguments.isEmpty {
            let item = arguments.removeFirst()
            switch item {
            case "--ignore":
                if let regex = arguments.first {
                    regexps.append(regex)
                    arguments.removeFirst()
                }
            case "--skip-predefined-ignores":
                shouldSkipPredefinedIgnores = true
            default:
                continue
            }
        }
        
        if !shouldSkipPredefinedIgnores {
            regexps += ["^Pods/", "fastlane/", "Tests.swift$", "Spec.swift$", "Tests/"]
        }
        
        return regexps
    }
    
    func findUsagesInFiles(files: [String], xibs: [String], items: [Item]) {
        var items = items
        var usages = Array(repeating: 0, count: items.count)
        
        files.forEach { file in
            if let lines = try? String(contentsOfFile: file).components(separatedBy: .newlines) {
                let words = lines.joined(separator: "\n").components(separatedBy: CharacterSet.alphanumerics.inverted)
                let wordFrequency = Dictionary(words.map { ($0, 1) }, uniquingKeysWith: +)
                
                items.enumerated().forEach { i, item in usages[i] += wordFrequency[item.name ?? ""] ?? 0 }
                
                let indexesToRemove = usages.enumerated().filter { $0.element >= 2 }.map { $0.offset }
                indexesToRemove.sorted().reversed().forEach { i in
                    usages.remove(at: i)
                    items.remove(at: i)
                }
            }
        }
        
        xibs.forEach { xib in
            if let fullXML = try? String(contentsOfFile: xib) {
                let classes = fullXML.matchingStrings(regex: #"(class|customClass)="([^"]+)""#).map { $0[2] }
                let classFrequency = Dictionary(classes.map { ($0, 1) }, uniquingKeysWith: +)
                
                items.enumerated().forEach { i, item in
                    usages[i] += classFrequency[item.name ?? ""] ?? 0
                }
                
                let indexesToRemove = usages.enumerated().filter { $0.element >= 2 }.map { $0.offset }
                indexesToRemove.sorted().reversed().forEach { i in
                    usages.remove(at: i)
                    items.remove(at: i)
                }
            }
        }
        
        let regexps = ignoringRegexpsFromCommandLineArgs()
        items = ignoreFiles(with: regexps, from: items)
        
        if !items.isEmpty {
            if CommandLine.arguments.first == "xcode" {
                FileHandle.standardError.write(Data(items.map { $0.toXcode() }.joined(separator: "\n").utf8))
            } else {
                print(items.map { $0.serialize() }.joined(separator: "\n"))
            }
        }
    }
    
    func grabItems(file: String) -> [Item]? {
        guard let lines = try? String(contentsOfFile: file).components(separatedBy: .newlines) else { return nil }
        return lines.enumerated()
            .filter { $0.element.range(of: #"(class|enum|struct|protocol)\s+\w+"#, options: .regularExpression) != nil }
            .map { Item(file: file, line: $0.element, at: $0.offset) }
    }
    
    func filterItems(items: [Item]) -> [Item] {
        items.filter { item in
            !(item.name?.hasPrefix("test") ?? false) &&
            !item.modifiers.contains("@IBAction") &&
            !item.modifiers.contains("override") &&
            !item.modifiers.contains("@objc") &&
            !item.modifiers.contains("@IBInspectable")
        }
    }
}
                      
extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { index in
                result.range(at: index).location != NSNotFound ? nsString.substring(with: result.range(at: index)) : ""
            }
        }
    }
}
                      
let unused = Unused()
unused.find()
