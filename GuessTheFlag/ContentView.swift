//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Massa Antonio on 12/05/21.
//

import SwiftUI

struct FlagImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var isCorrect = false
    @State private var isWrong = false
    @State private var selectedNumber = 0
    @State private var fadeOutOpacity = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .font(.title)
                    
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        withAnimation {
                            self.flagTapped(number)
                        }
                        
                    }) {
                        FlagImage(image: self.countries[number])
                        
                    }
                    .rotation3DEffect(.degrees(self.isCorrect && self.selectedNumber == number ? 360 : 0),
                                      axis: (x: 0, y: 1, z: 0))
                    .opacity(self.fadeOutOpacity && !(self.selectedNumber == number) ? 0.25 : 1)
                    .rotation3DEffect(.degrees(self.isWrong && self.selectedNumber == number ? 90 : 0),
                                      axis: (x: 0, y: 0, z: 0.5))
                }
                HStack {
                    Text("Your score is: \(userScore)")
                        .foregroundColor(.black)
                        .font(.title)
                        .fontWeight(.black)
                }
                Spacer()
            }
            
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is: \(userScore)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        self.selectedNumber = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
            isCorrect = true
            fadeOutOpacity = true
        } else {
            scoreTitle = "Wrong! This is \(countries[number])'s flag!"
            userScore -= 1
            isWrong = true
            fadeOutOpacity = true
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        isCorrect = false
        fadeOutOpacity = false
        isWrong = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
