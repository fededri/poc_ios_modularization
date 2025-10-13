package com.fedetorresdev.iosmodularizationdemo.issues

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

interface IssueDetailRepository {
    fun getIssueDetail(id: String): Flow<IssueDetailModel?>
}

class IssueDetailRepositoryImpl : IssueDetailRepository {
    override fun getIssueDetail(id: String): Flow<IssueDetailModel?> = flow {
        val issue = mockIssueDetails.find { it.id == id }
        emit(issue)
    }

    private val mockIssueDetails = listOf(
        IssueDetailModel(
            id = "1",
            title = "Issue 1",
            description = "Critical bug in the authentication system causing login failures for certain users",
            status = "Open",
            assignee = "John Doe",
            priority = "High",
            createdDate = "2024-10-01",
            dueDate = "2024-10-15",
            reporter = "Jane Smith"
        ),
        IssueDetailModel(
            id = "2",
            title = "Issue 2",
            description = "Feature request to add dark mode support across the entire application",
            status = "Closed",
            assignee = "Alice Johnson",
            priority = "Medium",
            createdDate = "2024-09-15",
            dueDate = "2024-10-10",
            reporter = "Bob Wilson"
        ),
        IssueDetailModel(
            id = "3",
            title = "Issue 3",
            description = "Performance optimization needed for data loading on the dashboard page",
            status = "In Progress",
            assignee = "Mike Brown",
            priority = "High",
            createdDate = "2024-10-05",
            dueDate = "2024-10-20",
            reporter = "Sarah Davis"
        )
    )
}

