import Cocoa
import Charts

final class CoinMenuItemView: MenuItemView, NibLoadable {
    
    @IBOutlet var lineChartView: LineChartView!
    @IBOutlet private(set) var imageView: NSImageView!
    @IBOutlet private(set) var symbolLabel: NSTextField!
    @IBOutlet private(set) var priceLabel: NSTextField!
    @IBOutlet private(set) var percentChangeLabel: NSTextField!
    
    var data = LineChartData()
    
    func configure(with coin: Coin, currency: Preferences.Currency, imagesService: ImagesServiceProtocol) {
                
        // Symbol
        
        symbolLabel.stringValue = coin.symbol
        
        // Image
        
        imagesService.getImage(for: coin) { result in
            guard let image = result.value else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        
        
        // Chart
        
        // Do any additional setup after loading the view.
        let ys1 = Array(1..<10).map { x in return sin(Double(x) / 2.0 / 3.141 * 1.5) }
        let ys2 = Array(1..<10).map { x in return cos(Double(x) / 2.0 / 3.141) }
        
        let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        let yse2 = ys2.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        
        
        let ds1 = LineChartDataSet(values: yse1, label: "Hello")
        ds1.colors = [NSUIColor.red]
        data.addDataSet(ds1)
        
        let ds2 = LineChartDataSet(values: yse2, label: "World")
        ds2.colors = [NSUIColor.blue]
        data.addDataSet(ds2)
        self.lineChartView.data = data
        
        self.lineChartView.gridBackgroundColor = NSUIColor.white
        
        self.lineChartView.chartDescription?.text = "Linechart Demo"
        
        // Value label
        
        switch currency {
        
        case .bitcoin:
            if let priceBTC = coin.priceBTC {
                priceLabel.stringValue = currency.formattedValue(priceBTC) ?? ""
            } else {
                priceLabel.stringValue = ""
            }
            
        case .unitedStatesDollar:
            if let priceUSD = coin.priceUSD {
                priceLabel.stringValue = currency.formattedValue(priceUSD) ?? ""
            } else {
                priceLabel.stringValue = ""
            }
        
        default:
            if let pricePreferredCurrency = coin.pricePreferredCurrency {
                priceLabel.stringValue = currency.formattedValue(pricePreferredCurrency) ?? ""
            } else {
                priceLabel.stringValue = ""
            }
        }

        // Percent change label
        
        if let percentChange = coin.percentChange1h {
            
            switch Double(percentChange) {
                
            case let positive? where positive > 0.0:
                percentChangeLabel.stringValue = "\(percentChange)%"
                percentChangeLabel.textColor = NSColor.green
                
            case let negative? where negative < 0.0:
                percentChangeLabel.stringValue = "\(percentChange)%"
                percentChangeLabel.textColor = NSColor.red
                
            case let zero? where zero == 0.0:
                percentChangeLabel.stringValue = "\(percentChange)%"
                
            default:
                percentChangeLabel.stringValue = "-"
                percentChangeLabel.textColor = NSColor.red
            }
        }
            
        else {
            percentChangeLabel.stringValue = "-"
        }
        
    }
}

