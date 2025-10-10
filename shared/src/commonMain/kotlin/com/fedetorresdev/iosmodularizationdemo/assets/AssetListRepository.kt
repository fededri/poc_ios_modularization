package com.fedetorresdev.iosmodularizationdemo.assets

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

interface AssetListRepository {
    fun getAllAssets(): Flow<List<AssetModel>>
}

class AssetListRepositoryImpl() : AssetListRepository {
    override fun getAllAssets(): Flow<List<AssetModel>> = flow {
        emit(assets)
    }


    private val assets = listOf(
        AssetModel(
            id = "1",
            name = "Asset 1",
            status = "Active",
            category = AssetCategoryModel(
                id = "cat1",
                name = "Category A"
            )
        ),
        AssetModel(
            id = "2",
            name = "Asset 2",
            status = "Inactive",
            category = AssetCategoryModel(
                id = "cat2",
                name = "Category B"
            )
        )
    )

}