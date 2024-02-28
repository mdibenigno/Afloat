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
    @State private var scale: Float = 1.0
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack {
            RealityView { content in
                // Generate multiple balloons
                for _ in 1...5 {
                    let model = ModelEntity(
                        mesh: .generateSphere(radius: 0.025),
                        materials: [SimpleMaterial(color: .red, isMetallic: true)]
                    )
                    
                    // Set the physics body to be a dynamic body with a mass of 1
                    model.components[PhysicsBodyComponent] = PhysicsBodyComponent(shapes: model.collision!.shapes, mass: 1, material: .default, mode: .dynamic)
                    
                    // Set the physics motion to be affected by forces and collisions
                    model.components[PhysicsMotionComponent] = PhysicsMotionComponent()
                    
                    let x = Float.random(in: -0.2...0.2)
                    let y = Float.random(in: 0.5...1.0) // eye level or above
                    let z = Float.random(in: -0.2...0.2)
                    model.position = SIMD3(x, y, z)
                    
                    // Enable interactions on the entity
                    model.components.set(InputTargetComponent())
                    model.components.set(CollisionComponent(shapes:[.generateSphere(radius: 0.025)]))
                    content.add(model)
                }
                
                // Start a timer to apply a random force to each balloon every second
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    content.entities.forEach { entity in
                        if let physicsBody = entity.components[PhysicsBodyComponent.self], var physicsMotion = entity.components[PhysicsMotionComponent.self] {
                            let force = SIMD3<Float>(Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1))
                            physicsMotion.linearVelocity += force / physicsBody.mass // Assuming force is applied for 1 second
                            entity.components[PhysicsMotionComponent.self] = physicsMotion
                        }
                    }
                }
            } update: { content in
                content.entities.forEach { entity in
                    entity.transform.scale = SIMD3<Float>(scale, scale * 2, scale)
                }
            }
            
            Button("Fetch Weather") {
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                    if self.scale < 2.0 {
                        self.scale += 0.01
                    } else {
                        self.timer?.invalidate()
                        self.timer = nil
                    }
                }
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
