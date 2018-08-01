```
# website: http://ethereon.github.io/netscope/#/editor

name: "RESNET_Mask-RCNN"

input: "data"
input_dim: 1
input_dim: 3
input_dim: 7
input_dim: 7


#---------------Mask Branch --------------------------

layer {
	bottom: "data"
	top: "conv_mask1"
	name: "conv_mask1"
	
	type: "Convolution"
	convolution_param {
		num_output: 256
		pad: 1
		kernel_size: 3
	}
}

layer { 
	bottom: 'conv_mask1' 
	top: 'conv_mask1-bn' 
	name: 'conv_mask1-bn' 
	type: 'BatchNorm'
  	batch_norm_param {
    		use_global_stats: false
  	}

}

layer {
	bottom: "conv_mask1-bn"
	top: "conv_mask1-bn"
	name: "scale_conv_mask1"
	type: "Scale"
	scale_param {
		bias_term: true
	}
}

layer {
	bottom: "conv_mask1-bn"
	top: "conv_mask1-bn"
	name: "relu_conv1"
	type: "ReLU"
}


layer {
	bottom: "conv_mask1-bn"
	top: "conv_mask1-bn"
	name: "drop_conv1"
	type: "Dropout"
	dropout_param {
		dropout_ratio: 0.5
	}
}


layer {
	bottom: "conv_mask1-bn"
	top: "deconv_mask1"
	name: "deconv_mask1"
	param {
		lr_mult: 1.0
	}

	type: "Deconvolution"
	convolution_param {
		num_output: 256
		kernel_size: 2
                stride: 2
       
		weight_filler {
        		type: "gaussian"
			std: 0.01
        		
      		}
      		bias_filler {
        		type: "constant" # initialize the biases to zero (0)
        		value: 0
      		}
        }
}

layer { 
	bottom: 'deconv_mask1' 
	top: 'deconv_mask1-bn' 
	name: 'deconv_mask1-bn' 
	type: 'BatchNorm'
  	batch_norm_param {
    		use_global_stats: false
  	}
}


layer {
	bottom: "deconv_mask1-bn"
	top: "deconv_mask1-bn"
	name: "scale_deconv_mask1"
	type: "Scale"
	scale_param {
		bias_term: true
	}
}
layer {
	bottom: "deconv_mask1-bn"
	top: "deconv_mask1-bn"
	name: "relu_deconv1"
	type: "ReLU"
}


layer {
	bottom: "deconv_mask1-bn"
	top: "conv_mask2"
	name: "conv_mask2"
	param {
		lr_mult: 1.0
	}
	param {
		lr_mult: 2.0
	}
	type: "Convolution"
	convolution_param {
		num_output: 256
		pad: 1
		kernel_size: 3
	

		weight_filler {
        		type: "gaussian"
			std: 0.01
        		
      		}
      		bias_filler {
        		type: "constant" # initialize the biases to zero (0)
        		value: 0
      		}

	}
}

layer { 
	bottom: 'conv_mask2' 
	top: 'conv_mask2-bn' 
	name: 'conv_mask2-bn' 
	type: 'BatchNorm'
  	batch_norm_param {
    		use_global_stats: false
  	}
}


layer {
	bottom: "conv_mask2-bn"
	top: "conv_mask2-bn"
	name: "scale_conv_mask2"
	type: "Scale"
	scale_param {
		bias_term: true
	}
}
layer {
	bottom: "conv_mask2-bn"
	top: "conv_mask2-bn"
	name: "relu_conv2"
	type: "ReLU"
}


layer {
	bottom: "conv_mask2-bn"
	top: "conv_mask2-bn"
	name: "drop_conv2"
	type: "Dropout"
	dropout_param {
		dropout_ratio: 0.5
	}
}

layer {
	bottom: "conv_mask2-bn"
	top: "conv_mask3"
	name: "conv_mask3"
	param {
		lr_mult: 1.0
	}
	param {
		lr_mult: 2.0
	}
	type: "Convolution"
	convolution_param {
		num_output: 256
		pad: 1
		kernel_size: 3
	

		weight_filler {
        		type: "gaussian"
			std: 0.01
        		
      		}
      		bias_filler {
        		type: "constant" # initialize the biases to zero (0)
        		value: 0
      		}

      }
}

layer { 
	bottom: 'conv_mask3' 
	top: 'conv_mask3-bn' 
	name: 'conv_mask3-bn' 
	type: 'BatchNorm'
  	batch_norm_param {
    		use_global_stats: false
  	}
}

layer {
	bottom: "conv_mask3-bn"
	top: "conv_mask3-bn"
	name: "scale_conv_mask3"
	type: "Scale"
	scale_param {
		bias_term: true
	}
}

layer {
	bottom: "conv_mask3-bn"
	top: "conv_mask3-bn"
	name: "relu_conv3"
	type: "ReLU"
}



layer {
	bottom: "conv_mask3-bn"
	top: "conv_mask4"
	name: "conv_mask4"
	param {
		lr_mult: 1.0
	}
	param {
		lr_mult: 2.0
	}
	type: "Convolution"
	convolution_param {
		num_output: 256
		pad: 1
		kernel_size: 3
	

		weight_filler {
        		type: "gaussian"
			std: 0.01
        		
      		}
      		bias_filler {
        		type: "constant" # initialize the biases to zero (0)
        		value: 0
      		}


        }
}

layer { 
	bottom: 'conv_mask4' 
	top: 'conv_mask4-bn' 
	name: 'conv_mask4-bn' 
	type: 'BatchNorm'
  	batch_norm_param {
    		use_global_stats: false
  	}
}


layer {
	bottom: "conv_mask4-bn"
	top: "conv_mask4-bn"
	name: "scale_conv_mask4"
	type: "Scale"
	scale_param {
		bias_term: true
	}
}


layer {
	bottom: "conv_mask4-bn"
	top: "conv_mask4-bn"
	name: "relu_conv4"
	type: "ReLU"
}


layer {
	bottom: "conv_mask4-bn"
	top: "conv_mask5"
	name: "conv_mask5"
	param {
		lr_mult: 1.0
	}
	param {
		lr_mult: 2.0
	}
	type: "Convolution"
	convolution_param {
		num_output: 256
		pad: 1
		kernel_size: 3
	

		weight_filler {
        		type: "gaussian"
			std: 0.01
        		
      		}
      		bias_filler {
        		type: "constant" # initialize the biases to zero (0)
        		value: 0
      		}


       }
}

layer { 
	bottom: 'conv_mask5' 
	top: 'conv_mask5-bn' 
	name: 'conv_mask5-bn' 
	type: 'BatchNorm'
  	batch_norm_param {
    		use_global_stats: false
  	}
}


layer {
	bottom: "conv_mask5-bn"
	top: "conv_mask5-bn"
	name: "scale_conv_mask5"
	type: "Scale"
	scale_param {
		bias_term: true
	}
}

layer {
	bottom: "conv_mask5-bn"
	top: "conv_mask5-bn"
	name: "relu_conv5"
	type: "ReLU"
}



layer {
	bottom: "conv_mask5-bn"
	top: "deconv_mask2"
	name: "deconv_mask2"
	param {
		lr_mult: 1.0
	}

	type: "Deconvolution"
	convolution_param {
		num_output: 256
		kernel_size: 2
                stride: 2
	
		weight_filler {
        		type: "gaussian"
			std: 0.01
        		
      		}
      		bias_filler {
        		type: "constant" # initialize the biases to zero (0)
        		value: 0
      		}


       }
}

layer { 
	bottom: 'deconv_mask2' 
	top: 'deconv_mask2-bn' 
	name: 'deconv_mask2-bn' 
	type: 'BatchNorm'
  	batch_norm_param {
    		use_global_stats: false
  	}
}


layer {
	bottom: "deconv_mask2-bn"
	top: "deconv_mask2-bn"
	name: "scale_deconv_mask1"
	type: "Scale"
	scale_param {
		bias_term: true
	}
}

layer {
	bottom: "deconv_mask2-bn"
	top: "deconv_mask2-bn"
	name: "relu_deconv2"
	type: "ReLU"
}



layer {
	bottom: "deconv_mask2-bn"
	top: "conv_mask6"
	name: "conv_mask6"
	param {
		lr_mult: 1.0
	}
	param {
		lr_mult: 2.0
	}
	type: "Convolution"
	convolution_param {
		num_output: 81
		pad: 1
		kernel_size: 3
	

		weight_filler {
        		type: "gaussian"
			std: 0.01
        		
      		}
      		bias_filler {
        		type: "constant" # initialize the biases to zero (0)
        		value: 0
      		}


     }
}


#---------------FC Branch --------------------------

layer {
	bottom: "data"
	top: "fc6"
	name: "fc6"
	param {
		lr_mult: 1.0
	}
	param {
		lr_mult: 2.0
	}
	type: "InnerProduct"
	inner_product_param {
		num_output: 4096
	}
}

layer {
	bottom: "fc6"
	top: "fc6"
	name: "relu6"
	type: "ReLU"
}

layer {
	bottom: "fc6"
	top: "fc6"
	name: "drop6"
	type: "Dropout"
	dropout_param {
		dropout_ratio: 0.5
	}
}

layer {
	bottom: "fc6"
	top: "fc7"
	name: "fc7"
	param {
		lr_mult: 1.0
	}
	param {
		lr_mult: 2.0
	}
	type: "InnerProduct"
	inner_product_param {
		num_output: 4096
	}
}

layer {
	bottom: "fc7"
	top: "fc7"
	name: "relu7"
	type: "ReLU"
}

layer {
	bottom: "fc7"
	top: "fc7"
	name: "drop7"
	type: "Dropout"
	dropout_param {
		dropout_ratio: 0.5
	}
}



#---------------Class Prediction Branch --------------------------

layer {
	bottom: "fc7"
	top: "cls_score"
	name: "cls_score"
	param {
		lr_mult: 1.0
	}
	param {
		lr_mult: 2.0
	}
	type: "InnerProduct"
	inner_product_param {
		num_output: 81
		weight_filler {
			type: "gaussian"
			std: 0.01
		}
		bias_filler {
			type: "constant"
			value: 0
		}
	}
}


#---------------Bounding Box Prediction Branch --------------------------
layer {
	bottom: "fc7"
	top: "bbox_pred"
	name: "bbox_pred"
	type: "InnerProduct"
	param {
		lr_mult: 1.0
	}
	param {
		lr_mult: 2.0
	}
	inner_product_param {
		num_output: 324
		weight_filler {
			type: "gaussian"
			std: 0.001
		}
		bias_filler {
			type: "constant"
			value: 0
		}
	}
}


#---------------Class Loss --------------------------

layer {
	name: "loss"
	type: "SoftmaxWithLoss"
	bottom: "cls_score"
	bottom: "labels"
	top: "loss_cls"
	loss_weight: 1
}



#---------------BB Loss --------------------------

layer {
	name: "loss_bbox"
	type: "SmoothL1Loss"
	bottom: "bbox_pred"
	bottom: "bbox_targets"
	bottom: "bbox_loss_weights"
	top: "loss_bbox"
	loss_weight: 1
}


#---------------Mask Loss --------------------------

layer {

	name: "loss_mask"
	type: "SigmoidCrossEntropyLoss"
	bottom: "conv_mask6"
	bottom: "mask_targets"
	top: "loss_mask"
	loss_weight: 1
        loss_param {
          ignore_label: -1
	}
}

```
