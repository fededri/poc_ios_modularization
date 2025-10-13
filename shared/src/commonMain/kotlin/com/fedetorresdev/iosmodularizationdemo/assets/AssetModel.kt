package com.fedetorresdev.iosmodularizationdemo.assets

data class AssetModel(
    val id: String,
    val name: String,
    val status: String,
    val category: AssetCategoryModel,
)

data class AssetDetailModel(
    val id: String,
    val name: String,
    val status: String,
    val category: AssetCategoryModel,
    val description: String,
    val location: String,
    val purchaseDate: String,
    val value: String,
    val manufacturer: String,
    val serialNumber: String,
)

data class AssetCategoryModel(
    val id: String,
    val name: String,
)