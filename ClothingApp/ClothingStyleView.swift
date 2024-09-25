import SwiftUI

struct ClothingStyleView: View {
    var style: ApparelStyle
    @ObservedObject var viewModel: ClothingViewModel
    
    var body: some View {
        VStack {
            Text(style.name)
            Spacer()
            Button("Нравится") {
                //тут логику прописать надо
            }
            Button("Не нравится") {
                //тут логику прописать надо
            }
        }
    }
}
