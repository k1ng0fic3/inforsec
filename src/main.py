# $$$!!Warning: Corp key information asset. No spread without permission.$$$
# !CODEMARK:RKeR1B8WMAfemkt1tTDGp6rtsdqqGJXiPNGqWgf0ocpT/IOEAcfEDQqMEGxAOcr0RxPw/kYz1Hhi
# 6rnWuj7Cb2sswhgRltJx35Zvf2MgWsIGfFTf9m7B22Va1zxSb/4l0+wDvkjaMfOyGnQScdAV9/j8
# GDtS3bmF+IWoYCtPvSiU0PjXERL3nahOhN+VXfAI#!
# $$$!!Warning: Deleting or modifying the preceding information is prohibited.$$$
from __future__ import print_function
import _init_paths
from attack_model import *
from tensorflow.python.platform import app
from tensorflow.python.platform import flags
import flags
FLAGS = flags.FLAGS

def main(argv = None):
    flags.print_attack_flags()
    AttackGraph()

    attack = Attack()
    attack.optimize()

if __name__ == '__main__':
    app.run()