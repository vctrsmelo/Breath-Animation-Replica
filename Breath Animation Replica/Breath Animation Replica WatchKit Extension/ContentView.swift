//
//  ContentView.swift
//  Breath Animation Replica WatchKit Extension
//
//  Created by Victor Melo on 04/03/20.
//  Copyright © 2020 Victor Melo. All rights reserved.
//

/*
 
 - uma view por pétala (6 pétalas)
    - círculo
    - animações:
        - scale
 - uma view que compõe as pétalas
    - animações:
        - girar
 
 Baby steps:
 - Criar uma pétala com degradê e opacidade
 - Fazer a pétala aumentar e diminuir (com eixo em baixo)
 - Criar 6 pétalas rotacionando em torno de um eixo central
 - Fazer o merge da pétala ser cor somativa (fica branca)
 
 */

import SwiftUI

extension Animation {
    static let breathe = Animation.easeInOut(duration: 5).repeatForever(autoreverses: true)
}

extension Color {
    static let petalColor1 = Color(red: 125/255, green: 218/255, blue: 160/255)
    static let petalColor2 = Color(red: 84/255, green: 161/255, blue: 176/255)
}

struct Petal: View {
    
    let geometry: GeometryProxy
    
    
    @State private var isSmall = true
    
    let petalGradient = Gradient(colors: [.petalColor1, .petalColor2])
    
    var body: some View {
        Circle()
            .fill(LinearGradient(gradient: petalGradient, startPoint: .top, endPoint: .bottom))
            .scaleEffect(isSmall ? 1 : 2, anchor: .top)
            .opacity(0.1)
            .blendMode(.plusLighter)
            .position(x: geometry.size.width/2, y: isSmall ? geometry.size.height/2 : geometry.size.height)
            .onAppear {
                withAnimation(Animation.breathe, {
                    self.isSmall.toggle()
                })
            }
    }
}

struct Flower: View {
    
    let numberOfPetals = 32
    
    @State private var isSmall = true
    
    var body: some View {
        Group {
            GeometryReader { geo in
                ForEach(0..<self.numberOfPetals) { i in
                    Group {
                        Petal(geometry: geo)
                    }
                    .rotationEffect(.degrees(Double(i * self.numberOfPetals*10)))
                }
            }
        }
        .frame(width: 35, height: 35, alignment: .center)
        .rotationEffect(Angle.degrees(isSmall ? 0 : 90), anchor: .center)
        .onAppear {
            withAnimation(Animation.breathe, {
                self.isSmall.toggle()
            })
        }
    }
}



struct ContentView: View {
    var body: some View {
        Flower()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
