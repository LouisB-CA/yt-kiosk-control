#!/usr/bin/env python3


# Run this to re-encode PNG files cleanly.  
# See docs/ for info.

from PIL import Image

img = Image.open('icon-192.png').convert('RGBA')
img.save('icon-192.png', 'PNG', optimize=True)
img2 = Image.open('icon-512.png').convert('RGBA')
img2.save('icon-512.png', 'PNG', optimize=True)

