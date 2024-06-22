package main

import rl "vendor:raylib"

Vec2 :: [2]f32 

Monitor :: struct{
    id : i32,
    refresh : i32,
    fps : i32,
    width : f32,
    height : f32
}

Color_Gradient :: struct {
    start_color : rl.Color,
    color_delta : [3]f32
}

get_monitor_data :: proc() -> Monitor {
    using monitor : Monitor = ---
    id = rl.GetCurrentMonitor()
    refresh = rl.GetMonitorRefreshRate(id)
    if refresh %  72 == 0 {
        fps = 72
    } else { 
        fps = 60 
    } 
    width = f32(rl.GetScreenWidth())
    height = f32(rl.GetScreenHeight())
    return monitor
}

wrap :: proc (pos : ^Vec2, w, h : f32) {
    if pos.x < 0.0 - BOUND {pos.x += w + BOUND * 2}
    else if pos.x > w + BOUND {pos.x -= w + BOUND * 2}
    if pos.y < 0.0 - BOUND {pos.y += h + BOUND * 2}
    else if pos.y > h {pos.y -= h + BOUND * 2}
}
 
vec2_clamp :: proc(vec : ^Vec2, range : Vec2){
    if vec.x > range.y {vec.x = range.y}
    if vec.x < range.x {vec.x = range.x}
    if vec.y > range.y {vec.y = range.y}
    if vec.y < range.x {vec.y = range.x}
}

get_gradient :: proc(normal : f32, start_color : rl.Color, color_delta : [3]f32) -> rl.Color {
    color : rl.Color = ---
    color.r = u8(f32(start_color.r) - normal * color_delta.r)
    color.g = u8(f32(start_color.g) - normal * color_delta.g)
    color.b = u8(f32(start_color.b) - normal * color_delta.b)
    color.a = 255
    return color
}