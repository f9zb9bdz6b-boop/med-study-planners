import Foundation
import SwiftData

struct DataSeeder {
    static func seedDataIfNeeded(modelContext: ModelContext) {
        // Check if data already exists
        let descriptor = FetchDescriptor<Topic>()
        let existingTopics = try? modelContext.fetch(descriptor)
        
        if let topics = existingTopics, !topics.isEmpty {
            // Data already seeded
            return
        }
        
        // Seed Pharmacology topics
        seedPharmacology(modelContext: modelContext)
        
        // Seed Pathology topics
        seedPathology(modelContext: modelContext)
        
        // Seed Microbiology topics
        seedMicrobiology(modelContext: modelContext)
        
        // Save context
        try? modelContext.save()
    }
    
    private static func seedPharmacology(modelContext: ModelContext) {
        // General
        let pharmacokinetics = Topic(
            name: "Pharmacokinetics",
            subject: .pharmacology,
            yieldLevel: .high,
            systemCategory: "General"
        )
        modelContext.insert(pharmacokinetics)
        
        let bioavailability = Topic(
            name: "Bioavailability",
            subject: .pharmacology,
            yieldLevel: .high,
            systemCategory: "General"
        )
        modelContext.insert(bioavailability)
        
        let loadingDose = Topic(
            name: "Loading Dose",
            subject: .pharmacology,
            yieldLevel: .medium,
            systemCategory: "General"
        )
        modelContext.insert(loadingDose)
        
        // ANS
        let pilocarpine = Topic(
            name: "Pilocarpine",
            subject: .pharmacology,
            yieldLevel: .high,
            systemCategory: "ANS"
        )
        modelContext.insert(pilocarpine)
        
        let opPoisoning = Topic(
            name: "OP Poisoning",
            subject: .pharmacology,
            yieldLevel: .high,
            systemCategory: "ANS"
        )
        modelContext.insert(opPoisoning)
        
        let adrenaline = Topic(
            name: "Adrenaline",
            subject: .pharmacology,
            yieldLevel: .high,
            systemCategory: "ANS"
        )
        modelContext.insert(adrenaline)
        
        let prazosin = Topic(
            name: "Prazosin",
            subject: .pharmacology,
            yieldLevel: .medium,
            systemCategory: "ANS"
        )
        modelContext.insert(prazosin)
        
        // CVS
        let captopril = Topic(
            name: "Captopril",
            subject: .pharmacology,
            yieldLevel: .high,
            systemCategory: "CVS"
        )
        modelContext.insert(captopril)
        
        let digoxin = Topic(
            name: "Digoxin",
            subject: .pharmacology,
            yieldLevel: .high,
            systemCategory: "CVS"
        )
        modelContext.insert(digoxin)
        
        let nitrates = Topic(
            name: "Nitrates",
            subject: .pharmacology,
            yieldLevel: .high,
            systemCategory: "CVS"
        )
        modelContext.insert(nitrates)
        
        let amiodarone = Topic(
            name: "Amiodarone",
            subject: .pharmacology,
            yieldLevel: .medium,
            systemCategory: "CVS"
        )
        modelContext.insert(amiodarone)
        
        // CNS
        let benzodiazepines = Topic(
            name: "Benzodiazepines",
            subject: .pharmacology,
            yieldLevel: .high,
            systemCategory: "CNS"
        )
        modelContext.insert(benzodiazepines)
        
        let phenytoin = Topic(
            name: "Phenytoin",
            subject: .pharmacology,
            yieldLevel: .high,
            systemCategory: "CNS"
        )
        modelContext.insert(phenytoin)
        
        let morphine = Topic(
            name: "Morphine",
            subject: .pharmacology,
            yieldLevel: .high,
            systemCategory: "CNS"
        )
        modelContext.insert(morphine)
        
        let ketamine = Topic(
            name: "Ketamine",
            subject: .pharmacology,
            yieldLevel: .medium,
            systemCategory: "CNS"
        )
        modelContext.insert(ketamine)
    }
    
