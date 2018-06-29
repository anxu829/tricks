from PIL import Image
import numpy as np
img = np.array(Image.open('000000061471.jpg'))
img[200:(200 + 280),272:(272+151),0] = 255
PIL.Image.fromarray(img)
