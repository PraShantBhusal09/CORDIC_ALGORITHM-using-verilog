import math

N, FRAC = 14, 13
ONE = 1 << FRAC
SH_H = [1, 2, 3, 4, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]       # hyperbolic shifts (4 repeated)

def q(v): return int(round(v * ONE))

ALPHA = {                                                     # same values as cordic_angle.v
    0: [q(math.atan(2.0**-i)) for i in range(N)],
    1: [q(2.0**-i) for i in range(N)],
    2: [q(math.atanh(2.0**-s)) for s in SH_H],
}
KC_INV = 1.0
for i in range(N): KC_INV /= math.sqrt(1 + 2.0**(-2*i))
KH_INV = 1.0
for s in SH_H:     KH_INV /= math.sqrt(1 - 2.0**(-2*s))

def cordic(mode, x, y, z):
    """x,y,z are integers (fixed point). Python >> on ints is an arithmetic shift, like >>> in Verilog."""
    for i in range(N):
        sh = SH_H[i] if mode == 2 else i
        d = 1 if z >= 0 else -1
        xs, ys = x >> sh, y >> sh
        xn = x if mode == 1 else (x - d*ys if mode == 0 else x + d*ys)
        y, z, x = y + d*xs, z - d*ALPHA[mode][i], xn
    return x, y, z

if __name__ == "__main__":
    print(f"1/Kc = {KC_INV:.7f} ({q(KC_INV)})   1/Kh = {KH_INV:.7f} ({q(KH_INV)})")
    tests = [
        ("Circular 45 deg", 0, q(KC_INV), 0, q(math.pi/4),  math.cos(math.pi/4)*ONE, math.sin(math.pi/4)*ONE),
        ("Linear 1.5*0.5",  1, q(1.5),    0, q(0.5),         1.5*ONE,                 0.75*ONE),
        ("Hyperbolic 0.5",  2, q(KH_INV), 0, q(0.5),         math.cosh(0.5)*ONE,      math.sinh(0.5)*ONE),
    ]
    for name, m, x, y, z, ex, ey in tests:
        xo, yo, zo = cordic(m, x, y, z)
        print(f"{name:16s} x={xo:6d} (ideal {ex:8.1f})  y={yo:6d} (ideal {ey:8.1f})  z={zo}")