package main

import rand "core:math/rand"

import rl "vendor:raylib"

Explosion :: struct {
    position : Vec2,
    particles : [30]Vec2,
    timer : Timer, 
    color : rl.Color
    //chunk : [3][2]Vec2, // random disconnected lines that will rotate and float
 }
 
 add_explosion :: proc(pos : Vec2) -> Explosion {
    using explosion : Explosion = ---
    position = pos 
    for &particle in particles {
       particle.x = rand.float32_range(-1.0, 1.0) 
       particle.y = rand.float32_range(-1.0, 1.0) 
    }
    timer = create_timer(1.0)
    return explosion
 }

 explode :: proc(using explosion : ^Explosion, dt : f32) {
    for &particle in particles{
        particle += particle * timer.time_left * dt * 8 
    }
    
    update_timer(&timer, dt)
 }

 draw_explosion :: proc(using explosion : ^Explosion){
    for &particle in particles {
        rl.DrawPixelV(particle + position, rl.YELLOW)
    }
 }