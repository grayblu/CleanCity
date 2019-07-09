import numpy as np
import cv2
from picamera.array import PiRGBArray
from picamera import PiCamera
from threading import Thread, Lock
import time
import requests
import websocket
import json
from objectdetecter import Objectdetecter
from bluetooth import *

from linedetecter import lineDetecter

def capture_img() :
    print('start capture_img')

    global new_image
    lock = Lock()
    camera = PiCamera()
    camera.rotation = 180
    camera.framerate = 10
    camera.resolution = (1024 , 768)
    rawCapture = PiRGBArray(camera)
    rawCapture.truncate(0)

    for frame in camera.capture_continuous(rawCapture, format="bgr", use_video_port=True) :
        lock.acquire()
        new_image = np.copy(frame.array)
        lock.release()
        rawCapture.truncate(0)


def detect_order() :
    print('start detect_order')
    global detected_order
    global find_image
    o_det = Objectdetecter()

    while True :
        if new_image is None :
            continue
        detected_order, find_image = o_det.order(new_image)


def run_order() :
    global order
    global new_image
    det = lineDetecter()
    
    while True:
        if new_image is None :
            continue
        
        order = det.order(new_image)


def sendImgtoServer() :
    print("start sendImgtoServer")
    url = 'http://70.12.109.151:8080/clean/camera/1'
    global new_image
    global find_image

    while True:
        if find_image is None :
            continue
        
        jpgImage = cv2.imencode('.jpg',find_image)[1].tostring()
        file = {'image' : jpgImage}
        requests.post(url,files=file)
        

def sendOrdertoArduino() :
    print('start sendOrdertoArduino')
    global mode
    global passive_order
    global garbageList
    global detected_order
    global order
    socket = BluetoothSocket(RFCOMM)
    socket.connect(("98:D3:31:F7:3E:49",1))

    while(True) :

        if mode == "passive" :
            if passive_order is not None:
                socket.send(passive_order)
                time.sleep(0.1)
                passive_order = None
            
        elif mode == "auto" :
            if garbageList :
                print("start remove trash!!")
                print("grabage list  : " + garbageList)

                while True:

                    if detected_order is not None :
                        socket.send(detected_order)
                        print('detected object : ' + detected_order)
                        time.sleep(0.1)
                        detected_order = None
                 
                    else :
                        if order is not None :
                            socket.send(order)
                            print('order : ' + order)
                            order = None
                            
                            time.sleep(0.1)
                    
                    if mode == "passive" :
                        break
    
# socket ##########################################################################

def on_message(ws,message):
    global garbageList
    global mode
    global passive_order
    data = json.loads(message)

    if data["type"] == "collectinList" :
        garbageList.append(data["garbageList"])   
    elif data["type"] == "driving" :
        passive_order = data["direction"]
    elif data["type"] == "state" :
        mode = data["mode"]
  
def on_error(ws,error):
    print(error)

def on_close(ws):
    print('### websocket closed ###')

def on_open(ws):
    global detected_order
    global garbageList

    def run(*args) :
        sub = {"type":"initializingCar","message":"70.12.109.151"}
        ws.send(json.dumps(sub))

        while True:
            if detected_order == "trash" :
                sub = {"type":"collectedData","message":"complete","address":"seoul gangnamgu","userid":"gs25"}
                ws.send(json.dumps(sub))
                garbageList.remove(0) 

        ws.close()

    Thread(target=run).start()

##########################################################################
        
if __name__ == "__main__":
    
    new_image = None
    order = None
    lines_edges = None
    detected_order = None
    passive_order = None
    find_image = None
    garbageList = []
    mode = "passive"
    ws = websocket.WebSocketApp("ws://70.12.109.151:8080/clean/admin/monitor/data",
                                on_open = on_open,
                                on_message = on_message,
                                on_error = on_error,
                                on_close = on_close)
    
    
    
    
    t1 = Thread(target=capture_img)
    t1.start()
    
    t2 = Thread(target=detect_order)
    t2.start()

    time.sleep(15) # object_detect 로딩 시간

    t3 = Thread(target=run_order)
    t3.start()   

    t4 = Thread(target=sendImgtoServer)
    t4.start()
    
    t5 = Thread(target = sendOrdertoArduino)
    t5.start()
    
    ws.run_forever()
