//
//  ARWrapper.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 4/6/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ARWrapper: UIViewRepresentable {
    @Binding var submittedExportRequest: Bool
    @Binding var exportedURL: URL?
    
    let arView = ARView(frame: .zero)
    
    func makeUIView(context: Context) -> ARView {
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        let vm = ExportViewModel()
        setARViewOptions(arView)
        let configuration = buildConfigure()
        arView.session.run(configuration)
        
        if submittedExportRequest {
            guard let camera = arView.session.currentFrame?.camera else { return }
            if let meshAnchors = arView.session.currentFrame?.anchors.compactMap( { $0 as? ARMeshAnchor } ),
               let asset = vm.convertToAsset(meshAnchors: meshAnchors, camera: camera) {
                do {
                    let url = try vm.export(asset: asset)
                    exportedURL = url
                } catch {
                    print("Export error: ", error)
                }
            }
        }
    }
    
    private func buildConfigure() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.environmentTexturing = .manual
        configuration.sceneReconstruction = .meshWithClassification
        
        arView.automaticallyConfigureSession = false
        
        if type(of: configuration).supportsFrameSemantics(.sceneDepth) {
            configuration.frameSemantics = .sceneDepth
        }
        
        return configuration
    }
    
    private func setARViewOptions(_ arView: ARView) {
        arView.debugOptions.insert(.showSceneUnderstanding)
    }
}

class ExportViewModel: NSObject, ObservableObject, ARSessionDelegate {

    func convertToAsset(meshAnchors: [ARMeshAnchor], camera: ARCamera) -> MDLAsset? {
        guard let device = MTLCreateSystemDefaultDevice() else { return nil }
        let asset = MDLAsset()
        for anchor in meshAnchors {
            let mdlMesh = anchor.geometry.toMDLMesh(device: device, camera: camera, modelMatrix: anchor.transform)
        }
        
        return asset
    }
    
    func export(asset: MDLAsset) throws -> URL {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "com.original.CreatingLidarModel", code: 153)
        }
        
        let folderName = "OBJ_FILES"
        let folderURL = directory.appendingPathComponent(folderName)
        try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
        let url = folderURL.appendingPathComponent("\(UUID().uuidString).obj")
        
        do {
            try asset.export(to: url)
            print("Objective save succesfully at ", url)
            return url
        } catch {
            print(error)
        }
        
        return url
    }
}
