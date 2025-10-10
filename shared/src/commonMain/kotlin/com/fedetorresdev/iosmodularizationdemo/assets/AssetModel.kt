package com.fedetorresdev.iosmodularizationdemo.assets

data class AssetModel(
    val id: String,
    val name: String,
    val status: String,
    val category: AssetCategoryModel,
)


data class AssetCategoryModel(
    val id: String,
    val name: String,
)