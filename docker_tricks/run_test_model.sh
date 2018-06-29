cd /detectron
python2 tools/infer_simple.py \
    --cfg configs/12_2017_baselines/e2e_mask_rcnn_R-101-FPN_2x.yaml \
    --output-dir /detectron_data/output  \
    --image-ext jpg  \
    --wts /detectron_data/tutorial/model_final.pkl \
    --im_or_folder /detectron_data/input/


                     
