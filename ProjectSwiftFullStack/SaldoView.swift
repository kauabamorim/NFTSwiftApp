import SwiftUI

struct SaldoView: View {
    @State private var saldo: Double = 1000.0
    
    var body: some View {
        VStack {
            Text("Main Account")
                .foregroundColor(.green)
                .font(.title)
                .padding()
            
            Text("R$ \(String(format: "%.2f", saldo))")
                .font(.headline)
                .font(.system(size: 50))
                .foregroundColor(saldo >= 0 ? .green : .red)
            
            Spacer()
        }
    }
}

struct SaldoView_Previews: PreviewProvider {
    static var previews: some View {
        SaldoView()
    }
}
