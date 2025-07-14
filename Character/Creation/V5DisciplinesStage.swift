import SwiftUI




// V5 Disciplines Creation Stage
struct V5DisciplinesStage<T: DisciplineCapable>: View {
    @Binding var character: T
    @State private var showingAddDiscipline = false
    @State private var selectedDiscipline: V5Discipline?
    @State private var showingDisciplineDetail = false
    @State private var refreshID: UUID = UUID()
    
    var body: some View {
        Form {
            Section(header: Text("V5 Disciplines")) {
                if character.v5Disciplines.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("No disciplines selected")
                            .foregroundColor(.secondary)
                        
                        Text("Disciplines grant supernatural powers to your vampire. Each discipline has multiple powers per level that you can choose from.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    let sortedDisciplines: [V5Discipline] = character.v5Disciplines.sorted(by: { $0.name < $1.name })

                    ForEach(sortedDisciplines) { discipline in
                        V5DisciplineRowView(
                            character: $character,
                            discipline: discipline,
                            isEditing: true,
                            selectedDiscipline: $selectedDiscipline,
                            showingDisciplineDetail: $showingDisciplineDetail,
                            refreshID: $refreshID
                        )
                    }
                }
                
                Button("Add Discipline") {
                    showingAddDiscipline = true
                }
                .foregroundColor(.accentColor)
            }
            
            Section(footer: Text("Disciplines are optional for character creation. You can add and modify them later. Select multiple powers per level as desired.")) {
                EmptyView()
            }
        }
        .sheet(isPresented: $showingAddDiscipline) {
            V5AddDisciplineView(character: $character)
        }
        .sheet(isPresented: $showingDisciplineDetail) {
            if let selected = selectedDiscipline {
                V5DisciplineDetailView(
                    character: $character,
                    disciplineName: selected.name,
                    isEditing: true
                )
            }
        }
    }
}
