package com.example.shared

class Greeting {
    private val platform = getPlatform()

    fun greet(): String {
        return "Hello from ${platform.name}!"
    }
}

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform
