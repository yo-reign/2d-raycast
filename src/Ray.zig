const Ray = @This();
const rl = @import("raylib");
const Vector2 = rl.Vector2;
const Boundary = @import("Boundary.zig");
const print = @import("std").debug.print;
const assert = @import("std").debug.assert;

pos: Vector2,
dir: Vector2,
is_finite: bool,
/// Only matters if 'is_finite' is set to true
length: f32 = 0,

pub fn draw(self: Ray, color: rl.Color) void {
    var end: Vector2 = undefined;

    if (self.is_finite) {
        assert(self.length > 0);
        end = self.pos.add(self.dir.scale(self.length));
    } else {
        end = self.pos.add(self.dir.scale(100));
    }

    rl.drawLineV(self.pos, end, color);
}

pub fn cast(self: Ray, wall: Boundary) bool {
    const x1 = wall.start.x;
    const y1 = wall.start.y;
    const x2 = wall.end.x;
    const y2 = wall.end.y;

    const x3 = self.pos.x;
    const y3 = self.pos.y;
    var x4: f32 = undefined;
    var y4: f32 = undefined;
    if (self.is_finite) {
        assert(self.length > 0);
        x4 = self.pos.x + self.dir.x * self.length;
        y4 = self.pos.y + self.dir.y * self.length;
    } else {
        x4 = self.pos.x + self.dir.x;
        y4 = self.pos.y + self.dir.y;
    }

    const den: f32 = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    // If den == 0 that means that both line segments are perfectly parallel with each other
    if (den == 0) {
        //return null;
        return false;
    }

    const t: f32 = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den;
    const u: f32 = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den;

    print("t: {d}\n u: {d}\n\n", .{ t, u });

    // NOTE: by requiring u to be between 0 and 1 I am making the ray we shoote finite
    if (self.is_finite) {
        if (t > 0 and t < 1 and u > 0 and u < 1) return true else return false;
    } else {
        if (t > 0 and t < 1 and u > 0) return true else return false;
    }
}

pub fn lookAtV(self: *Ray, pos: Vector2) void {
    self.dir.x = pos.x - self.pos.x;
    self.dir.y = pos.y - self.pos.y;
    self.dir = self.dir.normalize();
}
