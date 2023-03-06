import SwiftUI

struct CoordinateWithListView: View {
    let colors: [Color] = [.mint, .pink, .teal]
    @State private var selection: Color?
    
    var body: some View {
        NavigationSplitView {
            List(colors, id: \.self, selection: $selection) { color in
                NavigationLink(color.description, value: color)
            }
        } detail: {
            if let color = selection {
                ColorDetail(color: color)
            } else {
                Text("Pick a color")
            }
        }
    }
}

struct CoordinateWithListView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinateWithListView()
    }
}
