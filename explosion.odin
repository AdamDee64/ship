package main

import rand "core:math/rand"

import rl "vendor:raylib"

Explosion :: struct {
    position : Vec2,
    particles : [30]Vec2,
    timer : Timer, 
    gradient : Color_Gradient,
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
    gradient = {
      {213, 207, 0, 255},
      {124, 207, 0}
   }
    color = gradient.start_color
    return explosion
 }

 explode :: proc(using explosion : ^Explosion, dt : f32) {
    for &particle in particles{
         start_color : rl.Color = {213, 207, 0, 255}
         particle += particle * timer.time_left * dt * 8 
         color = get_gradient(1.0 - timer.time_left, gradient.start_color, gradient.color_delta)
    }
    
    update_timer(&timer, dt)
 }

 draw_explosion :: proc(using explosion : ^Explosion){
    for &particle in particles {
        rl.DrawPixelV(particle + position, color)
    }
 }