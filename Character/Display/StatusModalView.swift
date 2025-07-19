import SwiftUI

struct StatusModalView: View {
    @Binding var character: any BaseCharacter
    @Binding var isPresented: Bool
    @ObservedObject var store: CharacterStore
    
    @State private var draftCharacter: BaseCharacter?
    @State private var refreshID = UUID()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        statusContent(geometry: geometry)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Status")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        cancelChanges()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                }
            }
        }
        .onAppear {
            // Create draft character for editing
            draftCharacter = character.clone()
        }
    }
    
    @ViewBuilder
    private func statusContent(geometry: GeometryProxy) -> some View {
        if let draft = draftCharacter {
            let baseBinding: Binding<any BaseCharacter> = Binding<any BaseCharacter>(
                get: { draft },
                set: { newValue in draftCharacter = newValue }
            )
            
            switch character.characterType {
            case .vampire:
                if let vampireDraft = draft as? VampireCharacter {
                    let vampireBinding = Binding<VampireCharacter>(
                        get: { vampireDraft },
                        set: { updated in draftCharacter = updated }
                    )
                    vampireStatusContent(vampire: vampireBinding, base: baseBinding, geometry: geometry)
                }
            case .ghoul:
                if let ghoulDraft = draft as? GhoulCharacter {
                    let ghoulBinding = Binding<GhoulCharacter>(
                        get: { ghoulDraft },
                        set: { updated in draftCharacter = updated }
                    )
                    ghoulStatusContent(ghoul: ghoulBinding, base: baseBinding, geometry: geometry)
                }
            case .mage:
                if let mageDraft = draft as? MageCharacter {
                    let mageBinding = Binding<MageCharacter>(
                        get: { mageDraft },
                        set: { updated in draftCharacter = updated }
                    )
                    mageStatusContent(mage: mageBinding, base: baseBinding, geometry: geometry)
                }
            }
        }
    }
    
    @ViewBuilder
    private func vampireStatusContent(vampire: Binding<VampireCharacter>, base: Binding<any BaseCharacter>, geometry: GeometryProxy) -> some View {
        EditableStatusRowView(
            character: base,
            title: "Health",
            type: .health,
            availableWidth: geometry.size.width - 40,
            onChange: { refresh() }
        )
        EditableStatusRowView(
            character: base,
            title: "Willpower",
            type: .willpower,
            availableWidth: geometry.size.width - 40,
            onChange: { refresh() }
        )
        EditableHumanityRowView(
            character: vampire,
            availableWidth: geometry.size.width - 40,
            onChange: { refresh() }
        )
        EditableHungerRowView(
            character: vampire,
            availableWidth: geometry.size.width - 40,
            onChange: { refresh() }
        )
        EditableGenerationRowView(
            character: vampire,
            onChange: { refresh() }
        )
        EditableBloodPotencyRowView(
            character: vampire,
            onChange: { refresh() }
        )
    }
    
    @ViewBuilder
    private func ghoulStatusContent(ghoul: Binding<GhoulCharacter>, base: Binding<any BaseCharacter>, geometry: GeometryProxy) -> some View {
        EditableStatusRowView(
            character: base,
            title: "Health",
            type: .health,
            availableWidth: geometry.size.width - 40,
            onChange: { refresh() }
        )
        EditableStatusRowView(
            character: base,
            title: "Willpower",
            type: .willpower,
            availableWidth: geometry.size.width - 40,
            onChange: { refresh() }
        )
        EditableHumanityRowView(
            character: ghoul,
            availableWidth: geometry.size.width - 40,
            onChange: { refresh() }
        )
    }
    
    @ViewBuilder
    private func mageStatusContent(mage: Binding<MageCharacter>, base: Binding<any BaseCharacter>, geometry: GeometryProxy) -> some View {
        EditableStatusRowView(
            character: base,
            title: "Health",
            type: .health,
            availableWidth: geometry.size.width - 40,
            onChange: { refresh() }
        )
        EditableStatusRowView(
            character: base,
            title: "Willpower",
            type: .willpower,
            availableWidth: geometry.size.width - 40,
            onChange: { refresh() }
        )
        EditableMageTraitRowView(
            character: mage,
            title: "Hubris",
            traitType: .hubris,
            availableWidth: geometry.size.width - 40,
            onChange: { refresh() }
        )
        EditableMageTraitRowView(
            character: mage,
            title: "Quiet",
            traitType: .quiet,
            availableWidth: geometry.size.width - 40,
            onChange: { refresh() }
        )
        EditableParadoxRowView(
            character: mage,
            availableWidth: geometry.size.width - 40,
            onChange: { refresh() }
        )
        EditableAreteRowView(
            character: mage,
            onChange: { refresh() }
        )
        EditableQuintessenceRowView(
            character: mage,
            availableWidth: geometry.size.width - 40,
            onChange: { refresh() }
        )
    }
    
    private func refresh() {
        refreshID = UUID()
    }
    
    private func saveChanges() {
        if let draft = draftCharacter {
            let summary = character.generateChangeSummary(for: draft)
            if !summary.isEmpty {
                let logEntry = ChangeLogEntry(summary: summary)
                draft.changeLog.append(logEntry)
            }
            character = draft
            store.updateCharacter(character)
        }
        isPresented = false
    }
    
    private func cancelChanges() {
        // Discard changes
        draftCharacter = nil
        isPresented = false
    }
}
