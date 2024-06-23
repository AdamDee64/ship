package main

import "core:math"

import rl "vendor:raylib"

Bullet :: struct {
    position : Vec2,
    direction : Vec2,
    points : [5]Vec2,
    color : rl.Color
}

make_bullet :: proc(pos : Vec2, dir : Vec2) -> Bullet {
    using new_bullet : Bullet
    position = pos + dir 
    direction = dir
    points = {{0,3},{1,1},{1,-2},{-1,-2},{-1,1}} * 3

    rad := math.atan2(dir.x, dir.y)
    cos := math.cos(rad)
    sin := math.sin(-rad)

    for &point in points {
        temp := point.x * cos - point.y * sin
        point.y = point.x * sin + point.y * cos
        point.x = temp
    }
    color = get_random_bright_color()
    return new_bullet 
}


spawn_bullet :: proc(ship : ^Ship, bullets : ^[dynamic]Bullet){
    append(bullets, make_bullet(ship.position, ship.shape[0]))
}

draw_bullet :: proc(using bullet : ^Bullet){
    for i in 0..<5 {
        rl.DrawLineV(points[i % 9] + position, points[(i + 1) % 5] + position, color)
     }
    //rl.DrawCircleV(position, 10, rl.PURPLE)
}