# Draws stand-in sheets for Talia, so her build can be tested with none of Capri's art in it before her own is drawn.
# They're plain shapes with each sheet's name and frame number on them, drawn to the same guides as her Krita files
# (feet line, seat and hip points, mouth box) at her double size, with her shorter 16-frame sitting and lying sheets.
# Only a build with CHARACTER_PLACEHOLDERS=1 uses them, and only for a sheet she doesn't have in sprites/ yet. See NOTES.md.
#
# Remake them with: python characters/talia/make-placeholders.py   (needs Pillow: pip install pillow)
import math
import os

from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
OUT = os.path.join(HERE, 'placeholders')
SCALE = 2  # her art is drawn at double Capri's size

# Name, frames, kind, frame width at Capri's size. Sitting and lying loops are her shorter 16 frames, blinks 4.
SHEETS = [
    ('idle', 16, 'stand', 240), ('blink', 4, 'blink', 240), ('blink_glitch', 4, 'blink', 240), ('mouth', 5, 'mouth', 240),
    ('grin', 16, 'stand', 240), ('glitch', 10, 'stand', 240), ('dangle', 24, 'stand', 240), ('sleep', 16, 'stand', 240),
    ('wake', 13, 'stand', 240), ('walk', 12, 'stand', 240), ('arrive', 14, 'stand', 240), ('leave', 12, 'stand', 240),
    ('perch', 16, 'perch', 196), ('perch_blink', 4, 'perch', 196), ('perch_blink_glitch', 4, 'perch', 196),
    ('perch_music', 16, 'perch', 196), ('perch_talk', 16, 'perch', 196), ('perch_glitch', 10, 'perch', 288),
    ('perch_arrive', 14, 'perch', 288), ('perch_leave', 12, 'perch', 288),
    ('laydown', 16, 'lie', 372), ('laydown_talk', 16, 'lie', 372), ('laydown_blink', 4, 'lie', 372),
    ('laydown_blink_glitch', 4, 'lie', 372), ('laydown_sleep', 16, 'lie', 372), ('laydown_glitch', 10, 'lie', 440),
    ('laydown_leave', 12, 'lie', 440),
]
# How many frames Capri's own sheets have, to check each stand-in is the size the build expects.
CAPRI_FRAMES = {'perch': 60, 'perch_music': 60, 'perch_talk': 60, 'laydown': 60, 'laydown_talk': 60, 'laydown_sleep': 60,
                'perch_blink': 8, 'perch_blink_glitch': 8, 'laydown_blink': 8, 'laydown_blink_glitch': 8}

BODY = (92, 118, 140, 255)      # slate blue, nobody's colours on purpose
SKIN = (214, 196, 182, 255)
LINE = (34, 40, 52, 255)
EYE = (30, 34, 44, 255)
GLITCH = (240, 60, 200, 255)
TEXT = (255, 255, 255, 255)


def font(size):
    try:
        return ImageFont.load_default(size=size * SCALE)
    except TypeError:
        return ImageFont.load_default()


def s(v):
    return int(round(v * SCALE))


class Pen:
    """Draws in Capri-size coordinates onto a double-size frame, moved by (dx, dy)."""

    def __init__(self, image, dx=0, dy=0):
        self.d = ImageDraw.Draw(image)
        self.dx, self.dy = dx, dy

    def box(self, x0, y0, x1, y1, fill, r=6):
        self.d.rounded_rectangle([s(x0 + self.dx), s(y0 + self.dy), s(x1 + self.dx), s(y1 + self.dy)], radius=s(r), fill=fill, outline=LINE, width=s(1.5))

    def ball(self, cx, cy, r, fill):
        self.d.ellipse([s(cx - r + self.dx), s(cy - r + self.dy), s(cx + r + self.dx), s(cy + r + self.dy)], fill=fill, outline=LINE, width=s(1.5))

    def limb(self, x0, y0, x1, y1, w, fill):
        # A thick line with round ends, for legs and arms at an angle.
        a, b = (s(x0 + self.dx), s(y0 + self.dy)), (s(x1 + self.dx), s(y1 + self.dy))
        self.d.line([a, b], fill=LINE, width=s(w + 3))
        self.d.line([a, b], fill=fill, width=s(w))
        for p in (a, b):
            self.d.ellipse([p[0] - s(w / 2), p[1] - s(w / 2), p[0] + s(w / 2), p[1] + s(w / 2)], fill=fill)

    def text(self, x, y, words, size, fill=TEXT):
        self.d.text((s(x + self.dx), s(y + self.dy)), words, font=font(size), fill=fill)


