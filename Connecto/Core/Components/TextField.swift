import SwiftUI

struct customField: View {
    
    let title: String
    let placeholder: String
    let icon: String
    
    @Binding var text: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            HStack {
                
                Image(systemName: icon)
                    .foregroundColor(.white)
                
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.15))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.15))
            )
        }
    }
}
