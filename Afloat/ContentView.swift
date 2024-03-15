//
//  ContentView.swift
//  Afloat
//
//  Created by Michael DiBenigno on 2/23/24.
//
import SwiftUI
import RealityKit
import RealityKitContent
import GroupActivities
import WebKit
import Contacts



struct ContentView: View {

    @ObservedObject private var vm = WebViewModel()

    var body: some View {
        VStack {
            //Balls()

            WebView(viewModel: vm)
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .onAppear {
                    vm.webView.load(URLRequest(url: URL(string: "https://afriend.fly.dev/")!))
                  }
            //oldLinkReference "https://lil.software/widgets/selfie.html"
            Button("+ Add to Contacts") {
                // Create a mutable object to add to the contact.
                // Mutable object means an object state that can be modified after created.
                let contact = CNMutableContact()
                // Name
                contact.givenName = "Kyle"
                // Phone No.
                contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: "12345678"))]
                // Save the created contact.
                let store = CNContactStore()
                let saveRequest = CNSaveRequest()
                saveRequest.add(contact, toContainerWithIdentifier: nil)
                do {
                    try store.execute(saveRequest)
                } catch {
                    print("Error occur: \(error)")
                    // Handle error
                    // may add a alert...
                }
            }
            Link("FaceTime New Friend", destination: URL(string: "facetime://4383655577")!)
                            .buttonStyle(.borderedProminent)
//            Button("Create Ballooon") {
//               
//            }
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .clipShape(Capsule())
//            
            //Model3D(named: "Scene",bundle:realityKitContentBundle)
        }
    }
}

struct MyVolumeActivity: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.type = .generic
        metadata.title = NSLocalizedString("Balloon R Us", comment: "Let's play with balloons together")
        // Customize metadata as needed
        return metadata
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
            let x = Float.random(in: -0.45...0.45)
            let y = Float.random(in: -0.3...0.3)
            let z = Float.random(in: -0.2...0.2)
            model.position = SIMD3(x,y,z)
            
            // Enable interactions on the entity
            model.components.set(InputTargetComponent())
            model.components.set(CollisionComponent(shapes:[.generateSphere(radius: 0.025)]))
            content.add(model)
        }
        } update: { content in
            content.entities.forEach { entity in
                entity.transform.scale = SIMD3<Float>(scale, scale,scale)
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
