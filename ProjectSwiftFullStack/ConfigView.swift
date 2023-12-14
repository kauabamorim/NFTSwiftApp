import SwiftUI

struct ConfigView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isEditingName = false
    @State private var name = "Nome Pessoa"
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(uiImage: selectedImage ?? UIImage(systemName: "person.circle.fill")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .onTapGesture {
                            isImagePickerPresented = true
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImagePicker(selectedImage: $selectedImage, isPresented: $isImagePickerPresented)
                        }
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            if isEditingName {
                                TextField("Digite o nome", text: $name)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onSubmit {
                                        isEditingName = false
                                    }
                            } else {
                                Text(name)
                                    .font(.headline)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                isEditingName.toggle()
                            }) {
                                Image(systemName: "pencil")
                                    .imageScale(.large)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                Divider()
                
                Toggle("Modo Escuro", isOn: $isDarkMode)
                
                Spacer()
            }
            .padding()
        }
    }
}
