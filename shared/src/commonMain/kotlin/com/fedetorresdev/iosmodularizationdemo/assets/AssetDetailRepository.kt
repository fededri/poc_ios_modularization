package com.fedetorresdev.iosmodularizationdemo.assets

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

interface AssetDetailRepository {
    fun getAssetDetail(id: String): Flow<AssetDetailModel?>
}

class AssetDetailRepositoryImpl : AssetDetailRepository {
    override fun getAssetDetail(id: String): Flow<AssetDetailModel?> = flow {
        val asset = mockAssetDetails.find { it.id == id }
        emit(asset)
    }

    private val mockAssetDetails = listOf(
        AssetDetailModel(
            id = "1",
            name = "Asset 1",
            status = "Active",
            category = AssetCategoryModel(
                id = "cat1",
                name = "Category A"
            ),
            description = "High-performance industrial equipment for manufacturing operations",
            location = "Building A, Floor 2, Room 205",
            purchaseDate = "2023-01-15",
            value = "$25,000.00",
            manufacturer = "TechCorp Industries",
            serialNumber = "TC-2023-001-XYZ"
        ),
        AssetDetailModel(
            id = "2",
            name = "Asset 2",
            status = "Inactive",
            category = AssetCategoryModel(
                id = "cat2",
                name = "Category B"
            ),
            description = "Office furniture set including desk and ergonomic chair",
            location = "Building B, Floor 1, Office 101",
            purchaseDate = "2022-08-22",
            value = "$1,200.00",
            manufacturer = "Office Solutions Inc",
            serialNumber = "OSI-2022-078-ABC"
        ),
        AssetDetailModel(
            id = "3",
            name = "Asset 3",
            status = "Active",
            category = AssetCategoryModel(
                id = "cat1",
                name = "Category A"
            ),
            description = "Mobile computing device for field operations",
            location = "Building A, Floor 1, IT Department",
            purchaseDate = "2024-03-10",
            value = "$1,500.00",
            manufacturer = "Mobile Tech Co",
            serialNumber = "MTC-2024-045-DEF"
        )
    )
}

