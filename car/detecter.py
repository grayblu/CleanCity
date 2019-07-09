import tensorflow as tf
from utils import label_map_util
from utils import visualization_utils as vis_util
import numpy as np

class Detecter :

    def __init__(self):
        self.detection_graph = tf.Graph()

    def setup(self, model_file, label_map_file):
        self.load_model(model_file)
        self.load_label_map(label_map_file)
        self.prepare_tensors()
        self.sess = tf.Session(graph=self.detection_graph)

    # 사전 훈련된 그래프 로드
    def load_model(self, model_file) :
        with self.detection_graph.as_default():
            od_graph_def = tf.GraphDef()
            with tf.gfile.GFile(model_file, 'rb') as fid:
                serialized_graph = fid.read()
                od_graph_def.ParseFromString(serialized_graph)
                tf.import_graph_def(od_graph_def, name='')
                
    # 라벨 맵 생성
    def load_label_map(self, label_map_file):
        self.category_index = label_map_util.create_category_index_from_labelmap(label_map_file, use_display_name=True)


    # 텐서의 이름으로 모델에 있는 텐서 찾기
    def prepare_tensors(self):
        # 이미지 배열 입력 텐서 얻기
        self.image_tensor = self.detection_graph.get_tensor_by_name(
        'image_tensor:0')
        # 박스 처리 텐서 얻기
        self.detection_boxes = self.detection_graph.get_tensor_by_name(
        'detection_boxes:0')
        # 점수 텐서 얻기
        self.detection_scores = self.detection_graph.get_tensor_by_name(
        'detection_scores:0')
        # 결과 분류 텐서 얻기
        self.detection_classes = self.detection_graph.get_tensor_by_name(
        'detection_classes:0')
        # 발견한 객체 수 텐서 얻기
        self.num_detections = self.detection_graph.get_tensor_by_name(
        'num_detections:0')

    def detect(self, image):
        tensors = [self.detection_boxes, self.detection_scores,
        self.detection_classes, self.num_detections]
        (boxes, scores, classes, num) = self.sess.run(tensors,
        feed_dict={self.image_tensor: image})
        (boxes, scores, classes) = (np.squeeze(boxes), np.squeeze(scores),np.squeeze(classes).astype(np.uint8))

        return (boxes, scores, classes, num)

    def viaulize(self, image, boxes, classes, scores, threshold):
        vis_util.visualize_boxes_and_labels_on_image_array(image, boxes, classes, scores, self.category_index, use_normalized_coordinates=True, line_thickness=8, min_score_thresh=threshold)