    private static func seedPathology(modelContext: ModelContext) {
        // General
        let necrosis = Topic(
            name: "Necrosis",
            subject: .pathology,
            yieldLevel: .high,
            systemCategory: "General"
        )
        modelContext.insert(necrosis)
        
        let apoptosis = Topic(
            name: "Apoptosis",
            subject: .pathology,
            yieldLevel: .high,
            systemCategory: "General"
        )
        modelContext.insert(apoptosis)
        
        let inflammation = Topic(
            name: "Inflammation",
            subject: .pathology,
            yieldLevel: .high,
            systemCategory: "General"
        )
        modelContext.insert(inflammation)
        
        let calcification = Topic(
            name: "Calcification",
            subject: .pathology,
            yieldLevel: .medium,
            systemCategory: "General"
        )
        modelContext.insert(calcification)
        
        // Hemodynamics
        let shock = Topic(
            name: "Shock",
            subject: .pathology,
            yieldLevel: .high,
            systemCategory: "Hemodynamics"
        )
        modelContext.insert(shock)
        
        let thrombosis = Topic(
            name: "Thrombosis",
            subject: .pathology,
            yieldLevel: .high,
            systemCategory: "Hemodynamics"
        )
        modelContext.insert(thrombosis)
        
        let mi = Topic(
            name: "MI",
            subject: .pathology,
            yieldLevel: .high,
            systemCategory: "Hemodynamics"
        )
        modelContext.insert(mi)
        
        // Neoplasia
        let benignVsMalignant = Topic(
            name: "Benign vs Malignant",
            subject: .pathology,
            yieldLevel: .high,
            systemCategory: "Neoplasia"
        )
        modelContext.insert(benignVsMalignant)
        
        let metastasis = Topic(
            name: "Metastasis",
            subject: .pathology,
            yieldLevel: .high,
            systemCategory: "Neoplasia"
        )
        modelContext.insert(metastasis)
        
        // Systemic
        let endocarditis = Topic(
            name: "Endocarditis",
            subject: .pathology,
            yieldLevel: .high,
            systemCategory: "Systemic"
        )
        modelContext.insert(endocarditis)
        
        let pneumonia = Topic(
            name: "Pneumonia",
            subject: .pathology,
            yieldLevel: .high,
            systemCategory: "Systemic"
        )
        modelContext.insert(pneumonia)
        
        let cirrhosis = Topic(
            name: "Cirrhosis",
            subject: .pathology,
            yieldLevel: .high,
            systemCategory: "Systemic"
        )
        modelContext.insert(cirrhosis)
    }
    
    private static func seedMicrobiology(modelContext: ModelContext) {
        // General
        let kochPostulates = Topic(
            name: "Koch Postulates",
            subject: .microbiology,
            yieldLevel: .high,
            systemCategory: "General"
        )
        modelContext.insert(kochPostulates)
        
        let pcr = Topic(
            name: "PCR",
            subject: .microbiology,
            yieldLevel: .high,
            systemCategory: "General"
        )
        modelContext.insert(pcr)
        
        // Immunology
        let hypersensitivity = Topic(
            name: "Hypersensitivity",
            subject: .microbiology,
            yieldLevel: .high,
            systemCategory: "Immunology"
        )
        modelContext.insert(hypersensitivity)
        
        let elisa = Topic(
            name: "ELISA",
            subject: .microbiology,
            yieldLevel: .high,
            systemCategory: "Immunology"
        )
        modelContext.insert(elisa)
        
        // CVS/Blood
        let typhoid = Topic(
            name: "Typhoid",
            subject: .microbiology,
            yieldLevel: .high,
            systemCategory: "CVS/Blood"
        )
        modelContext.insert(typhoid)
        
        let hiv = Topic(
            name: "HIV",
            subject: .microbiology,
            yieldLevel: .high,
            systemCategory: "CVS/Blood"
        )
        modelContext.insert(hiv)
        
        let malaria = Topic(
            name: "Malaria",
            subject: .microbiology,
            yieldLevel: .high,
            systemCategory: "CVS/Blood"
        )
        modelContext.insert(malaria)
        
        // GI
        let cholera = Topic(
            name: "Cholera",
            subject: .microbiology,
            yieldLevel: .high,
            systemCategory: "GI"
        )
        modelContext.insert(cholera)
        
        let hepatitisB = Topic(
            name: "Hepatitis B",
            subject: .microbiology,
            yieldLevel: .high,
            systemCategory: "GI"
        )
        modelContext.insert(hepatitisB)
        
        // Resp
        let tb = Topic(
            name: "TB",
            subject: .microbiology,
            yieldLevel: .high,
            systemCategory: "Resp"
        )
        modelContext.insert(tb)
        
        let covid19 = Topic(
            name: "COVID-19",
            subject: .microbiology,
            yieldLevel: .high,
            systemCategory: "Resp"
        )
        modelContext.insert(covid19)
    }
}