def eyes(p, cx, cy, gap, shut, glitchy):
    # shut: 0 open, 1 half, 2 closed.
    for ex in (cx - gap / 2, cx + gap / 2):
        if shut == 2:
            p.d.line([s(ex - 5 + p.dx), s(cy + p.dy), s(ex + 5 + p.dx), s(cy + p.dy)], fill=EYE, width=s(2))
        else:
            h = 5 if shut == 0 else 2
            p.d.ellipse([s(ex - 4 + p.dx), s(cy - h + p.dy), s(ex + 4 + p.dx), s(cy + h + p.dy)], fill=GLITCH if glitchy else EYE)


def mouth_shape(p, cx, cy, shape):
    # 0 closed, 1 small, 2 small round, 3 open, 4 wide. Kept inside a 20x14 box around (cx, cy).
    if shape == 0:
        p.d.line([s(cx - 5 + p.dx), s(cy + p.dy), s(cx + 5 + p.dx), s(cy + p.dy)], fill=EYE, width=s(2))
        return
    w, h = {1: (5, 2), 2: (3, 3), 3: (5, 5), 4: (8, 6)}[shape]
    p.d.ellipse([s(cx - w + p.dx), s(cy - h + p.dy), s(cx + w + p.dx), s(cy + h + p.dy)], fill=EYE)


def stand(frame, name, i, n):
    """Standing, facing right, feet on y 362, face's mouth inside the box at (122, 126) to (142, 140)."""
    t = i / n
    bob = math.sin(t * 2 * math.pi) * 2
    dx = 0
    if name == 'dangle':
        dx = math.sin(t * 2 * math.pi) * 10
    p = Pen(frame, dx, bob if name in ('idle', 'grin', 'sleep', 'blink', 'blink_glitch') else 0)
    step = math.sin(t * 2 * math.pi) * 14 if name == 'walk' else 0
    lift = 18 if name == 'dangle' else 0  # held up, feet off the ground
    p.limb(108, 290 - lift, 108 + step, 352 - lift, 18, BODY)
    p.limb(140, 290 - lift, 140 - step, 352 - lift, 18, BODY)
    p.box(92, 348 - lift, 122, 362 - lift, LINE, 4) if not step else None
    p.box(126, 348 - lift, 156, 362 - lift, LINE, 4) if not step else None
    arm = -40 if name == 'dangle' else 0
    p.limb(88, 160, 72, 250 + arm * 2, 14, BODY)
    p.limb(160, 160, 176, 250 + arm * 2, 14, BODY)
    p.box(82, 145, 166, 295, BODY, 14)
    p.ball(128, 112, 38, SKIN)
    p.d.chord([s(90 + p.dx), s(70 + p.dy), s(166 + p.dx), s(130 + p.dy)], 180, 360, fill=BODY, outline=LINE, width=s(1.5))
    shut = 2 if name == 'sleep' or (name == 'wake' and i < 6) else (1 if name == 'wake' and i < 9 else 0)
    if name in ('blink', 'blink_glitch'):
        shut = (1, 2, 2, 1)[i]
    eyes(p, 132, 112, 22, shut, name == 'blink_glitch')
    if name == 'grin':
        p.d.arc([s(122 + p.dx), s(122 + p.dy), s(142 + p.dx), s(138 + p.dy)], 0, 180, fill=EYE, width=s(2.5))
    else:
        mouth_shape(p, 132, 133, 0)
    if name == 'sleep':
        p.text(160 + (i % 4) * 3, 60 - (i % 4) * 6, 'z', 14, LINE)
    p.text(90, 170, name, 9)
    p.text(90, 186, 'frame %d' % i, 9)
    p.text(90, 270, 'PLACE-', 8)
    p.text(90, 280, 'HOLDER', 8)


