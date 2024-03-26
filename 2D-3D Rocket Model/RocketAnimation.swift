import SwiftUI

struct ContentView: View {
    // The position state of the rocket
    @State private var position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    
    // The rotation state of the rocket (in degrees)
    @State private var rotation: Double = 0
    
    // The amount of movement and tilt
    let moveAmount: CGFloat = 10
    let tiltAmount: Double = 10
    
    var body: some View {
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


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
