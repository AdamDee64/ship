package main

import rand "core:math/rand"

import rl "vendor:raylib"

debug_add_explosion :: proc(explosions : ^[dynamic]Explosion) {
    if rl.IsKeyPressed(rl.KeyboardKey(.X)) {
        append(explosions, add_explosion({rand.float32_range(250, 500),rand.float32_range(250, 500)}))
     }  
}

debug_add_asteroids :: proc(asteroids : ^[dynamic]Asteroid) {
    if rl.IsKeyPressed(rl.KeyboardKey(.C)) {
        for i in 0..<20{
            spawn_asteroid(asteroids)
        }
     }  
}

debug_draw_fps :: proc (){
    rl.DrawRectangle(0,0,110,50, rl.DARKGRAY)
    rl.DrawFPS(10, 10);
}

debug_draw_asteroid_count :: proc(count : int) {
    rl.DrawRectangle(120, 0, 50, 50, rl.DARKGRAY)
    rl.DrawText(rl.TextFormat("%i", count), 130, 10, 20, rl.RAYWHITE)
}
    
debug_draw_bullet_count :: proc(count : int) {
    rl.DrawRectangle(180, 0, 50, 50, rl.DARKGRAY)
    rl.DrawText(rl.TextFormat("%i", count), 190, 10, 20, rl.PURPLE)
}