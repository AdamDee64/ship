package main

import "core:fmt"

import "core:math"

import rl "vendor:raylib"

Ship :: struct {
    position : Vec2,
    direction : Vec2,
    accelleration : f32,
    rotate_speed : f32,
    max_speed : Vec2,
    shape : [4]Vec2
 }
 
 make_ship :: proc(scale : f32) -> Ship {
    using new_ship : Ship = ---
    position = {f32(rl.GetScreenWidth() / 2), f32(rl.GetScreenHeight() / 2)}
    direction = {0, 0}
    rotate_speed = RAD * 200
    accelleration = 100
    max_speed = {-8, 8}
    shape = {{0, 10}, {5, -5}, {0, -2}, {-5, -5}} * scale
    return new_ship
 }
 
 draw_ship :: proc(using ship : ^Ship){
    color : rl.Color = rl.WHITE
    for i in 0..< 4 {
       rl.DrawLineV(shape[i % 4] + position, shape[(i + 1) % 4] + position, color)
    }
 }
 
 rotate_ship :: proc (using ship : ^Ship, dt : f32){
    cos := math.cos(rotate_speed * dt)
    sin := math.sin(rotate_speed * dt)
    for &point in shape {
       temp := point.x * cos - point.y * sin
       point.y = point.x * sin + point.y * cos
       point.x = temp
    }
 }
 
 move_ship :: proc(using ship : ^Ship, dir : f32) {
    a := math.atan2(shape[0].y, shape[0].x)
    direction += {math.cos(a), math.sin(a)} * dir
 }

 input_ship_movement :: proc(ship : ^Ship, dt : f32) {
    if rl.IsKeyDown(rl.KeyboardKey(.D)) {
        rotate_ship(ship, dt)
     }   
     if rl.IsKeyDown(rl.KeyboardKey(.A)) {
        rotate_ship(ship, -dt)
     }   
     if rl.IsKeyDown(rl.KeyboardKey(.W)) {
        move_ship(ship, 1 * dt)
        vec2_clamp(&ship.direction, ship.max_speed)
     }   
     if rl.IsKeyDown(rl.KeyboardKey(.S)) {
        move_ship(ship, -1 * dt)
        vec2_clamp(&ship.direction, ship.max_speed)
     }  

 }

 input_ship_shoot :: proc(ship : ^Ship, bullets : ^[dynamic]Bullet){
    if rl.IsKeyPressed(rl.KeyboardKey(.SPACE)) {
        spawn_bullet(ship, bullets)
     }  
 }