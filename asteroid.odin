package main

import "core:math"
import rand "core:math/rand"

import rl "vendor:raylib"

Asteroid :: struct {
    spin : f32,
    speed : f32,
    position : Vec2,
    direction : Vec2,
    points : [9]Vec2,
    size : f32,
    color : rl.Color
}

asteroid_gradient : Color_Gradient = {
   {119, 95, 69, 255},
   {-124, -51, -42}
}
 
 new_asteroid :: proc() -> Asteroid {
    using new_asteroid : Asteroid = ---
    spin = rand.float32_range(-1.5, 1.5) * RAD
    speed = rand.float32_range(0.1, 0.3)
 
    center_x := f32(rl.GetScreenWidth() / 2)
    center_y := f32(rl.GetScreenHeight() / 2)
    
    spawn_on_sides := rand.float32() - 0.5
    boundary : f32 = 30
 
    if spawn_on_sides > 0 {
       position.x = (center_x + boundary) * math.sign(rand.float32() - 0.5) + center_x
       position.y = rand.float32_range(-boundary, center_y * 2 + boundary)
    } else {
       position.y = (center_y + boundary) * math.sign(rand.float32() - 0.5) + center_y
       position.x = rand.float32_range(-boundary, center_x * 2 + boundary)
    }
 
    direction = {center_x + rand.float32_range(-center_x / 3, center_x / 3), center_y + rand.float32_range(-center_y / 3, center_y / 3)} - position 
 
    size = 35
    point_angle : f32 = 0
    var : f32 = 6
    point_distance := rand.float32_range(size - var, size + var)
    for &point in points {
       point.x = 0 - point_distance * math.sin(point_angle)
       point.y = point_distance * math.cos(point_angle)
       point_angle += rand.float32_range(37, 43) * RAD
       point_distance = rand.float32_range(size - var, size + var)
    }

    color = get_gradient(rand.float32(), asteroid_gradient.start_color, asteroid_gradient.color_delta)

    return new_asteroid
 }

   split_astroid :: proc(asteroids : ^[dynamic]Asteroid, index : int, left : bool ) -> Asteroid {
      using new_split := asteroids[index]

      angle : f32 = rand.float32_range(45, 135)
      if left {
         angle *= -1
      }
      cos := math.cos(RAD * angle)
      sin := math.sin(RAD * angle)
      temp := direction.x * cos - direction.y * sin
      direction.y = direction.x * sin + direction.y * cos
      direction.x = temp
      size *= .5
      speed *= rand.float32_range(0.3, 0.7)
      spin *= .8

      point_angle : f32 = 0
      var : f32 = 3

      point_distance := rand.float32_range(size - var, size + var)
      for &point in points {
         point.x = 0 - point_distance * math.sin(point_angle)
         point.y = point_distance * math.cos(point_angle)
         point_angle += rand.float32_range(37, 43) * RAD
         point_distance = rand.float32_range(size - var, size + var)
      }

      return new_split
   }


 
 draw_asteroid :: proc(using asteroid : ^Asteroid) {
    for i in 0..<9 {
       rl.DrawLineV(points[i % 9] + position, points[(i + 1) % 9] + position, color)
    }
 }
 
 rotate_asteroid :: proc(using asteroid : ^Asteroid) {
    cos := math.cos(spin)
    sin := math.sin(spin)
    for &point in points {
       temp := point.x * cos - point.y * sin
       point.y = point.x * sin + point.y * cos
       point.x = temp
    }
 }

 spawn_asteroid :: proc(asteroids : ^[dynamic]Asteroid, split : bool = false, index : int = 0) {
   if split {
      append(asteroids, split_astroid(asteroids, index, true))
      append(asteroids, split_astroid(asteroids, index, false))
   } else {
      append(asteroids, new_asteroid())
   }
 }

