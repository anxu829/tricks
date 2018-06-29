#sudo docker stop detectron
#sudo docker rm detectron
#sudo nvidia-docker run --name detectron -it -p 8899:8888  -v /study/detectron:/detectron_data  detectron:c2-cuda9-cudnn7  sh -c "cd / && jupyter notebook --no-browser --ip 0.0.0.0 --allow-root"

	# -v /study/detectron/Detectron/tools/infer_simple.py:/detectron/tools/infer_simple.py \

#sudo docker stop detectron
#sudo nvidia-docker start detectron 
#sudo nvidia-docker exec -it detectron sh -c "cd / && jupyter notebook --no-browser --ip 0.0.0.0 --allow-root"
 
sudo docker stop detectron
sudo docker rm detectron
sudo nvidia-docker run  --name detectron -it -p 8899:8888 -v /study/detectron/Detectron/tools/infer_simple.py:/detectron/tools/infer_simple.py   -v /study/detectron:/detectron_data  detectron:c2-cuda9-cudnn7   /bin/bash   -c "source ~/.bashrc && source /etc/profile && cd / && jupyter notebook --no-browser --ip 0.0.0.0 --allow-root --port 8888"


