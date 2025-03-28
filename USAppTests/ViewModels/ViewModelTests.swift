//
//  ViewModelTests.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//


import XCTest
@testable import USApp

class ViewModelTests: XCTestCase {
    
    func testGroupViewModel() {
        // Arrange
        let viewModel = GroupViewModel(isShowingFutureSessions: true)
        
        // Set some test data
        let testData = [
            ["25-12-2024", "15min", "40min", "10min", "Course", "Sortie longue", "5:30/km", "Parc des Sports"],
            ["26-12-2024", "20min", "60min", "15min", "Fractionné", "10x400m", "4:15/km", "Piste"]
        ]
        
        // Act
        Task {
            await MainActor.run {
                viewModel.sheetData = testData
            }
            
            // Assert
            let filtered = viewModel.filteredData()
            XCTAssertEqual(filtered.count, 2) // All should pass since dates are in future
            
            // Test search filter
            await MainActor.run {
                viewModel.searchQuery = "Fractionné"
            }
            
            let searchFiltered = viewModel.filteredData()
            XCTAssertEqual(searchFiltered.count, 1)
        }
    }
    
    func testDetailGroupViewModel() {
        // Arrange
        let testRow = ["25-12-2024", "15min", "40min", "10min", "Course", "Sortie longue", "5:30/km", "Parc des Sports"]
        
        // Act
        let viewModel = DetailGroupViewModel(rowData: testRow)
        
        // Assert
        XCTAssertEqual(viewModel.rowData, testRow)
        // Test formatted date (actual value will depend on locale)
        XCTAssertNotEqual(viewModel.formattedDate, "25-12-2024")
    }
    
    func testDetailIndividualViewModel() {
        // Arrange
        let testRow = ["25-12-2024", "15min", "40min", "10min", "Course", "Sortie longue", "5:30/km", "Parc des Sports"]
        let testProfile = "Johann"
        
        // Act
        let viewModel = DetailIndividualViewModel(rowData: testRow, selectedProfile: testProfile)
        
        // Assert
        XCTAssertEqual(viewModel.rowData, testRow)
        XCTAssertEqual(viewModel.selectedProfile, testProfile)
        // Test formatted date (actual value will depend on locale)
        XCTAssertNotEqual(viewModel.formattedDate, "25-12-2024")
    }
    
    func testIndividualViewModel() {
        // Arrange
        let viewModel = IndividualViewModel(isShowingFutureSessions: true)
        
        // Set some test data
        let testData = [
            ["25-12-2024", "15min", "40min", "10min", "Course", "Sortie longue", "5:30/km", "Parc des Sports"],
            ["26-12-2024", "20min", "60min", "15min", "Fractionné", "10x400m", "4:15/km", "Piste"]
        ]
        
        // Act
        Task {
            await MainActor.run {
                viewModel.sheetData = testData
            }
            
            // Assert
            XCTAssertEqual(viewModel.filteredData.count, 2) // All should pass since dates are in future
            
            // Test row selection
            viewModel.selectRow(testData[0])
            XCTAssertEqual(viewModel.selectedRow, testData[0])
            XCTAssertTrue(viewModel.showDetailView)
        }
    }
    
    func testLocalFileManagerViewModel() {
        // Arrange
        let viewModel = LocalFileManagerViewModel()
        
        // Act
        viewModel.licenceNumber = "TEST123456"
        viewModel.record5K = "20:30"
        viewModel.record10K = "45:10"
        viewModel.recordSemi = "1:40:20"
        viewModel.recordMarathon = "3:30:15"
        viewModel.save()
        
        // Create a new view model to test loading
        let newViewModel = LocalFileManagerViewModel()
        newViewModel.load()
        
        // Assert
        XCTAssertEqual(newViewModel.licenceNumber, "TEST123456")
        XCTAssertEqual(newViewModel.record5K, "20:30")
        XCTAssertEqual(newViewModel.record10K, "45:10")
        XCTAssertEqual(newViewModel.recordSemi, "1:40:20")
        XCTAssertEqual(newViewModel.recordMarathon, "3:30:15")
    }
}