def mouth_only(frame, i):
    # Only the mouth, over a patch of skin that hides idle's closed one, the rest transparent.
    p = Pen(frame)
    p.d.ellipse([s(122), s(127), s(142), s(139)], fill=SKIN)
    mouth_shape(p, 132, 133, i)


def perch(frame, name, i, n, width):
    """Sitting on a ledge, facing right. The seat point is (47, 267) in a 196 frame and (93, 267) in a 288 one."""
    sx = 47 if width == 196 else 93
    t = i / n
    sway = math.sin(t * 2 * math.pi) * (5 if name == 'perch_music' else 1.5)
    p = Pen(frame, sx - 47, 0)
    # Legs off the ledge: thighs along it, shins hanging down in front.
    kick = math.sin(t * 2 * math.pi) * 4
    p.limb(52, 262, 118, 262, 20, BODY)
    p.limb(118, 262, 124 + kick, 330, 17, BODY)
    p.limb(48, 256, 112, 254, 20, BODY)
    p.limb(112, 254, 120 - kick, 326, 17, BODY)
    q = Pen(frame, sx - 47 + sway, 0)
    q.limb(60, 130, 104, 228, 13, BODY)
    q.box(36, 112, 100, 268, BODY, 14)
    q.ball(76, 78, 34, SKIN)
    q.d.chord([s(42 + q.dx), s(40 + q.dy), s(110 + q.dx), s(94 + q.dy)], 180, 360, fill=BODY, outline=LINE, width=s(1.5))
    shut = 0
    if name in ('perch_blink', 'perch_blink_glitch'):
        shut = (1, 2, 2, 1)[i]
    eyes(q, 82, 78, 20, shut, name == 'perch_blink_glitch')
    # perch_talk is perch with only the mouth changed, so it moves through the open shapes.
    mouth_shape(q, 84, 98, (1, 3, 2, 4)[i % 4] if name == 'perch_talk' else 0)
    # Talking only changes her mouth (the self-test checks that), so it carries the same label as perch.
    q.text(40, 140, 'perch' if name == 'perch_talk' else name.replace('perch_', 'perch\n'), 8)
    q.text(40, 172, 'frame %d' % i, 8)
    q.text(40, 230, 'PLACE-\nHOLDER', 7)


def lie(frame, name, i, n, width):
    """Lying along a ledge on her back, head to the left. The hip is (303, 142) in a 372 frame, (337, 142) in a 440 one."""
    hx = 303 if width == 372 else 337
    t = i / n
    breath = math.sin(t * 2 * math.pi) * 1.5
    p = Pen(frame, hx - 303, 0)
    # Legs off the right end, hair and an arm off the left.
    p.limb(300, 132, 352, 140, 18, BODY)
    p.limb(352, 140, 362, 214, 16, BODY)
    p.limb(110, 128, 40, 150, 12, BODY)
    p.limb(40, 150, 30, 212, 11, BODY)
    p.box(110, 108 - breath, 306, 142, BODY, 14)
    p.ball(76, 112, 32, SKIN)
    p.d.chord([s(30 + p.dx), s(80 + p.dy), s(60 + p.dx), s(150 + p.dy)], 90, 270, fill=BODY, outline=LINE, width=s(1.5))
    p.limb(48, 140, 44, 200, 14, BODY)  # hair hanging off the end
    shut = 2 if name == 'laydown_sleep' else 0
    if name in ('laydown_blink', 'laydown_blink_glitch'):
        shut = (1, 2, 2, 1)[i]
    eyes(p, 82, 104, 20, shut, name == 'laydown_blink_glitch')
    mouth_shape(p, 86, 124, (1, 3, 2, 4)[i % 4] if name == 'laydown_talk' else 0)
    if name == 'laydown_sleep':
        p.text(110 + (i % 4) * 3, 60 - (i % 4) * 6, 'z', 14, LINE)
    p.text(120, 112, '%s  frame %d  PLACEHOLDER' % ('laydown' if name == 'laydown_talk' else name, i), 8)


