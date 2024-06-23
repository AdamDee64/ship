package main

Timer :: struct {
    time_set : f32,
    time_left : f32,
    looping : b8,
    running : b8
}

create_timer :: proc(set_time : f32, active : b8 = true, loop : b8 = false) -> Timer {
    using new_timer : Timer = ---
    time_set = set_time
    time_left = time_set
    looping = loop
    running = active
    return new_timer
}

update_timer :: proc(using timer : ^Timer, dt : f32) {
    if running {
        if time_left <= 0.0 {
            if looping {
                time_left = time_set + time_left
            } else {
                time_left = time_set
                running = false 
            }
        }
        time_left -= dt
    }
}
