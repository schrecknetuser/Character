import SwiftUI

struct ClanSelectionStage: View {
    @Binding var character: Character
    
    var body: some View {
        Form {
            Section(header: Text("Select Clan")) {
                ForEach(V5Constants.clans, id: \.self) { clan in
                    HStack {
                        Button(action: {
                            character.clan = clan
                        }) {
                            HStack {
                                Image(systemName: character.clan == clan ? "circle.fill" : "circle")
                                    .foregroundColor(character.clan == clan ? .accentColor : .secondary)
                                Text(clan)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            Section(footer: Text("You must select a clan to proceed.")) {
                EmptyView()
            }
        }
    }
}