def glitched(frame, i, n, name):
    # Shifts bands of rows sideways and tints them, like a bad signal. Arrive and leave fade too.
    w, h = frame.size
    out = Image.new('RGBA', frame.size, (0, 0, 0, 0))
    band = s(12)
    for k, y in enumerate(range(0, h, band)):
        shift = int(math.sin(i * 1.7 + k * 2.3) * s(8)) if (i + k) % 3 == 0 else 0
        piece = frame.crop((0, y, w, min(h, y + band)))
        out.paste(piece, (shift, y), piece)
    if i % 2 == 0:
        # Every other frame tinted pink where she's drawn, keeping her outline.
        tinted = Image.blend(out, Image.new('RGBA', frame.size, GLITCH), 0.35)
        tinted.putalpha(out.getchannel('A'))
        out = tinted
    if name.endswith('arrive') or name.endswith('leave'):
        k = (i + 1) / n if name.endswith('arrive') else 1 - i / n
        if name.endswith('leave') and i == 0:
            k = 1
        out.putalpha(out.getchannel('A').point(lambda a: int(a * k)))
    return out


def make(name, n, kind, width):
    fw = s(width)
    fh = s(250 if kind == 'lie' else 384)
    sheet = Image.new('RGBA', (fw * n, fh), (0, 0, 0, 0))
    for i in range(n):
        frame = Image.new('RGBA', (fw, fh), (0, 0, 0, 0))
        if kind == 'mouth':
            mouth_only(frame, i)
        elif kind in ('stand', 'blink'):
            stand(frame, name, i, n)
        elif kind == 'perch':
            perch(frame, name, i, n, width)
        else:
            lie(frame, name, i, n, width)
        # The last arrive frame and the first leave frame stay close to idle, so they're left clean.
        last_clean = (name.endswith('arrive') and i == n - 1) or (name.endswith('leave') and i == 0)
        if any(name.endswith(x) for x in ('glitch', 'arrive', 'leave')) and not name.endswith('blink_glitch') and not last_clean:
            frame = glitched(frame, i, n, name)
        sheet.paste(frame, (i * fw, 0), frame)
    check(name, sheet)
    sheet.save(os.path.join(OUT, name + '.png'), optimize=True)


def make_face():
    face = Image.new('RGBA', (s(400), s(400)), (0, 0, 0, 0))
    p = Pen(face)
    p.box(60, 300, 340, 420, BODY, 40)
    p.ball(200, 180, 130, SKIN)
    p.d.chord([s(66), s(40), s(334), s(230)], 180, 360, fill=BODY, outline=LINE, width=s(2))
    for ex in (150, 250):
        p.ball(ex, 190, 14, EYE)
    p.d.line([s(175), s(250), s(225), s(250)], fill=EYE, width=s(4))
    p.text(110, 330, 'face  PLACEHOLDER', 16)
    check('face', face)
    face.save(os.path.join(OUT, 'face.png'), optimize=True)


def check(name, sheet):
    # The same size test the build makes (characters/Use-Character.ps1), so a mistake shows up here first.
    capri = Image.open(os.path.join(ROOT, 'assets', 'sprites', name + '.png')).size
    frames = CAPRI_FRAMES.get(name)
    want = (capri[0] * 2, capri[1] * 2)
    if frames:
        want = (capri[0] // frames * dict(SHEETS_BY_NAME)[name] * 2, capri[1] * 2)
    if sheet.size != want:
        raise SystemExit('%s came out %dx%d, but the build wants %dx%d' % (name, sheet.size[0], sheet.size[1], want[0], want[1]))
    if sheet.size[0] > 32767:
        raise SystemExit('%s is too wide for Windows to draw' % name)


SHEETS_BY_NAME = [(x[0], x[1]) for x in SHEETS]

if __name__ == '__main__':
    os.makedirs(OUT, exist_ok=True)
    for sheet in SHEETS:
        make(*sheet)
    make_face()
    print('Made %d stand-in sheets in %s' % (len(SHEETS) + 1, OUT))
