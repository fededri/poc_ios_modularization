package com.fedetorresdev.iosmodularizationdemo.issues

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

interface IssuesListRepository {
    fun getAllIssues(): Flow<List<IssueModel>>
}

class IssuesListRepositoryImpl : IssuesListRepository {
    override fun getAllIssues(): Flow<List<IssueModel>> = flow {
        emit(issues)
    }
}

private val issues = listOf(
    IssueModel(
        id = "1",
        title = "Issue 1",
        description = "Description for issue 1",
        status = "Open"
    ),
    IssueModel(
        id = "2",
        title = "Issue 2",
        description = "Description for issue 2",
        status = "Closed"
    )
)