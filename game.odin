package main

import "core:fmt"
import rl "vendor:raylib"

RAD :: 0.01745329

BOUND :: 4 // how far off screen the ship travels before wrapping to the other side
DESPAWN : f32 : 40 // how far off screen before asteroids and bullets are removed from memory

BULLET_SPEED :: 20

// TODO
// collision detection
// score board
// game over condition
// restart game
// remove esc = quit or add confirmation ui

main :: proc() {
   
   WIDTH   :: 1024
   HEIGHT  :: 728
   TITLE : cstring : "ship"

   rl.InitWindow(WIDTH, HEIGHT, TITLE)

   monitor := get_monitor_data()

   rl.SetTargetFPS(monitor.fps)


   ship := make_ship(2.0)

   asteroids : [dynamic]Asteroid
   explosions : [dynamic]Explosion
   bullets : [dynamic]Bullet

   asteroid_spawn_timer := create_timer(2.0, true, true)

   for !rl.WindowShouldClose() {
      dt := rl.GetFrameTime()

      // ----------------- Update -------------------- //

      update_timer(&asteroid_spawn_timer, dt)
      if asteroid_spawn_timer.time_left <= 0 {
         spawn_asteroid(&asteroids)
      }

      ship.position += ship.direction * ship.accelleration * dt
      // check ship collision with asteroids

      if len(asteroids) > 0 {
         for &asteroid, index in asteroids {
            rotate_asteroid(&asteroid)
            using asteroid
            position += direction * speed * dt
            if rl.CheckCollisionCircles(ship.position, 9, position, size){
               append(&explosions, add_explosion(ship.position))
               fmt.println("hit on ship")
            }
            if position.x < -DESPAWN || position.x > monitor.width + DESPAWN || position.y < -DESPAWN || position.y > monitor.height + DESPAWN {
               defer unordered_remove(&asteroids, index)
            }
         }
      }

      if len(bullets) > 0 {
         for &bullet, index in bullets {
            // check bullet collision with asteroids
            using bullet
            if len(asteroids) > 0 {
               for &asteroid, asteroid_index in asteroids {
                  if rl.CheckCollisionCircles(position, 3, asteroid.position, asteroid.size){
                     append(&explosions, add_explosion(position))
                     if asteroid.size > 10 {
                       spawn_asteroid(&asteroids, true, asteroid_index)
                     }
                     defer unordered_remove(&asteroids, asteroid_index)
                     defer unordered_remove(&bullets, index)
                     break
                  }
               }
            }
            position += direction * dt * BULLET_SPEED
            if position.x < -DESPAWN || position.x > monitor.width + DESPAWN || position.y < -DESPAWN || position.y > monitor.height + DESPAWN {
               defer unordered_remove(&bullets, index)
            }
         }
      }
      
      if len(explosions) > 0 {
         for &explosion, index in explosions {
            explode(&explosion, dt)
            if !explosion.timer.running {
               defer unordered_remove(&explosions, index)
            }
         }
      }


      // ----------------- Input --------------------- //

      input_ship_movement(&ship, dt)
      input_ship_shoot(&ship, &bullets)

      debug_add_explosion(&explosions)
      debug_add_asteroids(&asteroids)

      wrap(&ship.position, WIDTH, HEIGHT)

      // ----------------- Draw--------------------- //
        rl.BeginDrawing()
        
            rl.ClearBackground(rl.BLACK)


            draw_ship(&ship)

            if len(asteroids) > 0 {
               for &asteroid in asteroids {
                  draw_asteroid(&asteroid)
               }
            }

            if len(bullets) > 0 {
               for &bullet in bullets {
                  draw_bullet(&bullet)
               }
            }

            if len(explosions) > 0{
               for &explosion in explosions{
                  draw_explosion(&explosion)
               }
            }


            debug_draw_fps()
            debug_draw_asteroid_count(len(asteroids))
            debug_draw_bullet_count(len(bullets))
            
            
        rl.EndDrawing()
    }

    rl.CloseWindow()
}