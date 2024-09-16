#python segmentation script
import sys
import json
import warnings
from ultralytics import YOLO
import numpy as np
import os

GI_values = {
    'ugali': 67,    # Example GI for ugali
    'beef': 0,      # Example GI for beef (assuming no carbohydrates)
    'kales': 10,
    'chapati': 52,
    'ndengu': 38,
    'spinach': 15,
    'rice': 73,
    'beans': 20,
    'cabbage': 10
}

carb_density = {
    'ugali': 1.725,   # Example carbohydrate density for ugali
    'beef': 0,      # Assuming beef has no carbohydrates
    'kales': 0.45,   # Example carbohydrate density for kales
    'chapati': 0.36,
    'ndengu': 0.675,
    'spinach': 0.45,
    'rice': 0.525,
    'beans': 0.675,
    'cabbage': 0.375
}

image_path = sys.argv[1]

# print(f"Received image path: {image_path}")
if not os.path.isfile(image_path):
    raise FileNotFoundError(f"File does not exist: {image_path}")

model = YOLO('./model1.pt')

results = model.predict(image_path, save=False, imgsz=320, conf=0.5, verbose=False)

segmented_areas = {}

for r in results:
  boxes = r.boxes
  masks = r.masks
  names = r.names
  
  for mask, box in zip(masks, boxes):
    class_idx = int(box.cls)
    class_name = names[class_idx]
    
    mask_np = mask.data.cpu().numpy()
    area = float(np.sum(mask_np))
    
    segmented_areas[class_name] = area
    
    
glycemic_load = {}

for food_item, area in segmented_areas.items():
  if area > 0:
    area_cm2 = area * (0.0264583333 ** 2)
    carbs_g = area_cm2 * carb_density.get(food_item, 0);
    
    gi = GI_values.get(food_item, 0)
    gl = (gi * carbs_g) / 100 if gi > 0 else 0
    
    glycemic_load[food_item] = round(gl, 2)
    
    
total_gl = round(sum(glycemic_load.values()), 2)

output_results = {
  'food_items': [
    {
      'food_item': food_item,
      'glycemic_load': gl
    }for food_item, gl in glycemic_load.items()
  ],
  'total_glycemic_load': total_gl
}

print(json.dumps(output_results))
