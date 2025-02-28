// raylib-zig (c) Nikolas Wipper 2023

const std = @import("std");
const rl = @import("raylib");
const Boundary = @import("Boundary.zig");
const Ray = @import("Ray.zig");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 800;

    rl.initWindow(screenWidth, screenHeight, "2D Raycast");
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
        .is_finite = true,
        .length = 700,
    };
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        var ray_color: rl.Color = undefined;

        // Update
        {
            // If ray intersects with a boundary, change its color indicator
            ray_color = rl.Color.green;
            if (ray.cast(wall)) {
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
        }
    }
}
