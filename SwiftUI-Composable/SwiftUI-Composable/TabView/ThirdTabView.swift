import ComposableArchitecture
import SwiftUI

struct ThirdTabFeature: ReducerProtocol {
    struct State: Equatable {}
    enum Action: Equatable {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        
    }
}

struct ThirdTabView: View {
    let store: StoreOf<ThirdTabFeature>
    
    var body: some View {
        Text("Third")
    }
}
