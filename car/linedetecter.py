import numpy as np
import cv2
import math
import time

class lineDetecter:

    def __init__(self) :
        pass
   
    #이미지의 하얀색을 검출하는 기능이다. 하얀색 이외의 부분은 모두 검은색[0,0,0]으로 변환시킨다.
    def __whiteFillter(self,image):
        # 이미지 복사
        mark = np.copy(image)
        # BGR 제한 값 설정
        blue_threshold = 200
        green_threshold = 200
        red_threshold = 200
        bgr_threshold = [blue_threshold, green_threshold, red_threshold]
        thresholds = (image[:,:,0] < bgr_threshold[0]) \
                | (image[:,:,1] < bgr_threshold[1]) \
                | (image[:,:,2] < bgr_threshold[2])
        mark[thresholds] = [0,0,0]
        return mark

    #하얀색을 추출한 이미지의 한 행의 가운데 픽셀값을 검출한다.
    def __findWhiteFillterCenter(self, rowImg) :
        width = 1024
        mid = 512
        #하얀색의 pixel값이 연속적으로 검출되는 경우에만 좌우 차선으로 인식한다.
        threshold = 10
        #한 행의 이미지 픽셀을 순회하며, 하얀색 픽셀을 카운트한다.
        cntWhite = 0

        #왼쪽 차선을 나타내는 값
        leftPixel = 0
        #오른쪽 차선을 나타내는 값
        rightPixel = 0
        #차선의 넓이
        line_width = 15

        #왼쪽 차선의 위치를 구하는 루프
        for idx, e in enumerate(rowImg) :
            if e :
                cntWhite += 1
            if idx > mid :
                leftPixel = 0
                break
            if cntWhite == threshold :
                leftPixel = idx + line_width
                break

        #오른쪽 차선의 위치를 구하는 루프
        for idx, e in enumerate(rowImg[::-1]) :
            if e :
                cntWhite += 1
            if idx > mid :
                rightPixel = 1024
                break
            if cntWhite == threshold :
                rightPixel = width - idx - line_width
                break

        center = (leftPixel + rightPixel) / 2
        return center

    def order(self,image) :
        height, width = image.shape[:2] # 이미지 높이, 너비
        imgCenter = int(width/2)

        whiteImg = self.__whiteFillter(image)
        whiteImg = cv2.cvtColor(whiteImg, cv2.COLOR_BGR2GRAY)
        rowImg = whiteImg[int(height/2)]

        center = self.__findWhiteFillterCenter(rowImg)
        threshold = 15
        difference = abs(center - imgCenter)

        if difference < threshold :
            return "forward"
        else :
            if center < imgCenter :
                return "turnleft"
            elif center > imgCenter :
                return "turnright"
        

            

