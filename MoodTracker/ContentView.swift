//
//  ContentView.swift
//  MoodTracker
//
//  Created by Mahta Moezzi on 16/05/2025.
//


import SwiftUI

struct MoodEntry: Identifiable, Codable {
    let id = UUID()
    let emoji: String
    let note: String
    let date: Date
}

struct ContentView: View {
    @State private var selectedMood: String = ""
    @State private var note: String = ""
    @State private var moodHistory: [MoodEntry] = []
    
    let moodOptions = ["😊", "😢", "😠", "😴", "😐", "🥳"]
    
    var body: some View {
        return NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.6), .purple.opacity(0.4)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Text("How do you feel today?")
                        .font(.title2)
                        .bold()
                    Button(role: .destructive) {
                        moodHistory.removeAll()
                        saveToUserDefaults()
                    } label: {
                        Text("Clear All History")
                            .foregroundColor(.red)
                    }
                    .padding(.top)
                    
                    
                    // Mood Picker
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(moodOptions, id: \.self) { mood in
                                Text(mood)
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(selectedMood == mood ? Color.blue.opacity(0.2) : Color.clear)
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        selectedMood = mood
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    
                    // Optional note
                    TextField("Add a short note...", text: $note)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Save button
                    Button(action: saveMood) {
                        Text("Save Mood")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // History
                    if !moodHistory.isEmpty {
                        List(moodHistory.reversed()) { entry in
                            VStack(alignment: .leading) {
                                Text(entry.emoji)
                                    .font(.largeTitle)
                                Text(entry.note)
                                    .font(.body)
                                Text(formattedDate(entry.date))
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                
                            }
                            .padding(.vertical, 4)
                            
                        }
                        .background(Color.clear)
                    } else {
                        Text("No moods saved yet.")
                            .foregroundColor(.gray)
                            .padding(.top)
                            
                    }
                }
                .padding()
                .navigationTitle("Mood Tracker")
            }
            .onAppear {
                loadMoodHistory()
            }
        }
        
        // MARK: - Save + Load
        func saveMood() {
            guard !selectedMood.isEmpty else { return }
            let newEntry = MoodEntry(emoji: selectedMood, note: note, date: Date())
            moodHistory.append(newEntry)
            saveToUserDefaults()
            note = ""
            selectedMood = ""
        }
        
        func saveToUserDefaults() {
            if let data = try? JSONEncoder().encode(moodHistory) {
                UserDefaults.standard.set(data, forKey: "moodHistory")
            }
        }
        
        func loadMoodHistory() {
            if let data = UserDefaults.standard.data(forKey: "moodHistory"),
               let saved = try? JSONDecoder().decode([MoodEntry].self, from: data) {
                moodHistory = saved
            }
        }
        
        func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    }
}
