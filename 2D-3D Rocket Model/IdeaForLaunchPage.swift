import SwiftUI
import Charts

struct ContentView: View {
    @State private var location = "N/A"
    @State private var speed: Double = 0.0
    @State private var altitude: Double = 0.0
    @State private var temperature: Double = 0.0
    @State private var pressure: Double = 0.0
    @State private var position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    @State private var rotation: Double = 0

    // Timer for data updates
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    // Temperature data for chart (with example values)
    @State private var temperatureData: [TemperatureData] = [
        TemperatureData(date: Date().addingTimeInterval(-3600 * 4), value: 22),
        TemperatureData(date: Date().addingTimeInterval(-3600 * 3), value: 23)
    ]

    
    // The amount of movement and tilt
    let moveAmount: CGFloat = 10
    let tiltAmount: Double = 10
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Launch")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                
                MetricCard(title: "GPS Location", value: location, icon: "location.circle.fill")
                MetricCard(title: "Speed", value: String(format: "%.4f m/s", speed), icon: "speedometer")
                MetricCard(title: "Altitude", value: String(format: "%.4f meters", altitude), icon: "airplane")
                MetricCard(title: "Temperature", value: String(format: "%.4f°C", temperature), icon: "thermometer")
                MetricCard(title: "Pressure", value: String(format: "%.4f hPa", pressure), icon: "gauge.high")
            }
            .onAppear {
                updateData()
            }
            .onReceive(timer) { _ in
                updateData()
            }
            .navigationTitle("Device Details")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
        RocketView(bodyColors: [.black, .gray], finColors: [.orange, .yellow], noseColors: [.orange, .yellow])
            .position(position)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                // Configure the timer
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                    
                    // Randomly move and tilt the rocket
                    withAnimation(.easeInOut(duration: 0.5)) {
                        position = CGPoint(
                            x: position.x + CGFloat.random(in:-moveAmount...moveAmount),
                            y: position.y + CGFloat.random(in:-moveAmount...moveAmount)
                        )
                        rotation = rotation + Double.random(in: -tiltAmount...tiltAmount)
                    }
                }
            }
    }
    func updateData() {
        // Example updates
        location = "40.7128° N, 74.0060° W"
        speed = Double.random(in: 0...30).rounded(toPlaces: 4)
        altitude = Double.random(in: 0...500).rounded(toPlaces: 4)
        temperature = Double.random(in: 10...30).rounded(toPlaces: 4)
        pressure = Double.random(in: 980...1050).rounded(toPlaces: 4)
    }
}



// Extension for rounding Double values
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

    
// Example Metric Card View
struct MetricCard: View {
    var title: String
    var value: String
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
            }
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemBackground)))
        .shadow(radius: 5)
    }
}

// Example Data and Constants
struct TemperatureData {
    let date: Date
    let value: Double
}

struct RocketView: View {
    
    // Color properties for customization
    var bodyColors: [Color] = [.gray, .white]
    var finColors: [Color] = [.white, .gray]
    var noseColors: [Color] = [.white, .gray]
    
    var body: some View {
        ZStack {
            // Rocket body
            RocketBody()
                .fill(LinearGradient(gradient: Gradient(colors: bodyColors), startPoint: .leading, endPoint: .trailing))
                .frame(width: 100, height: 300)
                .shadow(radius: 5)
            
            // Rocket bottom fins
            RocketFin()
                .fill(LinearGradient(gradient: Gradient(colors: finColors), startPoint: .top, endPoint: .bottom))
                .frame(width: 150, height: 50)
                .rotationEffect(.degrees(120))
                .offset(x: -65, y: 120)
                .shadow(radius: 5)
            
            RocketFin()
                .fill(LinearGradient(gradient: Gradient(colors: finColors), startPoint: .top, endPoint: .bottom))
                .frame(width: 150, height: 50)
                .rotationEffect(.degrees(-120))
                .offset(x: 65, y: 120)
                .shadow(radius: 5)
            
            // Rocket nose cone
            RocketNose()
                .fill(LinearGradient(gradient: Gradient(colors: noseColors), startPoint: .bottom, endPoint: .top))
                .frame(width: 100, height: 100)
                .offset(y: -170)
                .shadow(radius: 5)
        }
    }
}

// Rocket body - Cylinder shape
struct RocketBody: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: rect.width / 2, height: rect.height / 2))
        return path
    }
}

// Rocket fin - Triangle shape
struct RocketFin: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}


// Rocket nose - Cone shape
struct RocketNose: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}


let temperatureData = [
    TemperatureData(date: Date().addingTimeInterval(-3600 * 4), value: 22),
    TemperatureData(date: Date().addingTimeInterval(-3600 * 3), value: 23),
    // Add more data points
]

let temperatureDomain = 0.0...30.0

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
