package com.fedetorresdev.iosmodularizationdemo.issues

data class IssueModel(
    val id: String,
    val title: String,
    val description: String,
    val status: String,
)

data class IssueDetailModel(
    val id: String,
    val title: String,
    val description: String,
    val status: String,
    val assignee: String,
    val priority: String,
    val createdDate: String,
    val dueDate: String,
    val reporter: String,
)