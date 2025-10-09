package com.fedetorresdev.iosmodularizationdemo

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform