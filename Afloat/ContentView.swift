//
//  ContentView.swift
//  Afloat
//
//  Created by Michael DiBenigno on 2/23/24.
//
import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    // Initialize as blank

    var body: some View {
        VStack {
            Button("Create Ballooon") {
               
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            //Model3D(named: "Scene",bundle:realityKitContentBundle)
            Balls()
        }
    }
}

struct Balls: View{
    @State private var scale: Float = 1.0
    @State private var growing: Bool = false
    @State private var timer: Timer? = nil

var body: some View{
    RealityView { content in
        // Generate multiple spheres
        for _ in 1...5 {
            let model = ModelEntity(
                mesh: .generateSphere(radius: 0.025),
                materials: [SimpleMaterial(color: .red, isMetallic: true)]
            )
            let x = Float.random(in: -0.2...0.2)
            let y = Float.random(in: -0.2...0.2)
            let z = Float.random(in: -0.2...0.2)
            model.position = SIMD3(x,y,z)
            
            // Enable interactions on the entity
            model.components.set(InputTargetComponent())
            model.components.set(CollisionComponent(shapes:[.generateSphere(radius: 0.025)]))
            content.add(model)
        }
        } update: { content in
            content.entities.forEach { entity in
                entity.transform.scale = SIMD3<Float>(scale, scale, scale)
            }
        }
        .gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
            self.growing = !self.growing
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if self.growing {
                    if self.scale < 4.0 {
                        self.scale += 0.05
                    } else {
                        self.timer?.invalidate()
                    }
                } else {
                    if self.scale > 1.0 {
                        self.scale -= 0.05
                    } else {
                        self.timer?.invalidate()
                    }
                }
            }
        })
}
}


#Preview(windowStyle: .volumetric) {
    ContentView()
}
