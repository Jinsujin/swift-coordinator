import SwiftUI

struct ViewB: View {
    @StateObject var coordinator = Coordinator()
    
    var body: some View {
        NavigationView {
            VStack {
                coordinator.navigationLink()
                Text("ViewB")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        coordinator.push(.mintView)
                    } label: {
                        Text("mint")
                    }
                }
                
                ToolbarItem {
                    Button {
                        coordinator.popToRoot()
                    } label: {
                        Text("PopRoot")
                    }
                }
            }
            .navigationBarTitle("Title")
        }
    }
}

struct ViewB_Previews: PreviewProvider {
    static var previews: some View {
        ViewB()
    }
}
