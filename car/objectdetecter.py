import numpy as np
from PIL import Image
from detecter import Detecter
import cv2
import math

class Objectdetecter:

    def __init__(self):
        self.detecter = Detecter()
        self.detecter.setup('./data/ssd_mobilenet_v1/frozen_inference_graph.pb','./data/label_map.pbtxt')
        self.THRESHOLD = 0.8

    def __check(self, image):
        detect_image = np.copy(image)
        image = np.expand_dims(image, axis=0)
        (boxes, scores, classes, num) = self.detecter.detect(image)
        list = []
        self.detecter.viaulize(detect_image,boxes,classes,scores,self.THRESHOLD)
        for output in zip(classes, scores, boxes):
            if output[1] >= self.THRESHOLD:
                y1, x1, y2, x2 = output[2]
                y = int((y2 - y1) * 480)
                list.append((output, y))

        return list, detect_image

    def order(self, image):
        lists, detect_image = self.__check(image)

        sign = 5
        tra = 5
        st = 300
        fw = 5
        
        for list in lists:
            if list[0][0] == 5:
                c = list[1]
                if c > sign:
                    return 'stopsign', detect_image

            elif list[0][0] == 6:
                c = list[1]
                if c > tra:
                    return 'trash', detect_image

            elif list[0][0] == 1:
                c = list[1]
                if c < st:
                    return 'stop', detect_image

            elif list[0][0] == 2:
                c = list[1]
                if c > fw:
                    return 'forward', detect_image

        return None, detect_image