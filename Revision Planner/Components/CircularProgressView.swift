import SwiftUI

struct CircularProgressView: View {

    var progress: Double
    var progressText: String
    var color: Color = Color.orange


    var body: some View {
        
        if(progressText != "Completed") {
            ZStack {
                Circle()
                    .stroke(Color(.systemGray4), lineWidth: 5)
                Circle()
                    .trim(from: 0, to: CGFloat(self.progress))
                    .stroke(
                        color,
                        style: StrokeStyle(lineWidth: 5, lineCap: .round
                        )
                    )
            }
            .rotationEffect(Angle(degrees: 270))
            .overlay(
                Text(progressText).font(Font.largeTitle.monospacedDigit())
            )
        }
        else {
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray4), lineWidth: 5)
                    Circle()
                        .trim(from: 0, to: CGFloat(self.progress))
                        .stroke(
                            color,
                            style: StrokeStyle(lineWidth: 5, lineCap: .round
                            )
                        )
                }
                .rotationEffect(Angle(degrees: 270))
                .overlay(
                    Label("Completed", systemImage: "checkmark.circle").font(.title3)
            )
        }
    }
}
