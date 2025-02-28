// raylib-zig (c) Nikolas Wipper 2023

const std = @import("std");
const rl = @import("raylib");
const Boundary = @import("Boundary.zig");
const Ray = @import("Ray.zig");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 800;

    rl.initWindow(screen_width, screen_height, "2D Raycast");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(144);
    rl.setWindowMonitor(1);

    const wall = Boundary{
        .start = rl.Vector2{ .x = 400, .y = 200 },
        .end = rl.Vector2{ .x = 400, .y = 600 },
    };
    var ray = Ray{
        .pos = rl.Vector2{ .x = 200, .y = 400 },
        .dir = rl.Vector2{ .x = 1, .y = 0 },
        // .is_finite = true,
        // .length = 700,
        .is_finite = false,
    };
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        var ray_color: rl.Color = undefined;
        var intersection_point: ?rl.Vector2 = undefined;

        // Update
        {
            intersection_point = ray.cast(wall);

            // If ray intersects with a boundary, change its color indicator
            ray_color = rl.Color.green;
            if (intersection_point != null) {
                ray_color = rl.Color.red;
            }

            ray.lookAtV(rl.getMousePosition());
        }

        // Draw
        {
            rl.beginDrawing();
            defer rl.endDrawing();

            rl.clearBackground(rl.Color.white);

            wall.draw(rl.Color.black);
            ray.draw(ray_color);

            if (intersection_point != null) {
                rl.drawCircleV(intersection_point.?, 10, rl.Color.purple);
            }
        }
    }
}
