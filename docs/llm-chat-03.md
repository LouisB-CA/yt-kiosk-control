

## Don't use raw Inkscape PNG

Inkscape sometimes writes PNGs with metadata or colour profiles that trip up Android's icon parser. To rule this out, run this on the Pi to re-encode it cleanly:
```bash
cd ~/.local/share/yt-kiosk-control
python3 -c "
from PIL import Image
img = Image.open('icon-192.png').convert('RGBA')
img.save('icon-192.png', 'PNG', optimize=True)
img2 = Image.open('icon-512.png').convert('RGBA')
img2.save('icon-512.png', 'PNG', optimize=True)
"
```


