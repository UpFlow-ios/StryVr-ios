import SwiftUI

struct StryVrLaunchScreenView: View {
    @State private var animationPhase: AnimationPhase = .initial
    @State private var circle1Opacity: Double = 0
    @State private var circle2Opacity: Double = 0
    @State private var circle3Opacity: Double = 0
    @State private var circle4Opacity: Double = 0
    @State private var circle5Opacity: Double = 0
    @State private var circle6Opacity: Double = 0
    @State private var circle7Opacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var vesicaPiscisOpacity: Double = 0

    private let animationDuration: Double = 4.5
    private let circleRadius: CGFloat = 60

    enum AnimationPhase {
        case initial
        case firstCircle
        case secondCircle
        case vesicaPiscis
        case flowerOfLife
        case complete
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Solid black background
                Color.black
                    .ignoresSafeArea()

                // Sacred Geometry Circles
                ZStack {
                    // Circle 1 (Center)
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: circleRadius * 2, height: circleRadius * 2)
                        .opacity(circle1Opacity)

                    // Circle 2 (Overlapping to form Vesica Piscis)
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: circleRadius * 2, height: circleRadius * 2)
                        .offset(x: circleRadius * 0.866)  // cos(30°) * radius for perfect overlap
                        .opacity(circle2Opacity)

                    // Vesica Piscis Fill (Purple almond shape)
                    VesicaPiscisShape()
                        .fill(Color.purple.opacity(0.3))
                        .frame(width: circleRadius * 2, height: circleRadius * 2)
                        .opacity(vesicaPiscisOpacity)

                    // Circle 3 (Top Left) - Perfect Flower of Life positioning
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: circleRadius * 2, height: circleRadius * 2)
                        .offset(x: -circleRadius * 0.866, y: -circleRadius * 0.5)
                        .opacity(circle3Opacity)

                    // Circle 4 (Bottom Left) - Perfect Flower of Life positioning
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: circleRadius * 2, height: circleRadius * 2)
                        .offset(x: -circleRadius * 0.866, y: circleRadius * 0.5)
                        .opacity(circle4Opacity)

                    // Circle 5 (Top Right) - Perfect Flower of Life positioning
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: circleRadius * 2, height: circleRadius * 2)
                        .offset(x: circleRadius * 0.866, y: -circleRadius * 0.5)
                        .opacity(circle5Opacity)

                    // Circle 6 (Bottom Right) - Perfect Flower of Life positioning
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: circleRadius * 2, height: circleRadius * 2)
                        .offset(x: circleRadius * 0.866, y: circleRadius * 0.5)
                        .opacity(circle6Opacity)

                    // Circle 7 (Center Bottom) - Perfect Flower of Life positioning
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: circleRadius * 2, height: circleRadius * 2)
                        .offset(x: 0, y: circleRadius)
                        .opacity(circle7Opacity)
                }

                // "stryvr" Text
                Text("stryvr")
                    .font(.system(size: 24, weight: .light, design: .default))
                    .foregroundColor(.white)
                    .opacity(textOpacity)
            }
        }
        .onAppear {
            startAnimation()
        }
    }

    private func startAnimation() {
        // 00:00.00 - 00:00.80: Cinematic pause
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            // 00:00.80 - 00:01.10: First circle and text fade in
            withAnimation(.easeInOut(duration: 0.3)) {
                circle1Opacity = 1
                textOpacity = 1
            }
        }

        // 00:01.10 - 00:01.30: Second circle appears
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            withAnimation(.easeInOut(duration: 0.2)) {
                circle2Opacity = 1
            }
        }

        // 00:01.30 - 00:01.50: Vesica Piscis fill appears
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            withAnimation(.easeInOut(duration: 0.2)) {
                vesicaPiscisOpacity = 1
            }
        }

        // 00:01.50 - 00:02.10: Flower of Life circles appear one by one
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.2)) {
                circle3Opacity = 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            withAnimation(.easeInOut(duration: 0.2)) {
                circle4Opacity = 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
            withAnimation(.easeInOut(duration: 0.2)) {
                circle5Opacity = 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            withAnimation(.easeInOut(duration: 0.2)) {
                circle6Opacity = 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
            withAnimation(.easeInOut(duration: 0.2)) {
                circle7Opacity = 1
            }
        }
    }
}

// Custom shape for Vesica Piscis (almond shape)
struct VesicaPiscisShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        var path = Path()

        // Create the vesica piscis using two overlapping circles
        let circle1 = CGPoint(x: center.x - radius * 0.433, y: center.y)  // cos(30°) * radius
        let circle2 = CGPoint(x: center.x + radius * 0.433, y: center.y)

        // Create the almond shape by intersecting two circles
        let circle1Rect = CGRect(
            x: circle1.x - radius, y: circle1.y - radius, width: radius * 2, height: radius * 2)
        let circle2Rect = CGRect(
            x: circle2.x - radius, y: circle2.y - radius, width: radius * 2, height: radius * 2)

        // Draw the intersection area (vesica piscis)
        path.addEllipse(in: circle1Rect)
        path.addEllipse(in: circle2Rect)

        return path
    }
}

#Preview {
    StryVrLaunchScreenView()
}
