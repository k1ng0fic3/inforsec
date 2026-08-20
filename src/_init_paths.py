# $$$!!Warning: Corp key information asset. No spread without permission.$$$
# !CODEMARK:RKeR1B8WMAfemkt1tTDGp6rtsdqqGJXiPNGqWgf0ocpT/IOEAcfEDQqMEGxAOcr0RxPw/kYz1Hhi
# 6rnWuj7Cb2sswhgRltJx35Zvf2MgWsIGfFTf9m7B22Va1zxSb/4l0+wDvkjaMfOyGnQScdAV9/j8
# GDtS3bmF+IWoYCtPvSiU0PjXERL3nahOhN+VXfAI#!
# $$$!!Warning: Deleting or modifying the preceding information is prohibited.$$$
import os.path as osp
import sys

def add_path(path):
    if path not in sys.path:
        sys.path.insert(0, path)

this_dir = osp.dirname(__file__)

# Add lib to PYTHONPATH
lib_path = osp.join(this_dir, 'lib')
add_path(lib_path)

coco_path = osp.join(this_dir, 'data', 'coco', 'PythonAPI')
add_path(coco_path)
