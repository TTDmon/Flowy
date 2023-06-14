

import SwiftUI
import OpenAISwift

final class ViewModel: ObservableObject{
    init(){}

    private var client: OpenAISwift?

    func setup(){
        client = OpenAISwift(authToken: "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")
    }

    func send(text: String, completion: @escaping(String) -> Void){
        client?.sendCompletion(with: text,
                               completionHandler: {result in // Result<OpenAI, OpenAIError>
                                                   switch result {
                                                       case .success(let success):
                                                       let output = success.choices?.first?.text ?? ""
                                                       completion(output)
                                                       case .failure(let failure):
                                                       let output = failure.localizedDescription
                                                       completion(output)
                                                   }
                                                  })
    }
}


struct gptView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(models, id: \.self){
                string in Text(string)
            }

            Spacer()

            HStack{
                TextField("Type here ...", text: $text)
                Button("Send"){
                    send()
                }
            }
        }
        .onAppear{
            viewModel.setup()
        }
        .padding()
    }

    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        models.append("Me: \(text)")
        viewModel.send(text: text){
            response in DispatchQueue.main.async {
                self.models.append("ChatGPT: " + response)
                self.text = ""
            }
        }
    }
}

struct gptView_Previews: PreviewProvider {
    static var previews: some View {
        gptView()
    }
}
