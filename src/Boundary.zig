const Boundary = @This();
const rl = @import("raylib");
const Vector2 = rl.Vector2;

start: Vector2,
end: Vector2,

pub fn draw(self: Boundary, color: rl.Color) void {
    rl.drawLineV(self.start, self.end, color);
}
